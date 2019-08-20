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
    public class CustomerOrderTypeController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/CustomerOrderType
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    client_order_types =
                        from p in db.Client_Order_Type
                        orderby p.Type
                        select new
                        {
                            Client_Order_Type_ID = p.Client_Order_Type_ID,
                            Type = p.Type,
                            Description = p.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerOrderTypeController");
                return "false|Failed to retrieve Customer Order Types.";
            }
        }
    }
}
