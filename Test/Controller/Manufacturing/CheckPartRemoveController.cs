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
    public class CheckPartRemoveController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/CheckPartRemove
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                int part_type_ID = (int)json["part_type_ID"];
                int quantity = (int)json["quantity"];
                int job_card_ID = (int)json["job_card_ID"];

                List<Job_Card_Detail> jcd = new List<Job_Card_Detail>();
                jcd = (from p in db.Job_Card_Detail
                       where p.Job_Card_ID == job_card_ID
                       select p).ToList();

                int count = 0;

                foreach (Job_Card_Detail job_detail in jcd)
                {
                    count += (from d in db.Parts
                             where d.Job_Card_Detail.Contains(db.Job_Card_Detail.Where(x => x.Job_Card_Details_ID == job_detail.Job_Card_Details_ID).FirstOrDefault()) && d.Part_Type_ID == part_type_ID && d.Part_Status_ID == 1
                             select d).Count();
                }

                if (quantity > count)
                    return "false|Cannot remove some of the parts, some have already gone into production. <br/>" +
                    "You can remove " + count + " parts.";
                else
                    return "true|";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CheckPartRemoveController");
                return "false|Failed to calculate the quantity of parts that can be removed.";
            }
        }
    }
}
