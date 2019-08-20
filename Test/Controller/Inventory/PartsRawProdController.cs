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
    public class PartsRawProdController : ApiController
    {
        // GET: api/PartsRawStock
        public string Get()
        {
            ProteusEntities db = new ProteusEntities();

            try
            {
                JObject result = JObject.FromObject(new
                {
                    parts =
                        from p in db.Parts
                        where p.Part_Status_ID == 1 || p.Part_Status_ID == 2
                        select new
                        {
                            Part_ID = p.Part_ID,
                            Part_Serial = p.Part_Serial,
                            Part_Status_ID = p.Part_Status_ID,
                            Date_Added = p.Date_Added,
                            Cost_Price = p.Cost_Price,
                            Part_Stage = p.Part_Stage,
                            Part_Type_ID = p.Part_Type_ID,

                            Part_Type_Name = p.Part_Type.Name,
                            Part_Type_Abbreviation = p.Part_Type.Abbreviation,
                            Part_Type_Dimension = p.Part_Type.Dimension,
                            Part_Type_Selling_Price = p.Part_Type.Selling_Price,
                            Part_Type_Description = p.Part_Type.Description,
                            Stages_Count = p.Part_Type.Number_Of_Stages,

                            Job_Card_ID = (from d in (from e in db.Job_Card_Detail
                                                      where e.Parts.Contains(p) select e)
                                           select d.Job_Card_ID),

                            Order_Type = (from d in db.Job_Card_Detail
                                          where d.Parts.Where(x => x.Part_ID == p.Part_ID).FirstOrDefault().Part_ID == p.Part_ID
                                          select d.Job_Card.Job_Card_Priority.Name).FirstOrDefault(),
                            
                            Stages = (from d in db.Part_Type
                                           where d.Part_Type_ID == p.Part_Type_ID
                                           select new {
                                               recipe = (from c in db.Recipes
                                                         where c.Part_Type_ID == d.Part_Type_ID
                                                         orderby c.Stage_in_Manufacturing
                                                         select new
                                                         {
                                                            stage = c.Stage_in_Manufacturing,
                                                            name = c.Item_Name
                                                         }),
                                               machines = (from c in db.Machine_Part
                                                         where c.Part_Type_ID == d.Part_Type_ID
                                                         orderby c.Stage_In_Manufacturing
                                                         select new
                                                         {
                                                             stage = c.Stage_In_Manufacturing,
                                                             name = c.Machine.Name
                                                         }),
                                               manual = (from c in db.Manual_Labour_Type_Part
                                                         where c.Part_Type_ID == d.Part_Type_ID
                                                         orderby c.Stage_In_Manufacturing
                                                         select new
                                                         {
                                                             stage = c.Stage_In_Manufacturing,
                                                             name = c.Manual_Labour_Type.Name
                                                         })
                                           })
                        }
                });
                return "true|" + result.ToString();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "PartsRawProdController");
                return "false|Failed to retrieve Parts.";
            };
        }
    }
}
