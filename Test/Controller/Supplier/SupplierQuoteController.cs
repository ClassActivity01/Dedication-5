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
    public class SupplierQuoteController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/SupplierQuote
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    supplier_quotes =
                            from p in db.Supplier_Quote
                            select new
                            {
                                Supplier_Quote_ID = p.Supplier_Quote_ID,
                                Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                Supplier_Quote_Date = p.Supplier_Quote_Date,
                                Supplier_ID = p.Supplier_ID,
                                Supplier_Name = p.Supplier.Name,
                                Supplier_Quote_Expiry_Date = p.Supplier_Quote_Expiry_Date,

                                rms =
                                            from d in db.Supplier_Quote_Detail_Raw_Material
                                            where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                            select new
                                            {
                                                Raw_Material_ID = d.Raw_Material_ID,
                                                Raw_Material_Name = d.Raw_Material.Name,
                                                Quantity = d.Quantity,
                                                Price = d.Price,
                                                Dimension = d.Dimension
                                            },

                                cs =
                                            from d in db.Supplier_Quote_Component
                                            where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                            select new
                                            {
                                                Component_ID = d.Component_ID,
                                                Component_Name = d.Component.Name,
                                                Quantity_Requested = d.Quantity_Requested,
                                                Price = d.Price
                                            },

                                ps =
                                            from d in db.Supplier_Quote_Detail_Part
                                            where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                            select new
                                            {
                                                Part_Type_Name = d.Part_Type.Name,
                                                Part_Type_ID = d.Part_Type_ID,
                                                Quantity = d.Quantity,
                                                Price = d.Price
                                            }
                            }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierQuoteController GET");
                return "false|Failed to retrieve Supplier Quotes.";
            }
        }

        // GET: api/SupplierQuote/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    supplier_quotes =
                            from p in db.Supplier_Quote
                            where p.Supplier_Quote_ID == id
                            select new
                            {
                                Supplier_Quote_ID = p.Supplier_Quote_ID,
                                Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                Supplier_Quote_Date = p.Supplier_Quote_Date,
                                Supplier_ID = p.Supplier_ID,
                                Supplier_Name = p.Supplier.Name,
                                Supplier_Quote_Expiry_Date = p.Supplier_Quote_Expiry_Date,

                                rms =
                                            from d in db.Supplier_Quote_Detail_Raw_Material
                                            where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                            select new
                                            {
                                                Raw_Material_ID = d.Raw_Material_ID,
                                                Raw_Material_Name = d.Raw_Material.Name,
                                                Quantity = d.Quantity,
                                                Price = d.Price,
                                                Dimension = d.Dimension
                                            },

                                cs =
                                            from d in db.Supplier_Quote_Component
                                            where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                            select new
                                            {
                                                Component_ID = d.Component_ID,
                                                Component_Name = d.Component.Name,
                                                Quantity_Requested = d.Quantity_Requested,
                                                Price = d.Price
                                            },

                                ps =
                                            from d in db.Supplier_Quote_Detail_Part
                                            where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                            select new
                                            {
                                                Part_Type_Name = d.Part_Type.Name,
                                                Part_Type_ID = d.Part_Type_ID,
                                                Quantity = d.Quantity,
                                                Price = d.Price
                                            }
                            }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierQuoteController GET ID");
                return "false|Failed to retrieve Supplier Quote.";
            }
        }

        // POST: api/SupplierQuote
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Supplier_Quote supplier = new Model.Supplier_Quote();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject supplierDetails = (JObject)json["quote"];
                JArray componentDetails = (JArray)json["components"];
                JArray partTypeDetails = (JArray)json["parts"];
                JArray RawMaterialDetails = (JArray)json["raw"];

                int key = db.Supplier_Quote.Count() == 0 ? 1 : (from t in db.Supplier_Quote
                                                                orderby t.Supplier_Quote_ID descending
                                                           select t.Supplier_Quote_ID).First() + 1;

                supplier.Supplier_Quote_ID = key;
                supplier.Supplier_Quote_Serial = (string)supplierDetails["Supplier_Quote_Reference"];
                supplier.Supplier_Quote_Date = (DateTime)supplierDetails["Supplier_Quote_Date"];
                supplier.Supplier_ID = (int)supplierDetails["Supplier_ID"];
                supplier.Supplier_Quote_Expiry_Date = (DateTime)supplierDetails["Supplier_Quote_Expiry_Date"];

                db.Supplier_Quote.Add(supplier);

                if (componentDetails != null)
                    foreach (JObject comp in componentDetails)
                    {
                        Supplier_Quote_Component cs = new Supplier_Quote_Component();
                        cs.Component_ID = (int)comp["Component_ID"];
                        cs.Supplier_Quote_ID = key;
                        cs.Quantity_Requested = (int)comp["Quantity"];
                        cs.Price = (decimal)comp["Price"];

                        Component_Supplier comp2 = new Component_Supplier();
                        comp2 = (from d in db.Component_Supplier
                                 where d.Supplier_ID == supplier.Supplier_ID && d.Component_ID == cs.Component_ID
                                 select d).First();
                        comp2.unit_price = cs.Price;

                        db.Supplier_Quote_Component.Add(cs);
                    }

                if (partTypeDetails != null)
                    foreach (JObject part in partTypeDetails)
                    {
                        Supplier_Quote_Detail_Part ps = new Supplier_Quote_Detail_Part();
                        ps.Part_Type_ID = (int)part["Part_Type_ID"];
                        ps.Supplier_Quote_ID = key;
                        ps.Quantity = (int)part["Quantity"];
                        ps.Price = (decimal)part["Price"];

                        Part_Supplier part2 = new Part_Supplier();
                        part2 = (from d in db.Part_Supplier
                                 where d.Supplier_ID == supplier.Supplier_ID && d.Part_Type_ID == ps.Part_Type_ID
                                 select d).First();
                        part2.unit_price = ps.Price;

                        db.Supplier_Quote_Detail_Part.Add(ps);
                    }

                if (RawMaterialDetails != null)
                    foreach (JObject raw in RawMaterialDetails)
                    {
                        Supplier_Quote_Detail_Raw_Material rms = new Supplier_Quote_Detail_Raw_Material();
                        rms.Raw_Material_ID = (int)raw["Raw_Material_ID"];
                        rms.Supplier_Quote_ID = key;
                        rms.Quantity = (int)raw["Quantity"];
                        rms.Price = (decimal)raw["Price"];
                        rms.Dimension = (string)raw["Dimension"];

                        Raw_Material_Supplier raw2 = new Raw_Material_Supplier();
                        raw2 = (from d in db.Raw_Material_Supplier
                                where d.Supplier_ID == supplier.Supplier_ID && d.Raw_Material_ID == rms.Raw_Material_ID
                                select d).First();
                        raw2.unit_price = rms.Price;

                        db.Supplier_Quote_Detail_Raw_Material.Add(rms);
                    }

                db.SaveChanges();

            return "true|Supplier Quote #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierQuoteController POST");
                return "false|An error has occured adding the Supplier Quote to the system.";
            }
        }
    }
}
