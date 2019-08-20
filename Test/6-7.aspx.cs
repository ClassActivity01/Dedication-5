using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _6_7 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

  /*      class Comboclass
        {
            public List<Invoice> dn;
            public List<Invoice_Payment> ip;
        }
        [System.Web.Services.WebMethod]
        public static string getInvoices(int ID)
        {
            //indexes must match 
            Comboclass c = new Comboclass();
            c.dn = new List<Invoice>();
            c.dn.Add(new Invoice());
            c.dn[0].Invoice_Date = new DateTime(2016, 12, 23);
            c.dn[0].Delivery_Note_ID = 22;
            c.dn[0].amount_noVat = 233.33;
            c.dn[0].amount_Vat = 265.99;
            c.dn[0].Client_Order_ID = ID;
            c.dn[0].Invoice_ID = 1;
            c.dn[0].Invoice_Status_Name = "Partially Paid";

            c.ip = new List<Invoice_Payment>();
            c.ip.Add(new Invoice_Payment());
            c.ip[0].Amount_Paid = 100;
            c.ip[0].Invoice_ID = 1;
            c.ip[0].Payment_Date = new DateTime(2016, 12, 24);
            c.ip[0].Payment_ID = 1;

            c.dn.Add(new Invoice());
            c.dn[1].Invoice_Date = new DateTime(2016, 12, 24);
            c.dn[1].Delivery_Note_ID = 23;
            c.dn[1].amount_noVat = 233.33;
            c.dn[1].amount_Vat = 265.99;
            c.dn[1].Client_Order_ID = ID;
            c.dn[1].Invoice_ID = 2;
            c.dn[1].Invoice_Status_Name = "Partially Paid";

            c.ip.Add(new Invoice_Payment());
            c.ip[1].Amount_Paid = 100;
            c.ip[1].Invoice_ID = 2;
            c.ip[1].Payment_Date = new DateTime(2016, 12, 25);
            c.ip[1].Payment_ID = 2;

            string note = "True|" + JsonConvert.SerializeObject(c, Formatting.Indented);

            return note;
        }

        [System.Web.Services.WebMethod]
        public static string finaliseOrder(List<Invoice_Payment> invoices, int ID)
        {
            return "True|Blah blah";
        }*/
    }
}