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
    public class UniqueMachineStatusesController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/UniqueMachineStatusses
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    unique_machine_statuses =
                        from p in db.Machines join b in db.Unique_Machine on p.Machine_ID equals b.Machine_ID
                        orderby p.Name
                        select new
                        {
                            Unique_Machine_ID = b.Unique_Machine_ID,
                            Unique_Machine_Serial = b.Unique_Machine_Serial,
                            Machine_Status_ID = b.Machine_Status_ID,
                            Manufacturer = p.Manufacturer,
                            Model = p.Model,
                            Name = p.Name
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UniqueMachineStatusController GET");
                return "false|Failed to retrieve Unique Machines Statuses.";
            }
        }

        // POST: api/UniqueMachineStatusses
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Unique_Machine mach = new Model.Unique_Machine();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JArray machineDetails = JArray.Parse(message);

                foreach(JObject mac in machineDetails)
                {
                    int um_ID = (int)mac["Unique_Machine_ID"];
                    mach = (from p in db.Unique_Machine
                            where p.Unique_Machine_ID == um_ID
                            select p).First();

                    mach.Machine_Status_ID = (int)mac["Machine_Status_ID"];
                }
                db.SaveChanges();

                return "true|Unique Machine Statuses successfully updated.";
             }
             catch(Exception e)
             {
                ExceptionLog.LogException(e, "UniqueMachineStatusController POST");
                return "false|An error has occured updating the Unique Machine Statuses on the system.";
             }
        }
    }
}
