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
    public class JobCardBackController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/JobCardBack
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    job_cards =
                        from p in db.Job_Card
                        orderby p.Job_Card_ID
                        where (p.Job_Card_Status_ID == 2 || p.Job_Card_Status_ID == 1) && p.Job_Card_Priority_ID == 2
                        select new
                        {
                            Job_Card_ID = p.Job_Card_ID,
                            Job_Card_Date = p.Job_Card_Date,
                            Job_Card_Status_ID = p.Job_Card_Status_ID,
                            Job_Card_Priority_ID = p.Job_Card_Priority_ID,
                            Job_Card_Status_Name = p.Job_Card_Status.Name,
                            Job_Card_Priority_Name = p.Job_Card_Priority.Name,

                            details =
                                from d in db.Job_Card_Detail
                                where d.Job_Card_ID == p.Job_Card_ID
                                select new
                                {
                                    Part_Type_ID = d.Part_Type_ID,
                                    Abbreviation = d.Part_Type.Abbreviation,
                                    Name = d.Part_Type.Name,
                                    Description = d.Part_Type.Description,
                                    Job_Card_Details_ID = d.Job_Card_Details_ID,
                                    Quantity = d.Quantity,
                                    Non_Manual = d.Non_Manual,
                                    Job_Card_ID = d.Job_Card_ID,

                                    parts =
                                        from c in db.Parts
                                        where c.Part_Type_ID == d.Part_Type_ID && c.Job_Card_Detail.Contains(d)
                                        select new
                                        {
                                            Part_ID = c.Part_ID,
                                            Part_Serial = c.Part_Serial,
                                            Part_Status_ID = c.Part_Status_ID,
                                            Date_Added = c.Date_Added,
                                            Cost_Price = c.Cost_Price,
                                            Part_Stage = c.Part_Stage,
                                            Part_Type_ID = c.Part_Type_ID,
                                            Part_Status_Name = c.Part_Status.Name
                                        }
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "JobCardBackController");
                return "false|Failed to retrieve Job Cards.";
            }
        }
    }
}
