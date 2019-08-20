using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Inventory
{
    public class StockAvailableController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/StockAvailable
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);
                string inventoryType = (string)json["Inventory_Type"];
                int itemID = (int)json["Item_ID"];

                JObject result;

                if (inventoryType == "Component")
                {
                    result = JObject.FromObject(new
                    {
                        stock =
                            from p in db.Components
                            orderby p.Name
                            where p.Component_ID == itemID
                            select new
                            {
                                Stock = p.Quantity
                            }
                    });
                } else
                if (inventoryType == "Part Type")
                {
                    result = JObject.FromObject(new
                    {
                        stock =
                            from p in db.Part_Type
                            orderby p.Name
                            where p.Part_Type_ID == itemID
                            select new
                            {
                                Stock = p.Parts.Where(x => x.Part_Status_ID == 3).Count()
                            }
                    });
                } else
                {
                    result = JObject.FromObject(new
                    {
                        stock =
                            from p in db.Raw_Material
                            orderby p.Name
                            where p.Raw_Material_ID == itemID
                            select new
                            {
                                Stock = p.Unique_Raw_Material.Where(x => x.Date_Used == null).Count()
                            }
                    });
                }
                
                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "StockAvailableController");
                return "false|Failed to retrieve Stock.";
            }
        }
    }
}
