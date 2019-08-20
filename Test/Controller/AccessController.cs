using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Test.Model;

namespace Test.Controller
{
    public class AccessController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/Access
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    access =
                        from p in db.Accesses
                        orderby p.Access_ID
                        select new
                        {
                            ID = p.Access_ID,
                            UC_Name = p.Name,
                            access = false,
                            href = p.href
                        }
                });
                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "AccessController GET");
                return "false|Failed to retrieve Access categories.";
            }


        }


    }
}