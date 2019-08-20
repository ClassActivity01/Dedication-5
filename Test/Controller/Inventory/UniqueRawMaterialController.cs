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
    public class UniqueRawMaterialController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/UniqueRawMaterial
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    unique_raw_materials =
                        from p in db.Unique_Raw_Material join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                        orderby rm.Name
                        select new
                        {
                            Raw_Material_ID = p.Raw_Material_ID,
                            Raw_Material_Name = rm.Name,
                            Raw_Material_Description = rm.Description,
                            Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                            Dimension = p.Dimension,
                            Quality = p.Quality,
                            Date_Added = p.Date_Added,
                            Date_Used = p.Date_Used,
                            Cost_Price = p.Cost_Price,
                            Supplier_Order_ID = p.Supplier_Order_ID
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueRawMaterial GET");
                return "false|Failed to retrieve Unique Raw Materials.";
            }
        }

        // GET: api/UniqueRawMaterial/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    unique_raw_materials =
                        from p in db.Unique_Raw_Material
                        join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                        orderby rm.Name
                        where p.Unique_Raw_Material_ID == id
                        select new
                        {
                            Raw_Material_ID = p.Raw_Material_ID,
                            Raw_Material_Name = rm.Name,
                            Raw_Material_Description = rm.Description,
                            Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                            Dimension = p.Dimension,
                            Quality = p.Quality,
                            Date_Added = p.Date_Added,
                            Date_Used = p.Date_Used,
                            Cost_Price = p.Cost_Price,
                            Supplier_Order_ID = p.Supplier_Order_ID
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueRawMaterial GET ID");
                return "false|Failed to retrieve Unique Raw Material.";
            }
        }

        // POST: api/UniqueRawMaterial
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Unique_Raw_Material raw = new Model.Unique_Raw_Material();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject rawDetails = JObject.Parse(message);

                int key = db.Unique_Raw_Material.Count() == 0 ? 1 : (from t in db.Unique_Raw_Material
                                                                     orderby t.Unique_Raw_Material_ID descending
                                                              select t.Unique_Raw_Material_ID).First() + 1;

                raw.Unique_Raw_Material_ID = key;
                raw.Raw_Material_ID = (int)rawDetails["Raw_Material_ID"];
                raw.Dimension = (string)rawDetails["Dimension"];
                raw.Quality = (string)rawDetails["Quality"];
                raw.Date_Added = (DateTime)rawDetails["Date_Added"];
                //raw.Date_Used = (DateTime)rawDetails["Date_Used"];
                raw.Cost_Price = (decimal)rawDetails["Cost_Price"];
                // raw.Supplier_Order_ID = (int)rawDetails["Supplier_Order_ID"];

                if(rawDetails["Date_Used"] == null)
                    raw.Date_Used = null;
                else
                    raw.Date_Used = (DateTime)rawDetails["Date_Used"];

                if((int)rawDetails["Supplier_Order_ID"] == 0)
                     raw.Supplier_Order_ID = null;
                else
                    raw.Supplier_Order_ID = (int)rawDetails["Supplier_Order_ID"];


                string errorString = "false|";
                bool error = false;

                /*if ((from t in db.Supplier_Order
                     where t.Supplier_Order_ID == raw.Supplier_Order_ID
                     select t).Count() == 0)
                {
                    error = true;
                    errorString += "The Supplier Order No. does not exist in the system. ";
                }*/



                if (error)
                    return errorString;

                db.Unique_Raw_Material.Add(raw);

                db.SaveChanges();
                return "true|Unique Raw Material #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueRawMaterial POST");
                return "false|An error has occured adding the Unique Raw Material to the system.";
            }
        }

        // PUT: api/UniqueRawMaterial/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Unique_Raw_Material raw = new Unique_Raw_Material();
                raw = (from p in db.Unique_Raw_Material
                       where p.Unique_Raw_Material_ID == id
                       select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject rawDetails = JObject.Parse(message);

                raw.Raw_Material_ID = (int)rawDetails["Raw_Material_ID"];
                raw.Dimension = (string)rawDetails["Dimension"];
                raw.Quality = (string)rawDetails["Quality"];

                raw.Cost_Price = (decimal)rawDetails["Cost_Price"];


                if (rawDetails["Date_Used"] == null)
                    raw.Date_Used = null;
                else
                    raw.Date_Used = (DateTime)rawDetails["Date_Used"];

                if ((int)rawDetails["Supplier_Order_ID"] == 0)
                    raw.Supplier_Order_ID = null;
                else
                    raw.Supplier_Order_ID = (int)rawDetails["Supplier_Order_ID"];


                string errorString = "false|";
                bool error = false;

                /*if ((from t in db.Supplier_Order
                     where t.Supplier_Order_ID == raw.Supplier_Order_ID
                     select t).Count() == 0)
                {
                    error = true;
                    errorString += "The Supplier Order No. does not exist in the system. ";
                }*/

                if (error)
                    return errorString;

                db.SaveChanges();
                return "true|Unique Raw Material successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueRawMaterial PUT");
                return "false|An error has occured updating the Unique Raw Material on the system.";
            }
        }

        // DELETE: api/UniqueRawMaterial/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Unique_Raw_Material.SingleOrDefault(x => x.Unique_Raw_Material_ID == id);
                if (itemToRemove != null)
                {
                    db.Unique_Raw_Material.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Unique Raw Material has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueRawMaterial DELETE");
                return "false|The Unique Raw Material is in use and cannot be removed from the system.";
            }
        }
    }
}
