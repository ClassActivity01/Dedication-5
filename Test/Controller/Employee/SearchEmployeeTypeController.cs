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
    public class SearchEmployeeTypeController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchEmployeeType
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
                            employee_types =
                                from p in db.Employee_Type
                                orderby p.Name
                                where p.Name == criteria || p.Description == criteria
                                select new
                                {
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Name = p.Name
                                }
                        });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            employee_types =
                                from p in db.Employee_Type
                                orderby p.Name
                                where p.Name == criteria
                                select new
                                {
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Name = p.Name
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            employee_types =
                                from p in db.Employee_Type
                                orderby p.Name
                                where p.Description == criteria
                                select new
                                {
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Name = p.Name
                                }
                        });
                    }
                }
                else
                if (method == "Contains")
                {
                    if (category == "All")
                    {
                        if(criteria == "")
                        {
                            result = JObject.FromObject(new
                            {
                                employee_types =
                                from p in db.Employee_Type
                                orderby p.Name
                                select new
                                {
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Name = p.Name
                                }
                            });
                        }
                        else
                        {
                            result = JObject.FromObject(new
                            {
                                employee_types =
                                from p in db.Employee_Type
                                orderby p.Name
                                where p.Name.Contains(criteria) || p.Description.Contains(criteria)
                                select new
                                {
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Name = p.Name
                                }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            employee_types =
                                from p in db.Employee_Type
                                orderby p.Name
                                where p.Name.Contains(criteria)
                                select new
                                {
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Name = p.Name
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            employee_types =
                                from p in db.Employee_Type
                                orderby p.Name
                                where p.Description.Contains(criteria)
                                select new
                                {
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Name = p.Name
                                }
                        });
                    }
                }

                return "true|"+result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "SearchEmployeeTypeController");
                return "false|An error has occured searching for Employee categories on the system.";
            }
        }
    }
}
