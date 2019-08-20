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
    public class PartStatusController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/PartStatus
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    part_statuses =
                        from p in db.Part_Status
                        orderby p.Name
                        select new
                        {
                            Part_Status_ID = p.Part_Status_ID,
                            Name = p.Name,
                            Description = p.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartStatusController GET");
                return "false|Failed to retrieve Part Statuses.";
            }
        }

        // GET: api/PartStatus/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    part_statuses =
                        from p in db.Part_Status
                        orderby p.Name
                        where p.Part_Status_ID == id
                        select new
                        {
                            Part_Status_ID = p.Part_Status_ID,
                            Name = p.Name,
                            Description = p.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartStatusController GET ID");
                return "false|Failed to retrieve Part Statuses.";
            }
        }

        // POST: api/PartStatus
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Part_Status ps = new Model.Part_Status();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject partStatusDetails = JObject.Parse(message);

                int key = db.Part_Status.Count() == 0 ? 1 : (from t in db.Part_Status
                                                             orderby t.Part_Status_ID descending
                                                           select t.Part_Status_ID).First() + 1;

                ps.Part_Status_ID = key;
                ps.Name = (string)partStatusDetails["Name"];
                ps.Description = (string)partStatusDetails["Description"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Part_Status
                     where t.Name == ps.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Part Status entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Part_Status.Add(ps);
                db.SaveChanges();
                return "true|Part Status #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartStatusController POST");
                return "false|An error has occured adding the Part Status to the system.";
            }
        }

        // PUT: api/PartStatus/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject partStatusDetails = JObject.Parse(message);

                Model.Part_Status ps = new Model.Part_Status();
                ps = (from p in db.Part_Status
                        where p.Part_Status_ID == id
                        select p).First();

                ps.Name = (string)partStatusDetails["Name"];
                ps.Description = (string)partStatusDetails["Description"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Part_Status
                     where t.Name == ps.Name && t.Part_Status_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Part Status entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.SaveChanges();
                return "true|Part Status successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartStatus PUT");
                return "false|An error has occured adding the Part Status to the system.";
            }
        }

        // DELETE: api/PartStatus/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Part_Status.SingleOrDefault(x => x.Part_Status_ID == id);
                if (itemToRemove != null)
                {
                    db.Part_Status.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Part Status has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartStatusController DELETE");
                return "false|The Part Status is in use and cannot be removed from the system.";
            }
        }
    }
}
