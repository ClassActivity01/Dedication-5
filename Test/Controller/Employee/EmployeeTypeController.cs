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
    public class EmployeeTypeController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/EmployeeType
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    employee_types =
                        from p in db.Employee_Type
                        orderby p.Name
                        select new
                        {
                            Employee_Type_ID = p.Employee_Type_ID,
                            Name = p.Name,
                            Description = p.Description
                        }
                });
                return "true|"+result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeTypeController GET");
                return "false|Failed to retrieve Employee Categories.";
            }
        }

        // GET: api/EmployeeType/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    employee_types =
                        from p in db.Employee_Type
                        orderby p.Name
                        where p.Employee_Type_ID == id
                        select new
                        {
                            Employee_Type_ID = p.Employee_Type_ID,
                            Name = p.Name,
                            Description = p.Description,
                            access = from d in db.Access_Employee_Type
                                     orderby d.Employee_Type_ID
                                     where d.Employee_Type_ID == id
                                     select new
                                     {
                                         Access_ID = d.Access_ID,
                                         access = d.Acess
                                     }
                        }
                });
                return "true|" +result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeTypeController GET ID");
                return "false|Failed to retrieve Employee Category.";
            }
        }

        // POST: api/EmployeeType
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Employee_Type type = new Employee_Type();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject empType = (JObject)json["employee_type"];

                int key = db.Employee_Type.Count() == 0 ? 1 : (from t in db.Employee_Type
                                                               orderby t.Employee_Type_ID descending
                                                           select t.Employee_Type_ID).First() + 1;

                type.Employee_Type_ID = key;
                type.Name = (string)empType["name"];
                type.Description = (string)empType["description"];

                JArray access = (JArray)empType["access"];

                //Insert the access levels for this emp type
                foreach (JObject aa in access)
                {
                    bool flag = (bool)aa["access"];

                    int a_ID = (int)aa["ID"];
                    Model.Access_Employee_Type aet = new Access_Employee_Type();
                    aet.Access_ID = a_ID;
                    aet.Acess = flag;
                    aet.Employee_Type_ID = key;

                    db.Access_Employee_Type.Add(aet);


                }

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Employee_Type
                     where t.Name == type.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Category already exists on the system.";
                }

                if (error)
                    return errorString;

                db.Employee_Type.Add(type);
                db.SaveChanges();
                return "true|Employee Category  #" + key + " successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeTypeController POST");
                return "false|An error has occured adding the Employee Category to the system.";
            }
        }

        // PUT: api/EmployeeType/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Employee_Type type = new Employee_Type();
                type = (from p in db.Employee_Type
                       where p.Employee_Type_ID == id
                       select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject empType = (JObject)json["employee_type"];

                type.Name = (string)empType["name"];
                type.Description = (string)empType["description"];

                db.Access_Employee_Type.RemoveRange(db.Access_Employee_Type.Where(x => x.Employee_Type_ID == id));
                JArray access = (JArray)empType["access"];

                //Insert the access levels for this emp type
                foreach (JObject aa in access)
                {
                    bool flag = (bool)aa["access"];

                    int a_ID = (int)aa["ID"];
                    Model.Access_Employee_Type aet = new Access_Employee_Type();
                    aet.Access_ID = a_ID;
                    aet.Acess = flag;
                    aet.Employee_Type_ID = id;

                    db.Access_Employee_Type.Add(aet);


                }

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Employee_Type
                     where t.Name == type.Name && t.Employee_Type_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Category already exists on the system.";
                }

                if (error)
                    return errorString;

                db.SaveChanges();
                return "true|Employee Category successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeTypeController PUT");
                return "false|An error has occured updating the Employee Category on the system.";
            }
        }

        // DELETE: api/EmployeeType/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Employee_Type.SingleOrDefault(x => x.Employee_Type_ID == id);
                if (itemToRemove != null)
                {
                    db.Access_Employee_Type.RemoveRange(db.Access_Employee_Type.Where(x => x.Employee_Type_ID == id));
                    db.Employee_Type.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Employee Category has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeTypeController DELETE");
                return "false|The Employee Category is in use and cannot be removed from the system.";
            }
        }
    }
}