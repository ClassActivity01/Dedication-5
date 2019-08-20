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
    public partial class _3_11 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 /*       [WebMethod]
        public static string updateUniqueRawMaterial(Unique_Raw_Material rm)
        {


            return "False|Updated";
        }

        [WebMethod]
        public static string getUniqueRawMaterialDetails(int ID)
        {

            Unique_Raw_Material urm = new Unique_Raw_Material();
            urm.Cost_Price = 23.33;
            urm.Date_Added = new DateTime(2016, 5, 9);
            urm.Date_Used = default(DateTime);
            urm.Dimension = "24 mm X 26 mm X 33mm";
            urm.Quality = "A";
            urm.Raw_Material_ID = 2;
            urm.Supplier_Order_ID = 2;
            urm.Unique_Raw_Material_ID = 1;

            string rms = "True|" + JsonConvert.SerializeObject(urm, Formatting.Indented);

            return rms;

        }

        [WebMethod]
        public static string scrapUniqueRawMaterial(int ID)
        {


            return "False|Scrapped";
        } */
    }
}