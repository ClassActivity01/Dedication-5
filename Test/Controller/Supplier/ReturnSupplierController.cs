using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Supplier
{
    public class ReturnSupplierController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/ReturnSupplier/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JArray returnDetails = (JArray)json["sr"];
                string action = (string)json["action"];

                int key = db.Supplier_Return.Count() == 0 ? 1 : (from t in db.Supplier_Return
                                                                 orderby t.Supplier_Return_ID descending
                                                                 select t.Supplier_Return_ID).First() + 1;

                Supplier_Return sr = new Supplier_Return();
                sr.Supplier_Order_ID = id;
                sr.Supplier_Return_ID = key;
                sr.Invoice_Number = (string)json["Invoice_Number"];
                sr.Delivery_Note_Number = (string)json["Delivery_Note_Number"];
                sr.Comment = (string)json["Comment"];
                sr.Date_of_Return = (DateTime)json["Date_of_Return"];

                int item_key = db.Supplier_Return_Item.Count() == 0 ? 1 : (from t in db.Supplier_Return_Item
                                                                           orderby t.Return_Item_ID descending
                                                                            select t.Return_Item_ID).First() + 1;

                foreach (JObject ret in returnDetails)
                {
                    Supplier_Return_Item sri = new Supplier_Return_Item();
                    sri.Return_Item_ID = item_key;
                    item_key++;

                    sri.Supplier_Return_ID = key;
                    sri.Type_of_Inventory = (string)ret["Type_of_Inventory"];
                    sri.Inventory_ID = (int)ret["Inventory_ID"];
                    sri.Units_Returned = (int)ret["Units_Returned"];
                    sri.Item_Name = (string)ret["Item_Name"];

                    if (sri.Units_Returned > 0)
                        db.Supplier_Return_Item.Add(sri);
                }

                db.Supplier_Return.Add(sr);
                db.SaveChanges();

                if (action == "email")
                {
                    Supplier_Order so = new Supplier_Order();
                    so = (from p in db.Supplier_Order
                          where p.Supplier_Order_ID == id
                          select p).First();


                    string to = so.Supplier.Email;
                    string subject = "WME Supplier Return Note #" + key;

                    String orderDate = sr.Date_of_Return.ToShortDateString();
                    string body = "Walter Meano Engineering Supplier Return Note #" + key + "\nThe return note was generated on " + orderDate + "\n\nItems in return note:\n";

                    foreach (JObject ret in returnDetails)
                    {
                        Supplier_Return_Item sri = new Supplier_Return_Item();
                        sri.Return_Item_ID = item_key;
                        item_key++;

                        sri.Supplier_Return_ID = key;
                        sri.Type_of_Inventory = (string)ret["Type_of_Inventory"];
                        sri.Inventory_ID = (int)ret["Inventory_ID"];
                        sri.Units_Returned = (int)ret["Units_Returned"];
                        sri.Item_Name = (string)ret["Item_Name"];

                        if (sri.Units_Returned > 0)
                            db.Supplier_Return_Item.Add(sri);
                    }

                    foreach (JObject ret in returnDetails)
                    {
                        if((int)ret["Units_Returned"] > 0)
                            body += (string)ret["Item_Name"] + "\t\tx" + (int)ret["Units_Returned"] + "\n";
                    }

                    Email.SendEmail(to, subject, body);
                }

                return "true|Supplier Return Note #" + key + " successfully generated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ReturnSupplierController PUT");
                return "false|An error has occured updating the Supplier Purchase Order on the system.";
            }
        }
    }
}
