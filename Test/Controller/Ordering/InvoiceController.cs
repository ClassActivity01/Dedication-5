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
    public class InvoiceController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/Invoice/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    invoices =
                        from p in db.Invoices
                        where p.Delivery_Note.Client_Order_ID == id
                        select new
                        {
                            Invoice_ID = p.Invoice_ID,
                            Invoice_Date = p.Invoice_Date,
                            Invoice_Status_ID = p.Invoice_Status_ID,
                            Delivery_Note_ID = p.Delivery_Note_ID,
                            Invoice_Status_Name = p.Invoice_Status.Name,
                            amount_noVat = p.amount_noVat,
                            amount_Vat = p.amount_Vat,

                            ip = 
                                from d in db.Invoice_Payment
                                where d.Invoice_ID == p.Invoice_ID
                                select new
                                {
                                    Payment_ID = d.Payment_ID,
                                    Payment_Date = d.Payment_Date,
                                    Amount_Paid = d.Amount_Paid
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "InvoiceController GET");
                return "false|Failed to retrieve Invoice.";
            }
        }

        // POST: api/Invoice
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Invoice inv = new Model.Invoice();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                string action = (string)json["action"];

                int key = db.Invoices.Count() == 0 ? 1 : (from t in db.Invoices
                                                          orderby t.Invoice_ID descending
                                                              select t.Invoice_ID).First() + 1;

                inv.Invoice_ID = key;
                inv.Invoice_Date = (DateTime)json["Invoice_Date"];
                inv.Invoice_Status_ID = 1;
                inv.Delivery_Note_ID = (int)json["Delivery_Note_ID"];
                inv.amount_noVat = (decimal)json["amount_noVat"];
                inv.amount_Vat = (decimal)json["amount_Vat"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Invoices
                     where t.Delivery_Note_ID == inv.Delivery_Note_ID
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Delivery Note Number already has an Invoice on the system. ";
                }

                if (error)
                    return errorString;

                db.Invoices.Add(inv);
                db.SaveChanges();

                if (action == "email")
                {
                    string to = (string)json["email"];
                    string subject = "WME Invoice #" + key;

                    String orderDate = inv.Invoice_Date.ToShortDateString();
                    string body = "Walter Meano Engineering Invoice #" + key + "\nThe invoice was generated on " + orderDate + "\n\nItems payable:\n";

                    List<Delivery_Note_Details> parts = (from p in db.Delivery_Note_Details
                                        where p.Delivery_Note_ID == inv.Delivery_Note_ID
                                        select p).ToList();

                    foreach (Delivery_Note_Details part in parts)
                    {
                        Part_Type partDetails = (from p in db.Delivery_Note_Details
                                       where p.Delivery_Note_ID == inv.Delivery_Note_ID
                                       select p.Client_Order_Detail.Part_Type).First();
                        body += partDetails.Name + "\t\tx" + part.Quantity_Delivered + "\t"+part.Client_Order_Detail.Part_Price+" per unit\n";
                    }

                    body += "\nAmount payable VAT Excl.:\t"+ inv.amount_noVat;
                    body += "\nAmount payable VAT Incl.:\t" + inv.amount_Vat;

                    Email.SendEmail(to, subject, body);
                }

                return "true|Invoice #" + key + " successfully added.|" + key;
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "InvoiceController POST");
                return "false|An error has occured adding the Invoice to the system.";
            }
        }
    }
}
