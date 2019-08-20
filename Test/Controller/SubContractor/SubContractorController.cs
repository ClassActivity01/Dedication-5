using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Sub_Contractor
{
    public class SubContractorController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/SubContractor
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    sub_contractors =
                        from p in db.Sub_Contractor
                        orderby p.Name
                        select new
                        {
                            Sub_Contractor_ID = p.Sub_Contractor_ID,
                            Name = p.Name,
                            Address = p.Address,
                            City = p.City,
                            Zip = p.Zip,
                            Status = p.Status,
                            Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                            Province_ID = p.Province_ID,
                            Manual_Labour_Name = p.Manual_Labour_Type.Name,

                            contact_details =
                                from e in db.Sub_Contractor_Contact_Detail
                                orderby e.Name
                                where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                select new
                                {
                                    Number = e.Number,
                                    Name = e.Name,
                                    Email = e.Email
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SubContractorController GET");
                return "false|Failed to retrieve Sub-Contractors.";
            }
        }

        // GET: api/SubContractor/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    sub_contractors =
                        from p in db.Sub_Contractor
                        orderby p.Name
                        where p.Sub_Contractor_ID == id
                        select new
                        {
                            Sub_Contractor_ID = p.Sub_Contractor_ID,
                            Name = p.Name,
                            Address = p.Address,
                            City = p.City,
                            Zip = p.Zip,
                            Status = p.Status,
                            Manual_Labour_Type_ID = p.Manual_Labour_Type_ID,
                            Province_ID = p.Province_ID,
                            Manual_Labour_Name = p.Manual_Labour_Type.Name,

                            contact_details =
                                from e in db.Sub_Contractor_Contact_Detail
                                orderby e.Name
                                where e.Sub_Contractor_ID == p.Sub_Contractor_ID
                                select new
                                {
                                    Number = e.Number,
                                    Name = e.Name,
                                    Email = e.Email
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SubContractorController GET ID");
                return "false|Failed to retrieve Sub-Contractor.";
            }
        }

        // POST: api/SubContractor
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Sub_Contractor sub = new Model.Sub_Contractor();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject subDetails = JObject.Parse(message);
                JArray contactDetails = (JArray)subDetails["contact_details"];

                int key = db.Sub_Contractor.Count() == 0 ? 1 : (from t in db.Sub_Contractor
                                                                orderby t.Sub_Contractor_ID descending
                                                         select t.Sub_Contractor_ID).First() + 1;

                sub.Sub_Contractor_ID = key;
                sub.Name = (string)subDetails["Name"];
                sub.Address = (string)subDetails["Address"];
                sub.City = (string)subDetails["City"];
                sub.Zip = (string)subDetails["Zip"];
                sub.Status = Convert.ToBoolean(Convert.ToInt32(subDetails["Status"]));
                sub.Manual_Labour_Type_ID = (int)subDetails["Manual_Labour_Type_ID"];
                sub.Province_ID = (int)subDetails["Province_ID"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Sub_Contractor
                     where t.Name == sub.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Sub-Contractor name entered already exists on the system. ";
                }

                if ((from t in db.Sub_Contractor
                     where t.Address == sub.Address && t.City == sub.City && t.Zip == sub.Zip
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Sub-Contractor address entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Sub_Contractor.Add(sub);

                int contact_id = db.Sub_Contractor_Contact_Detail.Count() == 0 ? 1 : (from t in db.Sub_Contractor_Contact_Detail
                                                                                       orderby t.Contact_ID descending
                                                                                       select t.Contact_ID).First() + 1;

                foreach (JObject contact in contactDetails)
                {
                    Sub_Contractor_Contact_Detail ccpd = new Sub_Contractor_Contact_Detail();
                    ccpd.Contact_ID = contact_id;
                    contact_id++;

                    ccpd.Sub_Contractor_ID = key;
                    ccpd.Number = (string)contact["Number"];
                    ccpd.Name = (string)contact["Name"];
                    ccpd.Email = (string)contact["Email"];

                    db.Sub_Contractor_Contact_Detail.Add(ccpd);
                }

                db.SaveChanges();
                return "true|Sub-Contractor #" + key + " successfully added.";
            }
            catch (DbEntityValidationException dbEx)
            {
                // Retrieve the error messages as a list of strings.
                var errorMessages = dbEx.EntityValidationErrors
                        .SelectMany(x => x.ValidationErrors)
                        .Select(x => x.ErrorMessage);

                // Join the list to a single string.
                var fullErrorMessage = string.Join("; ", errorMessages);

                // Combine the original exception message with the new one.
                var exceptionMessage = string.Concat(dbEx.Message, " The validation errors are: ", fullErrorMessage);

                ExceptionLog.LogException(dbEx, exceptionMessage);

                return "false|An error has occured adding the Sub-Contractor to the system.|" + exceptionMessage;
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "SubContractorController POST");
                return "false|An error has occured adding the Sub-Contractor to the system.";
            }
        }

        // PUT: api/SubContractor/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Model.Sub_Contractor sub = new Model.Sub_Contractor();
                sub = (from p in db.Sub_Contractor
                        where p.Sub_Contractor_ID == id
                        select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject subDetails = JObject.Parse(message);
                JArray contactDetails = (JArray)subDetails["contact_details"];

                sub.Name = (string)subDetails["Name"];
                sub.Address = (string)subDetails["Address"];
                sub.City = (string)subDetails["City"];
                sub.Zip = (string)subDetails["Zip"];
                sub.Status = Convert.ToBoolean(Convert.ToInt32(subDetails["Status"]));
                sub.Manual_Labour_Type_ID = (int)subDetails["Manual_Labour_Type_ID"];
                sub.Province_ID = (int)subDetails["Province_ID"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Sub_Contractor
                     where t.Name == sub.Name && t.Sub_Contractor_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Sub-Contractor name entered already exists on the system. ";
                }

                if ((from t in db.Sub_Contractor
                     where (t.Address == sub.Address && t.City == sub.City && t.Zip == sub.Zip) && t.Sub_Contractor_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Sub-Contractor address entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Sub_Contractor_Contact_Detail.RemoveRange(db.Sub_Contractor_Contact_Detail.Where(x => x.Sub_Contractor_ID == id));

                int contact_id = db.Sub_Contractor_Contact_Detail.Count() == 0 ? 1 : (from t in db.Sub_Contractor_Contact_Detail
                                                                                      orderby t.Contact_ID descending
                                                                                      select t.Contact_ID).First() + 1;

                foreach (JObject contact in contactDetails)
                {
                    Sub_Contractor_Contact_Detail ccpd = new Sub_Contractor_Contact_Detail();
                    ccpd.Contact_ID = contact_id;
                    contact_id++;

                    ccpd.Sub_Contractor_ID = id;
                    ccpd.Number = (string)contact["Number"];
                    ccpd.Name = (string)contact["Name"];
                    ccpd.Email = (string)contact["Email"];

                    db.Sub_Contractor_Contact_Detail.Add(ccpd);
                }

                db.SaveChanges();
                return "true|Sub-Contractor successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SubContractorController PUT");
                return "false|An error has occured updating the Sub-Contractor on the system.";
            }
        }

        // DELETE: api/SubContractor/5
        public string Delete(int id)
        {
            try
            { 
                var itemToRemove = db.Sub_Contractor.SingleOrDefault(x => x.Sub_Contractor_ID == id);
                if (itemToRemove != null)
                {
                    db.Sub_Contractor_Contact_Detail.RemoveRange(db.Sub_Contractor_Contact_Detail.Where(x => x.Sub_Contractor_ID == id));
                    db.Sub_Contractor.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Sub-Contractor has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SubContractorController DELETE");
                return "false|The Sub-Contractor is in use and cannot be removed from the system.";
            }
        }
    }
}
