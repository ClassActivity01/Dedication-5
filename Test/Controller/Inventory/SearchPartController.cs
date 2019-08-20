using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Inventory
{
    public class SearchPartController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchPart
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                string method = (string)json["method"]; //Exact, Contains, Similar
                string criteria = (string)json["criteria"]; //Typed in search value
                string category = (string)json["category"]; //Name, Description, Access Level
                JObject result = null;

                if (method == "Exact")
                {
                    if (category == "All")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Serial == criteria || p.Part_Type.Abbreviation == criteria
                                    || p.Part_Type.Name == criteria
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
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Type.Name == criteria
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
                    }
                    else
                    if (category == "Serial")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Serial == criteria
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
                    }
                    else
                    if (category == "Abb")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Type.Abbreviation == criteria
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
                    }
                    else
                    if (category == "Job Card ID")
                    {
                    }
                }
                else
                if (method == "Contains")
                {
                    if (category == "All")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Serial.Contains(criteria) || p.Part_Type.Abbreviation.Contains(criteria)
                                    || p.Part_Type.Name.Contains(criteria)
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
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Type.Name.Contains(criteria)
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
                    }
                    else
                    if (category == "Serial")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Serial.Contains(criteria)
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
                    }
                    else
                    if (category == "Abb")
                    {
                        result = JObject.FromObject(new
                        {
                            parts =
                                from p in db.Parts
                                where p.Part_Type.Abbreviation.Contains(criteria)
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
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchPartController");
                return "false|An error has occured searching for Parts on the system.";
            }
        }
    }
}
