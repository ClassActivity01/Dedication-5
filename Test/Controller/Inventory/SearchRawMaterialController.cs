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
    public class SearchRawMaterialController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchRawMaterial
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

                if(category == "ID")
                {
                    try
                    {
                        int id = Convert.ToInt32(criteria);

                        result = JObject.FromObject(new
                        {
                            raw_materials =
                            from p in db.Raw_Material
                            orderby p.Name
                            where p.Raw_Material_ID == id
                            select new
                            {
                                Raw_Material_ID = p.Raw_Material_ID,
                                Name = p.Name,
                                Description = p.Description,
                                Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                            }
                        });
                    }
                    catch
                    {
                        return "false|The entered search criteria value is not a number.";
                    }
                }else
                if (method == "Exact")
                {
                    if (category == "All")
                    {
                        try
                        {
                            int id = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Raw_Material_ID == id || p.Name == criteria
                                    || p.Description == criteria
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Name == criteria || p.Description == criteria
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Name == criteria
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Description == criteria
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
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
                                raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Raw_Material_ID == id || p.Name.Contains(criteria)
                                    || p.Description.Contains(criteria)
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Name.Contains(criteria) || p.Description.Contains(criteria)
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Name.Contains(criteria)
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                orderby p.Name
                                where p.Description.Contains(criteria)
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchRawMaterialController POST");
                return "false|An error has occured searching for Raw Materials on the system.";
            }
        }


        // PUT: api/SearchRawMaterial/5
        public string Put(int id, HttpRequestMessage value)
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
                        int id2 = Convert.ToInt32(criteria);

                        result = JObject.FromObject(new
                        {
                            raw_materials =
                            from p in db.Raw_Material
                            join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                            orderby p.Name
                            where p.Raw_Material_ID == id2 && s.Supplier_ID == id
                            select new
                            {
                                Raw_Material_ID = p.Raw_Material_ID,
                                Name = p.Name,
                                Description = p.Description,
                                Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
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
                            int id2 = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where (p.Raw_Material_ID == id2 || p.Name == criteria
                                    || p.Description == criteria) && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where (p.Name == criteria || p.Description == criteria) && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where p.Name == criteria && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where p.Description == criteria && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
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
                            int id2 = Convert.ToInt32(criteria);

                            result = JObject.FromObject(new
                            {
                                raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where (p.Raw_Material_ID == id2 || p.Name.Contains(criteria)
                                    || p.Description.Contains(criteria)) && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where (p.Name.Contains(criteria) || p.Description.Contains(criteria)) && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                            });
                        }
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where p.Name.Contains(criteria) && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            raw_materials =
                                from p in db.Raw_Material
                                join s in db.Raw_Material_Supplier on p.Raw_Material_ID equals s.Raw_Material_ID
                                orderby p.Name
                                where p.Description.Contains(criteria) && s.Supplier_ID == id
                                select new
                                {
                                    Raw_Material_ID = p.Raw_Material_ID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Minimum_Stock_Instances = p.Minimum_Stock_Instances,
                                    Raw_Material_Suppliers =
                                    from d in db.Raw_Material_Supplier
                                    where d.Raw_Material_ID == p.Raw_Material_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Is_Prefered = d.Is_Prefered,
                                        unit_price = d.unit_price,
                                        Name = d.Supplier.Name
                                    }
                                }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchRawMaterialController PUT");
                return "false|An error has occured searching for Raw Materials on the system.";
            }
        }
    }
}
