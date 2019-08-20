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
    public class SearchComponentController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/SearchComponent
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
                    int id;
                    try
                    {
                        id = Convert.ToInt32(criteria);
                    }
                    catch
                    {
                        return "false|The value entered is not a number.";
                    }

                    result = JObject.FromObject(new
                    {
                        components =
                                from p in db.Components
                                orderby p.Name
                                where p.Component_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                    });
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
                                components =
                                from p in db.Components
                                orderby p.Name
                                where p.Name == criteria || p.Description == criteria
                                || p.Component_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                components =
                                from p in db.Components
                                orderby p.Name
                                where p.Name == criteria || p.Description == criteria
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
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
                            components =
                                from p in db.Components
                                orderby p.Name
                                where p.Name == criteria
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            components =
                                from p in db.Components
                                orderby p.Name
                                where p.Description == criteria
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
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
                                components =
                                from p in db.Components
                                orderby p.Name
                                where p.Name.Contains(criteria) || p.Description.Contains(criteria)
                                || p.Component_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                components =
                                from p in db.Components
                                orderby p.Name
                                where p.Name.Contains(criteria) || p.Description.Contains(criteria)
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
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
                            components =
                                from p in db.Components
                                orderby p.Name
                                where p.Name.Contains(criteria)
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            components =
                                from p in db.Components
                                orderby p.Name
                                where p.Description.Contains(criteria)
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchComponentController POST");
                return "false|An error has occured searching for Components on the system.";
            }
        }

        // PUT: api/SearchComponent/id
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
                    int id2;
                    try
                    {
                        id2 = Convert.ToInt32(criteria);
                    }
                    catch
                    {
                        return "false|The value entered is not a number.";
                    }

                    result = JObject.FromObject(new
                    {
                        components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where p.Component_ID == id2 && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                    });
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
                                components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where (p.Name == criteria || p.Description == criteria
                                || p.Component_ID == id2) && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where (p.Name == criteria || p.Description == criteria) && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
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
                            components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where p.Name == criteria && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where p.Description == criteria && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
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
                                components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where (p.Name.Contains(criteria) || p.Description.Contains(criteria)
                                || p.Component_ID == id2) && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                            });
                        }
                        catch
                        {
                            result = JObject.FromObject(new
                            {
                                components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where (p.Name.Contains(criteria) || p.Description.Contains(criteria)) && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
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
                            components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where p.Name.Contains(criteria) && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                        });
                    }
                    else
                    if (category == "Description")
                    {
                        result = JObject.FromObject(new
                        {
                            components =
                                from p in db.Components
                                join s in db.Component_Supplier on p.Component_ID equals s.Component_ID
                                orderby p.Name
                                where p.Description.Contains(criteria) && s.Supplier_ID == id
                                select new
                                {
                                    Component_ID = p.Component_ID,
                                    Quantity = p.Quantity,
                                    Unit_Price = p.Unit_Price,
                                    Description = p.Description,
                                    Dimension = p.Dimension,
                                    Name = p.Name,
                                    Suppliers =
                                    from d in db.Component_Supplier
                                    where d.Component_ID == p.Component_ID
                                    select new
                                    {
                                        Supplier_ID = d.Supplier_ID,
                                        Name = d.Supplier.Name,
                                        is_preferred = d.is_preferred,
                                        unit_price = d.unit_price
                                    }
                                }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "SearchComponentController PUT");
                return "false|An error has occured searching for Components on the system.";
            }
        }
    }
}
