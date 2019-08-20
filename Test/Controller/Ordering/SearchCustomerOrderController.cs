using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Ordering
{
    public class SearchCustomerOrderController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchCustomerOrder
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

                if(category == "NotComplete")
                {
                    result = JObject.FromObject(new
                    {
                        client_orders =
                                           from p in db.Client_Order
                                           orderby p.Date descending
                                           where p.Client_Order_Status_ID == 1
                                           select new
                                           {
                                               Client_Order_ID = p.Client_Order_ID,
                                               Date = p.Date,
                                               Reference_ID = p.Reference_ID,
                                               Contact_ID = p.Contact_ID,
                                               Client_ID = p.Client_ID,
                                               Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                               Client_Order_Type_ID = p.Client_Order_Type_ID,
                                               Client_Order_Status_ID = p.Client_Order_Status_ID,
                                               Delivery_Method_ID = p.Delivery_Method_ID,
                                               //Delivery_Method_Name = from dm in db.Delivery_Method where dm.Delivery_Method_ID == p.Delivery_Method_ID select dm.Name,
                                               Job_Card_ID = p.Job_Card_ID,
                                               VAT_Inclu = p.VAT_Inclu,
                                               Comment = p.Comment,
                                               Client_Name = p.Client.Name,
                                               Client_Order_Status_Name = p.Client_Order_Status.Name,
                                               Delivery_Method_Name = p.Delivery_Method.Name,
                                               Order_Type_Name = p.Client_Order_Type.Type,

                                               details =
                                                   from d in db.Client_Order_Detail
                                                   where d.Client_Order_ID == p.Client_Order_ID
                                                   select new
                                                   {
                                                       Quantity = d.Quantity,
                                                       Quantity_Delivered = d.Quantity_Delivered,
                                                       Part_Price = d.Part_Price,
                                                       Client_Discount_Rate = d.Client_Discount_Rate,
                                                       Part_Type_ID = d.Part_Type_ID,
                                                       Part_Type_Name = d.Part_Type.Name,
                                                       Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                   }
                                           }
                    });
                } else
                if (category == "ID")
                {
                    try
                    {
                        int id = Convert.ToInt32(criteria);

                        result = JObject.FromObject(new
                        {
                            client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client_Order_ID == id
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                        });
                    }
                    catch
                    {
                        return "false|The Customer Order Number value entered is not a number.";
                    }
                }
                else
                if (method == "Exact")
                {
                    if (category == "All")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Client_ID == id || p.Client_Order_ID == id || p.Client.Name == criteria
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Name == criteria
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                            });
                        }
                    }
                    else
                    if (category == "CName")
                    {
                        result = JObject.FromObject(new
                        {
                            client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Name == criteria
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                        });
                    }
                    else
                    if (category == "CID")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Client_ID == id
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                            });
                        }
                        catch
                        {
                            return "false|The Customer Number entered is not a number.";
                        }
                    }
                }
                else
                if (method == "Contains")
                {
                    if (category == "All")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Client_ID == id || p.Client_Order_ID == id || p.Client.Name.Contains(criteria)
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Name.Contains(criteria)
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                            });
                        }
                    }
                    else
                    if (category == "CName")
                    {
                        result = JObject.FromObject(new
                        {
                            client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Name.Contains(criteria)
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                        });
                    }
                    else
                    if (category == "CID")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                client_orders =
                                            from p in db.Client_Order
                                            orderby p.Date descending
                                            where p.Client.Client_ID == id
                                            select new
                                            {
                                                Client_Order_ID = p.Client_Order_ID,
                                                Date = p.Date,
                                                Reference_ID = p.Reference_ID,
                                                Contact_ID = p.Contact_ID,
                                                Client_ID = p.Client_ID,
                                                Settlement_Discount_Rate = p.Settlement_Discount_Rate,
                                                Client_Order_Type_ID = p.Client_Order_Type_ID,
                                                Client_Order_Status_ID = p.Client_Order_Status_ID,
                                                Delivery_Method_ID = p.Delivery_Method_ID,
                                                Job_Card_ID = p.Job_Card_ID,
                                                VAT_Inclu = p.VAT_Inclu,
                                                Comment = p.Comment,
                                                Client_Name = p.Client.Name,
                                                Client_Order_Status_Name = p.Client_Order_Status.Name,
                                                Delivery_Method_Name = p.Delivery_Method.Name,
                                                Order_Type_Name = p.Client_Order_Type.Type,

                                                details =
                                                    from d in db.Client_Order_Detail
                                                    where d.Client_Order_ID == p.Client_Order_ID
                                                    select new
                                                    {
                                                        Quantity = d.Quantity,
                                                        Quantity_Delivered = d.Quantity_Delivered,
                                                        Part_Price = d.Part_Price,
                                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                                        Part_Type_ID = d.Part_Type_ID,
                                                        Part_Type_Name = d.Part_Type.Name,
                                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                    }
                                            }
                            });
                        }
                        catch
                        {
                            return "false|The Customer Number entered is not a number.";
                        }
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchCustomerOrderController");
                return "false|An error has occured searching for Customer Orders on the system.";
            }
        }
    }
}
