using Newtonsoft.Json.Linq;
using System;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Web.Http;
using Test.Model;
using System.Web;
using System.Text;
using System.Drawing;
using System.IO;

namespace Test.Controller
{
    public class EmployeeController : ApiController
    {
        ProteusEntities db = new ProteusEntities();
        
        // GET: api/Employee
        public string Get()
        {
            try {
                JObject result = JObject.FromObject(new
                {
                    employees =
                        from p in db.Employees
                        orderby p.Name
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
                            Employee_Type = p.Employee_Type.Name,

                            manual_labour = p.Manual_Labour_Type.Select(s => s.Manual_Labour_Type_ID).ToList(),
                            machines = p.Machines.Select(s => s.Machine_ID).ToList()
                        }
                });
                return result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeController GET");
                return "false|Failed to retrieve Employees.";
            }
        }

        // GET: api/Employee/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    employees =
                        from p in db.Employees
                        orderby p.Name
                        where p.Employee_ID == id
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
                            Employee_Type = p.Employee_Type.Name,

                            manual_labour = p.Manual_Labour_Type.Select(s => s.Manual_Labour_Type_ID).ToList(),
                            machines = p.Machines.Select(s => s.Machine_ID).ToList()
                        }
                });
                return "true|"+result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeController GET ID");
                return "false|Failed to retrieve Employee.";
            }
        }

        private void saveImage(string in_image, string ID)
        {
            try
            {
                byte[] bytes = Convert.FromBase64String(in_image);

                Image image;
                using (MemoryStream ms = new MemoryStream(bytes))
                {
                    string completePath = HttpContext.Current.Server.MapPath("~/images/Employees/emp_") + ID + "_image.png";
                    image = Image.FromStream(ms);
                    image.Save(completePath, System.Drawing.Imaging.ImageFormat.Png);
                }

                Model.Employee_Photo ep = new Employee_Photo();

                int key = db.Employee_Photo.Count() == 0 ? 1 : (from t in db.Employee_Photo
                                                                orderby t.photo_ID descending
                                                                select t.photo_ID).First() + 1;

                ep.photo_ID = key;
                ep.Name_on_Server = "emp_" + ID + "_image.png";
                ep.Name = "Employee_Photo_" + ID;
                ep.File_Type = ".png";
                ep.Employee_ID = Convert.ToInt32(ID);

                db.Employee_Photo.Add(ep);

                //return "Image saved";
            }
            catch (Exception ex)
            {
                ExceptionLog.LogException(ex, "EmployeeController POST");
                //return ex.ToString();
            }
            
        }

        // POST: api/Employee Insert function
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Employee emp = new Model.Employee();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject empDetails = (JObject)json["emp"];
                JArray machines = (JArray)json["machines"];
                JArray labour = (JArray)json["manual_labour"];

                int key = db.Employees.Count() == 0 ? 1 : (from t in db.Employees
                                                           orderby t.Employee_ID descending
                                                            select t.Employee_ID).First() + 1;

                emp.Employee_ID = key;
                emp.Name = (string)empDetails["name"];
                emp.Surname = (string)empDetails["surname"];
                emp.Employee_Type_ID = (int)empDetails["type"];
                emp.Gender_ID = (string)empDetails["gender"];
                emp.Email = (string)empDetails["email"];
                emp.Contact_Number = (string)empDetails["contact_number"];
                emp.Username = (string)empDetails["username"];
                emp.Employee_Status = true;
                emp.ID_Number = (string)empDetails["ID"];


                if ((string)empDetails["img"] != "")
                {
                    string img = (string)empDetails["img"];
                    saveImage(img, Convert.ToString(key));
                }


                string errorString = "false|";
                bool error = false;

                if ((from t in db.Employees
                     where t.ID_Number == emp.ID_Number
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee ID Number entered already exists on the system. ";
                }

                if ((from t in db.Employees
                     where t.Contact_Number == emp.Contact_Number
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Contact Number entered already exists on the system. ";
                }

                if ((from t in db.Employees
                     where t.Email == emp.Email && t.Email != ""
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Email entered already exists on the system. ";
                }


                if ((from t in db.Employees
                     where t.Username == emp.Username
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Username entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                string salt = GetSalt(6);
                string password = (string)empDetails["password"];

                string passwordHashed = sha256(password + salt);
                emp.Salt = salt;
                emp.Password = passwordHashed;

                db.Employees.Add(emp);

                foreach (int machine in machines)
                {
                    Machine query = (from p in db.Machines
                                    where p.Machine_ID == machine
                                    select p).First();
                    emp.Machines.Add(query);
                }

                foreach (int man_lab in labour)
                {
                    Manual_Labour_Type query = (from p in db.Manual_Labour_Type
                                     where p.Manual_Labour_Type_ID == man_lab
                                     select p).First();
                    emp.Manual_Labour_Type.Add(query);
                }

                db.SaveChanges();
                return "true|Employee #"+key+" successfully added.";
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeController POST");
                return "false|An error has occured adding the Employee to the system.";

                //return e.ToString();
            }




        }

        static string sha256(string password)
        {
            SHA256Managed crypt = new SHA256Managed();
            StringBuilder hash = new StringBuilder();
            byte[] crypto = crypt.ComputeHash(Encoding.UTF8.GetBytes(password), 0, Encoding.UTF8.GetByteCount(password));
            foreach (byte theByte in crypto)
            {
                hash.Append(theByte.ToString("x2"));
            }
            return hash.ToString();
        }

        // PUT: api/Employee/5 Update Function
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Model.Employee emp = new Model.Employee();
                emp = (from p in db.Employees
                        where p.Employee_ID == id
                        select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JObject empDetails = (JObject)json["employee"];
                JArray machines = (JArray)json["machines"];
                JArray labour = (JArray)json["manual_labour"];

                emp.Name = (string)empDetails["name"];
                emp.Surname = (string)empDetails["surname"];
                emp.Employee_Type_ID = (int)empDetails["type"];
                emp.Gender_ID = (string)empDetails["gender"];
                emp.Email = (string)empDetails["email"];
                emp.Contact_Number = (string)empDetails["contact_number"];
                emp.Username = (string)empDetails["username"];
                emp.Employee_Status = true;
                emp.ID_Number = (string)empDetails["ID"];

                if ((string)empDetails["img"] != "")
                {
                    db.Employee_Photo.RemoveRange(db.Employee_Photo.Where(x => x.Employee_ID == id));
                    string img = (string)empDetails["img"];
                    saveImage(img, Convert.ToString(id));
                }



                if ((string)empDetails["password"] != "")
                {
                    string salt = GetSalt(6);
                    string password = (string)empDetails["password"];

                    string passwordHashed = sha256(password + salt);
                    emp.Salt = salt;
                    emp.Password = passwordHashed;
                }

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Employees
                     where t.ID_Number == emp.ID_Number && t.Employee_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee ID Number entered already exists on the system. ";
                }

                if ((from t in db.Employees
                     where t.Email == emp.Email && t.Employee_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Email entered already exists on the system. ";
                }

                if ((from t in db.Employees
                     where t.Contact_Number == emp.Contact_Number && t.Employee_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Contact Number entered already exists on the system. ";
                }

                if ((from t in db.Employees
                     where t.Username == emp.Username && t.Employee_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Employee Username entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                emp.Machines.Clear();

                foreach (int machine in machines)
                {
                    Machine query = (from p in db.Machines
                                     where p.Machine_ID == machine
                                     select p).First();
                    emp.Machines.Add(query);
                }

                emp.Manual_Labour_Type.Clear();

                foreach (int man_lab in labour)
                {
                    Manual_Labour_Type query = (from p in db.Manual_Labour_Type
                                                where p.Manual_Labour_Type_ID == man_lab
                                                select p).First();
                    emp.Manual_Labour_Type.Add(query);
                }

                db.SaveChanges();
                return "true|Employee successfully updated.";
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeController PUT");
                return "false|An error has occured updating the Employee on the system.";
            }
        }

        // DELETE: api/Employee/5 Delete function
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Employees.SingleOrDefault(x => x.Employee_ID == id);
                itemToRemove.Machines.Clear();
                itemToRemove.Manual_Labour_Type.Clear();
                if (itemToRemove != null)
                {
                    db.Employee_Photo.RemoveRange(db.Employee_Photo.Where(x => x.Employee_ID == id));
                    db.Employees.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Employee has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "EmployeeController DELETE");
                return "false|The Employee is in use and cannot be removed from the system.";
            }
        }

        public string GetSalt(int length)
        {
            //Create and populate random byte array
            byte[] randomArray = new byte[length];
            string randomString;

            //Create random salt and convert to string
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            rng.GetBytes(randomArray);
            randomString = Convert.ToBase64String(randomArray);
            return randomString;
        }
    }
}
