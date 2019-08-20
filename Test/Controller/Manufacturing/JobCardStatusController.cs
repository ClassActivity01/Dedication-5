using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Manufacturing
{
    public class JobCardStatusController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/JobCardStatus
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    job_card_statuses =
                        from p in db.Job_Card_Status
                        orderby p.Job_Card_Status_ID
                        select new
                        {
                            Job_Card_Status_ID = p.Job_Card_Status_ID,
                            Name = p.Name,
                            Description = p.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "JobCardStatusController");
                return "false|Failed to retrieve Job Card Statuses.";
            }
        }
    }
}
