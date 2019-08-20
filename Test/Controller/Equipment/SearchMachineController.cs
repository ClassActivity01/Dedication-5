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
    public class SearchMachineController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchMachine
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
                if(category == "ID")
                {
                    try
                    {
                        int id = Convert.ToInt32(criteria);

                        result = JObject.FromObject(new
                        {
                            machines =
                                from p in db.Machines
                                orderby p.Name
                                where p.Name == criteria || p.Model == criteria
                                || p.Manufacturer == criteria || p.Machine_ID == id
                                select new
                                {
                                    Machine_ID = p.Machine_ID,
                                    Name = p.Name,
                                    Manufacturer = p.Manufacturer,
                                    Model = p.Model,
                                    Price_Per_Hour = p.Price_Per_Hour,
                                    Run_Time = p.Run_Time
                                }
                        });
                    }
                    catch
                    {
                        return "false|The value entered is not a number.";
                    }
                }else
                if (method == "Exact")
                {
                    if (category == "All")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Name == criteria || p.Model == criteria
                                    || p.Manufacturer == criteria || p.Machine_ID == id
                                    select new
                                        {
                                            Machine_ID = p.Machine_ID,
                                            Name = p.Name,
                                            Manufacturer = p.Manufacturer,
                                            Model = p.Model,
                                            Price_Per_Hour = p.Price_Per_Hour,
                                            Run_Time = p.Run_Time
                                        }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Name == criteria || p.Model == criteria
                                    || p.Manufacturer == criteria
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Name == criteria
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                        });
                    }
                    else
                    if (category == "Model")
                    {
                        result = JObject.FromObject(new
                        {
                            machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Model == criteria
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                        });
                    }
                    else
                    if (category == "Manufacturer")
                    {
                        result = JObject.FromObject(new
                        {
                            machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Manufacturer == criteria
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
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
                                machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Name.Contains(criteria) || p.Model.Contains(criteria)
                                    || p.Manufacturer.Contains(criteria) || p.Machine_ID == id
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Name.Contains(criteria) || p.Model.Contains(criteria)
                                    || p.Manufacturer.Contains(criteria)
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Name.Contains(criteria)
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                        });
                    }
                    else
                    if (category == "Model")
                    {
                        result = JObject.FromObject(new
                        {
                            machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Model.Contains(criteria)
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                        });
                    }
                    else
                    if (category == "Manufacturer")
                    {
                        result = JObject.FromObject(new
                        {
                            machines =
                                    from p in db.Machines
                                    orderby p.Name
                                    where p.Manufacturer.Contains(criteria)
                                    select new
                                    {
                                        Machine_ID = p.Machine_ID,
                                        Name = p.Name,
                                        Manufacturer = p.Manufacturer,
                                        Model = p.Model,
                                        Price_Per_Hour = p.Price_Per_Hour,
                                        Run_Time = p.Run_Time
                                    }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchMachineController");
                return "false|An error has occured searching for Machines on the system.";
            }
        }
    }
}
