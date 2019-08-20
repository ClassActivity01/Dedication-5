using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _3_2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

/*        [System.Web.Services.WebMethod]
        public static string getRawMaterialDetails(int ID)
        {

            //if method == exact/Like/similiar
            //what will determine which table you are searching for. 

            Raw_Material s = new Raw_Material();
            s.Name = "Steel";
            s.Description = "Blah blah blah";
            s.Raw_Material_ID = 1;
            s.rms = new List<Raw_Material_Supplier>();
            s.rms.Add(new Raw_Material_Supplier());
            s.rms[0].Is_Prefered = true;
            s.rms[0].Supplier_ID = 2;
            s.rms[0].unit_price = 13.33;
            s.rms.Add(new Raw_Material_Supplier());
            s.rms[1].Is_Prefered = false;
            s.rms[1].Supplier_ID = 1;
            s.rms[1].unit_price = 123.33;



            string rm = JsonConvert.SerializeObject(s);

            return rm;

        }

        [System.Web.Services.WebMethod]
        public static string getSupplierName(int ID)
        {
            if (ID == 1)
                return "SM-Suppliers";
            else
                return "Something Suppliers";

        }

        [System.Web.Services.WebMethod]
        public static string updateRawMaterial(Raw_Material rm)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return Convert.ToString(rm.Name);
        }

        [System.Web.Services.WebMethod]
        public static string deleteRawMaterial(int ID)
        {
            //Return message in following format:
            //Status(true/false)|Message

            return Convert.ToString(ID);
        }*/
    }
}