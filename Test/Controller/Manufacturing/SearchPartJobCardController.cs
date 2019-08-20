using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Manufacturing
{
    public class SearchPartJobCardController : ApiController
    {

        ProteusEntities db = new ProteusEntities();
        // POST: api/SearchPartType
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

                if (method == "Exact")
                {

                    if (category == "All")
                    {
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where (p.Name == criteria || p.Abbreviation == criteria
                                    || p.Description == criteria || p.Dimension == criteria) && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                    else
                    if (category == "ID")
                    {
                        int id = Int32.Parse(criteria);

                        result = JObject.FromObject(new
                        {

                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Part_Type_ID == id && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Name == criteria && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                    else
                    if (category == "Abb")
                    {
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Abbreviation == criteria && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
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
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Description == criteria && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                    else
                    if (category == "Dimension")
                    {
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Dimension == criteria && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
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
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where (p.Name.Contains(criteria) || p.Abbreviation.Contains(criteria) 
                                    || p.Description.Contains(criteria) || p.Dimension.Contains(criteria)) && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                    else
                    if (category == "Name")
                    {
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Name.Contains(criteria) && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                    else
                    if (category == "Abb")
                    {
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Abbreviation.Contains(criteria) && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
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
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Description.Contains(criteria) && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                    else
                    if (category == "Dimension")
                    {
                        result = JObject.FromObject(new
                        {
                            part_types =
                                from p in db.Part_Type
                                orderby p.Name
                                where p.Dimension.Contains(criteria) && p.Manufactured == true
                                select new
                                {
                                    Part_Type_ID = p.Part_Type_ID,
                                    Abbreviation = p.Abbreviation,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Selling_Price = p.Selling_Price,
                                    Dimension = p.Dimension,
                                    Minimum_Level = p.Minimum_Level,
                                    Maximum_Level = p.Maximum_Level,
                                    Max_Discount_Rate = p.Max_Discount_Rate,
                                    Manufactured = p.Manufactured,
                                    Average_Completion_Time = p.Average_Completion_Time,
                                    Stock_Available = db.Parts.Where(x => x.Part_Type_ID == p.Part_Type_ID && (x.Part_Status_ID == 3)).Count(),

                                    Manual_Labours =
                                        from d in db.Manual_Labour_Type_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Manual_Labour_Type_ID = d.Manual_Labour_Type_ID,
                                            Manual_Labour_Type_Name = d.Manual_Labour_Type.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    Machines =
                                        from d in db.Machine_Part
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Machine_ID = d.Machine_ID,
                                            Machine_Name = d.Machine.Name,
                                            Stage_In_Manufacturing = d.Stage_In_Manufacturing
                                        },

                                    recipe =
                                        from d in db.Recipes
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Recipe_ID = d.Recipe_ID,
                                            Recipe_Type = d.Recipe_Type,
                                            Quantity_Required = d.Quantity_Required,
                                            Stage_in_Manufacturing = d.Stage_in_Manufacturing,
                                            Item_ID = d.Item_ID,
                                            Item_Name = d.Item_Name
                                        },

                                    suppliers =
                                        from d in db.Part_Supplier
                                        where d.Part_Type_ID == p.Part_Type_ID
                                        select new
                                        {
                                            Is_Prefered = d.Is_Prefered,
                                            Supplier_ID = d.Supplier_ID,
                                            Name = d.Supplier.Name,
                                            unit_price = d.unit_price
                                        }
                                }
                        });
                    }
                }

                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "SearchPartTypeController POST");
                return "false|An error has occured searching for Part Types on the system.";
            }
        }
    }
}
