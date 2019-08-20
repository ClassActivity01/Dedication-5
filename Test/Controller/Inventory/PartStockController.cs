using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Inventory
{
    public class PartStockController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/PartStock/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    part_types =
                        from p in db.Part_Type
                        orderby p.Name
                        select new
                        {
                            Stock_Available = p.Parts.Where(x => x.Part_Status_ID == 3).Count(),
                            Minimum_Level = p.Minimum_Level
                        }
                });
                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "PartStockController");
                return "false|Failed to retrieve Stock Levels.";
            }
        }
    }
}
