using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _8_4 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 /*       [System.Web.Services.WebMethod]
        public static string getUniqueMachineDetails(string ID)
        {
            Unique_Machine um = new Unique_Machine();
            um.Machine_ID = 1;
            um.Machine_Status_ID = 1;
            um.Unique_Machine_ID = "123-ABC";

            string unique_Machine = JsonConvert.SerializeObject(um);

            return unique_Machine;

        }

        [System.Web.Services.WebMethod]
        public static string updateUniqueMachine(Unique_Machine um)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return "False|Hello";
        }

        [System.Web.Services.WebMethod]
        public static string deleteUniqueMachine(string ID)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return ID;
        }*/
    }
}