using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _3_6 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 /*       [System.Web.Services.WebMethod]
        public static string updatePart(Part part)
        {
            return part.Part_ID;
        }

        class ComboClass
        {
            public Part p;
            public Part_Type pt;
        }
        [System.Web.Services.WebMethod]
        public static string getPartDetails(string ID)
        {
            ComboClass c = new ComboClass();

            c.p = new Part();
            c.pt = new Part_Type();

            c.p.Cost_Price = 123.33;
            c.p.Part_ID = "VSH 123";
            c.p.Part_Status_ID = 1;
            c.p.Part_Type_ID = 1;

            c.pt.Part_Type_ID = 1;
            c.pt.Name = "Pump A";
            c.pt.Dimension = "23mm X 33mm X 45mm";
            c.pt.Selling_Price = 234.33;
            c.pt.Description = "This is a sample description.";

            string part = JsonConvert.SerializeObject(c);

            return part;

        }*/
    }
}