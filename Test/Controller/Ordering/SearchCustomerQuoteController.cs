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
    public class SearchCustomerQuoteController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchCustomerQuote
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
                            client_quotes =
                            from p in db.Client_Quote
                            orderby p.Date descending
                            where p.Client_Quote_ID == id
                            select new
                            {
                                Client_Quote_ID = p.Client_Quote_ID,
                                Date = p.Date,
                                Client_ID = p.Client_ID,
                                Contact_ID = p.Contact_ID,
                                Client_Name = p.Client.Name,

                                details =
                                    from d in db.Client_Quote_Detail
                                    where d.Client_Quote_ID == p.Client_Quote_ID
                                    select new
                                    {
                                        Quantity = d.Quantity,
                                        Part_Price = d.Part_Price,
                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                        Settlement_Discount_Rate = d.Client_Discount_Rate,
                                        Part_Type_ID = d.Part_Type_ID,
                                        Part_Type_Name = d.Part_Type.Name,
                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
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
                if (method == "Exact")
                {
                    if (category == "All")
                    {
                            try
                            {
                                int id = Convert.ToInt32(criteria);

                                result = JObject.FromObject(new
                                {
                                    client_quotes =
                                        from p in db.Client_Quote
                                        orderby p.Date descending
                                        where p.Client_Quote_ID == id
                                        select new
                                        {
                                            Client_Quote_ID = p.Client_Quote_ID,
                                            Date = p.Date,
                                            Client_ID = p.Client_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Quote_Detail
                                                where d.Client_Quote_ID == p.Client_Quote_ID
                                                select new
                                                {
                                                    Quantity = d.Quantity,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                                    client_quotes =
                                        from p in db.Client_Quote
                                        orderby p.Date descending
                                        where p.Client.Name == criteria
                                        select new
                                        {
                                            Client_Quote_ID = p.Client_Quote_ID,
                                            Date = p.Date,
                                            Client_ID = p.Client_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Quote_Detail
                                                where d.Client_Quote_ID == p.Client_Quote_ID
                                                select new
                                                {
                                                    Quantity = d.Quantity,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                            client_quotes =
                                        from p in db.Client_Quote
                                        orderby p.Date descending
                                        where p.Client.Name == criteria
                                        select new
                                        {
                                            Client_Quote_ID = p.Client_Quote_ID,
                                            Date = p.Date,
                                            Client_ID = p.Client_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Quote_Detail
                                                where d.Client_Quote_ID == p.Client_Quote_ID
                                                select new
                                                {
                                                    Quantity = d.Quantity,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
                                                    Part_Type_ID = d.Part_Type_ID,
                                                    Part_Type_Name = d.Part_Type.Name,
                                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation
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
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                client_quotes =
                                    from p in db.Client_Quote
                                    orderby p.Date descending
                                    where p.Client_Quote_ID == id
                                    select new
                                    {
                                        Client_Quote_ID = p.Client_Quote_ID,
                                        Date = p.Date,
                                        Client_ID = p.Client_ID,
                                        Contact_ID = p.Contact_ID,
                                        Client_Name = p.Client.Name,

                                        details =
                                            from d in db.Client_Quote_Detail
                                            where d.Client_Quote_ID == p.Client_Quote_ID
                                            select new
                                            {
                                                Quantity = d.Quantity,
                                                Part_Price = d.Part_Price,
                                                Client_Discount_Rate = d.Client_Discount_Rate,
                                                Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                                client_quotes =
                                    from p in db.Client_Quote
                                    orderby p.Date descending
                                    where p.Client.Name.Contains(criteria)
                                    select new
                                    {
                                        Client_Quote_ID = p.Client_Quote_ID,
                                        Date = p.Date,
                                        Client_ID = p.Client_ID,
                                        Contact_ID = p.Contact_ID,
                                        Client_Name = p.Client.Name,

                                        details =
                                            from d in db.Client_Quote_Detail
                                            where d.Client_Quote_ID == p.Client_Quote_ID
                                            select new
                                            {
                                                Quantity = d.Quantity,
                                                Part_Price = d.Part_Price,
                                                Client_Discount_Rate = d.Client_Discount_Rate,
                                                Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                            client_quotes =
                                        from p in db.Client_Quote
                                        orderby p.Date descending
                                        where p.Client.Name.Contains(criteria)
                                        select new
                                        {
                                            Client_Quote_ID = p.Client_Quote_ID,
                                            Date = p.Date,
                                            Client_ID = p.Client_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Quote_Detail
                                                where d.Client_Quote_ID == p.Client_Quote_ID
                                                select new
                                                {
                                                    Quantity = d.Quantity,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
                                                    Part_Type_ID = d.Part_Type_ID,
                                                    Part_Type_Name = d.Part_Type.Name,
                                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                }
                                        }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchCustomerQuoteController POST");
                return "false|An error has occured searching for Customer Quotes on the system.";
            }
        }

        // POST: api/SearchCustomerQuote
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
                            client_quotes =
                            from p in db.Client_Quote
                            orderby p.Date descending
                            where p.Client_Quote_ID == id2 && p.Client_ID == id
                            select new
                            {
                                Client_Quote_ID = p.Client_Quote_ID,
                                Date = p.Date,
                                Client_ID = p.Client_ID,
                                Contact_ID = p.Contact_ID,
                                Client_Name = p.Client.Name,

                                details =
                                    from d in db.Client_Quote_Detail
                                    where d.Client_Quote_ID == p.Client_Quote_ID
                                    select new
                                    {
                                        Quantity = d.Quantity,
                                        Part_Price = d.Part_Price,
                                        Client_Discount_Rate = d.Client_Discount_Rate,
                                        Settlement_Discount_Rate = d.Client_Discount_Rate,
                                        Part_Type_ID = d.Part_Type_ID,
                                        Part_Type_Name = d.Part_Type.Name,
                                        Part_Type_Abbreviation = d.Part_Type.Abbreviation
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
                if (method == "Exact")
                {
                    if (category == "All")
                    {
                        try
                        {
                            int id2 = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                client_quotes =
                                    from p in db.Client_Quote
                                    orderby p.Date descending
                                    where p.Client_Quote_ID == id2 && p.Client_ID == id
                                    select new
                                    {
                                        Client_Quote_ID = p.Client_Quote_ID,
                                        Date = p.Date,
                                        Client_ID = p.Client_ID,
                                        Contact_ID = p.Contact_ID,
                                        Client_Name = p.Client.Name,

                                        details =
                                            from d in db.Client_Quote_Detail
                                            where d.Client_Quote_ID == p.Client_Quote_ID
                                            select new
                                            {
                                                Quantity = d.Quantity,
                                                Part_Price = d.Part_Price,
                                                Client_Discount_Rate = d.Client_Discount_Rate,
                                                Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                                client_quotes =
                                    from p in db.Client_Quote
                                    orderby p.Date descending
                                    where p.Client.Name == criteria && p.Client_ID == id
                                    select new
                                    {
                                        Client_Quote_ID = p.Client_Quote_ID,
                                        Date = p.Date,
                                        Client_ID = p.Client_ID,
                                        Contact_ID = p.Contact_ID,
                                        Client_Name = p.Client.Name,

                                        details =
                                            from d in db.Client_Quote_Detail
                                            where d.Client_Quote_ID == p.Client_Quote_ID
                                            select new
                                            {
                                                Quantity = d.Quantity,
                                                Part_Price = d.Part_Price,
                                                Client_Discount_Rate = d.Client_Discount_Rate,
                                                Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                            client_quotes =
                                        from p in db.Client_Quote
                                        orderby p.Date descending
                                        where p.Client.Name == criteria && p.Client_ID == id
                                        select new
                                        {
                                            Client_Quote_ID = p.Client_Quote_ID,
                                            Date = p.Date,
                                            Client_ID = p.Client_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Quote_Detail
                                                where d.Client_Quote_ID == p.Client_Quote_ID
                                                select new
                                                {
                                                    Quantity = d.Quantity,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
                                                    Part_Type_ID = d.Part_Type_ID,
                                                    Part_Type_Name = d.Part_Type.Name,
                                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation
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
                        try
                        {
                            int id2 = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                client_quotes =
                                    from p in db.Client_Quote
                                    orderby p.Date descending
                                    where p.Client_Quote_ID == id2 && p.Client_ID == id
                                    select new
                                    {
                                        Client_Quote_ID = p.Client_Quote_ID,
                                        Date = p.Date,
                                        Client_ID = p.Client_ID,
                                        Contact_ID = p.Contact_ID,
                                        Client_Name = p.Client.Name,

                                        details =
                                            from d in db.Client_Quote_Detail
                                            where d.Client_Quote_ID == p.Client_Quote_ID
                                            select new
                                            {
                                                Quantity = d.Quantity,
                                                Part_Price = d.Part_Price,
                                                Client_Discount_Rate = d.Client_Discount_Rate,
                                                Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                                client_quotes =
                                    from p in db.Client_Quote
                                    orderby p.Date descending
                                    where p.Client.Name.Contains(criteria) && p.Client_ID == id
                                    select new
                                    {
                                        Client_Quote_ID = p.Client_Quote_ID,
                                        Date = p.Date,
                                        Client_ID = p.Client_ID,
                                        Contact_ID = p.Contact_ID,
                                        Client_Name = p.Client.Name,

                                        details =
                                            from d in db.Client_Quote_Detail
                                            where d.Client_Quote_ID == p.Client_Quote_ID
                                            select new
                                            {
                                                Quantity = d.Quantity,
                                                Part_Price = d.Part_Price,
                                                Client_Discount_Rate = d.Client_Discount_Rate,
                                                Settlement_Discount_Rate = d.Client_Discount_Rate,
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
                            client_quotes =
                                        from p in db.Client_Quote
                                        orderby p.Date descending
                                        where p.Client.Name.Contains(criteria) && p.Client_ID == id
                                        select new
                                        {
                                            Client_Quote_ID = p.Client_Quote_ID,
                                            Date = p.Date,
                                            Client_ID = p.Client_ID,
                                            Contact_ID = p.Contact_ID,
                                            Client_Name = p.Client.Name,

                                            details =
                                                from d in db.Client_Quote_Detail
                                                where d.Client_Quote_ID == p.Client_Quote_ID
                                                select new
                                                {
                                                    Quantity = d.Quantity,
                                                    Part_Price = d.Part_Price,
                                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
                                                    Part_Type_ID = d.Part_Type_ID,
                                                    Part_Type_Name = d.Part_Type.Name,
                                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                                }
                                        }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchCustomerQuoteController PUT");
                return "false|An error has occured searching for Customer Quotes on the system.";
            }
        }
    }
}
