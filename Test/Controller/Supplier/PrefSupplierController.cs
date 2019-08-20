using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Test.Model;

namespace Test.Controller.Supplier
{
    public class PrefSupplierController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/PrefSupplier
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                int r_ID = (int)json["Resource_ID"];
                string inventory_type = (string)json["i_type"];

                if (inventory_type == "Raw Material")
                {
                    JObject result = JObject.FromObject(new
                    {
                        suppliers =
                        from p in db.Suppliers
                        orderby p.Name
                        where p.Raw_Material_Supplier.Any(x => x.Raw_Material_ID == r_ID && x.Is_Prefered == true)
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
                            Foreign_Bank = p.Foreign_Bank
                        }
                    });
                    return "true|" + result.ToString();
                }
                else if (inventory_type == "Part Type")
                {
                    JObject result = JObject.FromObject(new
                    {
                        suppliers =
                        from p in db.Suppliers
                        orderby p.Name
                        where p.Part_Supplier.Any(x => x.Part_Type_ID == r_ID && x.Is_Prefered == true)
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
                            Foreign_Bank = p.Foreign_Bank
                        }
                    });
                    return "true|" + result.ToString();
                }
                else if (inventory_type == "Component")
                {
                    JObject result = JObject.FromObject(new
                    {
                        suppliers =
                        from p in db.Suppliers
                        orderby p.Name
                        where p.Component_Supplier.Any(x => x.Component_ID == r_ID && x.is_preferred == true)
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
                            Foreign_Bank = p.Foreign_Bank
                        }
                    });
                    return "true|" + result.ToString();
                }
                else return "false|Unknown Command";

            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "SupplierController GET ID");
                return "false|Failed to retrieve Supplier.";
            }
        }
    }
}