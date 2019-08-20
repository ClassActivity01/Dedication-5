using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _6_6 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

  /*      [System.Web.Services.WebMethod]
        public static string getDeliveryNotes(int ID)
        {
            //what refers to print or email.
            List<Delivery_Note> dn = new List<Delivery_Note>();
            dn.Add(new Delivery_Note());
            dn[0].Delivery_Note_Date = new DateTime(2016, 12, 23);
            dn[0].Delivery_Note_ID = 22;
            dn.Add(new Delivery_Note());
            dn[0].Delivery_Note_Date = new DateTime(2016, 12, 24);
            dn[0].Delivery_Note_ID = 23;


            string note = "True|" + JsonConvert.SerializeObject(dn, Formatting.Indented);

            return note;
        }

        [System.Web.Services.WebMethod]
        public static string generateInvoice(Invoice invoice, string what)
        {
            //Remember to generate an invoice_payment entry as well with nothing paid yet
            return "True|Blah blah";
        }

        class comboClass
        {
            public int Delivery_Note_ID;
            public int Client_Order_ID;
            public List<Delivery_Note_Details> dn;
            public List<Client_Order_Detail> cod;
        }
        [System.Web.Services.WebMethod]
        public static string getDeliveryNoteDetails(int ID)
        {
            //returns the amount of stock available for a part type

            comboClass cq = new comboClass();
            cq.Delivery_Note_ID = ID;
            cq.Client_Order_ID = 1;

            //Their indexes have to match
            cq.dn = new List<Delivery_Note_Details>();
            cq.dn.Add(new Delivery_Note_Details());
            cq.dn[0].Client_Order_Detail_ID = 1;
            cq.dn[0].Quantity_Delivered = 2;
            cq.cod = new List<Client_Order_Detail>();
            cq.cod.Add(new Client_Order_Detail());
            cq.cod[0].Part_Type_ID = 1;
            cq.cod[0].Part_Type_Name = "Pump A";
            cq.cod[0].Part_Price = 23.33;
            cq.cod[0].Quantity = 22;
            cq.cod[0].Quantity_Delivered = 4;
            cq.cod[0].Client_Discount_Rate = 11;
            cq.cod[0].Client_Order_Detail_ID = 1;
            cq.cod[0].Client_Order_ID = 1;


            string quote = "True|" + JsonConvert.SerializeObject(cq, Formatting.Indented);

            return quote;
        }*/
    }
}