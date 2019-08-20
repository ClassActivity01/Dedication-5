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
    public partial class _5_5 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /*  
               [WebMethod]
               public static string updateSupplierOrder(int order_ID, int status_ID)
               {

                   return "True|blah blah";
               }

               [WebMethod]
               public static string getOrderDetails(int ID)
               {
                   Supplier_Order sq = new Supplier_Order();
                   sq.sqc = new List<Supplier_Order_Component>();
                   sq.sqc.Add(new Supplier_Order_Component());
                   sq.sqc[0].Component_ID = 1;
                   sq.sqc[0].Component_Name = "Bolt";
                   sq.sqc[0].Price = 123.33;
                   sq.sqc[0].Quantity_Requested = 3;
                   sq.sqc[0].Quantity_Received = 3;
                   sq.sqp = new List<Supplier_Order_Detail_Part>();
                   sq.sqp.Add(new Supplier_Order_Detail_Part());
                   sq.sqp[0].Part_Type_ID = 1;
                   sq.sqp[0].Part_Type_Name = "Part A";
                   sq.sqp[0].Price = 123.33;
                   sq.sqp[0].Quantity = 3;
                   sq.sqp[0].Quantity_Received = 0;
                   sq.sqrm = new List<Supplier_Order_Detail_Raw_Material>();
                   sq.sqrm.Add(new Supplier_Order_Detail_Raw_Material());
                   sq.sqrm[0].Raw_Material_ID = 1;
                   sq.sqrm[0].Raw_Material_Name = "Steel";
                   sq.sqrm[0].Price = 123.33;
                   sq.sqrm[0].Quantity = 3;
                   sq.sqrm[0].Quantity_Received = 3;
                   sq.sqrm[0].Dimensions = "a X b X c";
                   sq.Supplier_ID = 1;
                   sq.Date = new DateTime(2016, 12, 11);
                   sq.Supplier_Order_ID = 1;
                   sq.Supplier_Name = "Supplier Name";
                   sq.Date = new DateTime(2016, 12, 12);

                   string Suppliers = "True|" + JsonConvert.SerializeObject(sq, Formatting.Indented);

                   return Suppliers;

               }*/
    }
}