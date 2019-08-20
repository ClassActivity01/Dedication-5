using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Supplier
{
    public class SupplierOrderStatusController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/SupplierOrderStatus
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    supplier_order_statuses =
                            from p in db.Supplier_Order_Status
                            select new
                            {
                                Supplier_Order_Status_ID = p.Supplier_Order_Status_ID,
                                Name = p.Name,
                                Description = p.Description
                            }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierOrderStatusController GET");
                return "false|Failed to retrieve Supplier Order Statuses.";
            }
        }

        // GET: api/SupplierOrderStatus/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    supplier_order_statuses =
                            from p in db.Supplier_Order_Status
                            where p.Supplier_Order_Status_ID == id
                            select new
                            {
                                Supplier_Order_Status_ID = p.Supplier_Order_Status_ID,
                                Name = p.Name,
                                Description = p.Description
                            }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SupplierOrderStatusController GET ID");
                return "false|Failed to retrieve Supplier Order Status.";
            }
        }
    }
}
