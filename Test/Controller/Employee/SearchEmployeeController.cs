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
    public class SearchEmployeeController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchEmployee
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                string method = (string)json["method"]; //Exact, Contains, Similar
                string criteria = (string)json["criteria"]; //Typed in search value
                string category = (string)json["category"]; //Name, Description, Access Level
                JObject result = null;


                if (method == "PS")
                {
                    
                    result = JObject.FromObject(new
                    {
                        employees =
                            from p in db.Employees
                            orderby p.Name
                            where p.Name.Contains(criteria) || p.Surname.Contains(criteria) || p.Email.Contains(criteria)
                                || p.ID_Number.Contains(criteria) || p.Contact_Number.Contains(criteria)
                            select new
                            {
                                Employee_ID = p.Employee_ID,
                                Name = p.Name,
                                Surname = p.Surname,
                                ID_Number = p.ID_Number,
                                Contact_Number = p.Contact_Number,
                                Password = p.Password,
                                Salt = p.Salt,
                                Username = p.Username,
                                Email = p.Email,
                                Employee_Type_ID = p.Employee_Type_ID,
                                Gender_ID = p.Gender_ID,
                                Employee_Status = p.Employee_Status,
                                Employee_Category_Name = p.Employee_Type.Name,

                                manual_labour = p.Manual_Labour_Type.Select(s => s.Manual_Labour_Type_ID).ToList(),
                                machines = p.Machines.Select(s => s.Machine_ID).ToList()
                            }
                    });

                }
                if (method == "Exact")
                {
                    if (category == "All")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.Name == criteria || p.Surname == criteria || p.Email == criteria
                                    || p.ID_Number == criteria || p.Contact_Number == criteria
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                 from p in db.Employees
                                 orderby p.Name
                                 where p.Name == criteria
                                 select new
                                 {
                                     Employee_ID = p.Employee_ID,
                                     Name = p.Name,
                                     Surname = p.Surname,
                                     ID_Number = p.ID_Number,
                                     Contact_Number = p.Contact_Number,
                                     Password = p.Password,
                                     Salt = p.Salt,
                                     Username = p.Username,
                                     Email = p.Email,
                                     Employee_Type_ID = p.Employee_Type_ID,
                                     Gender_ID = p.Gender_ID,
                                     Employee_Status = p.Employee_Status,
                                     Employee_Category_Name = p.Employee_Type.Name,

                                     manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                     machines = p.Machines.Select(s => s.Name).ToList()
                                 }
                        });
                    }
                    else
                    if (category == "Surname")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.Surname == criteria
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                    else
                    if (category == "Email")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                 from p in db.Employees
                                 orderby p.Name
                                 where p.Email == criteria
                                 select new
                                 {
                                     Employee_ID = p.Employee_ID,
                                     Name = p.Name,
                                     Surname = p.Surname,
                                     ID_Number = p.ID_Number,
                                     Contact_Number = p.Contact_Number,
                                     Password = p.Password,
                                     Salt = p.Salt,
                                     Username = p.Username,
                                     Email = p.Email,
                                     Employee_Type_ID = p.Employee_Type_ID,
                                     Gender_ID = p.Gender_ID,
                                     Employee_Status = p.Employee_Status,
                                     Employee_Category_Name = p.Employee_Type.Name,

                                     manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                     machines = p.Machines.Select(s => s.Name).ToList()
                                 }
                        });
                    }
                    else
                    if (category == "IDNumber")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.ID_Number == criteria
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                    else
                    if (category == "ContactNumber")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.Contact_Number == criteria
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                }
                else
                if (method == "Contains")
                {
                    if (category == "All")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.Name.Contains(criteria) || p.Surname.Contains(criteria) || p.Email.Contains(criteria)
                                    || p.ID_Number.Contains(criteria) || p.Contact_Number.Contains(criteria)
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                 from p in db.Employees
                                 orderby p.Name
                                 where p.Name.Contains(criteria)
                                 select new
                                 {
                                     Employee_ID = p.Employee_ID,
                                     Name = p.Name,
                                     Surname = p.Surname,
                                     ID_Number = p.ID_Number,
                                     Contact_Number = p.Contact_Number,
                                     Password = p.Password,
                                     Salt = p.Salt,
                                     Username = p.Username,
                                     Email = p.Email,
                                     Employee_Type_ID = p.Employee_Type_ID,
                                     Gender_ID = p.Gender_ID,
                                     Employee_Status = p.Employee_Status,
                                     Employee_Category_Name = p.Employee_Type.Name,

                                     manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                     machines = p.Machines.Select(s => s.Name).ToList()
                                 }
                        });
                    }
                    else
                    if (category == "Surname")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.Surname.Contains(criteria)
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                    else
                    if (category == "Email")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                 from p in db.Employees
                                 orderby p.Name
                                 where p.Email.Contains(criteria)
                                 select new
                                 {
                                     Employee_ID = p.Employee_ID,
                                     Name = p.Name,
                                     Surname = p.Surname,
                                     ID_Number = p.ID_Number,
                                     Contact_Number = p.Contact_Number,
                                     Password = p.Password,
                                     Salt = p.Salt,
                                     Username = p.Username,
                                     Email = p.Email,
                                     Employee_Type_ID = p.Employee_Type_ID,
                                     Gender_ID = p.Gender_ID,
                                     Employee_Status = p.Employee_Status,
                                     Employee_Category_Name = p.Employee_Type.Name,

                                     manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                     machines = p.Machines.Select(s => s.Name).ToList()
                                 }
                        });
                    }
                    else
                    if (category == "IDNumber")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.ID_Number.Contains(criteria)
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                    else
                    if (category == "ContactNumber")
                    {
                        result = JObject.FromObject(new
                        {
                            employees =
                                from p in db.Employees
                                orderby p.Name
                                where p.Contact_Number.Contains(criteria)
                                select new
                                {
                                    Employee_ID = p.Employee_ID,
                                    Name = p.Name,
                                    Surname = p.Surname,
                                    ID_Number = p.ID_Number,
                                    Contact_Number = p.Contact_Number,
                                    Password = p.Password,
                                    Salt = p.Salt,
                                    Username = p.Username,
                                    Email = p.Email,
                                    Employee_Type_ID = p.Employee_Type_ID,
                                    Gender_ID = p.Gender_ID,
                                    Employee_Status = p.Employee_Status,
                                    Employee_Category_Name = p.Employee_Type.Name,

                                    manual_labour = p.Manual_Labour_Type.Select(s => s.Name).ToList(),
                                    machines = p.Machines.Select(s => s.Name).ToList()
                                }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "SearchEmployeeController");
                return "false|An error has occured searching for Employee on the system.";
            }
        }
    }
}
