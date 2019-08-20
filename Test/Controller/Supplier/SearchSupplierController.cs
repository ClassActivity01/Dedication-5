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
    public class SearchSupplierController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchSupplier
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
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Name == criteria || p.Email == criteria || p.Contact_Number == criteria
                                    || p.Contact_Name == criteria
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
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Name == criteria
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
                    }
                    else
                    if (category == "Email")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Email == criteria
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
                    }
                    else
                    if (category == "CName")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Contact_Name == criteria
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
                    }
                    else
                    if (category == "Contact_Number")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Contact_Number == criteria
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
                    }
                }
                else
                if (method == "Contains")
                {
                    if (category == "All")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Name.Contains(criteria) || p.Email.Contains(criteria) || p.Contact_Number.Contains(criteria)
                                    || p.Contact_Name.Contains(criteria)
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
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Name.Contains(criteria)
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
                    }
                    else
                    if (category == "Email")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Email.Contains(criteria)
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
                    }
                    else
                    if (category == "CName")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Contact_Name.Contains(criteria)
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
                    }
                    else
                    if (category == "Contact_Number")
                    {
                        result = JObject.FromObject(new
                        {
                            suppliers =
                                from p in db.Suppliers
                                orderby p.Name
                                where p.Contact_Number.Contains(criteria)
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
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchSupplierController");
                return "false|An error has occured searching for Suppliers on the system.";
            }
        }
    }
}
