using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Ordering
{
    public class OrderExtraController : ApiController
    {
        ProteusEntities db = new ProteusEntities();
        // GET: api/OrderExtra/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    order =
                        from a in db.Client_Order
                        where a.Client_Order_ID == id
                        select new
                        {
                            delivery = from d in db.Delivery_Note
                                       where d.Client_Order_ID == id
                                       select new
                                       {
                                           Delivery_Note_ID = d.Delivery_Note_ID,
                                           Date = d.Delivery_Note_Date,
                                           
                                           delivery_note_details =
                                            from dn in db.Delivery_Note_Details
                                            where dn.Delivery_Note_ID == d.Delivery_Note_ID
                                            select new
                                            {
                                                Delivery_Note_ID = d.Delivery_Note_ID,
                                                Quantity_Delivered = dn.Quantity_Delivered,
                                                Client_Order_Detail_ID = dn.Client_Order_Detail_ID,
                                                Part_Type_Name = dn.Client_Order_Detail.Part_Type.Name,
                                                Part_Type_Abbreviation = dn.Client_Order_Detail.Part_Type.Abbreviation,
                                                Part_Type_ID = dn.Client_Order_Detail.Part_Type.Part_Type_ID,
                                                Client_Discount_Rate = dn.Client_Order_Detail.Client_Discount_Rate,
                                                Part_Price = dn.Client_Order_Detail.Part_Price
                                            },
                                            invoice = from i in db.Invoices
                                                     where i.Delivery_Note_ID == d.Delivery_Note_ID
                                                    select new
                                                    {
                                                        Invoice_ID = i.Invoice_ID,
                                                        Amount = i.amount_noVat,
                                                        Amount_Vat = i.amount_Vat,
                                                        Date = i.Invoice_Date
                                                    }
                                       }

                              

                        }


                });
                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "DeliveryNoteDetailsController");
                return "false|Failed to retrieve Delivery Note Details.";
            }
        }
    }
}
