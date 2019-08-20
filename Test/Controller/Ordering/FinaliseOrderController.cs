using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Ordering
{
    public class FinaliseOrderController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/FinaliseOrder
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JArray invoices = (JArray)json["invoices"];
                int orderID = (int)json["ID"];

                int key = db.Invoice_Payment.Count() == 0 ? 1 : (from t in db.Invoice_Payment
                                                                 orderby t.Payment_ID descending
                                                               select t.Payment_ID).First() + 1;

                foreach (JObject inv in invoices)
                {
                    Invoice_Payment ip = new Invoice_Payment();
                    key++;

                    ip.Payment_ID = key;
                    ip.Payment_Date = (DateTime)inv["Payment_Date"];
                    ip.Invoice_ID = (int)inv["Invoice_ID"];
                    ip.Amount_Paid = (decimal)inv["Amount_Paid"];

                    if (ip.Amount_Paid != 0)
                        db.Invoice_Payment.Add(ip);

                    Model.Invoice invoice = new Model.Invoice();
                    invoice = (from p in db.Invoices
                               where p.Invoice_ID == ip.Invoice_ID
                               select p).First();

                    if ((decimal)inv["Amount_Paid"] != (decimal)inv["Amount_Due"])
                        invoice.Invoice_Status_ID = 2;
                    else
                        invoice.Invoice_Status_ID = 3;
                }

                db.SaveChanges();
                return "true|Customer Order Payments successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "FinaliseOrderController GET");
                return "false|An error has occured adding the Customer Order Payments to the system.";
            }
        }
    }
}
