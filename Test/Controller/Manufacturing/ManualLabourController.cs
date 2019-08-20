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
    public class ManualLabourController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/ManualLabour
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    manual_labour_types =
                        from p in db.Manual_Labour_Type
                        orderby p.Name
                        select new
                        {
                            Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                            Name = p.Name,
                            Description = p.Description,
                            Duration = p.Duration,
                            Sub_Contractor = p.Sub_Contractor
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ManualLabourController GET");
                return "false|Failed to retrieve Manual Labour Types.";
            }
        }

        // GET: api/ManualLabour/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    manual_labour_types =
                        from p in db.Manual_Labour_Type
                        orderby p.Name
                        where p.Manual_Labour_Type_ID == id
                        select new
                        {
                            Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                            Name = p.Name,
                            Description = p.Description,
                            Duration = p.Duration,
                            Sub_Contractor = p.Sub_Contractor
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ManualLabourController GET ID");
                return "false|Failed to retrieve Manual Labour Type.";
            }
        }

        // POST: api/ManualLabour
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Manual_Labour_Type mlt = new Model.Manual_Labour_Type();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                int key = db.Manual_Labour_Type.Count() == 0 ? 1 : (from t in db.Manual_Labour_Type
                                                                    orderby t.Manual_Labour_Type_ID descending
                                                              select t.Manual_Labour_Type_ID).First() + 1;

                mlt.Manual_Labour_Type_ID = key;

                mlt.Name = (string)json["Name"];
                mlt.Description = (string)json["Description"];
                mlt.Duration = (int)json["Duration"];
                mlt.Sub_Contractor = Convert.ToBoolean((string)json["Sub_Contractor"]);

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Manual_Labour_Type
                     where t.Name == mlt.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Manual Labour Type name entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Manual_Labour_Type.Add(mlt);

                db.SaveChanges();
                return "true|Manual Labour Type #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ManualLabourController POST");
                return "false|An error has occured adding the Manual Labour Type to the system.";
            }
        }

        // PUT: api/ManualLabour/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Manual_Labour_Type mlt = new Manual_Labour_Type();
                mlt = (from p in db.Manual_Labour_Type
                       where p.Manual_Labour_Type_ID == id
                       select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Manual_Labour_Type
                     where t.Name == mlt.Name && t.Manual_Labour_Type_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Manual Labour Type name entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                mlt.Name = (string)json["Name"];
                mlt.Description = (string)json["Description"];
                mlt.Duration = (int)json["Duration"];
                mlt.Sub_Contractor = Convert.ToBoolean((string)json["Sub_Contractor"]);
                
                db.SaveChanges();
                return "true|Manual Labour Type successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ManualLabourController PUT");
                return "false|An error has occured updating the Manual Labour Type on the system.";
            }
        }

        // DELETE: api/ManualLabour/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Manual_Labour_Type.SingleOrDefault(x => x.Manual_Labour_Type_ID == id);
                if (itemToRemove != null)
                {
                    db.Manual_Labour_Type.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Manual Labour Type has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ManualLabourController DELETE");
                return "false|The Manual Labour Type is in use and cannot be removed from the system.";
            }
        }
    }
}
