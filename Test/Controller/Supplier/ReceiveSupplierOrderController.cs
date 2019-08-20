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
    public class ReceiveSupplierOrderController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // PUT: api/ReceiveSupplierOrder/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                JArray cs = (JArray)json["cs"];
                JArray ps = (JArray)json["ps"];
                JArray rms = (JArray)json["rms"];

                var so = (from p in db.Supplier_Order
                      where p.Supplier_Order_ID == id
                      select p).First();

                bool rawAll = true;
                bool partAll = true;
                bool compAll = true;

                foreach (JObject comp in cs)
                {
                    int component_id = (int)comp["Component_ID"];
                    Supplier_Order_Component soc = new Supplier_Order_Component();
                    soc = (from p in db.Supplier_Order_Component
                           where p.Supplier_Order_ID == id && p.Component_ID == component_id
                           select p).First();
                    int quantity = soc.Quantity_Received;
                    int newquantity = (int)comp["Quantity_Received"] - quantity;

                    soc.Quantity_Received = (int)comp["Quantity_Received"];
                    soc.Supplier_Order = so;

                    Component c = new Component();
                    c = (from p in db.Components
                         where p.Component_ID == component_id
                         select p).First();
                    c.Quantity += newquantity;

                    if (soc.Quantity_Requested != soc.Quantity_Received)
                        compAll = false;
                }

                foreach (JObject part in ps)
                {
                    int component_id = (int)part["Part_Type_ID"];
                    Supplier_Order_Detail_Part soc = new Supplier_Order_Detail_Part();
                    soc = (from p in db.Supplier_Order_Detail_Part
                           where p.Supplier_Order_ID == id && p.Part_Type_ID == component_id
                           select p).First();

                    int quantity = soc.Quantity_Received;
                    int newquantity = (int)part["Quantity_Received"] - quantity;
                    soc.Quantity_Received = (int)part["Quantity_Received"];

                    int key = db.Parts.Count() == 0 ? 1 : (from t in db.Parts
                                                                    orderby t.Part_ID descending
                                                                    select t.Part_ID).First() + 1;

                    if (soc.Quantity != soc.Quantity_Received)
                        partAll = false;

                    for (int x = 0; x < newquantity; x++)
                    {
                        string abbreviation = soc.Part_Type.Abbreviation;

                        //(Armand) Generate the new number;
                        Random rand = new Random();
                        int num = 0;
                        string serial = "";

                        while (true)
                        {
                            num = rand.Next(1, 999999999);
                            serial = abbreviation + "-" + Convert.ToString(num);

                            if ((from d in db.Parts
                                 where d.Part_Serial == serial
                                 select d).Count() == 0)
                                break;
                        }

                        Part p = new Part();
                        p.Parent_ID = 0;
                        p.Part_Serial = serial;
                        p.Part_Status_ID = 1;
                        p.Part_Type_ID = component_id;
                        p.Part_ID = key;
                        key++;
                        p.Part_Stage = 0;
                        p.Date_Added = DateTime.Now;
                        p.Cost_Price = (decimal)part["Price"];
                        p.Supplier_Order.Add(so);
                        db.Parts.Add(p);
                    }
                }

                foreach (JObject raw in rms)
                {
                    int component_id = (int)raw["Raw_Material_ID"];
                    Supplier_Order_Detail_Raw_Material soc = new Supplier_Order_Detail_Raw_Material();
                    soc = (from p in db.Supplier_Order_Detail_Raw_Material
                           where p.Supplier_Order_ID == id && p.Raw_Material_ID == component_id
                           select p).First();

                    int quantity = soc.Quantity_Received;
                    int newquantity = (int)raw["Quantity_Received"] - quantity;
                    soc.Quantity_Received = (int)raw["Quantity_Received"];

                    int key = db.Unique_Raw_Material.Count() == 0 ? 1 : (from t in db.Unique_Raw_Material
                                                                         orderby t.Unique_Raw_Material_ID descending
                                                                        select t.Unique_Raw_Material_ID).First() + 1;

                    if (soc.Quantity != soc.Quantity_Received)
                        rawAll = false;

                    for (int x = 0; x < newquantity; x++)
                    {
                        Unique_Raw_Material p = new Unique_Raw_Material();
                        p.Unique_Raw_Material_ID = key;
                        key++;
                        p.Cost_Price = (decimal)raw["Price"];
                        p.Date_Added = DateTime.Now;
                        p.Raw_Material_ID = component_id;
                        p.Dimension = (string)raw["Dimensions"];
                        p.Quality = "";
                        p.Supplier_Order_ID = id;

                        db.Unique_Raw_Material.Add(p);
                    }
                }

                if(rawAll && partAll && compAll)
                {
                    so.Supplier_Order_Status_ID = 5;
                }
                else
                {
                    so.Supplier_Order_Status_ID = 2;

                    string to = so.Supplier.Email;
                    string subject = "WME Supplier Order #" + so.Supplier_Order_ID +" Back Order";

                    String orderDate = DateTime.Now.ToShortDateString();
                    string body = "Walter Meano Engineering Supplier Order #" + so.Supplier_Order_ID + "\nThe order was partially received on " + orderDate + "\n\nThe following items still need to be delivered:\n";

                    foreach (JObject comp in cs)
                    {
                        int component_id = (int)comp["Component_ID"];
                        Supplier_Order_Component soc = new Supplier_Order_Component();
                        soc = (from p in db.Supplier_Order_Component
                               where p.Supplier_Order_ID == id && p.Component_ID == component_id
                               select p).First();
                        int quantity = soc.Quantity_Received;
                        int quantityLeft = soc.Quantity_Requested - quantity;

                        if(quantityLeft != 0)
                        {
                            Component c = new Component();
                            c = (from p in db.Components
                                 where p.Component_ID == component_id
                                 select p).First();

                            body += c.Name + "\t\tx" + quantityLeft + "\n";
                        }
                    }

                    foreach (JObject part in ps)
                    {
                        int component_id = (int)part["Part_Type_ID"];
                        Supplier_Order_Detail_Part soc = new Supplier_Order_Detail_Part();
                        soc = (from p in db.Supplier_Order_Detail_Part
                               where p.Supplier_Order_ID == id && p.Part_Type_ID == component_id
                               select p).First();

                        int quantity = soc.Quantity_Received;
                        int quantityLeft = soc.Quantity - quantity;

                        if (quantityLeft != 0)
                        {
                            Part_Type c = new Part_Type();
                            c = (from p in db.Part_Type
                                 where p.Part_Type_ID == component_id
                                 select p).First();

                            body += c.Name + "\t\tx" + quantityLeft + "\n";
                        }
                    }

                    foreach (JObject raw in rms)
                    {
                        int component_id = (int)raw["Raw_Material_ID"];
                        Supplier_Order_Detail_Raw_Material soc = new Supplier_Order_Detail_Raw_Material();
                        soc = (from p in db.Supplier_Order_Detail_Raw_Material
                               where p.Supplier_Order_ID == id && p.Raw_Material_ID == component_id
                               select p).First();

                        int quantity = soc.Quantity_Received;
                        int quantityLeft = soc.Quantity - quantity;

                        if (quantityLeft != 0)
                        {
                            Raw_Material c = new Raw_Material();
                            c = (from p in db.Raw_Material
                                 where p.Raw_Material_ID == component_id
                                 select p).First();

                            body += c.Name + "\t\tx" + quantityLeft + "\n";
                        }
                    }

                    Email.SendEmail(to, subject, body);
                } 

                db.SaveChanges();
                return "true|Supplier Purchase Order successfully received.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "ReceiveSupplierOrderController");
                return "false|An error has occured receiving the Supplier Purchase Order on the system.";
            }
        }
    }
}
