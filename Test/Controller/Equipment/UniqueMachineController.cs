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
    public class UniqueMachineController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/UniqueMachine
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    unique_machines =
                        from p in db.Unique_Machine
                        orderby p.Unique_Machine_Serial
                        select new
                        {
                            Unique_Machine_ID = p.Unique_Machine_ID,      
                            Unique_Machine_Serial = p.Unique_Machine_Serial,
                            Machine_Status_ID = p.Machine_Status_ID,
                            Machine_ID = p.Machine_ID
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueMachineController GET");
                return "false|Failed to retrieve Unique Machines.";
            }
        }

        // GET: api/UniqueMachine/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    unique_machines =
                        from p in db.Unique_Machine
                        orderby p.Unique_Machine_Serial
                        where p.Unique_Machine_ID == id
                        select new
                        {
                            Unique_Machine_ID = p.Unique_Machine_ID,
                            Unique_Machine_Serial = p.Unique_Machine_Serial,
                            Machine_Status_ID = p.Machine_Status_ID,
                            Machine_ID = p.Machine_ID
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueMachineController GET ID");
                return "false|Failed to retrieve Unique Machines.";
            }
        }

        // POST: api/UniqueMachine
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Unique_Machine mach = new Model.Unique_Machine();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject machineDetails = JObject.Parse(message);

                int key = db.Unique_Machine.Count() == 0 ? 1 : (from t in db.Unique_Machine
                                                                orderby t.Unique_Machine_ID descending
                                                          select t.Unique_Machine_ID).First() + 1;

                mach.Unique_Machine_ID = key;
                mach.Machine_ID = (int)machineDetails["Machine_ID"];
                mach.Unique_Machine_Serial = (string)machineDetails["Unique_Machine_ID"];
                mach.Machine_Status_ID = (int)machineDetails["Machine_Status_ID"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Unique_Machine
                     where t.Unique_Machine_Serial == mach.Unique_Machine_Serial
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Unique Machine serial number entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Unique_Machine.Add(mach);
                db.SaveChanges();

                return "true|Unique Machine " + (string)machineDetails["Unique_Machine_ID"] + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueMachineController POST");
                return "false|An error has occured adding the Unique Machine to the system.";
            } 
        }

        // PUT: api/UniqueMachine/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Unique_Machine mach = new Unique_Machine();

                mach = (from p in db.Unique_Machine
                        where p.Unique_Machine_ID == id
                        select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject machineDetails = JObject.Parse(message);

                mach.Machine_ID = (int)machineDetails["Machine_ID"];
                mach.Unique_Machine_Serial = (string)machineDetails["Unique_Machine_Serial"];
                mach.Machine_Status_ID = (int)machineDetails["Machine_Status_ID"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Unique_Machine
                     where t.Unique_Machine_Serial == mach.Unique_Machine_Serial && t.Unique_Machine_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Unique Machine serial number entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.SaveChanges();
                return "true|Unique Machine successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueMachineController PUT");
                return "false|An error has occured updating the Unique Machine on the system.";
            }
        }

        // DELETE: api/UniqueMachine/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Unique_Machine.SingleOrDefault(x => x.Unique_Machine_ID == id);
                if (itemToRemove != null)
                {
                    db.Unique_Machine.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Unique Machine has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueMachineController DELETE");
                return "false|The Unique Machine is in use and cannot be removed from the system.";
            }
        }
    }
}
