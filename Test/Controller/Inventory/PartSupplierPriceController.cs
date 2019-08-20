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
    public class PartSupplierPriceController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/PartSupplierPrice
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                int Supplier_ID = (int)json["Supplier_ID"]; 
                string Inventory_Type = (string)json["Inventory_Type"];
                int Item_ID = (int)json["Item_ID"];
                string what = (string)json["What"];


                if (what == "Price")
                {
                    decimal price = 0;

                    if (Inventory_Type == "Part Type")
                    {
                        price = (from t in db.Part_Supplier
                                 where t.Part_Type_ID == Item_ID && t.Supplier_ID == Supplier_ID
                                 select t.unit_price).First();
                    }
                    else
                    if (Inventory_Type == "Raw Material")
                    {
                        price = (from t in db.Raw_Material_Supplier
                                 where t.Raw_Material_ID == Item_ID && t.Supplier_ID == Supplier_ID
                                 select t.unit_price).First();
                    }
                    else
                    if (Inventory_Type == "Component")
                    {
                        price = (from t in db.Component_Supplier
                                 where t.Component_ID == Item_ID && t.Supplier_ID == Supplier_ID
                                 select t.unit_price).First();
                    }

                    return "true|" + price.ToString();
                }
                else if (what == "SellingPrice")
                {
                    decimal price = 0;

                    if (Inventory_Type == "Part Type")
                    {
                        price = (from t in db.Part_Type where t.Part_Type_ID == Item_ID select t.Selling_Price).First();
                    }
                    else
                    if (Inventory_Type == "Raw Material")
                    {
                        
                    }
                    else
                    if (Inventory_Type == "Component")
                    {
                        price = (from t in db.Components where t.Component_ID == Item_ID select t.Unit_Price).First();
                    }

                    return "true|" + price.ToString();
                }
                else if (what == "Stock_Available")
                {
                    int stock = 0;

                    if (Inventory_Type == "Part Type")
                    {
                        stock = (from p in db.Part_Type
                                 where p.Part_Type_ID == Item_ID
                                 select p.Parts.Where(x => x.Part_Status_ID == 3).Count()).First();
                    }
                    else
                    if (Inventory_Type == "Component")
                    {
                        stock = (from t in db.Components
                                 where t.Component_ID == Item_ID
                                 select t.Quantity).First();
                    }
                    else
                    if (Inventory_Type == "Raw Material")
                    {
                        stock = (from t in db.Raw_Material
                                 where t.Raw_Material_ID == Item_ID
                                 select t.Unique_Raw_Material.Where(x => x.Raw_Material_ID == Item_ID).Count()).First();
                    }

                    return "true|" + stock.ToString();
                }
                else if (what == "Min_Stock")
                {
                    int stock = 0;

                    if (Inventory_Type == "Part Type")
                    {
                        stock = (from p in db.Part_Type
                                 where p.Part_Type_ID == Item_ID
                                 select p.Minimum_Level).First();
                    }
                    else
                    if (Inventory_Type == "Component")
                    {
                        stock = (from t in db.Components
                                 where t.Component_ID == Item_ID
                                 select t.Min_Stock).First();
                    }
                    else
                    if (Inventory_Type == "Raw Material")
                    {

                    }

                    return "true|" + stock.ToString();
                }
                else return "false|Unknown Command";
                

                
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartSupplierPriceController");
                return "false|Failed to retrieve Inventory Item Supplier price.";
            }
        }
    }
}
