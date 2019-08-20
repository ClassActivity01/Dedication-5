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
    public class DeliveryNoteController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/DeliveryNote/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    delivery_notes =
                        from p in db.Delivery_Note
                        where p.Client_Order_ID == id
                        select new
                        {
                            Delivery_Note_ID = p.Delivery_Note_ID,
                            Delivery_Note_Date = p.Delivery_Note_Date,
                            Client_Order_ID = p.Client_Order_ID
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "DeliveryNoteController GET");
                return "false|Failed to retrieve Delivery Note.";
            }
        }

        // POST: api/DeliveryNote
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Delivery_Note dn = new Model.Delivery_Note();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JArray parts = (JArray)json["details"];

                int key = db.Delivery_Note.Count() == 0 ? 1 : (from t in db.Delivery_Note
                                                               orderby t.Delivery_Note_ID descending
                                                          select t.Delivery_Note_ID).First() + 1;

                dn.Delivery_Note_ID = key;
                dn.Delivery_Note_Date = (DateTime)json["Delivery_Note_Date"];
                dn.Client_Order_ID = (int)json["Client_Order_ID"];
                string action = (string)json["action"];

                db.Delivery_Note.Add(dn);

                foreach(JObject part in parts)
                {
                    Delivery_Note_Details cod = new Delivery_Note_Details();

                    cod.Quantity_Delivered = (int)part["Quantity_Delivered"];
                    cod.Delivery_Note_ID = key;
                    cod.Client_Order_Detail_ID = (int)part["Client_Order_Detail_ID"];

                    Client_Order_Detail cod2 = new Client_Order_Detail();
                    cod2 = (from d in db.Client_Order_Detail
                            where d.Client_Order_Detail_ID == cod.Client_Order_Detail_ID
                            select d).First();

                    cod2.Quantity_Delivered += cod.Quantity_Delivered;

                    db.Delivery_Note_Details.Add(cod);
                }

                if (action == "email")
                {
                    Client_Contact_Person_Detail cl = new Client_Contact_Person_Detail();

                    string to = (string)json["email"];
                    string subject = "WME Delivery Note #" + key;

                    String orderDate = dn.Delivery_Note_Date.ToShortDateString();
                    string body = "Walter Meano Engineering Delivery Note #" + key + "\nThe delivery note was generated on " + orderDate + "\n\nItems delivered:\n";

                    foreach (JObject part in parts)
                    {
                        body += (string)part["Part_Type_Name"] + "\t\tx" + (int)part["Quantity_Delivered"] + "\n";
                    }

                    Email.SendEmail(to, subject, body);
                }

                db.SaveChanges();
                return "true|Delivery Note #" + key + " successfully added.|" + key;
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "DeliveryNoteController POST");
                return "false|An error has occured adding the Delivery Note to the system.";
            }
        }
    }
}
