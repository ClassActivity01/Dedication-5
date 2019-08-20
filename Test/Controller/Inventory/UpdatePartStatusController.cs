using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Inventory
{
    public class UpdatePartStatusController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/UpdatePartStatus
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    parts =
                        from p in db.Parts join pt in db.Part_Type on p.Part_Type_ID equals pt.Part_Type_ID
                        orderby p.Part_Serial
                        where p.Part_Status_ID == 1 || p.Part_Status_ID == 2 || p.Part_Status_ID == 6
                        select new
                        {
                            Part_ID = p.Part_ID,
                            Part_Serial = p.Part_Serial,
                            Part_Status_ID = p.Part_Status_ID,
                            Date_Added = p.Date_Added,
                            Name = pt.Name,
                            Part_Stage = p.Part_ID,
                            Job_Card_ID = from j in db.Job_Card
                                          where j.Job_Card_Detail.Any(x => x.Parts.Any(y => y.Part_ID == p.Part_ID))
                                          select j.Job_Card_ID
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UpdatePartStatusController GET");
                return "false|Failed to retrieve Part Statuses.";
            }
        }

        // POST: api/UpdatePartStatus
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JArray partStatusDetails = JArray.Parse(message);

                foreach(JObject partObject in partStatusDetails)
                {
                    Model.Part ps = new Model.Part();
                    int part_id = (int)partObject["Part_ID"];

                    ps = (from p in db.Parts
                          where p.Part_ID == part_id
                          select p).First();

                    ps.Part_Status_ID = (int)partObject["Part_Status_ID"];
                }

                db.SaveChanges();
                return "true|Part Statuses successfully updated on the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "UpdatePartStatusController POST");
                return "false|An error has occured updating the Part Statuses on the system.";
            }
        }
    }
}
