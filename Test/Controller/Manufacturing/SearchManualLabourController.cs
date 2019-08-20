using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Manufacturing
{
    public class SearchManualLabourController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchManualLabour
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
                            manual_labour_types =
                                from p in db.Manual_Labour_Type
                                where p.Manual_Labour_Type_ID == id
                                select new
                                {
                                    Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Duration = p.Duration,
                                    Sub_Contractor = p.Sub_Contractor
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
                                manual_labour_types =
                                    from p in db.Manual_Labour_Type
                                    where p.Manual_Labour_Type_ID == id || p.Name == criteria || p.Description == criteria
                                    select new
                                    {
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Name = p.Name,
                                        Description = p.Description,
                                        Duration = p.Duration,
                                        Sub_Contractor = p.Sub_Contractor
                                    }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                manual_labour_types =
                                     from p in db.Manual_Labour_Type
                                     where p.Name == criteria || p.Description == criteria
                                     select new
                                     {
                                         Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                         Name = p.Name,
                                         Description = p.Description,
                                         Duration = p.Duration,
                                         Sub_Contractor = p.Sub_Contractor
                                     }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            manual_labour_types =
                                     from p in db.Manual_Labour_Type
                                     where p.Name == criteria
                                     select new
                                     {
                                         Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                         Name = p.Name,
                                         Description = p.Description,
                                         Duration = p.Duration,
                                         Sub_Contractor = p.Sub_Contractor
                                     }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            manual_labour_types =
                                     from p in db.Manual_Labour_Type
                                     where p.Description == criteria
                                     select new
                                     {
                                         Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                         Name = p.Name,
                                         Description = p.Description,
                                         Duration = p.Duration,
                                         Sub_Contractor = p.Sub_Contractor
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
                                manual_labour_types =
                                    from p in db.Manual_Labour_Type
                                    where p.Manual_Labour_Type_ID == id || p.Name.Contains(criteria) || p.Description.Contains(criteria)
                                    select new
                                    {
                                        Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                        Name = p.Name,
                                        Description = p.Description,
                                        Duration = p.Duration,
                                        Sub_Contractor = p.Sub_Contractor
                                    }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                manual_labour_types =
                                     from p in db.Manual_Labour_Type
                                     where p.Name.Contains(criteria) || p.Description.Contains(criteria)
                                     select new
                                     {
                                         Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                         Name = p.Name,
                                         Description = p.Description,
                                         Duration = p.Duration,
                                         Sub_Contractor = p.Sub_Contractor
                                     }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            manual_labour_types =
                                     from p in db.Manual_Labour_Type
                                     where p.Name.Contains(criteria)
                                     select new
                                     {
                                         Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                         Name = p.Name,
                                         Description = p.Description,
                                         Duration = p.Duration,
                                         Sub_Contractor = p.Sub_Contractor
                                     }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            manual_labour_types =
                                     from p in db.Manual_Labour_Type
                                     where p.Description.Contains(criteria)
                                     select new
                                     {
                                         Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                                         Name = p.Name,
                                         Description = p.Description,
                                         Duration = p.Duration,
                                         Sub_Contractor = p.Sub_Contractor
                                     }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchManualLabourController");
                return "false|An error has occured searching for Manual Labour Types on the system.";
            }
        }
    }
}
