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
    public class LowStockController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/LowStock
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    ps =
                        from p in db.Part_Type
                        where p.Parts.Where(x => x.Part_Status_ID == 3).Count() < p.Minimum_Level
                        select new
                        {
                            Part_Type_ID = p.Part_Type_ID,
                            Abbreviation = p.Abbreviation,
                            Name = p.Name,
                            Description = p.Description,
                            Min_Stock = p.Minimum_Level,
                            Quantity = p.Parts.Where(x => x.Part_Status_ID == 3).Count()
                        },

                    comp = from c in db.Components
                           where c.Quantity < c.Min_Stock
                           select new
                           {
                               Component_ID = c.Component_ID,
                               Min_Stock = c.Min_Stock,
                               Quantity = c.Quantity,
                               Name = c.Name
                           }
                });
                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "LowStockController GET");
                return "false|Failed to retrieve Low Stock Inventory Items.";
            }
        }
    }
}
