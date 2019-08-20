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
    public class CreditNoteController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/CreditNote
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Customer_Credit cc = new Model.Customer_Credit();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JArray returnDetails = (JArray)json["cni"];
                string action = (string)json["action"];

                int key = db.Customer_Credit.Count() == 0 ? 1 : (from t in db.Customer_Credit
                                                                 orderby t.Customer_Credit_ID descending
                                                                 select t.Customer_Credit_ID).First() + 1;

                cc.Customer_Credit_ID = key;
                cc.Date = (DateTime)json["Date"];
                cc.Return_Comment = (string)json["Return_Comment"];

                db.Customer_Credit.Add(cc);

                foreach (JObject part in returnDetails)
                {
                    if ((bool)part["return_to"] == true)
                    { 
                        Customer_Credit_Detail ccd = new Customer_Credit_Detail();

                        ccd.Customer_Credit_ID = key;
                        ccd.Part_ID = (int)part["Part_ID"];
                        ccd.Client_Order_Detail_ID = (int)part["Client_Order_Detail_ID"];
                        ccd.Status = (string)part["status"];

                        Part p = new Part();
                        p = (from d in db.Parts
                             where d.Part_ID == ccd.Part_ID
                             select d).First();

                        p.Part_Status_ID = (int)part["status"];

                        db.Customer_Credit_Detail.Add(ccd);
                    }
                }

                db.SaveChanges();

                if (action == "email")
                {
                    string to = (string)json["email"];
                    string subject = "WME Credit Note #" + key;

                    String orderDate = cc.Date.ToShortDateString();
                    string body = "Walter Meano Engineering Credit Note #" + key + "\nThe credit note was generated on " + orderDate + "\n\nItems on Order:\n";

                    foreach (JObject part in returnDetails)
                    {
                        if ((bool)part["return_to"] == true)
                        {
                            int Part_ID = (int)part["Part_ID"];

                            Part p = new Part();
                            p = (from d in db.Parts
                                 where d.Part_ID == Part_ID
                                 select d).First();

                            body += p.Part_Type.Abbreviation + " - " + p.Part_Type.Name + " - " + p.Part_Serial + "\n";
                        }
                    }

                    Email.SendEmail(to, subject, body);
                }
                return "true|Customer Credit Note #" + key + " successfully generated.|" + key;
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CreditNoteController");
                return "false|An error has occured adding the Customer Credit Note to the system.";
            }
        }
    }
}
