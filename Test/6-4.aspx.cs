using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _6_4 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 /*       [System.Web.Services.WebMethod]
        public static string getOrderDetails(int ID)
        {
            //returns the amount of stock available for a part type

            Client_Order cq = new Client_Order();
            cq.Client_ID = 1;
            cq.Client_Order_ID = 1;
            cq.Contact_ID = 1;
            cq.Date = new DateTime(2014, 12, 12);
            cq.Settlement_Discount_Rate = 23;
            cq.Reference_ID = "abc-123";
            cq.VAT_Inclu = true;
            cq.Delivery_Method_ID = 1;
            cq.Contact_ID = 1;
            cq.Comment = "This is  comment";
            cq.Client_Order_Type_ID = 1;
            cq.Client_Order_Status_ID = 1;

            cq.details = new List<Client_Order_Detail>();
            cq.details.Add(new Client_Order_Detail());
            cq.details[0].Client_Order_Detail_ID = 1;
            cq.details[0].Part_Type_ID = 1;
            cq.details[0].Quantity = 22;
            cq.details[0].Client_Discount_Rate = 12;
            cq.details[0].Part_Price = 23.33;
            cq.details[0].Part_Type_Name = "Pump A";

            string quote = "True|" + JsonConvert.SerializeObject(cq, Formatting.Indented);

            return quote;
        }

        [System.Web.Services.WebMethod]
        public static string maintainOrder(int order_ID, int status_ID, int order_type, int delivery_method)
        {

            return "True|blah blah";
        }

        [System.Web.Services.WebMethod]
        public static string cancelOrder(int ID)
        {

            return "True|blah blah";
        }*/
    }
}