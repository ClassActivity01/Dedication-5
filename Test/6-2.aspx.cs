using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _6_2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

  /*      [System.Web.Services.WebMethod]
        public static string submitOrder(Client_Order client, string action)
        {
            //action is either print or email or just process i.e. adding a new order
            //Remember to add a job card as well!
            return Convert.ToString(client.Client_ID);
        }

        [System.Web.Services.WebMethod]
        public static string getStockAvailable(int ID)
        {
            //returns the amount of stock available for a part type

            return "True|23";
        }

        [System.Web.Services.WebMethod]
        public static string getQuoteDetails(int ID)
        {
            //returns the amount of stock available for a part type

            Client_Quote cq = new Client_Quote();
            cq.Client_ID = 1;
            cq.Client_Quote_ID = 1;
            cq.Contact_ID = 1;
            cq.Date = new DateTime(2014, 12, 12);
            cq.Settlement_Discount_Rate = 23;
            cq.details = new List<Client_Quote_Detail>();
            cq.details.Add(new Client_Quote_Detail());
            cq.details[0].Part_Type_ID = 1;
            cq.details[0].Quantity = 22;
            cq.details[0].Client_Discount_Rate = 12;
            cq.details[0].Part_Price = 23.33;
            cq.details[0].Part_Type_Name = "Pump A";

            string quote = "True|" + JsonConvert.SerializeObject(cq, Formatting.Indented);

            return quote;
        }

        [System.Web.Services.WebMethod]
        public static string getDeliveryMethods()
        {
            List<Delivery_Method> dm = new List<Delivery_Method>();
            dm.Add(new Delivery_Method());
            dm[0].Delivery_Method_ID = 1;
            dm[0].Name = "Partial Delivery";
            dm.Add(new Delivery_Method());
            dm[1].Delivery_Method_ID = 2;
            dm[1].Name = "Full Delivery";

            string delivery = "True|" + JsonConvert.SerializeObject(dm, Formatting.Indented);

            return delivery;
        }

        [System.Web.Services.WebMethod]
        public static string getOrderTypes()
        {
            List<Client_Order_Type> dm = new List<Client_Order_Type>();
            dm.Add(new Client_Order_Type());
            dm[0].Client_Order_Type_ID = 1;
            dm[0].Type = "Cash Sale";
            dm.Add(new Client_Order_Type());
            dm[1].Client_Order_Type_ID = 2;
            dm[1].Type = "Contracted Sale";

            string type = "True|" + JsonConvert.SerializeObject(dm, Formatting.Indented);

            return type;
        }

        [System.Web.Services.WebMethod]
        public static string getOrderStatuses()
        {
            List<Client_Order_Status> dm = new List<Client_Order_Status>();
            dm.Add(new Client_Order_Status());
            dm[0].Client_Order_Status_ID = 1;
            dm[0].Name = "Paid";
            dm.Add(new Client_Order_Status());
            dm[1].Client_Order_Status_ID = 2;
            dm[1].Name = "Partially paid";

            string type = "True|" + JsonConvert.SerializeObject(dm, Formatting.Indented);

            return type;
        }*/
    }
}