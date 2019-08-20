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
    public class DeliveryMethodController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/DeliveryMethod
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    delivery_methods =
                        from p in db.Delivery_Method
                        orderby p.Name descending
                        select new
                        {
                            Delivery_Method_ID = p.Delivery_Method_ID,
                            Name = p.Name,
                            Description = p.Description
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "DeliveryMethodController");
                return "false|Failed to retrieve Delivery Methods.";
            }
        }
    }
}
