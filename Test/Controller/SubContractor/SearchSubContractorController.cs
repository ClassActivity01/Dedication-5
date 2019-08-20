using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.SubContractor
{
    public class SearchSubContractorController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchSubContractor
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
                                sub_contractors =
                                    from p in db.Sub_Contractor join d in db.Sub_Contractor_Contact_Detail 
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where p.Name == criteria || p.Address == criteria || d.Name == criteria 
                                        || d.Number == criteria || d.Email == criteria
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,              
                                                Name = e.Name,   
                                                Email = e.Email
                                            }
                                    }
                            });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where p.Name == criteria
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Address")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where p.Address == criteria
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "ContactName")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where d.Name == criteria
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Number")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where d.Number == criteria
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Email")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where d.Email == criteria
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
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
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where p.Name.Contains(criteria) || p.Address.Contains(criteria) || d.Name.Contains(criteria)
                                        || d.Number.Contains(criteria) || d.Email.Contains(criteria)
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where p.Name.Contains(criteria)
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Address")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where p.Address.Contains(criteria)
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "ContactName")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where d.Name.Contains(criteria)
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Number")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where d.Number.Contains(criteria)
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                    else
                    if (category == "Email")
                    {
                        result = JObject.FromObject(new
                        {
                            sub_contractors =
                                    from p in db.Sub_Contractor
                                    join d in db.Sub_Contractor_Contact_Detail
                                        on p.Sub_Contractor_ID equals d.Sub_Contractor_ID
                                    orderby p.Name
                                    where d.Email.Contains(criteria)
                                    select new
                                    {
                                        Sub_Contractor_ID = p.Sub_Contractor_ID,
                                        Name = p.Name,
                                        Address = p.Address,
                                        City = p.City,
                                        Zip = p.Zip,
                                        Status = p.Status,
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Province_ID = p.Province_ID,
                                        Manual_Labour_Name = p.Manual_Labour_Type.Name,

                                        contact_details =
                                            from e in db.Sub_Contractor_Contact_Detail
                                            orderby e.Name
                                            where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                            select new
                                            {
                                                Number = e.Number,
                                                Name = e.Name,
                                                Email = e.Email
                                            }
                                    }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchSubContractorController");
                return "false|An error has occured searching for Sub-Contractors on the system.";
            }
        }
    }
}
