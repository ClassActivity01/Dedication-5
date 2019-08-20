using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Supplier
{
    public class SupplierOrderController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/SupplierOrder
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    supplier_orders =
                        from p in db.Supplier_Order
                        select new
                        {
                            Supplier_Order_ID = p.Supplier_Order_ID,
                            Date = p.Date,
                            Supplier_Order_Status_ID = p.Supplier_Order_Status_ID,
                            Supplier_ID = p.Supplier_ID,
                            Status_Name = p.Supplier_Order_Status.Name,
                            Supplier_Name = p.Supplier.Name,

                            rms =
                                        from d in db.Supplier_Order_Detail_Raw_Material
                                        where d.Supplier_Order_ID == p.Supplier_Order_ID
                                        select new
                                        {
                                            Raw_Material_ID = d.Raw_Material_ID,
                                            Raw_Material_Name = d.Raw_Material.Name,
                                            Quantity = d.Quantity,
                                            Price = d.Price,
                                            Quantity_Received = d.Quantity_Received,
                                            Dimensions = d.Dimensions
                                        },

                            cs =
                                        from d in db.Supplier_Order_Component
                                        where d.Supplier_Order_ID == p.Supplier_Order_ID
                                        select new
                                        {
                                            Component_ID = d.Component_ID,
                                            Component_Name = d.Component.Name,
                                            Quantity_Requested = d.Quantity_Requested,
                                            Price = d.Price,
                                            Quantity_Received = d.Quantity_Received
                                        },

                            ps =
                                        from d in db.Supplier_Order_Detail_Part
                                        where d.Supplier_Order_ID == p.Supplier_Order_ID
                                        select new
                                        {
                                            Part_Type_Name = d.Part_Type.Name,
                                            Part_Type_ID = d.Part_Type_ID,
                                            Quantity = d.Quantity,
                                            Price = d.Price,
                                            Quantity_Received = d.Quantity_Received
                                        }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierOrderController GET");
                return "false|Failed to retrieve Supplier Orders.";
            }
        }

        // GET: api/SupplierOrder/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    supplier_orders =
                        from p in db.Supplier_Order
                        where p.Supplier_Order_ID == id
                        select new
                        {
                            Supplier_Order_ID = p.Supplier_Order_ID,
                            Date = p.Date,
                            Supplier_Order_Status_ID = p.Supplier_Order_Status_ID,
                            Supplier_ID = p.Supplier_ID,
                            Status_Name = p.Supplier_Order_Status.Name,
                            Supplier_Name = p.Supplier.Name,

                            rms =
                                        from d in db.Supplier_Order_Detail_Raw_Material
                                        where d.Supplier_Order_ID == p.Supplier_Order_ID
                                        select new
                                        {
                                            Raw_Material_ID = d.Raw_Material_ID,
                                            Raw_Material_Name = d.Raw_Material.Name,
                                            Quantity = d.Quantity,
                                            Price = d.Price,
                                            Quantity_Received = d.Quantity_Received,
                                            Dimensions = d.Dimensions,

                                            unique = 
                                                from c in db.Unique_Raw_Material
                                                where c.Supplier_Order_ID == p.Supplier_Order_ID
                                                select new
                                                {
                                                    Raw_Material_ID = c.Raw_Material_ID,
                                                    Raw_Material_Name = c.Raw_Material.Name,
                                                    Raw_Material_Description = c.Raw_Material.Description,
                                                    Unique_Raw_Material_ID = c.Unique_Raw_Material_ID,
                                                    Dimension = c.Dimension,
                                                    Quality = c.Quality,
                                                    Date_Added = c.Date_Added,
                                                    Date_Used = c.Date_Used,
                                                    Cost_Price = c.Cost_Price
                                                }
                                        },

                            cs =
                                        from d in db.Supplier_Order_Component
                                        where d.Supplier_Order_ID == p.Supplier_Order_ID
                                        select new
                                        {
                                            Component_ID = d.Component_ID,
                                            Component_Name = d.Component.Name,
                                            Quantity_Requested = d.Quantity_Requested,
                                            Price = d.Price,
                                            Quantity_Received = d.Quantity_Received
                                        },

                            ps =
                                        from d in db.Supplier_Order_Detail_Part
                                        where d.Supplier_Order_ID == p.Supplier_Order_ID
                                        select new
                                        {
                                            Part_Type_Name = d.Part_Type.Name,
                                            Part_Type_ID = d.Part_Type_ID,
                                            Quantity = d.Quantity,
                                            Price = d.Price,
                                            Quantity_Received = d.Quantity_Received,

                                            parts =
                                                from c in db.Parts
                                                where c.Supplier_Order.Contains(p)
                                                select new
                                                {
                                                    Part_ID = c.Part_ID,
                                                    Part_Serial = c.Part_Serial,
                                                    Part_Status_ID = c.Part_Status_ID,
                                                    Date_Added = c.Date_Added,
                                                    Cost_Price = c.Cost_Price,
                                                    Part_Stage = c.Part_Stage,
                                                    Part_Type_ID = c.Part_Type_ID,

                                                    Part_Type_Name = c.Part_Type.Name,
                                                    Part_Type_Abbreviation = c.Part_Type.Abbreviation,
                                                    Part_Type_Dimension = c.Part_Type.Dimension,
                                                    Part_Type_Selling_Price = c.Part_Type.Selling_Price,
                                                    Part_Type_Description = c.Part_Type.Description
                                                }
                                        }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierOrderController GET ID");
                return "false|Failed to retrieve Supplier Order.";
            }
        }

        // POST: api/SupplierOrder
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Supplier_Order supplier = new Model.Supplier_Order();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject orderDetails = (JObject)json["order"];
                string type = (string)json["type"];
                string action = (string)json["action"];

                int key = db.Supplier_Order.Count() == 0 ? 1 : (from t in db.Supplier_Order
                                                                orderby t.Supplier_Order_ID descending
                                                                select t.Supplier_Order_ID).First() + 1;

                supplier.Supplier_Order_ID = key;
                supplier.Supplier_Order_Status_ID = (int)orderDetails["Supplier_Order_Status_ID"];
                supplier.Date = (DateTime)orderDetails["Date"];
                supplier.Supplier_ID = (int)orderDetails["Supplier_ID"];

                db.Supplier_Order.Add(supplier);

                if (type == "AdHoc")
                {
                    JArray componentDetails = (JArray)json["components"];
                    JArray partTypeDetails = (JArray)json["parts"];
                    JArray RawMaterialDetails = (JArray)json["raw"];

                    if (componentDetails != null)
                        foreach (JObject comp in componentDetails)
                        {
                            Supplier_Order_Component cs = new Supplier_Order_Component();
                            cs.Component_ID = (int)comp["Component_ID"];
                            cs.Supplier_Order_ID = key;
                            cs.Quantity_Requested = (int)comp["Quantity_Requested"];
                            cs.Quantity_Received = 0;
                            cs.Price = (decimal)comp["Price"];

                            db.Supplier_Order_Component.Add(cs);
                        }

                    if (partTypeDetails != null)
                        foreach (JObject part in partTypeDetails)
                        {
                            Supplier_Order_Detail_Part ps = new Supplier_Order_Detail_Part();
                            ps.Part_Type_ID = (int)part["Part_Type_ID"];
                            ps.Supplier_Order_ID = key;
                            ps.Quantity = (int)part["Quantity"];
                            ps.Quantity_Received = 0;
                            ps.Price = (decimal)part["Price"];

                            db.Supplier_Order_Detail_Part.Add(ps);
                        }

                    if (RawMaterialDetails != null)
                        foreach (JObject raw in RawMaterialDetails)
                        {
                            Supplier_Order_Detail_Raw_Material rms = new Supplier_Order_Detail_Raw_Material();
                            rms.Raw_Material_ID = (int)raw["Raw_Material_ID"];
                            rms.Supplier_Order_ID = key;
                            rms.Quantity = (int)raw["Quantity"];
                            rms.Price = (decimal)raw["Price"];
                            rms.Quantity_Received = 0;
                            rms.Dimensions = (string)raw["Dimensions"];

                            db.Supplier_Order_Detail_Raw_Material.Add(rms);
                        }
                }else
                {
                    JArray componentDetails = (JArray)json["components"];
                    JArray partTypeDetails = (JArray)json["parts"];
                    JArray RawMaterialDetails = (JArray)json["raw"];

                    int quoteID = (int)orderDetails["Supplier_Quote_ID"];

                    Supplier_Quote sq = new Supplier_Quote();
                    sq = (from p in db.Supplier_Quote
                          where p.Supplier_Quote_ID == quoteID
                          select p).First();

                    supplier.Supplier_Quote.Add(sq);

                    if (componentDetails != null)
                        foreach (JObject comp in componentDetails)
                        {
                            Supplier_Order_Component cs = new Supplier_Order_Component();
                            cs.Component_ID = (int)comp["Component_ID"];
                            cs.Supplier_Order_ID = key;
                            cs.Quantity_Requested = (int)comp["Quantity_Requested"];
                            cs.Quantity_Received = 0;
                            cs.Price = (decimal)comp["Price"];

                            db.Supplier_Order_Component.Add(cs);
                        }

                    if (partTypeDetails != null)
                        foreach (JObject part in partTypeDetails)
                        {
                            Supplier_Order_Detail_Part ps = new Supplier_Order_Detail_Part();
                            ps.Part_Type_ID = (int)part["Part_Type_ID"];
                            ps.Supplier_Order_ID = key;
                            ps.Quantity = (int)part["Quantity"];
                            ps.Quantity_Received = 0;
                            ps.Price = (decimal)part["Price"];

                            db.Supplier_Order_Detail_Part.Add(ps);
                        }

                    if (RawMaterialDetails != null)
                        foreach (JObject raw in RawMaterialDetails)
                        {
                            Supplier_Order_Detail_Raw_Material rms = new Supplier_Order_Detail_Raw_Material();
                            rms.Raw_Material_ID = (int)raw["Raw_Material_ID"];
                            rms.Supplier_Order_ID = key;
                            rms.Quantity = (int)raw["Quantity"];
                            rms.Price = (decimal)raw["Price"];
                            rms.Quantity_Received = 0;
                            rms.Dimensions = (string)raw["Dimensions"];

                            db.Supplier_Order_Detail_Raw_Material.Add(rms);
                        }
                }

                db.SaveChanges();

                if (action == "email")
                {
                    JArray componentDetails = (JArray)json["components"];
                    JArray partTypeDetails = (JArray)json["parts"];
                    JArray RawMaterialDetails = (JArray)json["raw"];

                    Model.Supplier sup = new Model.Supplier();
                    sup = (from p in db.Suppliers
                           where p.Supplier_ID == supplier.Supplier_ID
                           select p).First();

                    string to = sup.Email;
                    string subject = "WME Supplier Order #" + key;

                    String orderDate = supplier.Date.ToShortDateString();
                    string body = "Walter Meano Engineering Supplier Order #" + key + "\nThe order was placed on " + orderDate + "\n\nItems in Order:\n";

                    if (componentDetails != null)
                        foreach (JObject comp in componentDetails)
                        {
                            Component cs = new Component();
                            int comp_id = (int)comp["Component_ID"];
                            cs = (from p in db.Components
                                  where p.Component_ID == comp_id
                                  select p).First();

                            body += cs.Name + "\t\tx" + (int)comp["Quantity_Requested"] + "\n";
                        }

                    if (partTypeDetails != null)
                        foreach (JObject part in partTypeDetails)
                        {
                            Part_Type pt = new Part_Type();
                            int part_id = (int)part["Part_Type_ID"];
                            pt = (from p in db.Part_Type
                                  where p.Part_Type_ID == part_id
                                  select p).First();

                            body += pt.Name + "\t\tx" + (int)part["Quantity"] + "\n";
                        }

                    if (RawMaterialDetails != null)
                        foreach (JObject raw in RawMaterialDetails)
                        {
                            Raw_Material raw2 = new Raw_Material();
                            int raw_id = (int)raw["Raw_Material_ID"];
                            raw2 = (from p in db.Raw_Material
                                  where p.Raw_Material_ID == raw_id
                                  select p).First();

                            body += raw2.Name + "\t\tx" + (int)raw["Quantity"] + "\n";
                        }

                    Email.SendEmail(to, subject, body);
                }

                return "true|Supplier Purchase Order #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierOrderController POST");
                return "false|An error has occured adding the Supplier Order to the system.";
            }
        }

        // PUT: api/SupplierOrder/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Supplier_Order so = new Supplier_Order();
                so = (from p in db.Supplier_Order
                      where p.Supplier_Order_ID == id
                       select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                so.Supplier_Order_Status_ID = (int)json["Supplier_Order_Status_ID"];

                if (so.Supplier_Order_Status_ID == 7)
                {
                    int rawCount = (from t in db.Supplier_Order_Detail_Raw_Material
                                    where t.Supplier_Order_ID == id && t.Quantity_Received > 0
                                    select t).Count();
                    int compCount = (from t in db.Supplier_Order_Component
                                     where t.Supplier_Order_ID == id && t.Quantity_Received > 0
                                     select t).Count();
                    int partCount = (from t in db.Supplier_Order_Detail_Part
                                     where t.Supplier_Order_ID == id && t.Quantity_Received > 0
                                     select t).Count();
                    if (rawCount > 0 || compCount > 0 || partCount > 0)
                    {
                        return "false|The Purchase Order has already received some of its items, thus it cannot be cancelled.";
                    }else
                        db.SaveChanges();
                }
                else
                    db.SaveChanges();

                return "true|Supplier Order successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierOrderController PUT");
                return "false|An error has occured updating the Supplier Order on the system.";
            }
        }
    }
}
