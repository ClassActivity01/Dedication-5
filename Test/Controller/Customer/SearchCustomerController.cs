using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller
{
    public class SearchCustomerController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchClient
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
                            clients =
                                from p in db.Clients
                                orderby p.Name
                                where p.Client_ID == id
                                select new
                                {
                                    Client_ID = p.Client_ID,
                                    Name = p.Name,
                                    Address = p.Address,
                                    City = p.City,
                                    Zip = p.Zip,
                                    Overdue_Payment = p.Overdue_Payment,
                                    Vat_Number = p.Vat_Number,
                                    Account_Name = p.Account_Name,
                                    Contract_Discount_Rate = p.Contract_Discount_Rate,
                                    Client_Status = p.Client_Status,
                                    Province_ID = p.Province_ID,
                                    Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                    contact_details =
                                        from d in db.Client_Contact_Person_Detail
                                        where d.Client_ID == p.Client_ID
                                        orderby d.Name
                                        select new
                                        {
                                            Contact_ID = d.Contact_ID,
                                            Name = d.Name,
                                            Number = d.Number,
                                            Job_Description = d.Job_Description,
                                            Email_Address = d.Email_Address
                                        },

                                    part_discounts =
                                        from pd in db.Client_Discount_Rate
                                        where pd.Client_ID == p.Client_ID
                                        select new
                                        {
                                            Discount_Rate = pd.Discount_Rate,
                                            Part_Type_ID = pd.Part_Type_ID,
                                            Part_Type_Name = pd.Part_Type.Name,
                                            Part_Type_Abbreviation = pd.Part_Type.Abbreviation
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
                                clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Client_ID == id || p.Name == criteria || p.Vat_Number == criteria 
                                        || p.Account_Name == criteria
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Name == criteria || p.Vat_Number == criteria
                                        || p.Account_Name == criteria
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Name == criteria
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Vat")
                    {
                        result = JObject.FromObject(new
                        {
                            clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Vat_Number == criteria
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Account")
                    {
                        result = JObject.FromObject(new
                        {
                            clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Account_Name == criteria
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
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
                                clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Client_ID == id || p.Name.Contains(criteria) || p.Vat_Number.Contains(criteria)
                                        || p.Account_Name.Contains(criteria)
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Name.Contains(criteria) || p.Vat_Number.Contains(criteria)
                                        || p.Account_Name.Contains(criteria)
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Name.Contains(criteria)
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Vat")
                    {
                        result = JObject.FromObject(new
                        {
                            clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Vat_Number.Contains(criteria)
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Account")
                    {
                        result = JObject.FromObject(new
                        {
                            clients =
                                    from p in db.Clients
                                    orderby p.Name
                                    where p.Account_Name.Contains(criteria)
                                    select new
                                    {
                                        Client_ID = p.Client_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Overdue_Payment = p.Overdue_Payment,
                                        Vat_Number = p.Vat_Number,
                                        Account_Name = p.Account_Name,
                                        Contract_Discount_Rate = p.Contract_Discount_Rate,
                                        Client_Status = p.Client_Status,
                                        Province_ID = p.Province_ID,
                                        Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                                        contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            },

                                        part_discounts =
                                            from pd in db.Client_Discount_Rate
                                            where pd.Client_ID == p.Client_ID
                                            select new
                                            {
                                                Discount_Rate = pd.Discount_Rate,
                                                Part_Type_ID = pd.Part_Type_ID,
                                                Part_Type_Name = pd.Part_Type.Name,
                                                Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                            }
                                    }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "SearchCustomerController");
                return "false|An error has occured searching for Suppliers on the system.";
            }
        }
    }
}
