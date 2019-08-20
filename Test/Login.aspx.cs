using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Test.Controller;
using Test.Model;

namespace Test
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string login(string username, string password)
        {
            try
            {
                ProteusEntities db = new ProteusEntities();

                Model.Employee emp = new Model.Employee();
                emp = (from p in db.Employees
                       where p.Username == username
                       select p).FirstOrDefault();

                if (emp == null)
                    return "false|The username does not exist on the system.";

                string salt = emp.Salt;
                string passwordHashed = sha256(password + salt);

                if (passwordHashed == emp.Password)
                {
                    var access = (from d in db.Access_Employee_Type
                           join p in db.Accesses
                                 on d.Access_ID equals p.Access_ID
                           where d.Employee_Type_ID == emp.Employee_Type_ID
                           select new
                           {
                               p.href,
                               d.Acess
                           }).ToArray();

                    string accessString = "";

                    foreach(var p in access)
                    {
                        accessString += p.href+"," +p.Acess +"~";
                    }


                    HttpContext.Current.Session["Employee_ID"] = emp.Employee_ID;
                    HttpContext.Current.Session["Access_Level"] = accessString;

                    return "true|Successfully logged in.";
                }
                else
                {
                    return "false|The password is incorrect or you do not have the access rights for the system.";
                }
            }
            catch (Exception ex)
            {
                //return "false|" + ex.ToString();
                ExceptionLog.LogException(ex, "Login");
                return "false|Failed to Login.";
            }
           
        }

        [WebMethod]
        public static string logout()
        {
            HttpContext.Current.Session.Abandon();
            return "true|Successfully logged out.";
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
    }
}