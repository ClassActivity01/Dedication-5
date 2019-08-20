using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Supplier
{
    public class SupplierController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/Supplier
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    suppliers =
                        from p in db.Suppliers
                        orderby p.Name
                        select new
                        {
                            Supplier_ID = p.Supplier_ID,
                            Name = p.Name,
                            Address = p.Address,
                            City = p.City,
                            Zip = p.Zip,
                            Bank_Account_Number = p.Bank_Account_Number,
                            Bank_Branch = p.Bank_Branch,
                            Bank_Name = p.Bank_Name,
                            Email = p.Email,
                            Contact_Number = p.Contact_Number,
                            Status = p.Status,
                            Province_ID = p.Province_ID,
                            Bank_Reference = p.Bank_Reference,
                            Contact_Name = p.Contact_Name,
                            Foreign_Bank = p.Foreign_Bank,

                            rms =
                                        from d in db.Raw_Material_Supplier
                                        where d.Supplier_ID == p.Supplier_ID
                                        select new
                                        {
                                            Raw_Material_ID = d.Raw_Material_ID,
                                            Raw_Material_Name = d.Raw_Material.Name,
                                            Is_Prefered = d.Is_Prefered,
                                            unit_price = d.unit_price
                                        },

                            cs =
                                        from d in db.Component_Supplier
                                        where d.Supplier_ID == p.Supplier_ID
                                        select new
                                        {
                                            Component_ID = d.Component_ID,
                                            Component_Name = d.Component.Name,
                                            is_preferred = d.is_preferred,
                                            unit_price = d.unit_price
                                        },

                            ps =
                                        from d in db.Part_Supplier
                                        where d.Supplier_ID == p.Supplier_ID
                                        select new
                                        {
                                            Part_Type_Name = d.Part_Type.Name,
                                            Part_Type_ID = d.Part_Type_ID,
                                            Is_Prefered = d.Is_Prefered,
                                            unit_price = d.unit_price
                                        }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierController GET");
                return "false|Failed to retrieve Suppliers.";
            }
        }

        // GET: api/Supplier/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    suppliers =
                        from p in db.Suppliers
                        orderby p.Name
                        where p.Supplier_ID == id
                        select new
                        {
                            Supplier_ID = p.Supplier_ID,
                            Name = p.Name,
                            Address = p.Address,
                            City = p.City,
                            Zip = p.Zip,
                            Bank_Account_Number = p.Bank_Account_Number,
                            Bank_Branch = p.Bank_Branch,
                            Bank_Name = p.Bank_Name,
                            Email = p.Email,
                            Contact_Number = p.Contact_Number,
                            Status = p.Status,
                            Province_ID = p.Province_ID,
                            Bank_Reference = p.Bank_Reference,
                            Contact_Name = p.Contact_Name,
                            Foreign_Bank = p.Foreign_Bank,

                            rms =
                                        from d in db.Raw_Material_Supplier
                                        where d.Supplier_ID == p.Supplier_ID
                                        select new
                                        {
                                            Raw_Material_ID = d.Raw_Material_ID,
                                            Raw_Material_Name = d.Raw_Material.Name,
                                            Is_Prefered = d.Is_Prefered,
                                            unit_price = d.unit_price
                                        },

                            cs =
                                        from d in db.Component_Supplier
                                        where d.Supplier_ID == p.Supplier_ID
                                        select new
                                        {
                                            Component_ID = d.Component_ID,
                                            Component_Name = d.Component.Name,
                                            is_preferred = d.is_preferred,
                                            unit_price = d.unit_price
                                        },

                            ps =
                                        from d in db.Part_Supplier
                                        where d.Supplier_ID == p.Supplier_ID
                                        select new
                                        {
                                            Part_Type_Name = d.Part_Type.Name,
                                            Part_Type_ID = d.Part_Type_ID,
                                            Is_Prefered = d.Is_Prefered,
                                            unit_price = d.unit_price
                                        }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierController GET ID");
                return "false|Failed to retrieve Supplier.";
            }
        }

        // POST: api/Supplier
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Supplier supplier = new Model.Supplier();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject supplierDetails = (JObject)json["supplier"];
                JArray componentDetails = (JArray)json["components"];
                JArray partTypeDetails = (JArray)json["parts"];
                JArray RawMaterialDetails = (JArray)json["raw"];
            
                int key = db.Suppliers.Count() == 0 ? 1 : (from t in db.Suppliers
                                                            orderby t.Supplier_ID descending
                                                            select t.Supplier_ID).First() + 1;

                supplier.Supplier_ID = key;
                supplier.Name = (string)supplierDetails["Name"];
                supplier.Address = (string)supplierDetails["Address"];
                supplier.City = (string)supplierDetails["City"];
                supplier.Zip = (string)supplierDetails["Zip"];
                supplier.Bank_Account_Number = (string)supplierDetails["Bank_Account_Number"];
                supplier.Bank_Branch = (string)supplierDetails["Bank_Branch"];
                supplier.Bank_Name = (string)supplierDetails["Bank_Name"];
                supplier.Email = (string)supplierDetails["Email"];
                supplier.Contact_Number = (string)supplierDetails["Contact_Number"];
                supplier.Status = Convert.ToBoolean(Convert.ToInt32(supplierDetails["Status"]));
                supplier.Province_ID = (int)supplierDetails["Province_ID"];
                supplier.Bank_Reference = (string)supplierDetails["Bank_Reference"];
                supplier.Contact_Name = (string)supplierDetails["Contact_Name"];
                supplier.Foreign_Bank = Convert.ToBoolean(supplierDetails["Foreign_Bank"]);

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Suppliers
                     where t.Name == supplier.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Supplier Name entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where t.Email == supplier.Email
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Contact Email entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where t.Contact_Number == supplier.Contact_Number
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Contact Number entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where t.Address == supplier.Address && t.City == supplier.City && t.Zip == supplier.Zip
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Supplier Address entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where t.Bank_Account_Number == supplier.Bank_Account_Number && t.Bank_Branch == supplier.Bank_Branch
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Supplier Banking details entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Suppliers.Add(supplier);

                if(componentDetails != null)
                foreach (JObject comp in componentDetails)
                {
                    Component_Supplier cs = new Component_Supplier();
                    cs.Component_ID = (int)comp["Component_ID"];
                    cs.Supplier_ID = key;
                    cs.is_preferred = Convert.ToBoolean(Convert.ToInt32(comp["Is_Prefered"]));
                    cs.unit_price = (decimal)comp["unit_price"];

                    db.Component_Supplier.Add(cs);
                }

                if (partTypeDetails != null)
                foreach (JObject part in partTypeDetails)
                {
                    Part_Supplier ps = new Part_Supplier();
                    ps.Part_Type_ID = (int)part["Part_Type_ID"];
                    ps.Supplier_ID = key;
                    ps.Is_Prefered = Convert.ToBoolean(Convert.ToInt32(part["Is_Prefered"]));
                    ps.unit_price = (decimal)part["unit_price"];

                    db.Part_Supplier.Add(ps);
                }

                if (RawMaterialDetails != null)
                foreach (JObject raw in RawMaterialDetails)
                {
                    Raw_Material_Supplier rms = new Raw_Material_Supplier();
                    rms.Raw_Material_ID = (int)raw["Raw_Material_ID"];
                    rms.Supplier_ID = key;
                    rms.Is_Prefered = Convert.ToBoolean(Convert.ToInt32(raw["Is_Prefered"]));
                    rms.unit_price = (decimal)raw["unit_price"];

                    db.Raw_Material_Supplier.Add(rms);
                }

                db.SaveChanges();
            
                return "true|Supplier #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierController POST");
                return "false|An error has occured adding the Supplier to the system.";
            }
        }

        // PUT: api/Supplier/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Model.Supplier supplier = new Model.Supplier();
                supplier = (from p in db.Suppliers
                          where p.Supplier_ID == id
                          select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject supplierDetails = (JObject)json["supplier"];
                JArray componentDetails = (JArray)json["components"];
                JArray partTypeDetails = (JArray)json["parts"];
                JArray RawMaterialDetails = (JArray)json["raw"];

                supplier.Name = (string)supplierDetails["Name"];
                supplier.Address = (string)supplierDetails["Address"];
                supplier.City = (string)supplierDetails["City"];
                supplier.Zip = (string)supplierDetails["Zip"];
                supplier.Bank_Account_Number = (string)supplierDetails["Bank_Account_Number"];
                supplier.Bank_Branch = (string)supplierDetails["Bank_Branch"];
                supplier.Bank_Name = (string)supplierDetails["Bank_Name"];
                supplier.Email = (string)supplierDetails["Email"];
                supplier.Contact_Number = (string)supplierDetails["Contact_Number"];
                supplier.Status = Convert.ToBoolean(supplierDetails["Status"]);
                supplier.Province_ID = (int)supplierDetails["Province_ID"];
                supplier.Bank_Reference = (string)supplierDetails["Bank_Reference"];
                supplier.Contact_Name = (string)supplierDetails["Contact_Name"];
                supplier.Foreign_Bank = Convert.ToBoolean(supplierDetails["Foreign_Bank"]);

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Suppliers
                     where t.Name == supplier.Name && t.Supplier_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Supplier name entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where t.Contact_Name == supplier.Contact_Name && t.Supplier_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Contact Name entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where t.Email == supplier.Email && t.Supplier_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Contact Email entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where t.Contact_Number == supplier.Contact_Number && t.Supplier_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Contact Number entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where (t.Address == supplier.Address && t.City == supplier.City && t.Zip == supplier.Zip) && t.Supplier_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Supplier Address entered already exists on the system. ";
                }

                if ((from t in db.Suppliers
                     where (t.Bank_Account_Number == supplier.Bank_Account_Number && t.Bank_Branch == supplier.Bank_Branch) && t.Supplier_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Supplier Banking details entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Component_Supplier.RemoveRange(db.Component_Supplier.Where(x => x.Supplier_ID == id));

                if (componentDetails != null)
                    foreach (JObject comp in componentDetails)
                    {
                        Component_Supplier cs = new Component_Supplier();
                        cs.Component_ID = (int)comp["Component_ID"];
                        cs.Supplier_ID = id;
                        cs.is_preferred = Convert.ToBoolean(Convert.ToInt32(comp["Is_Prefered"]));
                        cs.unit_price = (decimal)comp["unit_price"];

                        db.Component_Supplier.Add(cs);
                    }

                db.Part_Supplier.RemoveRange(db.Part_Supplier.Where(x => x.Supplier_ID == id));

                if (partTypeDetails != null)
                    foreach (JObject part in partTypeDetails)
                    {
                        Part_Supplier ps = new Part_Supplier();
                        ps.Part_Type_ID = (int)part["Part_Type_ID"];
                        ps.Supplier_ID = id;
                        ps.Is_Prefered = Convert.ToBoolean(Convert.ToInt32(part["Is_Prefered"]));
                        ps.unit_price = (decimal)part["unit_price"];

                        db.Part_Supplier.Add(ps);
                    }

                db.Raw_Material_Supplier.RemoveRange(db.Raw_Material_Supplier.Where(x => x.Supplier_ID == id));

                if (RawMaterialDetails != null)
                    foreach (JObject raw in RawMaterialDetails)
                    {
                        Raw_Material_Supplier rms = new Raw_Material_Supplier();
                        rms.Raw_Material_ID = (int)raw["Raw_Material_ID"];
                        rms.Supplier_ID = id;
                        rms.Is_Prefered = Convert.ToBoolean(Convert.ToInt32(raw["Is_Prefered"]));
                        rms.unit_price = (decimal)raw["unit_price"];

                        db.Raw_Material_Supplier.Add(rms);
                    }

                db.SaveChanges();
                return "true|Supplier successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierController PUT");
                return "false|An error has occured updating the Suplier on the system.";
            }
        }

        // DELETE: api/Supplier/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Suppliers.SingleOrDefault(x => x.Supplier_ID == id);
                if (itemToRemove != null)
                {
                    db.Suppliers.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Supplier has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierController DELETE");
                return "false|The Supplier is in use and cannot be removed from the system.";
            }
        }
    }
}
