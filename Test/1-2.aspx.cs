using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _1_2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        class Employee
        {
            public string ID;
            public string name;
            public string surname;
            public string ID_number;
            public string contact_no;
            public string gender;
            public string email;
            public string type_ID;
            public string username;
            //PUt the IDS of the machines in the strings
            public string[] machines = new string[2];
            public string[] manual_labour = new string[1];
        }

        [System.Web.Services.WebMethod]
        public static string getEmployeeDetails(string ID)
        {

            //if method == exact/Like/similiar
            //what will determine which table you are searching for. 

            List<Employee> s = new List<Employee>();
            s.Add(new Employee());
            s[0].ID = "Emp-123";
            s[0].name = "Jane";
            s[0].surname = "Doe";
            s[0].ID_number = "9510020027081";
            s[0].contact_no = "0126633444";
            s[0].gender = "1";
            s[0].email = "Jane@gmail.com";
            //Type ID has to be in the format ID>Access-Level i.e 1>Access-1
            s[0].type_ID = "0>Access-4";
            s[0].username = "Jane01";
            s[0].machines[0] = "1";
            s[0].machines[1] = "3";
            s[0].manual_labour[0] = "1";


            string employee = JsonConvert.SerializeObject(s, Formatting.Indented);

            return employee;

        }

        [System.Web.Services.WebMethod]
        public static string updateEmployee(string employee, string machines, string manual_labour)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return employee;
        }

        [System.Web.Services.WebMethod]
        public static string deleteEmployee(string ID)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return ID;
        }

        [System.Web.Services.WebMethod]
        public static string confirmPassword(string password)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return "True|Password Correct";
        }
    }
}