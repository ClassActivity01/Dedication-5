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
    public class ComponentController : ApiController
    {
        ProteusEntities db = new ProteusEntities();
        
        // GET: api/Component
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    components =
                        from p in db.Components
                        orderby p.Name
                        select new
                        {
                            Component_ID = p.Component_ID,
                            Quantity = p.Quantity,
                            Unit_Price = p.Unit_Price,
                            Description = p.Description,
                            Dimension = p.Dimension,
                            Name = p.Name,
                            Min_Stock = p.Min_Stock,
                            Suppliers =
                                from d in db.Component_Supplier
                                where d.Component_ID == p.Component_ID
                                select new
                                {
                                    Supplier_ID = d.Supplier_ID,
                                    is_preferred = d.is_preferred,
                                    unit_price = d.unit_price
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ComponentController GET");
                return "false|Failed to retrieve Components.";
            }
        }

        // GET: api/Component/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    components =
                        from p in db.Components
                        orderby p.Name
                        where p.Component_ID == id
                        select new
                        {
                            Component_ID = p.Component_ID,
                            Quantity = p.Quantity,
                            Unit_Price = p.Unit_Price,
                            Description = p.Description,
                            Dimension = p.Dimension,
                            Name = p.Name,
                            Min_Stock = p.Min_Stock,
                            Suppliers =
                                from d in db.Component_Supplier
                                where d.Component_ID == id
                                select new
                                {
                                    Supplier_ID = d.Supplier_ID,
                                    is_preferred = d.is_preferred,
                                    unit_price = d.unit_price
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ComponentController GET ID");
                return "false|Failed to retrieve Component.";
            }
        }

        // POST: api/Component
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Component component = new Model.Component();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject cmpDetails = (JObject)json["component"];
                JArray supplierDetails = (JArray)json["suppliers"];

                int key = db.Components.Count() == 0 ? 1 : (from t in db.Components
                                                            orderby t.Component_ID descending
                                                         select t.Component_ID).First() + 1;

                component.Component_ID = key;
                component.Quantity = (int)cmpDetails["Quantity"];
                component.Unit_Price = (decimal)cmpDetails["Unit_Price"];
                component.Description = (string)cmpDetails["Description"];
                component.Dimension = (string)cmpDetails["Dimension"];
                component.Name = (string)cmpDetails["Name"];
                component.Min_Stock = (int)cmpDetails["Min_Stock"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Components
                     where t.Name == component.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Component name entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Components.Add(component);

                foreach (JObject supplier in supplierDetails)
                {
                    Component_Supplier cs = new Component_Supplier();
                    cs.Component_ID = key;
                    cs.Supplier_ID = (int)supplier["Supplier_ID"];
                    cs.is_preferred = Convert.ToBoolean(Convert.ToInt32(supplier["Is_Prefered"]));
                    cs.unit_price = (decimal)supplier["unit_price"];

                    db.Component_Supplier.Add(cs);
                }

                db.SaveChanges();
                return "true|Component #"+key+" successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ComponentController POST");
                return "false|An error has occured adding the Component to the system.";
            }
        }

        // PUT: api/Component/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Component component = new Component();
                component = (from p in db.Components
                             where p.Component_ID == id
                            select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject cmpDetails = (JObject)json["component"];
                JArray supplierDetails = (JArray)json["suppliers"];

                component.Quantity = (int)cmpDetails["Quantity"];
                component.Unit_Price = (decimal)cmpDetails["Unit_Price"];
                component.Description = (string)cmpDetails["Description"];
                component.Dimension = (string)cmpDetails["Dimension"];
                component.Name = (string)cmpDetails["Name"];
                component.Min_Stock = (int)cmpDetails["Min_Stock"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Components
                     where t.Name == component.Name && t.Component_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Component name entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Component_Supplier.RemoveRange(db.Component_Supplier.Where(x => x.Component_ID == id));

                foreach (JObject supplier in supplierDetails)
                {
                    Component_Supplier cs = new Component_Supplier();
                    cs.Component_ID = id;
                    cs.Supplier_ID = (int)supplier["Supplier_ID"];
                    cs.is_preferred = Convert.ToBoolean(Convert.ToInt32(supplier["Is_Prefered"]));
                    cs.unit_price = (decimal)supplier["unit_price"];

                    db.Component_Supplier.Add(cs);
                }

                db.SaveChanges();
                return "true|Component successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ComponentController PUT");
                return "false|An error has occured updating the Component on the system.";
            }
        }

        // DELETE: api/Component/5
        public string Delete(int id)
        {
            try
            {
                db.Component_Supplier.RemoveRange(db.Component_Supplier.Where(x => x.Component_ID == id));
                var itemToRemove = db.Components.SingleOrDefault(x => x.Component_ID == id);
                if (itemToRemove != null)
                {
                    db.Components.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Component has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ComponentController DELETE");
                return "false|The Component is in use and cannot be removed from the system.";
            }
        }
    }
}
