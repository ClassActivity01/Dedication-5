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
    public class SearchSupplierOrderController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchSupplierOrder
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
                            supplier_orders =
                                from p in db.Supplier_Order
                                where p.Supplier_Order_ID == id
                                orderby p.Date descending
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
                                supplier_orders =
                                from p in db.Supplier_Order
                                where DbFunctions.TruncateTime(p.Date) == DbFunctions.TruncateTime(id)
                                orderby p.Date descending
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
                        }
                        catch
                        {
                            try
                            {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                supplier_orders =
                                from p in db.Supplier_Order
                                where p.Supplier_Order_ID == id
                                orderby p.Date descending
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
                        }
                            catch
                            {
                                result = JObject.FromObject(new
                                {
                                    supplier_orders =
                                    from p in db.Supplier_Order
                                    orderby p.Date descending
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
                            supplier_orders =
                                from p in db.Supplier_Order
                                orderby p.Date descending
                                where DbFunctions.TruncateTime(p.Date) == DbFunctions.TruncateTime(id)
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
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a valid date (YYYY/MM/DD).";
                    }
                }else
                if (category == "Recent")
                {
                    try
                    {
                        DateTime id = DateTime.UtcNow.Date.AddDays(-3);

                        result = JObject.FromObject(new
                        {
                            supplier_orders =
                                from p in db.Supplier_Order
                                orderby p.Date descending
                                where p.Date >= id
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
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a valid date (YYYY/MM/DD).";
                    }
                }else
                if (category == "NotComplete")
                {
                    try
                    {
                        result = JObject.FromObject(new
                        {
                            supplier_orders =
                                from p in db.Supplier_Order
                                where p.Supplier_Order_Status_ID >= 1 && p.Supplier_Order_Status_ID <= 5
                                orderby p.Date descending
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
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a valid date (YYYY/MM/DD).";
                    }
                }

                return "true|" + result.ToString();
               }
               catch(Exception e)
               {
                ExceptionLog.LogException(e, "SearchSupplierOrderController");
                return "false|An error has occured searching for Suppliers on the system.";
               }
        }
    }
}
