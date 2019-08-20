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
    public class CustomerQuoteController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/CustomerQuote
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    client_quotes =
                        from p in db.Client_Quote
                        orderby p.Date
                        select new
                        {
                            Client_Quote_ID = p.Client_Quote_ID,
                            Date = p.Date,
                            Client_ID = p.Client_ID,
                            Contact_ID = p.Contact_ID,
                            Client_Name = p.Client.Name,
                            Client_Quote_Expiry_Date = p.Client_Quote_Expiry_Date,

                            details = 
                                from d in db.Client_Quote_Detail
                                where d.Client_Quote_ID == p.Client_Quote_ID
                                select new
                                {
                                    Quantity = d.Quantity,
                                    Part_Price = d.Part_Price,
                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
                                    Part_Type_ID = d.Part_Type_ID,
                                    Part_Type_Name = d.Part_Type.Name,
                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                },

                            contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerQuoteController GET");
                return "false|Failed to retrieve Customer Quote Details.";
            }
        }

        // GET: api/CustomerQuote/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    client_quotes =
                        from p in db.Client_Quote
                        orderby p.Date
                        where p.Client_Quote_ID == id
                        select new
                        {
                            Client_Quote_ID = p.Client_Quote_ID,
                            Date = p.Date,
                            Client_ID = p.Client_ID,
                            Contact_ID = p.Contact_ID,
                            Client_Name = p.Client.Name,
                            Client_Quote_Expiry_Date = p.Client_Quote_Expiry_Date,

                            details =
                                from d in db.Client_Quote_Detail
                                where d.Client_Quote_ID == p.Client_Quote_ID
                                select new
                                {
                                    Quantity = d.Quantity,
                                    Part_Price = d.Part_Price,
                                    Client_Discount_Rate = d.Client_Discount_Rate,
                                    Settlement_Discount_Rate = d.Client_Discount_Rate,
                                    Part_Type_ID = d.Part_Type_ID,
                                    Part_Type_Name = d.Part_Type.Name,
                                    Part_Type_Abbreviation = d.Part_Type.Abbreviation
                                },

                            contact_details =
                                            from d in db.Client_Contact_Person_Detail
                                            where d.Client_ID == p.Client_ID
                                            orderby d.Name
                                            select new
                                            {
                                                Contact_ID = d.Contact_ID,
                                                Name = d.Name,
                                                Number = d.Number,
                                                Job_Description = d.Job_Description,
                                                Email_Address = d.Email_Address
                                            }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerQuoteController GET ID");
                return "false|Failed to retrieve Customer Quote Details.";
            }
        }

        // POST: api/CustomerQuote
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Client_Quote client = new Model.Client_Quote();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject clientDetails = (JObject)json["client"];
                JArray parts = (JArray)clientDetails["details"];
                string action = (string)json["action"];

                int key = db.Client_Quote.Count() == 0 ? 1 : (from t in db.Client_Quote
                                                              orderby t.Client_Quote_ID descending
                                                         select t.Client_Quote_ID).First() + 1;
                client.Client_Quote_ID = key;
                client.Client_ID = (int)clientDetails["Client_ID"];
                client.Contact_ID = (int)clientDetails["Contact_ID"];
                client.Date = (DateTime)clientDetails["Date"];
                client.Client_Quote_Expiry_Date = (DateTime)clientDetails["Client_Quote_Expiry_Date"];


                db.Client_Quote.Add(client);

                foreach (JObject part in parts)
                {
                    Client_Quote_Detail cqd = new Client_Quote_Detail();
                    cqd.Quantity = (int)part["Quantity"];
                    cqd.Part_Price = (decimal)part["Part_Price"];
                    cqd.Client_Discount_Rate = (double)part["Client_Discount_Rate"];
                    cqd.Settlement_Discount_Rate = (double)clientDetails["Settlement_Discount_Rate"];
                    cqd.Client_Quote_ID = key;
                    cqd.Part_Type_ID = (int)part["Part_Type_ID"];

                    db.Client_Quote_Detail.Add(cqd);
                }

                bool flag = true;

                if(action == "email")
                {
                    Client_Contact_Person_Detail cl = new Client_Contact_Person_Detail();
                    cl = (from p in db.Client_Contact_Person_Detail
                          where p.Contact_ID == client.Contact_ID
                          select p).First();

                    string to = cl.Email_Address;
                    string subject = "WME Quote #"+ key;

                    DateTime expiry = (DateTime)clientDetails["Client_Quote_Expiry_Date"];
                    string body = "Walter Meano Engineering Quote #"+key +"\nThe quote is valid until "+ expiry.ToShortDateString() + "\n\nItems on Quote:\n";

                    foreach (JObject part in parts)
                    {
                        Part_Type pt = new Part_Type();
                        int part_id = (int)part["Part_Type_ID"];
                        pt = (from p in db.Part_Type
                              where p.Part_Type_ID == part_id
                              select p).First();

                        body += pt.Abbreviation +" - "+pt.Name +"\t\tx"+(int)part["Quantity"]+"\tR "+ (decimal)part["Part_Price"] +" per unit\n";
                    }

                    flag = Email.SendEmail(to, subject, body);
                }

                db.SaveChanges();

                string s = "";
                if (flag == false)
                    s += "If the quote has not been emailed successfully you will receive an email notifying you of this in a few minutes.";

                return "true|Customer Quote #" + key + " successfully added. "+s+"|" + key;
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerQuoteController POST");
                return "false|An error has occured adding the Customer Quote to the system.";
            }
        }
    }
}
