using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller
{
    public class PartTypeController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/PartType
        public string Get()
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
                                        Item_Name = d.Item_Name,
                                        Dimension = d.Dimension
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
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartTypeController GET");
                return "false|Failed to retrieve Part Types.";
            }
        }

        // GET: api/PartType/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    part_types =
                        from p in db.Part_Type
                        orderby p.Name
                        where p.Part_Type_ID == id
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
                            Stock_Available = db.Parts.Where(x => x.Part_Type_ID == id && (x.Part_Status_ID == 3)).Count(),

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
                                        Dimension = d.Dimension
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
                                    },

                             blueprints =
                                    from b in db.Part_Blueprint
                                    orderby b.Name
                                    where b.Part_Type_ID == id
                                    select new
                                    {
                                        Name = b.Name,
                                        Blueprint_ID = b.Blueprint_ID,
                                        File_Type = b.File_Type,
                                        Removed = false
                                    }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartTypeController GET ID");
                return "false|Failed to retrieve Part Type.";
            }
        }

        // POST: api/PartType
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Part_Type part = new Model.Part_Type();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject partDetails = (JObject)json["partType"];
                JArray suppDetails = (JArray)json["supplier"];
                JArray recipeDetails = (JArray)json["recipe"];
                JArray manualDetails = (JArray)json["manual"];
                JArray machineDetails = (JArray)json["machine"];

                int key = db.Part_Type.Count() == 0 ? 1 : (from t in db.Part_Type
                                                           orderby t.Part_Type_ID descending
                                                              select t.Part_Type_ID).First() + 1;

                part.Part_Type_ID = key;

                part.Abbreviation = (string)partDetails["Abbreviation"];
                part.Name = (string)partDetails["Name"];
                part.Description = (string)partDetails["Description"];
                part.Selling_Price = (decimal)partDetails["Selling_Price"];
                part.Dimension = (string)partDetails["Dimension"];
                part.Minimum_Level = (int)partDetails["Minimum_Level"];
                part.Maximum_Level = (int)partDetails["Maximum_Level"];
                part.Max_Discount_Rate = (int)partDetails["Max_Discount_Rate"];
                part.Manufactured = Convert.ToBoolean(Convert.ToInt32(partDetails["Manufactured"]));
                part.Average_Completion_Time = (int)partDetails["Average_Completion_Time"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Part_Type
                     where t.Name == part.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Part Type name entered already exists on the system. ";
                }

                if ((from t in db.Part_Type
                     where t.Abbreviation == part.Abbreviation
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Part Type Abbreviation entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                foreach (JObject supplier in suppDetails)
                {
                    Part_Supplier ps = new Part_Supplier();
                    ps.Part_Type_ID = key;
                    ps.Supplier_ID = (int)supplier["Supplier_ID"];
                    ps.Is_Prefered = Convert.ToBoolean(Convert.ToInt32(supplier["Is_Prefered"]));
                    ps.unit_price = (decimal)supplier["unit_price"];

                    db.Part_Supplier.Add(ps);
                }

                int recipe_key = db.Recipes.Count() == 0 ? 1 : (from t in db.Recipes
                                                                orderby t.Recipe_ID descending
                                                                select t.Recipe_ID).First() + 1;

                int stages = 0;
                int runtime = 0;

                foreach (JObject item in recipeDetails)
                {
                    Recipe rec = new Recipe();
                    recipe_key++;
                    rec.Recipe_ID = recipe_key;
                    rec.Part_Type_ID = key;
                    rec.Stage_in_Manufacturing = (int)item["Stage_in_Manufacturing"];
                    rec.Quantity_Required = (int)item["Quantity_Required"];
                    rec.Item_ID = (int)item["resouce_ID"];
                    rec.Recipe_Type = (string)item["Recipe_Type"];
                    rec.Item_Name = (string)item["Item_Name"];
                    rec.Dimension = (String)item["Dimension"];
                    stages++;

                    if((string)item["Recipe_Type"] == "Part Type")
                        runtime += (from t in db.Part_Type
                                    where t.Part_Type_ID == rec.Item_ID
                                   select t.Average_Completion_Time).First();

                    db.Recipes.Add(rec);
                }

                foreach (JObject manual in manualDetails)
                {
                    Manual_Labour_Type_Part ml = new Manual_Labour_Type_Part();

                    ml.Manual_Labour_Type_ID = (int)manual["Manual_Labour_Type_ID"];
                    ml.Stage_In_Manufacturing = (int)manual["Stage_In_Manufacturing"];
                    ml.Part_Type_ID = key;
                    stages++;
                    runtime += (from t in db.Manual_Labour_Type
                                where t.Manual_Labour_Type_ID == ml.Manual_Labour_Type_ID
                                select t.Duration).First();

                    db.Manual_Labour_Type_Part.Add(ml);
                }

                foreach (JObject machine in machineDetails)
                {
                    Machine_Part mach = new Machine_Part();

                    mach.Machine_ID = (int)machine["Machine_ID"];
                    mach.Stage_In_Manufacturing = (int)machine["Stage_In_Manufacturing"];
                    mach.Part_Type_ID = key;
                    stages++;
                    runtime += (from t in db.Machines
                                where t.Machine_ID == mach.Machine_ID
                                select t.Run_Time).First();

                    db.Machine_Part.Add(mach);
                }

                part.Number_Of_Stages = stages;
                part.Average_Completion_Time = runtime;

                db.Part_Type.Add(part);
                db.SaveChanges();
                return "true|Part Type #" + key + " successfully added.|" + key;
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartTypeController POST");
                return "false|An error has occured adding the Part Type to the system.";
            }
        }

        // PUT: api/PartType/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Model.Part_Type part = new Model.Part_Type();
                part = (from p in db.Part_Type
                            where p.Part_Type_ID == id
                            select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject partDetails = (JObject)json["partType"];
                JArray suppDetails = (JArray)json["supplier"];
                JArray recipeDetails = (JArray)json["recipe"];
                JArray manualDetails = (JArray)json["manual"];
                JArray machineDetails = (JArray)json["machine"];

                part.Abbreviation = (string)partDetails["Abbreviation"];
                part.Name = (string)partDetails["Name"];
                part.Description = (string)partDetails["Description"];
                part.Selling_Price = (decimal)partDetails["Selling_Price"];
                part.Dimension = (string)partDetails["Dimension"];
                part.Minimum_Level = (int)partDetails["Minimum_Level"];
                part.Maximum_Level = (int)partDetails["Maximum_Level"];
                part.Max_Discount_Rate = (int)partDetails["Max_Discount_Rate"];
                part.Manufactured = Convert.ToBoolean(Convert.ToInt32(partDetails["Manufactured"]));
                part.Average_Completion_Time = (int)partDetails["Average_Completion_Time"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Part_Type
                     where t.Name == part.Name && t.Part_Type_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Part Type name entered already exists on the system. ";
                }

                if ((from t in db.Part_Type
                     where t.Abbreviation == part.Abbreviation && t.Part_Type_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Part Type Abbreviation entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Part_Supplier.RemoveRange(db.Part_Supplier.Where(x => x.Part_Type_ID == id));

                foreach (JObject supplier in suppDetails)
                {
                    Part_Supplier ps = new Part_Supplier();
                    ps.Part_Type_ID = id;
                    ps.Supplier_ID = (int)supplier["Supplier_ID"];
                    ps.Is_Prefered = Convert.ToBoolean(Convert.ToInt32(supplier["Is_Prefered"]));
                    ps.unit_price = (decimal)supplier["unit_price"];

                    db.Part_Supplier.Add(ps);
                }

                int recipe_key = db.Recipes.Count() == 0 ? 1 : (from t in db.Recipes
                                                                orderby t.Recipe_ID descending
                                                                select t.Recipe_ID).First() + 1;
                db.Recipes.RemoveRange(db.Recipes.Where(x => x.Part_Type_ID == id));

                int stages = 0;
                int runtime = 0;

                foreach (JObject item in recipeDetails)
                {
                    Recipe rec = new Recipe();
                    recipe_key++;
                    rec.Recipe_ID = recipe_key;
                    rec.Part_Type_ID = id;
                    rec.Stage_in_Manufacturing = (int)item["Stage_in_Manufacturing"];
                    rec.Quantity_Required = (int)item["Quantity_Required"];
                    rec.Item_ID = (int)item["resouce_ID"];
                    rec.Recipe_Type = (string)item["Recipe_Type"];
                    rec.Item_Name = (string)item["Item_Name"];
                    rec.Dimension = (String)item["Dimension"];
                    stages++;

                    if ((string)item["Recipe_Type"] == "Part Type")
                        runtime += (from t in db.Part_Type
                                    where t.Part_Type_ID == rec.Item_ID
                                    select t.Average_Completion_Time).First();

                    db.Recipes.Add(rec);
                }

                db.Manual_Labour_Type_Part.RemoveRange(db.Manual_Labour_Type_Part.Where(x => x.Part_Type_ID == id));
                foreach (JObject manual in manualDetails)
                {
                    Manual_Labour_Type_Part ml = new Manual_Labour_Type_Part();

                    ml.Manual_Labour_Type_ID = (int)manual["Manual_Labour_Type_ID"];
                    ml.Stage_In_Manufacturing = (int)manual["Stage_In_Manufacturing"];
                    ml.Part_Type_ID = id;
                    stages++;
                    runtime += (from t in db.Manual_Labour_Type
                                where t.Manual_Labour_Type_ID == ml.Manual_Labour_Type_ID
                                select t.Duration).First();

                    db.Manual_Labour_Type_Part.Add(ml);
                }

                db.Machine_Part.RemoveRange(db.Machine_Part.Where(x => x.Part_Type_ID == id));
                foreach (JObject machine in machineDetails)
                {
                    Machine_Part mach = new Machine_Part();

                    mach.Machine_ID = (int)machine["Machine_ID"];
                    mach.Stage_In_Manufacturing = (int)machine["Stage_In_Manufacturing"];
                    mach.Part_Type_ID = id;
                    stages++;
                    runtime += (from t in db.Machines
                                where t.Machine_ID == mach.Machine_ID
                                select t.Run_Time).First();

                    db.Machine_Part.Add(mach);
                }
                part.Number_Of_Stages = stages;
                part.Average_Completion_Time = runtime;

                db.SaveChanges();
                return "true|Part Type successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartTypeController PUT");
                return "false|An error has occured updating the Part Type on the system.";
            }
        }

        // DELETE: api/PartType/5
        public string Delete(int id)
        {
            try
            {
                db.Part_Supplier.RemoveRange(db.Part_Supplier.Where(x => x.Part_Type_ID == id));
                db.Recipes.RemoveRange(db.Recipes.Where(x => x.Part_Type_ID == id));
                db.Machine_Part.RemoveRange(db.Machine_Part.Where(x => x.Part_Type_ID == id));
                db.Manual_Labour_Type_Part.RemoveRange(db.Manual_Labour_Type_Part.Where(x => x.Part_Type_ID == id));
                db.Part_Blueprint.RemoveRange(db.Part_Blueprint.Where(x => x.Part_Type_ID == id));

                var itemToRemove = db.Part_Type.SingleOrDefault(x => x.Part_Type_ID == id);
                
                if (itemToRemove != null)
                {
                    db.Part_Type.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Part Type has successfully been removed from the system.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PartTypeController DELETE");
                return "false|The Part Type is in use and cannot be removed from the system.";
            }
        }
    }
}
