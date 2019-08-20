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
    public class PartTypeController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/PartType
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    part_types =
                        from p in db.Part_Type
                        orderby p.Name
                        select new
                        {
                            Part_Type_ID = p.Part_Type_ID,
                            Abbreviation = p.Abbreviation,
                            Name = p.Name,
                            Description = p.Description,
                            Selling_Price = p.Selling_Price,
                            Dimension = p.Dimension,
                            Minimum_Level = p.Minimum_Level,
                            Maximum_Level = p.Maximum_Level,
                            Max_Discount_Rate = p.Max_Discount_Rate,
                            Manufactured = p.Manufactured,
                            Average_Completion_Time = p.Average_Completion_Time
                        }
                });
                return "true|" + result.ToString();
            }
            catch
            {
                return "false|Failed to retrieve Part Types.";
            }
        }

        // GET: api/PartType/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    part_types =
                        from p in db.Part_Type
                        orderby p.Name
                        where p.Part_Type_ID == id
                        select new
                        {
                            Part_Type_ID = p.Part_Type_ID,
                            Abbreviation = p.Abbreviation,
                            Name = p.Name,
                            Description = p.Description,
                            Selling_Price = p.Selling_Price,
                            Dimension = p.Dimension,
                            Minimum_Level = p.Minimum_Level,
                            Maximum_Level = p.Maximum_Level,
                            Max_Discount_Rate = p.Max_Discount_Rate,
                            Manufactured = p.Manufactured,
                            Average_Completion_Time = p.Average_Completion_Time
                        }
                });
                return "true|" + result.ToString();
            }
            catch
            {
                return "false|Failed to retrieve Part Type.";
            }
        }

        // POST: api/PartType
        public string Post(HttpRequestMessage value)
        {
         //   try
         //   {
                Model.Part_Type part = new Model.Part_Type();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject partDetails = (JObject)json["partType"];
                JArray suppDetails = (JArray)json["supplier"];
                JArray recipeDetails = (JArray)json["recipe"];
                JArray manualDetails = (JArray)json["manual"];
                JArray machineDetails = (JArray)json["machine"];

                int key = db.Part_Type.Count() == 0 ? 1 : (from t in db.Part_Type
                                                           orderby t.Part_Type_ID descending
                                                              select t.Part_Type_ID).First() + 1;

                part.Part_Type_ID = key;

                part.Abbreviation = (string)partDetails["Abbreviation"];
                part.Name = (string)partDetails["Name"];
                part.Description = (string)partDetails["Description"];
                part.Selling_Price = (decimal)partDetails["Selling_Price"];
                part.Dimension = (string)partDetails["Dimension"];
                part.Minimum_Level = (int)partDetails["Minimum_Level"];
                part.Maximum_Level = (int)partDetails["Maximum_Level"];
                part.Max_Discount_Rate = (int)partDetails["Max_Discount_Rate"];
                part.Manufactured = Convert.ToBoolean(Convert.ToInt32(partDetails["Manufactured"]));
                part.Average_Completion_Time = (int)partDetails["Average_Completion_Time"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Part_Type
                     where t.Name == part.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Part Type name entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Part_Type.Add(part);

                foreach (JObject supplier in suppDetails)
                {
                    Part_Supplier ps = new Part_Supplier();
                    ps.Part_Type_ID = key;
                    ps.Supplier_ID = (int)supplier["Supplier_ID"];
                    ps.Is_Prefered = Convert.ToBoolean(Convert.ToInt32(supplier["Is_Prefered"]));
                    ps.unit_price = (decimal)supplier["unit_price"];

                    db.Part_Supplier.Add(ps);
                }

                db.SaveChanges();
                return "true|Part Type successfully added.";
    /*        }
            catch
            {
                return "false|An error has occured adding the Raw Material to the system.";
            } */
        }

        // PUT: api/PartType/5
        public string Put(int id, HttpRequestMessage value)
        {
            return "";
        }

        // DELETE: api/PartType/5
        public string Delete(int id)
        { 
            return "";
        }
    }
}
