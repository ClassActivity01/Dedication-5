using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Manufacturing
{
    public class JobCardController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/JobCard
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    job_cards =
                        from p in db.Job_Card
                        orderby p.Job_Card_ID
                        where p.Job_Card_Status_ID == 2 || p.Job_Card_Status_ID == 1
                        select new
                        {
                            Job_Card_ID = p.Job_Card_ID,
                            Job_Card_Date = p.Job_Card_Date,
                            Job_Card_Status_ID = p.Job_Card_Status_ID,
                            Job_Card_Priority_ID = p.Job_Card_Priority_ID,
                            Job_Card_Status_Name = p.Job_Card_Status.Name,
                            Job_Card_Priority_Name = p.Job_Card_Priority.Name,

                            details =
                                from d in db.Job_Card_Detail
                                where d.Job_Card_ID == p.Job_Card_ID
                                select new
                                {
                                    Part_Type_ID = d.Part_Type_ID,
                                    Abbreviation = d.Part_Type.Abbreviation,
                                    Name = d.Part_Type.Name,
                                    Description = d.Part_Type.Description,
                                    Job_Card_Details_ID = d.Job_Card_Details_ID,
                                    Quantity = d.Quantity,
                                    Non_Manual = d.Non_Manual,
                                    Job_Card_ID = d.Job_Card_ID,

                                    parts =
                                        from c in db.Parts
                                        where c.Part_Type_ID == d.Part_Type_ID && c.Job_Card_Detail.Contains(d)
                                        select new
                                        {
                                            Part_ID = c.Part_ID,
                                            Part_Serial = c.Part_Serial,
                                            Part_Status_ID = c.Part_Status_ID,
                                            Date_Added = c.Date_Added,
                                            Cost_Price = c.Cost_Price,
                                            Part_Stage = c.Part_Stage,
                                            Part_Type_ID = c.Part_Type_ID,
                                            Part_Status_Name = c.Part_Status.Name
                                        }
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "JobCardController GET");
                return "false|Failed to retrieve Job Cards.";
            }
        }

        // POST: api/JobCard
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JArray partDetails = (JArray)json["details"];

                Job_Card jc = new Job_Card();
                int job_key = db.Job_Card.Count() == 0 ? 1 : (from t in db.Job_Card
                                                              orderby t.Job_Card_ID descending
                                                              select t.Job_Card_ID).First() + 1;

                jc.Job_Card_ID = job_key;
                jc.Job_Card_Date = (DateTime)json["Job_Card_Date"];
                jc.Job_Card_Status_ID = (int)json["Job_Card_Status_ID"];
                jc.Job_Card_Priority_ID = 2;

                db.Job_Card.Add(jc);
                db.SaveChanges();
                int detail_key = db.Job_Card_Detail.Count() == 0 ? 1 : (from t in db.Job_Card_Detail
                                                                            orderby t.Job_Card_Details_ID descending
                                                                            select t.Job_Card_Details_ID).First() + 1;

                foreach (JObject part in partDetails)
                {
                    Job_Card_Detail jcd = new Job_Card_Detail();
                    jcd.Job_Card_Details_ID = detail_key;
                    detail_key++;

                    jcd.Part_Type_ID = (int)part["Part_Type_ID"];
                    jcd.Job_Card_ID = job_key;
                    jcd.Non_Manual = Convert.ToBoolean((string)part["Non_Manual"]);
                    jcd.Quantity = (int)part["Quantity"];

                    db.Job_Card_Detail.Add(jcd);
                    db.SaveChanges();

                    //2. Handle child dependencies
                    checkForChildren(jcd.Part_Type_ID, jcd.Quantity, job_key, "Manufacturing");

                    generateUniqueParts(jcd.Quantity, jcd.Part_Type_ID, 0, detail_key-1, "Manufacturing");
                }
                
                return "true|Job Card #" + job_key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "JobCardController POST");
                return "false|An error has occured adding the Job Card to the system.";
            }
        }

        private void checkForChildren(int part_type_ID, int quantity_requested, int job_card_ID, string type)
        {
            //(Armand) Check for dependencies i.e check if the part_type has any part dependencies in the recipe table 
            //and make a list of children part_types.
            List<Recipe> dependencies = null;

            dependencies = (from p in db.Recipes
                            where p.Part_Type_ID == part_type_ID && p.Recipe_Type == "Part Type"
                            select p).ToList();

            if (dependencies != null)
            {
                foreach (Recipe pt in dependencies)
                {
                    int? child_ID = pt.Item_ID;

                    //(Armand) first check if there isn't alreayd an entry for the child's ID in job_card_detail
                    //where jcd.Part_Type_ID == child_ID and Job_Card_ID == job_card_ID and assign to jcd
                    Job_Card_Detail jcd = null;
                    jcd = (from p in db.Job_Card_Detail
                           where p.Part_Type_ID == child_ID && p.Job_Card_ID == job_card_ID
                           select p).FirstOrDefault();


                    int quantity = quantity_requested * pt.Quantity_Required;

                    if (jcd != null)
                    {
                        //add the required children parts to the quantity already requested
                        int new_quantity;
                        if (quantity > jcd.Quantity)
                            new_quantity = jcd.Quantity + quantity;
                        else
                            new_quantity = jcd.Quantity;

                        //update this existing record with the new quantity.

                        jcd.Quantity = new_quantity;
                        db.SaveChanges();
                    }
                    else
                    {
                        int detail_key = db.Job_Card_Detail.Count() == 0 ? 1 : (from t in db.Job_Card_Detail
                                                                                orderby t.Job_Card_Details_ID descending
                                                                                select t.Job_Card_Details_ID).First() + 1;

                        Job_Card_Detail jcd2 = new Job_Card_Detail();
                        jcd2.Job_Card_Details_ID = detail_key;

                        jcd2.Part_Type_ID = Convert.ToInt32(pt.Part_Type_ID);
                        jcd2.Job_Card_ID = job_card_ID;
                        jcd2.Non_Manual = true;
                        jcd2.Quantity = quantity;

                        db.Job_Card_Detail.Add(jcd2);
                        db.SaveChanges();
                        //The id of the last inserted record i.e. the one above
                        int available = checkForPartAvailability(Convert.ToInt32(child_ID), quantity, detail_key);

                        //Calculate how many new parts must be generated
                        int how_many = quantity - available;

                        //Generate the new child parts
                        generateUniqueParts(how_many, Convert.ToInt32(child_ID), 1, detail_key, type);
                    }
                }
            }
        }

        private int checkForPartAvailability(int part_type_ID, int quantity_requested, int job_card_detail_ID)
        {
            int available = 0;

            //(Armand) Check for stock availability i.e in-stock
            List<Part> available_parts = null;
            available_parts = (from p in db.Parts
                               where p.Part_Type_ID == part_type_ID && p.Part_Status_ID == 3
                               select p).ToList();


            if (available_parts != null)
            {
                foreach (Part part in available_parts)
                {
                    //(Armand) DO a select to determine whether this part is tied to a client order
                    bool isTiedtoClientOrder = false;
                    isTiedtoClientOrder = (from p in db.Job_Card_Detail
                                           where p.Parts.Contains(part) && p.Job_Card.Job_Card_Priority_ID == 1
                                           select p) != null;

                    if (available >= quantity_requested)
                        break;

                    if (isTiedtoClientOrder == false)
                    {
                        available++;
                        assignAvailableParts(part.Part_ID, job_card_detail_ID);
                    }
                }
            }

            return available;
        }

        private void assignAvailableParts(int part_ID, int job_card_detail_ID)
        {
            Job_Card_Detail jcd = new Job_Card_Detail();
            jcd = (from p in db.Job_Card_Detail
                   where p.Job_Card_Details_ID == job_card_detail_ID
                   select p).First();

            Part part = new Part();
            part = (from p in db.Parts
                   where p.Part_ID == part_ID
                   select p).First();

            jcd.Parts.Add(part);

            db.SaveChanges();
        }

        private void generateUniqueParts(int how_many, int part_type_ID, int parent_ID, int job_card_detail_ID, string type)
        {
            if (type == "Ordering")
            {
                //(Armand) Check for parts that are in-stock and not tied to any other client order
                List<Part> in_stock_parts = null;
                var parts = (from p in db.Parts
                            where p.Part_Type_ID == part_type_ID && p.Part_Status_ID == 3
                            select p).ToList();

                foreach(Part part in parts)
                {
                    if((from p in db.Job_Card_Detail
                        where p.Parts.Contains(part) && p.Job_Card.Job_Card_Priority_ID == 1
                        select p) == null)
                        in_stock_parts.Add(part);
                }

                if (in_stock_parts != null)
                {
                    foreach (Part part in in_stock_parts)
                    {
                        //now we assign the part to this job card
                        assignAvailableParts(part.Part_ID, job_card_detail_ID);
                        how_many--;
                    }
                }
            }


            //(Armand) Check for cancelled parts
            List<Part> cancelled_parts = null;
            cancelled_parts = (from p in db.Parts
                                   where p.Part_Type_ID == part_type_ID && p.Part_Status_ID == 5
                                   select p).ToList();

            if (cancelled_parts != null)
            {
                foreach (Part part in cancelled_parts)
                {
                    Part p = new Part();
                    p = (from d in db.Parts
                         where d.Part_ID == part.Part_ID
                         select d).First();

                    if (p.Part_Stage == 1)
                        p.Part_Status_ID = 1;
                    else
                        p.Part_Status_ID = 2;

                    db.SaveChanges();

                    assignAvailableParts(part.Part_ID, job_card_detail_ID);
                    how_many--;
                }
            }

            //Now to make new parts
            for (int k = 0; k < how_many; k++)
            {
                Part_Type pt = new Part_Type();
                pt = (from p in db.Part_Type
                      where p.Part_Type_ID == part_type_ID
                      select p).First();


                //(Armand) Get the abbreviation for the part_type
                string abbreviation = pt.Abbreviation;

                //(Armand) Generate the new number;
                Random rand = new Random();
                int num = 0;
                string serial = "";

                while (true)
                {
                    num = rand.Next(1, 999999999);
                    serial = abbreviation + "-" + Convert.ToString(num);

                    if ((from p in db.Parts
                         where p.Part_Serial == serial
                         select p).Count() == 0)
                        break;
                }
              

                int partkey = db.Parts.Count() == 0 ? 1 : (from t in db.Parts
                                                          orderby t.Part_ID descending
                                                          select t.Part_ID).First() + 1;

                Part newpart = new Part();
                newpart.Part_ID = partkey;
                newpart.Part_Serial = serial;
                newpart.Part_Stage = 1;
                newpart.Parent_ID = parent_ID;
                newpart.Part_Type_ID = part_type_ID;
                newpart.Part_Status_ID = 1;
                newpart.Date_Added = DateTime.Now;
                newpart.Cost_Price = 0;

                db.Parts.Add(newpart);
                db.SaveChanges();

                assignAvailableParts(partkey, job_card_detail_ID);
            }
        }

        // PUT: api/JobCard/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JArray partDetails = (JArray)json["details"];


                Job_Card jc = new Job_Card();
                jc = (from p in db.Job_Card
                      where p.Job_Card_ID == id
                      select p).First();

                int old_status = jc.Job_Card_Status_ID;
                jc.Job_Card_Status_ID = (int)json["Job_Card_Status_ID"];

                if (jc.Job_Card_Status_ID == 4) //if job card is being cancelled.
                {
                    if (old_status == 1)
                        jc.Job_Card_Status_ID = 4;
                    else
                        return "false|The Job Card is already in production, thus it cannot be cancelled.";

                    List<Job_Card_Detail> details = (from d in db.Job_Card_Detail
                                                     where d.Job_Card_ID == jc.Job_Card_ID
                                                     select d).ToList();

                    foreach (Job_Card_Detail det in details)
                    {
                        List<Part> parts = (from d in db.Parts
                                            where d.Job_Card_Detail.Contains(db.Job_Card_Detail.Where(x => x.Job_Card_Details_ID == det.Job_Card_Details_ID).FirstOrDefault())
                                                && (d.Part_Status_ID == 1 || d.Part_Status_ID == 2)
                                            select d).ToList();

                        foreach (Part p in parts)
                        {
                            p.Part_Status_ID = 5;
                        }
                    }

                    db.SaveChanges();
                    return "true|The Job Card has been cancelled.";
                }
                else if (jc.Job_Card_Status_ID == 3) //if job card is being set to complete.
                {
                    List<Job_Card_Detail> details = (from d in db.Job_Card_Detail
                                                     where d.Job_Card_ID == jc.Job_Card_ID
                                                     select d).ToList();

                    foreach (Job_Card_Detail det in details)
                    {
                        List<Part> parts = (from d in db.Parts
                                            where d.Job_Card_Detail.Contains(db.Job_Card_Detail.Where(x => x.Job_Card_Details_ID == det.Job_Card_Details_ID).FirstOrDefault())
                                                && (d.Part_Status_ID == 1 || d.Part_Status_ID == 2) && d.Parent_ID == 0
                                            select d).ToList();

                        foreach (Part p in parts)
                        {
                            p.Part_Status_ID = 3;

                            updateChildren(p.Part_ID, 2, jc.Job_Card_ID); //2 is for Complete.
                        }
                    }

                    db.SaveChanges();
                    return "True|Job Card has been set to completed.";
                }
                else //Only some parts are being removed 
                {
                    foreach (JObject jcd in partDetails)
                    {
                        int remove_quantity = (int)jcd["Remove_Quantity"];
                        if (remove_quantity > 0)
                        {
                            List<Job_Card_Detail> details = (from d in db.Job_Card_Detail
                                                             where d.Job_Card_ID == jc.Job_Card_ID
                                                             select d).ToList();

                            foreach (Job_Card_Detail det in details)
                            {
                                int part_type_ID = (int)jcd["Part_Type_ID"];
                                //(Armand) Get all the parts of the above part type tied to the job card 
                                //and order them by putting the last added part first
                                List<Part> parts = (from d in db.Parts
                                                    where d.Job_Card_Detail.Contains(db.Job_Card_Detail.Where(x => x.Job_Card_Details_ID == det.Job_Card_Details_ID).FirstOrDefault())
                                                        && d.Part_Type_ID == part_type_ID
                                                    select d).ToList();

                                int i = 0;
                                foreach (Part p in parts)
                                {
                                    if (p.Part_Status_ID == 1) //If the part is still in raw state but not in production
                                    {
                                        p.Part_Status_ID = 5;

                                        db.Parts.Where(x => x.Part_ID == p.Part_ID).First().Job_Card_Detail.Remove(det);

                                        i++;
                                    }

                                    det.Quantity = det.Quantity - remove_quantity;

                                    if (i == remove_quantity)
                                        break;
                                }

                                if (i == (int)jcd["Quantity"])
                                {
                                    //If all the parts have been removed then remove the entry from job_card_detail
                                    //for that part_type_ID
                                    db.Job_Card_Detail.Remove(det);
                                }
                            }
                        }
                    }

                    db.SaveChanges();
                    return "true|Job Card successfully updated.";
                }
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "JobCardController PUT");
                return "false|An error has occured updating the Job Card on the system.";
            }
      }

        private void updateChildren(int part_ID, int status, int job_card_ID)
        {
            try
            {
                if (status == 2)//I.e Completed
                {
                    List<Job_Card_Detail> details = (from d in db.Job_Card_Detail
                                                     where d.Job_Card_ID == job_card_ID
                                                     select d).ToList();

                    foreach (Job_Card_Detail det in details)
                    {
                        List<Part> parts = (from d in db.Parts
                                            where d.Job_Card_Detail.Contains(db.Job_Card_Detail.Where(x => x.Job_Card_Details_ID == det.Job_Card_Details_ID).FirstOrDefault())
                                                && d.Parent_ID == part_ID
                                            select d).ToList();

                        foreach (Part p in parts)
                        {
                            if (p.Part_Status_ID == 1 || p.Part_Status_ID == 2 || p.Part_Status_ID == 3)
                                p.Part_Status_ID = 7;
                        }
                    }

                    db.SaveChanges();
                }
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "JobCardController updateChildren");
            }
        }
    }
}
