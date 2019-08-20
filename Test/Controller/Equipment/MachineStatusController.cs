using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Equipment
{
    public class MachineStatusController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/MachineStatus
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    machine_statuses =
                        from p in db.Machine_Status
                        orderby p.Name
                        select new
                        {
                            Machine_Status_ID = p.Machine_Status_ID,
                            Name = p.Name,
                            Description = p.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "MachineStatusController GET");
                return "false|Failed to retrieve Machines.";
            }
        }
    }
}
