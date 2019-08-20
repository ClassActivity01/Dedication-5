using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Supplier
{
    public class SearchSupplierQuoteController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchSupplierQuote
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

                if (category == "ID")
                {
                    try
                    {
                        int id = Convert.ToInt32(criteria);

                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a number.";
                    }
                }
                else
                if (category == "All")
                {
                    try
                    {
                        DateTime id = Convert.ToDateTime(criteria);

                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where DbFunctions.TruncateTime(p.Supplier_Quote_Date) == DbFunctions.TruncateTime(id)
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                    catch
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                supplier_quotes =
                                   from p in db.Supplier_Quote
                                   where p.Supplier_Quote_Serial.Contains(criteria)
                                   orderby p.Supplier_Quote_Date
                                   select new
                                   {
                                       Supplier_Quote_ID = p.Supplier_Quote_ID,
                                       Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                       Supplier_Quote_Date = p.Supplier_Quote_Date,
                                       Supplier_ID = p.Supplier_ID,
                                       Supplier_Name = p.Supplier.Name,

                                       rms =
                                                   from d in db.Supplier_Quote_Detail_Raw_Material
                                                   where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                   select new
                                                   {
                                                       Raw_Material_ID = d.Raw_Material_ID,
                                                       Raw_Material_Name = d.Raw_Material.Name,
                                                       Quantity = d.Quantity,
                                                       Price = d.Price
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
                        }
                    }
                }
                else
                if (category == "Date")
                {
                    try
                    {
                        DateTime id = Convert.ToDateTime(criteria);

                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where DbFunctions.TruncateTime(p.Supplier_Quote_Date) == DbFunctions.TruncateTime(id)
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a valid date (YYYY/MM/DD).";
                    }
                }else
                if(method == "Exact")
                {
                    if(category == "Serial")
                    {
                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_Serial == criteria
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                }else
                if(method == "Contains")
                {
                    if (category == "Serial")
                    {
                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_Serial.Contains(criteria)
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchSupplierQuoteController POST");
                return "false|An error has occured searching for Supplier Quotes on the system.";
            }
        }

        // PUT: api/SearchSupplierQuote/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                string method = (string)json["method"]; //Exact, Contains, Similar
                string criteria = (string)json["criteria"]; //Typed in search value
                string category = (string)json["category"]; //Name, Description, Access Level
                JObject result = null;

                if (category == "ID")
                {
                    try
                    {
                        int id2 = Convert.ToInt32(criteria);

                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_ID == id2 && p.Supplier_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a number.";
                    }
                }
                else
                if (category == "All")
                {
                    try
                    {
                        DateTime id2 = Convert.ToDateTime(criteria);

                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where DbFunctions.TruncateTime(p.Supplier_Quote_Date) == DbFunctions.TruncateTime(id2) && p.Supplier_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                    catch
                    {
                        try
                        {
                            int id2 = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_ID == id2 && p.Supplier_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                supplier_quotes =
                                   from p in db.Supplier_Quote
                                   where p.Supplier_Quote_Serial.Contains(criteria) && p.Supplier_ID == id
                                   orderby p.Supplier_Quote_Date
                                   select new
                                   {
                                       Supplier_Quote_ID = p.Supplier_Quote_ID,
                                       Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                       Supplier_Quote_Date = p.Supplier_Quote_Date,
                                       Supplier_ID = p.Supplier_ID,
                                       Supplier_Name = p.Supplier.Name,

                                       rms =
                                                   from d in db.Supplier_Quote_Detail_Raw_Material
                                                   where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                   select new
                                                   {
                                                       Raw_Material_ID = d.Raw_Material_ID,
                                                       Raw_Material_Name = d.Raw_Material.Name,
                                                       Quantity = d.Quantity,
                                                       Price = d.Price
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
                        }
                    }
                }
                else
                if (category == "Date")
                {
                    try
                    {
                        DateTime id2 = Convert.ToDateTime(criteria);

                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where DbFunctions.TruncateTime(p.Supplier_Quote_Date) == DbFunctions.TruncateTime(id2) && p.Supplier_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a valid date (YYYY/MM/DD).";
                    }
                }
                else
                if (method == "Exact")
                {
                    if (category == "Serial")
                    {
                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_Serial == criteria && p.Supplier_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                }
                else
                if (method == "Contains")
                {
                    if (category == "Serial")
                    {
                        result = JObject.FromObject(new
                        {
                            supplier_quotes =
                                from p in db.Supplier_Quote
                                where p.Supplier_Quote_Serial.Contains(criteria) && p.Supplier_ID == id
                                orderby p.Supplier_Quote_Date
                                select new
                                {
                                    Supplier_Quote_ID = p.Supplier_Quote_ID,
                                    Supplier_Quote_Serial = p.Supplier_Quote_Serial,
                                    Supplier_Quote_Date = p.Supplier_Quote_Date,
                                    Supplier_ID = p.Supplier_ID,
                                    Supplier_Name = p.Supplier.Name,

                                    rms =
                                                from d in db.Supplier_Quote_Detail_Raw_Material
                                                where d.Supplier_Quote_ID == p.Supplier_Quote_ID
                                                select new
                                                {
                                                    Raw_Material_ID = d.Raw_Material_ID,
                                                    Raw_Material_Name = d.Raw_Material.Name,
                                                    Quantity = d.Quantity,
                                                    Price = d.Price
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
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchSupplierQuoteController PUT");
                return "false|An error has occured searching for Supplier Quotes on the system.";
            }
        }
    }
}