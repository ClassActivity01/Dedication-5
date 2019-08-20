using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Lookup
{
    public class ProvincesController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/Provinces
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    provinces =
                        from p in db.Provinces
                        orderby p.Province1
                        select new
                        {
                            Province_ID = p.Province_ID,
                            Province = p.Province1
                        }
                });
                return "true|" + result.ToString();
            }
            catch
            {
                return "false|Failed to retrieve Provinces.";
            }
        }
    }
}
