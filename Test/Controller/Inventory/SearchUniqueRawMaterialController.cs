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
    public class SearchUniqueRawMaterialController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchUniqueRawMaterial
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                string method = (string)json["method"]; //Exact, Contains, Similar
                string criteria = (string)json["criteria"]; //Typed in search value
                string category = (string)json["category"]; //Name, Description, Access Level
                JObject result = null;

                if (category == "ID")
                {
                    try
                    {
                        int id = Convert.ToInt32(criteria);

                        result = JObject.FromObject(new
                        {
                            unique_raw_materials =
                                from p in db.Unique_Raw_Material
                                join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                orderby rm.Name
                                where p.Unique_Raw_Material_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Raw_Material_Name = rm.Name,
                                    Raw_Material_Description = rm.Description,
                                    Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                    Dimension = p.Dimension,
                                    Quality = p.Quality,
                                    Date_Added = p.Date_Added,
                                    Date_Used = p.Date_Used,
                                    Cost_Price = p.Cost_Price,
                                    Supplier_Order_ID = p.Supplier_Order_ID
                                }
                        });
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a number.";
                    }
                }
                else
                if (method == "Exact")
                {
                    if (category == "All")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where p.Unique_Raw_Material_ID == id || rm.Name == criteria
                                        || rm.Description == criteria || p.Dimension == criteria
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where rm.Name == criteria || rm.Description == criteria || p.Dimension == criteria
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where rm.Name == criteria
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where rm.Description == criteria
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                        });
                    }
                    else
                    if (category == "Dimension")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where p.Dimension == criteria
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                        });
                    }
                }
                else
                if (method == "Contains")
                {
                    if (category == "All")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where p.Unique_Raw_Material_ID == id || rm.Name.Contains(criteria)
                                        || rm.Description.Contains(criteria) || p.Dimension.Contains(criteria)
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where rm.Name.Contains(criteria) || rm.Description.Contains(criteria) || p.Dimension.Contains(criteria)
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where rm.Name.Contains(criteria)
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where rm.Description.Contains(criteria)
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                        });
                    }
                    else
                    if (category == "Dimension")
                    {
                        result = JObject.FromObject(new
                        {
                            unique_raw_materials =
                                    from p in db.Unique_Raw_Material
                                    join rm in db.Raw_Material on p.Raw_Material_ID equals rm.Raw_Material_ID
                                    orderby rm.Name
                                    where p.Dimension.Contains(criteria)
                                    select new
                                    {
                                        Raw_Material_ID = p.Raw_Material_ID,
                                        Raw_Material_Name = rm.Name,
                                        Raw_Material_Description = rm.Description,
                                        Unique_Raw_Material_ID = p.Unique_Raw_Material_ID,
                                        Dimension = p.Dimension,
                                        Quality = p.Quality,
                                        Date_Added = p.Date_Added,
                                        Date_Used = p.Date_Used,
                                        Cost_Price = p.Cost_Price,
                                        Supplier_Order_ID = p.Supplier_Order_ID
                                    }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchUniqueRawMaterialController");
                return "false|An error has occured searching for Unique Raw Materials on the system.";
            }
        }
    }
}
