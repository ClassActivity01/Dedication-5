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
    public class SearchUniqueMachineController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchUniqueMachine
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
                                unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Manufacturer == criteria || m.Name == criteria
                                    || m.Model == criteria || p.Unique_Machine_Serial == criteria
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                            });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Name == criteria
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                        });
                    }
                    else
                    if (category == "Model")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Model == criteria
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                        });
                    }
                    else
                    if (category == "Manufacturer")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Manufacturer == criteria
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                        });
                    }
                    else
                    if (category == "Serial")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where p.Unique_Machine_Serial == criteria
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
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
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Manufacturer.Contains(criteria) || m.Name.Contains(criteria)
                                    || m.Model.Contains(criteria) || p.Unique_Machine_Serial.Contains(criteria)
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                        });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Name.Contains(criteria)
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                        });
                    }
                    else
                    if (category == "Model")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Model.Contains(criteria)
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                        });
                    }
                    else
                    if (category == "Manufacturer")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_machines =
                                    from p in db.Unique_Machine
                                    join m in db.Machines on p.Machine_ID equals m.Machine_ID
                                    orderby m.Name
                                    where m.Manufacturer.Contains(criteria)
                                    select new
                                    {
                                        Unique_Machine_ID = p.Unique_Machine_ID,
                                        Unique_Machine_Serial = p.Unique_Machine_Serial,
                                        Name = m.Name,
                                        Manufacturer = m.Manufacturer,
                                        Model = m.Model,
                                        Status = p.Machine_Status.Name,
                                        Machine_ID = m.Machine_ID
                                    }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchUniqueMachineController");
                return "false|An error has occured searching for Unique Machines on the system.";
            }
        }
    }
}