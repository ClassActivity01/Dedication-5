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
    public class VATController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/VAT
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    vats =
                        from p in db.VATs
                        orderby p.Date descending
                        select new
                        {
                            Date = p.Date,
                            VAT_Rate = p.VAT_Rate
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "VATController GET");
                return "false|Failed to retrieve VAT.";
            }
        }

        // POST: api/VAT
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.VAT vat = new Model.VAT();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                vat.Date = (DateTime)json["Date"];
                vat.VAT_Rate = (double)json["VAT_Rate"];
                
                db.VATs.Add(vat);

                db.SaveChanges();
                return "true|VAT successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "VATController POST");
                return "false|An error has occured adding the VAT to the system.";
            }
        }
    }
}
