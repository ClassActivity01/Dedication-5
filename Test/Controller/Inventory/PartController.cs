using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller
{
    public class PartController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/Part
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    parts =
                        from p in db.Parts
                        select new
                        {
                            Part_ID = p.Part_ID,
                            Part_Serial = p.Part_Serial,
                            Part_Status_ID = p.Part_Status_ID,
                            Date_Added = p.Date_Added,
                            Cost_Price = p.Cost_Price,
                            Part_Stage = p.Part_Stage,
                            Part_Type_ID = p.Part_Type_ID,

                            Part_Type_Name = p.Part_Type.Name,
                            Part_Type_Abbreviation = p.Part_Type.Abbreviation,
                            Part_Type_Dimension = p.Part_Type.Dimension,
                            Part_Type_Selling_Price = p.Part_Type.Selling_Price,
                            Part_Type_Description = p.Part_Type.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            { 
                ExceptionLog.LogException(e, "PartController GET");
                return "false|Failed to retrieve Parts.";
            }
        }

        // GET: api/Part/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    parts =
                        from p in db.Parts
                        where p.Part_ID == id
                        select new
                        {
                            Part_ID = p.Part_ID,
                            Part_Serial = p.Part_Serial,
                            Part_Status_ID = p.Part_Status_ID,
                            Date_Added = p.Date_Added,
                            Cost_Price = p.Cost_Price,
                            Part_Stage = p.Part_Stage,
                            Part_Type_ID = p.Part_Type_ID,

                            Part_Type_Name = p.Part_Type.Name,
                            Part_Type_Abbreviation = p.Part_Type.Abbreviation,
                            Part_Type_Dimension = p.Part_Type.Dimension,
                            Part_Type_Selling_Price = p.Part_Type.Selling_Price,
                            Part_Type_Description = p.Part_Type.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartController GET ID");
                return "false|Failed to retrieve Part.";
            }
        }

        // POST: api/Part
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Part part = new Model.Part();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject partStatusDetails = JObject.Parse(message);

                int key = db.Parts.Count() == 0 ? 1 : (from t in db.Parts
                                                       orderby t.Part_ID descending
                                                             select t.Part_ID).First() + 1;

                part.Part_ID = key;
                part.Part_Serial = (string)partStatusDetails["Part_Serial"];
                part.Part_Status_ID = (int)partStatusDetails["Part_Status_ID"];
                part.Date_Added = DateTime.Now;
                part.Cost_Price = (decimal)partStatusDetails["Cost_Price"];
                part.Part_Stage = (int)partStatusDetails["Part_Stage"];
                part.Parent_ID = 0;
                part.Part_Type_ID = (int)partStatusDetails["Part_Type_ID"];

                db.Parts.Add(part);
                db.SaveChanges();
                return "true|Part #" + key + " successfully added to system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartController POST");
                return "false|An error has occured adding the Part to the system.";
            }
        }

        // PUT: api/Part/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Part part = new Part();
                part = (from p in db.Parts
                        where p.Part_ID == id
                        select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject partStatusDetails = JObject.Parse(message);

                part.Part_Serial = (string)partStatusDetails["Part_Serial"];
                part.Part_Status_ID = (int)partStatusDetails["Part_Status_ID"];
                part.Cost_Price = (decimal)partStatusDetails["Cost_Price"];
                part.Part_Type_ID = (int)partStatusDetails["Part_Type_ID"];

                db.SaveChanges();
                return "true|Part successfully updated on the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartController PUT");
                return "false|An error has occured updating the Part on the system.";
            }
        }

        // DELETE: api/Part/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Parts.SingleOrDefault(x => x.Part_ID == id);
                if (itemToRemove != null)
                {
                    db.Parts.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Part has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartController DELETE");
                return "false|The Part is in use and cannot be removed from the system.";
            }
        }
    }
}
