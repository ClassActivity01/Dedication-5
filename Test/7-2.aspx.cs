using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _7_2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

/*        [System.Web.Services.WebMethod]
        public static string getSunContractorDetails(int ID)
        {
            Sub_Contractor s = new Sub_Contractor();
            s.Sub_Contractor_ID = ID;
            s.Name = "CC - Something";
            s.Address = "93 Example Street";
            s.City = "Pretoria";
            s.Province_ID = 1;
            s.Zip = "1234";
            s.Manual_Labour_Type_ID = 1;
            s.contact_details = new List<Sub_Contractor_Contact_Detail>();
            s.contact_details.Add(new Sub_Contractor_Contact_Detail());
            s.contact_details[0].Email = "Jane@yum.com";
            s.contact_details[0].Name = "Peanut The Great";
            s.contact_details[0].Number = "01233330987";
            s.contact_details.Add(new Sub_Contractor_Contact_Detail());
            s.contact_details[1].Email = "Jane@yum.com";
            s.contact_details[1].Name = "Peanut The Great";
            s.contact_details[1].Number = "01233330987";

            string ss = "True|" + JsonConvert.SerializeObject(s, Formatting.Indented);

            return ss;

        }

        [System.Web.Services.WebMethod]
        public static string updateSubContractor(Client client)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return Convert.ToString(client.Client_ID);
        }

        [System.Web.Services.WebMethod]
        public static string deleteSubContractor(int ID)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return "False|" +  Convert.ToString(ID);
        }*/
    }
}