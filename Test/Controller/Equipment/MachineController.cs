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
    public class MachineController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/Machine
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    machines =
                        from p in db.Machines
                        orderby p.Name
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
                return "true|"+result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "MachineController GET");
                return "false|Failed to retrieve Machines.";
            }
        }

        // GET: api/Machine/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    machines =
                        from p in db.Machines
                        orderby p.Name
                        where p.Machine_ID == id
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
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "MachineController GET ID");
                return "false|Failed to retrieve Machine.";
            }
        }

        // POST: api/Machine
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Machine mach = new Model.Machine();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject machineDetails = JObject.Parse(message);

                int key = db.Machines.Count() == 0 ? 1 : (from t in db.Machines
                                                          orderby t.Machine_ID descending
                                                                select t.Machine_ID).First() + 1;

                mach.Machine_ID = key;
                mach.Name = (string)machineDetails["Name"];
                mach.Manufacturer = (string)machineDetails["Manufacturer"];
                mach.Model = (string)machineDetails["Model"];
                mach.Price_Per_Hour = (decimal)machineDetails["Price_Per_Hour"];
                mach.Run_Time = (int)machineDetails["Run_Time"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Machines
                     where t.Manufacturer == mach.Manufacturer && t.Model == mach.Model
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Machine manufacturer and model entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Machines.Add(mach);
                db.SaveChanges();

                return "true|Machine  #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "MachineController POST");
                return "false|An error has occured adding the Machine to the system.";
            }
        }

        // PUT: api/Machine/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Machine mach = new Machine();

                mach = (from p in db.Machines
                        where p.Machine_ID == id
                        select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject machineDetails = JObject.Parse(message);

                mach.Name = (string)machineDetails["Name"];
                mach.Manufacturer = (string)machineDetails["Manufacturer"];
                mach.Model = (string)machineDetails["Model"];
                mach.Price_Per_Hour = (decimal)machineDetails["Price_Per_Hour"];
                mach.Run_Time = (int)machineDetails["Run_Time"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Machines
                     where (t.Manufacturer == mach.Manufacturer && t.Model == mach.Model) && t.Machine_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Machine manufacturer and model entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.SaveChanges();
                return "true|Machine successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "MachineController PUT");
                return "false|An error has occured updating the Machine on the system.";
            }
        }

        // DELETE: api/Machine/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Machines.SingleOrDefault(x => x.Machine_ID == id);
                if (itemToRemove != null)
                {
                    db.Machines.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Machine has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "MachineController DELETE");
                return "false|The Machine is in use and cannot be removed from the system.";
            }
        }
    }
}
