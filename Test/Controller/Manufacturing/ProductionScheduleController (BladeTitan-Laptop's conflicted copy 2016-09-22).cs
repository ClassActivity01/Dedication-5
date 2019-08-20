using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Manufacturing
{
    public class ProductionScheduleController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/ProductionSchedule
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/ProductionSchedule/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/ProductionSchedule
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/ProductionSchedule/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/ProductionSchedule/5
        public void Delete(int id)
        {
        }

        class ProductionPart
        {
            public Part part;
            public Part_Type part_type;
            public int job_card_ID;
            public string[] partResources;
            public string[] partTypeResources;
        }

        private string generateProductionSchedule()
        {
            //*************************************** GET EVERYTHING SET UP

            //Armand: Check if production schedule exists for today
            bool flag = false;

            if (flag == true)
                return "false|Production Schedule has already been generated.";

            TimeSpan day_start = new TimeSpan(8, 0, 0);
            TimeSpan day_end = new TimeSpan(17, 0, 0);

            TimeSpan day_duration = day_end.Subtract(day_start);

            List<Machine> machines = (from p in db.Machines
                                      orderby p.Machine_ID
                                      select p).ToList();

            List<Manual_Labour_Type> manual = (from p in db.Manual_Labour_Type
                                               orderby p.Name
                                               where p.Sub_Contractor == false
                                               select p).ToList();

            List<Unique_Machine> um = (from p in db.Unique_Machine
                                       orderby p.Machine_ID
                                       select p).ToList();


            int i = 1440;

            //Calculate the shortest amount of time.
            foreach (Machine m in machines)
            {
                if (i > m.Run_Time)
                    i = m.Run_Time;
            }

            foreach (Manual_Labour_Type ml in manual)
            {
                if (i > ml.Duration)
                    i = ml.Duration;
            }

            TimeSpan intervals = new TimeSpan(0, i, 0);
            int interval_count = Convert.ToInt32(day_duration.TotalMinutes / i);
            int num_of_resouces = (manual.Count + um.Count + 1);
            bool[,] grid = new bool[interval_count, num_of_resouces];


            //Set all cells to false
            for (int aa = 0; aa < interval_count; aa++)
            {
                for (int bb = 0; bb < num_of_resouces; bb++)
                    grid[aa, bb] = false;
            }

            string[] resouce_pos = new string[num_of_resouces];

            for (int k = 0; k < resouce_pos.Length; k++)
            {
                if (k < manual.Count)
                    resouce_pos[k] = "Manual|" + manual[k].Manual_Labour_Type_ID + "|" + manual[k].Name;
                else
                {
                    resouce_pos[k] = "Machine|" + um[k].Unique_Machine_ID + "|" + um[k].Machine_ID;
                }

            }

            //*************************************** Create production schedule

            //Armand: Insert a new entry in the production_schedule table. Remeber to save
            //the intervals as well

            Production_Schedule ps = new Production_Schedule();
            int key = db.Machines.Count() == 0 ? 1 : (from t in db.Production_Schedule
                                                      orderby t.Production_Schedule_ID descending
                                                      select t.Production_Schedule_ID).First() + 1;

            ps.Production_Schedule_ID = key;
            ps.Production_Schedule_Date = DateTime.Now;
            ps.intervals = intervals.Ticks;
            db.Production_Schedule.Add(ps);
            db.SaveChanges();

            //*************************************** Create Part Queue

            //Armand : Get all the uncompleted job cards order by priority then by date. Client
            //job cards are more important
            List<Job_Card> cards = (from p in db.Job_Card
                                    orderby p.Job_Card_Priority_ID, p.Job_Card_Date
                                    select p).ToList();

            //Make an empty queue
            Queue<ProductionPart> parts = new Queue<ProductionPart>();

            foreach (Job_Card jc in cards)
            {
                if (jc.Job_Card_Status_ID == 1)
                {
                    //Armand : IF job card has a status of started then update to in-production
                    Job_Card jcTemp = new Job_Card();
                    jcTemp = (from p in db.Job_Card
                              where p.Job_Card_ID == jc.Job_Card_ID
                              select p).First();

                    jcTemp.Job_Card_Status_ID = 2;
                    db.SaveChanges();
                }

                //Armand: Create a list of parts that are tied to this job card.
                List<Part> pp = new List<Part>();

                foreach (Job_Card_Detail jcd in jc.Job_Card_Detail)
                {
                    List<Part> tmp = (from p in db.Parts
                                      where p.Job_Card_Detail.Contains(jcd)
                                      select p).ToList();

                    pp = pp.Concat(tmp).ToList();
                }

                foreach (Part p in pp)
                {
                    //Create a new production part
                    ProductionPart temp = new ProductionPart();

                    //Populate with data from the database where p.part_type_ID for part type and 
                    //p.Part_ID for part but you can probably just assign p to temp.part

                    temp.part = p;
                    temp.part_type = p.Part_Type;
                    temp.job_card_ID = jc.Job_Card_ID;

                    string[] resourceNeeded = new string[temp.part_type.Machine_Part.Count + temp.part_type.Manual_Labour_Type_Part.Count + 1];
                    
                    //Create the array of stages we need to go through
                    foreach (Machine_Part m in temp.part_type.Machine_Part)
                    {
                        resourceNeeded[m.Stage_In_Manufacturing] = "Machine|" + m.Machine_ID;
                    }

                    foreach (Manual_Labour_Type_Part m in temp.part_type.Manual_Labour_Type_Part)
                    {
                        resourceNeeded[m.Stage_In_Manufacturing] = "Manual|" + m.Manual_Labour_Type_ID;
                    }

                    temp.partResources = resourceNeeded;
                    parts.Enqueue(temp);
                }
            }

            //*************************************** Start scheduling

            bool scheduleFull = false;

            while (parts.Count != 0 && scheduleFull == false)
            {
                ProductionPart pp = parts.Dequeue();

                for (int s = pp.part.Part_Stage; s <= pp.part_type.Number_Of_Stages; s++)
                {
                    //Find the recipe entry;
                    Recipe r = new Recipe();

                    for (int k = 0; k < pp.part_type.Recipes.Count; k++)
                    {
                        if (pp.part_type.Recipes.ElementAt(k).Stage_in_Manufacturing == s)
                        {
                            r = pp.part_type.Recipes.ElementAt(k);
                        }
                    }

                    //Does this stage need another part?
                    if (r.Recipe_Type == "Part Type")
                    {
                        //If no child is available then 
                        //skip the remained of the steps
                        if (checkForChildren(pp.part.Part_ID, r.Item_ID, r.Quantity_Required) == false)
                            continue;
                    }


                    //resouceneeded[0] == type and [1] == ID
                    string[] resouceNeeded = pp.partResources[s].Split('|');
                    bool scheduled = false;

                    if (resouceNeeded[0] == "Machine")
                    {
                        for (int k = 0; k < resouce_pos.Length && scheduled == false; k++)
                        {
                            string[] resouce = resouce_pos[k].Split('|');

                            int duration = 0;

                            if (resouce[0] == "Machine")
                            {
                                int machine_ID = Convert.ToInt32(resouce[2]);
                                int machine_ID_needed = Convert.ToInt32(resouceNeeded[1]);

                                //If we have found a match
                                if (machine_ID == machine_ID_needed)
                                {
                                    //Get the duration

                                    for (int a = 0; a < machines.Count; a++)
                                        if (machines[a].Machine_ID == machine_ID)
                                            duration = machines[a].Run_Time;
                                }
                            }
                            else //it's a Manual Labour
                            {
                                int manual_ID = Convert.ToInt32(resouce[1]);
                                bool sub_contractor = false;

                                //Is this manual labour for a sub-contractor?
                                for (int a = 0; a < manual.Count; a++)
                                {
                                    if (manual[a].Manual_Labour_Type_ID == manual_ID)
                                        sub_contractor = manual[a].Sub_Contractor;
                                }

                                if (sub_contractor == true) //skip the remaining steps
                                    break;

                                for (int a = 0; a < manual.Count; a++)
                                    if (manual[a].Manual_Labour_Type_ID == manual_ID)
                                        duration = manual[a].Duration;
                            }

                            //i is the interval. So if i= 18 then 
                            //round up to the nearest factor of 18
                            duration = RoundUp(duration, i);

                            //How many cells will this occupy?
                            int cellcount = duration / i;

                            //Grid[rows,cols]
                            //k = the pos of the current machine we are working with
                            //Find some space

                            bool space = true;
                            int space_index_start = 0;

                            for (int b = 0; b < interval_count; b++)
                            {
                                for (int g = b; g < cellcount + b; g++)
                                {
                                    if (grid[g, k] == true)
                                        space = false;
                                }

                                //If there is no space in the n spaces then skip them 
                                //and continue down the column until space is found else 
                                //move on to next resouce.

                                if (space == false)
                                    b = b + cellcount;
                                else
                                {
                                    space_index_start = b;
                                    break;
                                }
                            }

                            //Occupy the space in the grid
                            if (space == true)
                            {
                                for (int b = space_index_start; b < b + cellcount; b++)
                                    grid[b, k] = true;

                                TimeSpan minutes = new TimeSpan(0, space_index_start, 0);
                                TimeSpan start_time = day_start.Add(minutes);

                                minutes = new TimeSpan(0, duration, 0);
                                TimeSpan end_time = start_time.Add(minutes);

                                //Armand: FInd an eligible employee
                                Employee emp = new Employee();

                                int resource_id;

                                if(resouce[0] == "Machine")
                                {
                                    resource_id = Convert.ToInt32(resouce[2]);

                                    Machine m = new Machine();
                                    m = (from p in db.Machines
                                         where p.Machine_ID == resource_id
                                         select p).First();

                                    emp = (from d in db.Employees
                                           where d.Machines.Contains(m)
                                           select d).FirstOrDefault();
                                } else
                                {
                                    resource_id = Convert.ToInt32(resouce[1]);

                                    Manual_Labour_Type m = new Manual_Labour_Type();
                                    m = (from p in db.Manual_Labour_Type
                                         where p.Manual_Labour_Type_ID == resource_id
                                         select p).First();

                                    emp = (from d in db.Employees
                                           where d.Manual_Labour_Type.Contains(m)
                                           select d).FirstOrDefault();
                                }

                                int employee_ID = emp.Employee_ID;

                                //Then create a new task
                                //part_stage = s
                                //resouce_type = resource[0]

                                Production_Task pt = new Production_Task();

                                int prod_task_key = db.Production_Task.Count() == 0 ? 1 : (from t in db.Production_Task
                                                                                 orderby t.Production_Task_ID descending
                                                                                select t.Production_Task_ID).First() + 1;

                                pt.Production_Task_ID = prod_task_key;
                                pt.Production_Task_Type = resouce[0];
                                pt.start_time = start_time;
                                pt.end_time = end_time;
                                pt.Part_Stage = s;
                                pt.Production_Schedule_ID = key;
                                pt.Employee_ID = employee_ID;
                                pt.complete = false;
                                pt.Part_ID = pp.part.Part_ID;
                                pt.Resource_ID = resource_id;
                                pt.Job_Card_ID = pp.job_card_ID;
                                pt.duration = pp.;

                                scheduled = true;
                                break;
                            }
                        }
                    }
                }
            }

            return "True|Production Schedule has been generated.";
        }

        private static int RoundUp(int toRound, int toWhat)
        {
            return (toWhat - toRound % toWhat) + toRound;
        }

        private bool checkForChildren(int part_ID, int? child_type_ID, int how_many)
        {
            //Armand : Query the database and check how many children of child_type_ID is available 
            //that is not tied to a client order and is in-stock
            List<Part> children = null;
            int available_Children = children.Count;

            if (available_Children < how_many) //If not enough children is available
                return false;

            //Assign the available chidren to the parent part
            for (int k = 0; k < how_many; k++)
            {
                //Armand: Update chidren[k] and set its parent_ID equal to part_ID
            }
            return false;
        }

    }
}
