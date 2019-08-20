using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _3_13 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 /*       [WebMethod]
        public static string updateComponent(Component comp)
        {


            return "False|Updated";
        }

        [WebMethod]
        public static string removeComponent(int ID)
        {


            return "False|Removed";
        }

        [WebMethod]
        public static string getComponentDetails(int ID)
        {
            Component c = new Component();
            c.Component_ID = ID;
            c.Description = "Blah blah blah blah";
            c.Dimension = "24 mm X 26 mm X 33mm";
            c.Name = "Bolt";
            c.Quantity = 23;
            c.Unit_Price = 33.30;
            c.cs = new List<Component_Supplier>();
            c.cs.Add(new Component_Supplier());
            c.cs[0].is_preferred = false;
            c.cs[0].Supplier_ID = 1;
            c.cs[0].unit_price = 123.33;

            string comp = "True|" + JsonConvert.SerializeObject(c, Formatting.Indented);

            return comp;
        }*/
    }
}