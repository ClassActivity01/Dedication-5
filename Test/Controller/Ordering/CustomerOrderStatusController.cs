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
    public class CustomerOrderStatusController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/CustomerOrderStatus
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    order_statuses =
                        from p in db.Client_Order_Status
                        orderby p.Name descending
                        select new
                        {
                            Client_Order_Status_ID = p.Client_Order_Status_ID,
                            Name = p.Name,
                            Description = p.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerOrderStatusController POST");
                return "false|Failed to retrieve Order Statuses.";
            }
        }
    }
}
