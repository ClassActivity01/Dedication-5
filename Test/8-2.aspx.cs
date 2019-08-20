using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _8_2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 /*       [System.Web.Services.WebMethod]
        public static string getMachineDetails(int ID)
        {

            //if method == exact/Like/similiar
            //what will determine which table you are searching for. 

            Machine s = new Machine();
            s.Name = "Machine A";
            s.Manufacturer = "Mm Works";
            s.Model = "123-abc";
            s.Price_Per_Hour = 123.23;
            s.Run_Time = 29;


            string machine = JsonConvert.SerializeObject(s);

            return machine;

        }

        [System.Web.Services.WebMethod]
        public static string updateMachine(Machine machine)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return Convert.ToString(machine.Machine_ID);
        }

        [System.Web.Services.WebMethod]
        public static string deleteMachine(int ID)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return Convert.ToString(ID);
        } */
    }
}