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
    public class RawMaterialController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/RawMaterial
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    raw_materials =
                        from p in db.Raw_Material
                        orderby p.Name
                        select new
                        {
                            Raw_Material_ID = p.Raw_Material_ID,
                            Name = p.Name,
                            Description = p.Description,
                            Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                            Raw_Material_Suppliers =
                                from d in db.Raw_Material_Supplier
                                where d.Raw_Material_ID == p.Raw_Material_ID
                                select new
                                {
                                    Supplier_ID = d.Supplier_ID,
                                    Is_Prefered = d.Is_Prefered,
                                    unit_price = d.unit_price,
                                    Name = d.Supplier.Name
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "RawMaterialController GET");
                return "false|Failed to retrieve Raw Materials.";
            }
        }

        // GET: api/RawMaterial/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    raw_materials =
                        from p in db.Raw_Material
                        orderby p.Name
                        where p.Raw_Material_ID == id
                        select new
                        {
                            Raw_Material_ID = p.Raw_Material_ID,
                            Name = p.Name,
                            Description = p.Description,
                            Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                            Raw_Material_Suppliers =
                                from d in db.Raw_Material_Supplier
                                where d.Raw_Material_ID == p.Raw_Material_ID
                                select new
                                {
                                    Supplier_ID = d.Supplier_ID,
                                    Is_Prefered = d.Is_Prefered,
                                    unit_price = d.unit_price,
                                    Name = d.Supplier.Name
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "RawMaterialController GET ID");
                return "false|Failed to retrieve Raw Material.";
            }
        }

        // POST: api/RawMaterial
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Raw_Material raw = new Model.Raw_Material();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject rawDetails = (JObject)json["raw"];
                JArray suppDetails = (JArray)json["suppliers"];

                int key = db.Raw_Material.Count() == 0 ? 1 : (from t in db.Raw_Material
                                                              orderby t.Raw_Material_ID descending
                                                           select t.Raw_Material_ID).First() + 1;

                raw.Raw_Material_ID = key;
                raw.Name = (string)rawDetails["Name"];
                raw.Description = (string)rawDetails["Description"];
                raw.Minimum_Stock_Instances = (int)rawDetails["Minimum_Stock_Instances"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Raw_Material
                     where t.Name == raw.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Raw Material name entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Raw_Material.Add(raw);

                foreach (JObject supplier in suppDetails)
                {
                    Raw_Material_Supplier rms = new Raw_Material_Supplier();
                    rms.Raw_Material_ID = key;
                    rms.Supplier_ID = (int)supplier["Supplier_ID"];
                    rms.Is_Prefered = Convert.ToBoolean(supplier["Is_Prefered"]);
                    rms.unit_price = (decimal)supplier["unit_price"];

                    db.Raw_Material_Supplier.Add(rms);
                }

                db.SaveChanges();
                return "true|Raw Material #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "RawMaterialController POST");
                return "false|An error has occured adding the Raw Material to the system.";
            }
        }

        // PUT: api/RawMaterial/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Raw_Material raw = new Raw_Material();
                raw = (from p in db.Raw_Material
                        where p.Raw_Material_ID == id
                        select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject rawDetails = (JObject)json["raw"];
                JArray suppDetails = (JArray)json["suppliers"];

                raw.Name = (string)rawDetails["Name"];
                raw.Description = (string)rawDetails["Description"];
                raw.Minimum_Stock_Instances = (int)rawDetails["Minimum_Stock_Instances"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Raw_Material
                     where t.Name == raw.Name && t.Raw_Material_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Raw Material name entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Raw_Material_Supplier.RemoveRange(db.Raw_Material_Supplier.Where(x => x.Raw_Material_ID == id));

                foreach (JObject supplier in suppDetails)
                {
                    Raw_Material_Supplier rms = new Raw_Material_Supplier();
                    rms.Raw_Material_ID = id;
                    rms.Supplier_ID = (int)supplier["Supplier_ID"];
                    rms.Is_Prefered = Convert.ToBoolean(supplier["Is_Prefered"]);
                    rms.unit_price = (decimal)supplier["unit_price"];

                    db.Raw_Material_Supplier.Add(rms);
                }

                db.SaveChanges();
                return "true|Raw Material successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "RawMaterialController PUT");
                return "false|An error has occured updating the Raw Material on the system.";
            }
        }

        // DELETE: api/RawMaterial/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Raw_Material.SingleOrDefault(x => x.Raw_Material_ID == id);
                db.Raw_Material_Supplier.RemoveRange(db.Raw_Material_Supplier.Where(x => x.Raw_Material_ID == id));
                if (itemToRemove != null)
                {
                    db.Raw_Material.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Raw Material has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "RawMaterialController DELETE");
                return "false|The Raw Material is in use and cannot be removed from the system.";
            }
        }
    }
}
