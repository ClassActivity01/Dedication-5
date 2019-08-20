using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Ordering
{
    public class CustomerOrderController : ApiController
    {
        static ProteusEntities db = new ProteusEntities();

        // GET: api/CustomerOrder
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    client_orders =
                                        from p in db.Client_Order
                                        orderby p.Date
                                        select new
                                        {
                                            Client_Order_ID = p.Client_Order_ID,
                                            Date = p.Date,
                                            Reference_ID = p.Reference_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_ID = p.Client_ID,
                                            Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                            Client_Order_Type_ID = p.Client_Order_Type_ID,
                                            Client_Order_Status_ID = p.Client_Order_Status_ID,
                                            Delivery_Method_ID = p.Delivery_Method_ID,
                                            Job_Card_ID = p.Job_Card_ID,
                                            VAT_Inclu = p.VAT_Inclu,
                                            Comment = p.Comment,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Order_Detail
                                                where d.Client_Order_ID == p.Client_Order_ID
                                                select new
                                                {
                                                    Client_Order_Detail_ID = d.Client_Order_Detail_ID,
                                                    Quantity = d.Quantity,
                                                    Quantity_Delivered = d.Quantity_Delivered,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Part_Type_ID = d.Part_Type_ID,
                                                    Part_Type_Name = d.Part_Type.Name,
                                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation,
                                                    Stock_Available = 
                                                        (from c in db.Parts
                                                         where c.Part_Stage == 3

                                                         select new
                                                         {
                                                             count = (from e in db.Job_Card_Detail
                                                                      where e.Job_Card_ID == p.Job_Card_ID && e.Parts.Contains(c)
                                                                      select e).Count()
                                                         })
                                                }
                                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerOrderController GET");
                return "false|Failed to retrieve Customer Orders.";
            }
        }

        // GET: api/CustomerOrder/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    client_orders =
                                        from p in db.Client_Order
                                        orderby p.Date
                                        where p.Client_Order_ID == id
                                        select new
                                        {
                                            Client_Order_ID = p.Client_Order_ID,
                                            Date = p.Date,
                                            Reference_ID = p.Reference_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_ID = p.Client_ID,
                                            Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                            Client_Order_Type_ID = p.Client_Order_Type_ID,
                                            Client_Order_Status_ID = p.Client_Order_Status_ID,
                                            Delivery_Method_ID = p.Delivery_Method_ID,
                                            Job_Card_ID = p.Job_Card_ID,
                                            VAT_Inclu = p.VAT_Inclu,
                                            Comment = p.Comment,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Order_Detail
                                                where d.Client_Order_ID == p.Client_Order_ID
                                                select new
                                                {
                                                    Client_Order_Detail_ID = d.Client_Order_Detail_ID,
                                                    Quantity = d.Quantity,
                                                    Quantity_Delivered = d.Quantity_Delivered,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Part_Type_ID = d.Part_Type_ID,
                                                    Part_Type_Name = d.Part_Type.Name,
                                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation,
                                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == d.Part_Type_ID && (x.Part_Status_ID == 3)).Count()
                                                }
                                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerOrderController GET ID");
                return "false|Failed to retrieve Customer Order.";
            }
        }

        // POST: api/CustomerOrder
        public string Post(HttpRequestMessage value)
        {
        //    try
        //    {
                Model.Client_Order co = new Model.Client_Order();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject orderDetails = (JObject)json["client"];
                JArray parts = (JArray)orderDetails["details"];
                string todo = (string)json["action"];

                int key = db.Client_Order.Count() == 0 ? 1 : (from t in db.Client_Order
                                                              orderby t.Client_Order_ID descending
                                                           select t.Client_Order_ID).First() + 1;

                co.Client_Order_ID = key;
                co.Date = (DateTime)orderDetails["Date"];
                co.Reference_ID = (string)orderDetails["Reference_ID"];
                co.Contact_ID = (int)orderDetails["Contact_ID"];
                co.Client_ID = (int)orderDetails["Client_ID"];
                co.Settlement_Discount_Rate = (double)orderDetails["Settlement_Discount_Rate"];
                co.Client_Order_Type_ID = (int)orderDetails["Client_Order_Type_ID"];
                co.Client_Order_Status_ID = 1;
                co.Settlement_Discount_Rate = (double)orderDetails["Settlement_Discount_Rate"];
                co.Delivery_Method_ID = (int)orderDetails["Delivery_Method_ID"];
                co.VAT_Inclu = Convert.ToBoolean((string)orderDetails["VAT_Inclu"]);
                co.Comment = (string)orderDetails["Comment"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Client_Order
                     where t.Reference_ID == co.Reference_ID
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer Order Reference entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                Job_Card jc = new Job_Card();
                int job_key = db.Job_Card.Count() == 0 ? 1 : (from t in db.Job_Card
                                                              orderby t.Job_Card_ID descending
                                                              select t.Job_Card_ID).First() + 1;

                jc.Job_Card_ID = job_key;
                jc.Job_Card_Date = (DateTime)orderDetails["Date"];
                jc.Job_Card_Status_ID = 1;
                jc.Job_Card_Priority_ID = 1;
                co.Job_Card_ID = job_key;

                db.Client_Order.Add(co);
                db.Job_Card.Add(jc);
                db.SaveChanges();

                int detail_key = db.Job_Card_Detail.Count() == 0 ? 1 : (from t in db.Job_Card_Detail
                                                                        orderby t.Job_Card_Details_ID descending
                                                                        select t.Job_Card_Details_ID).First() + 1;

                int co_key = db.Client_Order_Detail.Count() == 0 ? 1 : (from t in db.Client_Order_Detail
                                                                        orderby t.Client_Order_Detail_ID descending
                                                                        select t.Client_Order_Detail_ID).First() + 1;

                foreach (JObject part in parts)
                {
                    Client_Order_Detail cqd = new Client_Order_Detail();
                    cqd.Part_Type_ID = (int)part["Part_Type_ID"];
                    cqd.Quantity = (int)part["Quantity"];
                    cqd.Quantity_Delivered = 0;
                    cqd.Part_Price = (decimal)part["Part_Price"];
                    cqd.Client_Discount_Rate = (double)part["Client_Discount_Rate"];
                    cqd.Client_Order_ID = key;
                    cqd.Client_Order_Detail_ID = co_key;
                    co_key++;

                    db.Client_Order_Detail.Add(cqd);

                    Job_Card_Detail jcd = new Job_Card_Detail();
                    jcd.Job_Card_Details_ID = detail_key;
                    detail_key++;

                    jcd.Part_Type_ID = (int)part["Part_Type_ID"];
                    jcd.Job_Card_ID = job_key;
                    jcd.Non_Manual = false;
                    jcd.Quantity = (int)part["Quantity"];

                    db.Job_Card_Detail.Add(jcd);
                    db.SaveChanges();

                    //2. Handle child dependencies
                    checkForChildren(jcd.Part_Type_ID, jcd.Quantity, job_key, "Ordering");

                    generateUniqueParts(jcd.Quantity, jcd.Part_Type_ID, 0, detail_key - 1, "Ordering");
                }

                db.SaveChanges();

                if (todo == "email")
                {
                    Client_Contact_Person_Detail cl = new Client_Contact_Person_Detail();
                    cl = (from p in db.Client_Contact_Person_Detail
                          where p.Contact_ID == co.Contact_ID
                          select p).First();

                    string to = cl.Email_Address;
                    string subject = "WME Order #" + key;

                    String orderDate = co.Date.ToShortDateString();
                    string body = "Walter Meano Engineering Order #" + key + "\nThe order was placed on " + orderDate + "\n\nItems on Order:\n";

                    foreach (JObject part in parts)
                    {
                        Part_Type pt = new Part_Type();
                        int part_id = (int)part["Part_Type_ID"];
                        pt = (from p in db.Part_Type
                              where p.Part_Type_ID == part_id
                              select p).First();

                        body += pt.Abbreviation + " - " + pt.Name + "\t\tx" + (int)part["Quantity"] + "\tR " + (decimal)part["Part_Price"] + " per unit\n";
                    }

                    Email.SendEmail(to, subject, body);
                }

                return "true|Order #" + key +" has been placed.";
       /*         var return_message = sendSms((int)orderDetails["Contact_ID"], key);

                return return_message;
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerOrderController POST");
                return "false|An error has occured adding the Customer Order to the system.";
            }*/
        }

        private static string sendSms(int c_ID, int orderNum)
        {
            try
            {

                IQueryable<String> contact_details =
                                from d in db.Client_Contact_Person_Detail
                                where d.Contact_ID == c_ID
                                orderby d.Name
                                select d.Number;

                List<String> l = contact_details.ToList();

                string cellphone = l.First();
                DateTime today = DateTime.Now;

                string message = "Your order no: " + Convert.ToString(orderNum) + " has been placed on " + today.Year.ToString() + "-" + today.Month.ToString() + "-" + today.Day.ToString();

               

                string sURL = "http://www.stepsdatabase.com/sms4pro/smsOUT.aspx";
                sURL += "?sUser=" + "natasha";
                sURL += "&sPass=" + "Tiekie";
                sURL += "&sVs=1.1";
                sURL += "&sDomain=" + "sms4pro.com";
                sURL += "&cellNum=" + cellphone;
                sURL += "&from=35528";
                sURL += "&messID=" + "1";
                sURL += "&msg=" + message;
                sURL += "&comp=" + "Lenono";


                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(sURL);

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                System.IO.Stream resStream = response.GetResponseStream();
                string var = resStream.ToString();

                return "true|Customer Order has been placed";
            }
            catch (Exception ex)
            {
                ExceptionLog.LogException(ex, "CustomerOrderController sendSMS");
                return "false| " + ex.ToString();
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

                foreach (Part part in parts)
                {
                    if ((from p in db.Job_Card_Detail
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

        // PUT: api/CustomerOrder/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Client_Order co = new Client_Order();
                co = (from p in db.Client_Order
                      where p.Client_Order_ID == id
                       select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                co.Client_Order_Status_ID = (int)json["status_ID"];
                co.Client_Order_Type_ID = (int)json["order_type"];
                co.Delivery_Method_ID = (int)json["delivery_method"];
                co.Reference_ID = (string)json["reference"];
                co.VAT_Inclu = Convert.ToBoolean((string)json["vat"]);
                co.Comment = (string)json["comment"];
                co.Contact_ID = (int)json["Contact_ID"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Client_Order
                     where t.Reference_ID == co.Reference_ID && t.Client_Order_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer Order Reference entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.SaveChanges();
                return "true|Customer Order successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerOrderController PUT");
                return "false|An error has occured updating the Customer Order on the system.";
            }
        }
    }
}
