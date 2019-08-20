using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Manufacturing
{
    public class ProductionScheduleController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/ProductionSchedule
        public string Get()
        {
            try
            {
                return generateGrid();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "ProductionScheduleController GET");
                return "false|Failed to retrieve Production Schedule.";
            }
        }

        // POST: api/ProductionSchedule
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                DateTime date = new DateTime();
                date = (DateTime)json["date"];

                Production_Schedule ps = new Production_Schedule();
                ps = (from p in db.Production_Schedule
                      where DbFunctions.TruncateTime(p.Production_Schedule_Date) == DbFunctions.TruncateTime(date)
                      select p).FirstOrDefault();

                if(ps == null)
                {
                    generateProductionSchedule();
                }else
                {
                    return "false|Production schedule has already been generated.";
                }
                
                return "true|Succesfully generated production schedule.";
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "ProductionScheduleController POST");
                return "false|Failed to generate Production Schedule.";
            }
        }


        private class productionSchedule
        {
            public Production_Task pt;
            public bool printed = false;

            public productionSchedule(Production_Task _pt)
            {
                pt = _pt;
            }
        }

        private string generateGrid()
        {
            //******************************************** Prepare the grid
            Production_Schedule ps = new Production_Schedule();
            ps = (from p in db.Production_Schedule
                  where DbFunctions.TruncateTime(p.Production_Schedule_Date) == DbFunctions.TruncateTime(DateTime.Now)
                  select p).FirstOrDefault();

            //Armand: Query the database and add all the tasks to the tasks variable
            if (ps == null)
                return "false~-~Production Schedule has not been generated yet for the day.";

            List<Production_Task> tasks = (from p in db.Production_Task
                                           where p.Production_Schedule_ID == ps.Production_Schedule_ID
                                           select p).ToList();

            TimeSpan day_start = new TimeSpan(8, 0, 0);
            TimeSpan day_end = new TimeSpan(17, 0, 0);

            TimeSpan day_duration = day_end.Subtract(day_start);

            //Armand get ALL the machines + unique machines and ALL the manual labour that is not sub-contracted.
            List<Machine> machines = (from p in db.Machines
                                      orderby p.Machine_ID
                                      select p).ToList();

            List<Manual_Labour_Type> manual = (from p in db.Manual_Labour_Type
                                               orderby p.Manual_Labour_Type_ID
                                               where p.Sub_Contractor == false
                                               select p).ToList();

            List<Unique_Machine> um = (from p in db.Unique_Machine
                                       orderby p.Machine_ID
                                       where p.Machine_Status_ID == 1
                                       select p).ToList();

            int interval = ps.intervals;

            int interval_count = Convert.ToInt32(day_duration.TotalMinutes / interval);
            int num_of_resouces = (manual.Count + um.Count);
            bool[,] schedule = new bool[interval_count, num_of_resouces];
            productionSchedule[,] schedule2 = new productionSchedule[interval_count, num_of_resouces];
            string[] resouce_positions = new string[num_of_resouces];
            

            //Set all cells to false
            for (int aa = 0; aa < interval_count; aa++)
            {
                for (int bb = 0; bb < num_of_resouces; bb++)
                {
                    schedule[aa, bb] = false;
                    schedule2[aa, bb] = null;
                }
            }

            int x;

            for (x = 0; x < resouce_positions.Count() && x < manual.Count(); x++)
            {
                resouce_positions[x] = "Manual|" + manual[x].Manual_Labour_Type_ID + "|" + manual[x].Name;
            }

            int z = x;

            for (int y = 0; y < resouce_positions.Count() - z + 1 && y < um.Count(); y++, x++)
            {
                resouce_positions[x] = "Machine|" + um[y].Unique_Machine_ID + "|" + um[y].Machine_ID +"|" +um[y].Unique_Machine_Serial;
            }

            //******************************************** Start generating the grid
            foreach (Production_Task task in tasks)
            {
                int start1 = Convert.ToInt32(task.start_time.TotalMinutes);
                int start2 = Convert.ToInt32(day_start.TotalMinutes);

                int position_start = (start1 - start2) / interval;
                int duration = Convert.ToInt32(task.duration);
                int cellcount = duration / interval;

                //Find the correct position
                for (int k = 0; k < resouce_positions.Count(); k++)
                {
                    string[] resouce = resouce_positions[k].Split('|');

                    int resouce_ID = Convert.ToInt32(resouce[1]);

                    if (resouce[0] == task.Production_Task_Type && task.Resource_ID == resouce_ID)
                    {
                        int trol = position_start + cellcount;
                        for (int where = position_start; where < trol && where < interval_count; where++)
                        {
                            schedule[where, k] = true;
                            schedule2[where, k] = new productionSchedule(task);
                        }
                        break;
                    }
                }
            }

            string scheduleHTML = "<div class='table-responsive'><table class='table table-bordered'><thead><th>Time</th>";
            for (int k = 0; k < resouce_positions.Length; k++)
            {
                string[] resources = resouce_positions[k].Split('|');
                string name = "";
                string ID;
                string other;

                if (resources[0] == "Machine")
                {
                    int machine_ID = Convert.ToInt32(resources[1]);

                    for (int o = 0; o < um.Count; o++)
                    {
                        if (um[o].Unique_Machine_ID == machine_ID)
                            name = um[o].Machine.Name;
                    }

                    ID = resources[1];
                    other = resources[2];
                    string serial = resources[3];

                    scheduleHTML += "<th>Machine<br/>" +
                        name + "<br/>" +
                        "Machine Serial: " + serial + "<br/></th>";
                }
                else
                {
                    name = resources[2];
                    ID = resources[1];

                    scheduleHTML += "<th>Manual Labour<br/>" +
                        name + "<br/>" +
                        "Manual Labour ID: " + ID + "<br/></th>";
                }
            }

            scheduleHTML += "</thead><tbody>";
            TimeSpan s_start_time = day_start;


            //for each row
            for (int k = 0; k < interval_count; k++)
            {
                scheduleHTML += "<tr>";
                //for each column
                for (int i = 0; i < resouce_positions.Count()+1; i++)
                {
                    if (i == 0)
                    {
                        string time = s_start_time.ToString("hh\\:mm");
                        scheduleHTML += "<td>" + time + "</td>";
                        TimeSpan tmp = new TimeSpan(0, interval, 0);
                        s_start_time = s_start_time.Add(tmp);
                    }
                    else
                    {
                        string[] resources = resouce_positions[i-1].Split('|');

                        if (schedule2[k, i-1] == null) //IF the cell is empty. Add an empty cell
                        {
                            scheduleHTML += "<td></td>";
                        }
                        //If the prev cell's task is equal to the current cell's task then do nothing
                        else 
                            if (schedule2[k, i - 1].printed == false)
                            {
                                int Part_Type_ID = schedule2[k, i - 1].pt.Part.Part_Type_ID;
                                string part_name = schedule2[k, i - 1].pt.Part.Part_Type.Name;
                                string part_serial = schedule2[k, i - 1].pt.Part.Part_Serial;
                                int part_ID = schedule2[k, i - 1].pt.Part_ID;
                                string part_stage = Convert.ToString(schedule2[k, i - 1].pt.Part_Stage);
                                string task_ID = Convert.ToString(schedule2[k, i - 1].pt.Production_Task_ID);
                                string time = schedule2[k, i - 1].pt.start_time + " - " + schedule2[k, i - 1].pt.end_time;
                                int Emp_ID = schedule2[k, i - 1].pt.Employee_ID;
                                string emp_name = schedule2[k, i - 1].pt.Employee.Name + " " + schedule2[k, i - 1].pt.Employee.Surname;
                                int rowspan = Convert.ToInt32(schedule2[k, i - 1].pt.duration / interval);

                                for (int o = k; o < ((schedule2[k, i - 1].pt.duration / interval)+k); o++)
                                    schedule2[o, i - 1].printed = true;

                                scheduleHTML += "<td rowspan='" + rowspan + "'>" +
                                "<button type='button' class='btn btn-primary'>" +
                                    "<b>Part Serial:</b> " + part_serial + "<br/>" +
                                    "<b>Part Name:</b> " + part_name + "<br/>" +
                                    "<b>Stage:</b> " + part_stage + "<br/>" +
                                    "<b>Task ID:</b> " + task_ID + "<br/>" +
                                    "<b>Time:</b> " + task_ID + "<br/>" +
                                    "<b>Employee:</b> " + emp_name + "<br/>" +
                                "</button></td>";
                            }
                    }
                }

                scheduleHTML += "</tr>";
            }

            scheduleHTML += "</tbody></table></div>";
            return "true~-~" + scheduleHTML;
        }



        // PUT: api/ProductionSchedule/5
        public string Put(int id, HttpRequestMessage value)
        {
            return "";
        }

        class ProductionPart
        {
            public Part part;
            public int job_card_ID;
            public List<MachineRecipe> machines = new List<MachineRecipe>();
            public List<ManualRecipe> manual = new List<ManualRecipe>();
            public List<Recipe> recipe;

            public class MachineRecipe
            {
                public Machine machine;
                public int stage;
            }

            public class ManualRecipe
            {
                public Manual_Labour_Type manual;
                public int stage;
            }
        }

        private void generateProductionSchedule()
        {
            TimeSpan day_start = new TimeSpan(8, 0, 0);
            TimeSpan day_end = new TimeSpan(17, 0, 0);
            TimeSpan day_duration = day_end.Subtract(day_start);

            List<Machine> machines = new List<Machine>();
            List<Manual_Labour_Type> manual = new List<Manual_Labour_Type>();
            List<Part> pp = new List<Part>();
            List<Unique_Machine> unique = new List<Unique_Machine>();

            //*************************************** Create Part Queue
            List<Job_Card> cards = (from p in db.Job_Card
                                    where p.Job_Card_Status_ID == 1 || p.Job_Card_Status_ID == 2
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

                //Somehow get parts
                foreach (Job_Card_Detail jcd in jc.Job_Card_Detail)
                {
                    List<Part> tmp = (from p in db.Parts
                                      where p.Job_Card_Detail.Where(y => y.Job_Card_Details_ID == jcd.Job_Card_Details_ID).FirstOrDefault().Job_Card_Details_ID == jcd.Job_Card_Details_ID && p.Part_Status_ID < 3
                                      select p).ToList();

                    pp = pp.Concat(tmp).ToList();

                    foreach(Part p in tmp)
                    {
                        ProductionPart tmp2 = new ProductionPart();
                        tmp2.part = p;
                        tmp2.job_card_ID = jcd.Job_Card_ID;

                        List<Machine> mac = (from z in db.Machines
                                         join d in db.Machine_Part
                                            on z.Machine_ID equals d.Machine_ID
                                         where d.Part_Type_ID == p.Part_Type_ID
                                         select z).ToList();

                        List<Manual_Labour_Type> man = (from z in db.Manual_Labour_Type
                                                           join d in db.Manual_Labour_Type_Part
                                                           on z.Manual_Labour_Type_ID equals d.Manual_Labour_Type_ID
                                                           where d.Part_Type_ID == p.Part_Type_ID
                                                           select z).ToList(); ;

                        tmp2.recipe = p.Part_Type.Recipes.ToList();

                        foreach (Machine m in mac)
                        {
                            ProductionPart.MachineRecipe mr = new ProductionPart.MachineRecipe();
                            mr.machine = m;
                            mr.stage = (from z in db.Machine_Part
                                        where z.Machine_ID == m.Machine_ID && z.Part_Type_ID == p.Part_Type_ID
                                        select z.Stage_In_Manufacturing).First();

                            machines.Add(m);
                            tmp2.machines.Add(mr);
                        }

                        foreach (Manual_Labour_Type m in man)
                        {
                            ProductionPart.ManualRecipe mr = new ProductionPart.ManualRecipe();
                            mr.manual = m;
                            mr.stage = (from z in db.Manual_Labour_Type_Part
                                        where z.Manual_Labour_Type_ID == m.Manual_Labour_Type_ID && z.Part_Type_ID == p.Part_Type_ID
                                        select z.Stage_In_Manufacturing).First();

                            manual.Add(m);
                            tmp2.manual.Add(mr);
                        }

                        parts.Enqueue(tmp2);
                    }
                }
            }

            manual = manual.Distinct().ToList();
            machines = machines.Distinct().ToList();

            foreach(Machine m in machines)
            {
                unique = unique.Concat(m.Unique_Machine.Where(x => x.Machine_Status_ID == 1)).ToList();
            }

            int i = 1440; //max amount of time is equal to 24 hours

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
            int num_of_resources = unique.Count() + manual.Count();

            bool[,] grid = new bool[interval_count, num_of_resources];
            Employee[,] gridEmployee = new Employee[interval_count, num_of_resources];

            for (int aa = 0; aa < interval_count; aa++)
            {
                for (int bb = 0; bb < num_of_resources; bb++)
                {
                    grid[aa, bb] = false;
                    gridEmployee[aa, bb] = null;
                } 
            }

            //*************************************** Create production schedule
            Production_Schedule ps = new Production_Schedule();
            int key = db.Production_Schedule.Count() == 0 ? 1 : (from t in db.Production_Schedule
                                                                 orderby t.Production_Schedule_ID descending
                                                                 select t.Production_Schedule_ID).First() + 1;

            ps.Production_Schedule_ID = key;
            ps.Production_Schedule_Date = DateTime.Now;
            ps.intervals = Convert.ToInt32(intervals.TotalMinutes);
            db.Production_Schedule.Add(ps);
            db.SaveChanges();

            bool scheduleFull = false;

            while (parts.Count != 0 && scheduleFull == false)
            {
                ProductionPart ProdPart = parts.Dequeue();
                TimeSpan currentTime = day_start;
                int interval_stage = 0;
                
                for(int x = 1; x <= ProdPart.part.Part_Type.Number_Of_Stages; x++)
                {
                    Machine tmp1;
                    Manual_Labour_Type tmp2;

                    try
                    {
                        tmp1 = ProdPart.machines.Find(y => y.stage == x).machine;
                    }
                    catch
                    {
                        tmp1 = null;
                    }

                    try
                    {
                        tmp2 = ProdPart.manual.Find(y => y.stage == x).manual;
                    }
                    catch
                    {
                        tmp2 = null;
                    }
                     
                    Recipe tmp3 = ProdPart.recipe.Find(y => y.Stage_in_Manufacturing == x);
                    int cellcount;

                    if (tmp1 != null)
                    {
                        cellcount = RoundUp(tmp1.Run_Time, i) / i;

                        bool foundEmployee = false;
                        bool foundMachine = false;

                        List<Unique_Machine> um = tmp1.Unique_Machine.ToList();
                        int k = manual.Count();
                        int l = 0;

                        for (int y = 0; y < unique.Count(); y++)
                        {
                            if(um[0].Unique_Machine_ID == unique[y].Unique_Machine_ID)
                            {
                                k += y;
                                break;
                            }
                        }

                        while (!foundEmployee && !foundMachine)
                        {
                            if(interval_stage+cellcount >= interval_count)
                            {
                                l++;

                                if (l == um.Count())
                                    break;

                                k = manual.Count();
                                for (int y = 0; y < unique.Count(); y++)
                                {
                                    if (um[l].Unique_Machine_ID == unique[y].Unique_Machine_ID)
                                    {
                                        k += y;
                                        break;
                                    }
                                }
                                interval_stage = Convert.ToInt32((currentTime.TotalMinutes-day_start.TotalMinutes) / i);
                            }

                            foundMachine = false;
                            foundEmployee = false;

                            bool spotOpen = true;

                            for (int g = interval_stage; g < interval_stage + cellcount && g < interval_count; g++)
                            {
                                if (grid[g, k] == true)
                                    spotOpen = false;
                            }

                            if(!spotOpen)
                            {
                                interval_stage += 1;
                            }else
                            {
                                foundMachine = true;

                                Unique_Machine umO = um[l];

                                List<Employee> empList = (from p in db.Employees
                                                      where p.Machines.Where(e => e.Machine_ID == tmp1.Machine_ID).FirstOrDefault().Machine_ID == tmp1.Machine_ID
                                                      select p).ToList();

                                int z = 0;

                                bool empOpen = true;
                                Employee emp = null;

                                while (empOpen)
                                {
                                    if(z == empList.Count())
                                    {
                                        emp = null;
                                        break;
                                    }

                                    emp = empList[z];

                                    for (int g = interval_stage; g < interval_stage + cellcount && g < interval_count; g++)
                                    {
                                        for (int h = 0; h < manual.Count() + unique.Count(); h++)
                                        {
                                            if (gridEmployee[g, h] == emp)
                                                empOpen = false;
                                        }
                                    }

                                    if(!empOpen)
                                    {
                                        z++;
                                        empOpen = true;
                                    }else
                                        break;
                                }

                                if(emp == null)
                                {
                                    interval_stage += 1;
                                }else
                                {
                                    foundEmployee = true;

                                    Production_Task pt = new Production_Task();

                                    int prod_task_key = db.Production_Task.Count() == 0 ? 1 : (from t in db.Production_Task
                                                                                               orderby t.Production_Task_ID descending
                                                                                               select t.Production_Task_ID).First() + 1;

                                    for (int g = interval_stage; g < interval_stage + cellcount && g < interval_count; g++)
                                    {
                                        grid[g, k] = true;
                                        gridEmployee[g, k] = emp;
                                    }

                                    TimeSpan minutes = new TimeSpan(0, interval_stage * Convert.ToInt32(intervals.TotalMinutes), 0);
                                    TimeSpan start_time = currentTime.Add(minutes);

                                    minutes = new TimeSpan(0, RoundUp(tmp1.Run_Time, i), 0);
                                    TimeSpan end_time = start_time.Add(minutes);
                                    currentTime = end_time;

                                    pt.Production_Task_ID = prod_task_key;
                                    pt.Production_Task_Type = "Machine";
                                    pt.start_time = start_time;
                                    pt.end_time = end_time;
                                    pt.Part_Stage = x;
                                    pt.Production_Schedule_ID = key;
                                    pt.Employee_ID = emp.Employee_ID;
                                    pt.complete = false;
                                    pt.Part_ID = ProdPart.part.Part_ID;
                                    pt.Resource_ID = umO.Unique_Machine_ID;
                                    pt.Job_Card_ID = ProdPart.job_card_ID;
                                    pt.duration = RoundUp(tmp1.Run_Time, i);

                                    db.Production_Task.Add(pt);
                                    db.SaveChanges();
                                }
                            }
                        }
                    }else
                    if (tmp2 != null)
                    {
                        cellcount = RoundUp(tmp2.Duration, i) / i;

                        bool foundEmployee = false;
                        bool foundManual = false;

                        int k = 0;

                        for (int y = 0; y < manual.Count(); y++)
                        {
                            if (tmp2.Manual_Labour_Type_ID == manual[y].Manual_Labour_Type_ID)
                            {
                                k += y;
                                break;
                            }
                        }

                        while (!foundEmployee && !foundManual)
                        {
                            if (interval_stage + cellcount >= interval_count)
                            {
                                break;
                            }

                            foundManual = false;
                            foundEmployee = false;

                            bool spotOpen = true;

                            for (int g = interval_stage; g < interval_stage + cellcount && g < interval_count; g++)
                            {
                                if (grid[g, k] == true)
                                    spotOpen = false;
                            }

                            if (!spotOpen)
                            {
                                interval_stage += 1;
                            }
                            else
                            {
                                foundManual = true;

                                List<Employee> empList = (from p in db.Employees
                                                          where p.Manual_Labour_Type.Where(e => e.Manual_Labour_Type_ID == tmp2.Manual_Labour_Type_ID).FirstOrDefault().Manual_Labour_Type_ID == tmp2.Manual_Labour_Type_ID
                                                          select p).ToList();

                                int z = 0;

                                bool empOpen = true;
                                Employee emp = null;

                                while (empOpen)
                                {
                                    if (z == empList.Count())
                                    {
                                        emp = null;
                                        break;
                                    }

                                    emp = empList[z];

                                    for (int g = interval_stage; g < interval_stage + cellcount && g < interval_count; g++)
                                    {
                                        for (int h = 0; h < manual.Count() + unique.Count(); h++)
                                        {
                                            if (gridEmployee[g, h] == emp)
                                                empOpen = false;
                                        }
                                    }

                                    if (!empOpen)
                                    {
                                        z++;
                                        empOpen = true;
                                    }
                                    else
                                        break;
                                }

                                if (emp == null)
                                {
                                    interval_stage += 1;
                                }
                                else
                                {
                                    foundEmployee = true;

                                    Production_Task pt = new Production_Task();

                                    int prod_task_key = db.Production_Task.Count() == 0 ? 1 : (from t in db.Production_Task
                                                                                               orderby t.Production_Task_ID descending
                                                                                               select t.Production_Task_ID).First() + 1;

                                    for (int g = interval_stage; g < interval_stage + cellcount && g < interval_count; g++)
                                    {
                                        grid[g, k] = true;
                                        gridEmployee[g, k] = emp;
                                    }

                                    TimeSpan minutes = new TimeSpan(0, interval_stage * Convert.ToInt32(intervals.TotalMinutes), 0);
                                    TimeSpan start_time = currentTime.Add(minutes);

                                    minutes = new TimeSpan(0, RoundUp(tmp2.Duration, i), 0);
                                    TimeSpan end_time = start_time.Add(minutes);
                                    currentTime = end_time;

                                    pt.Production_Task_ID = prod_task_key;
                                    pt.Production_Task_Type = "Manual";
                                    pt.start_time = start_time;
                                    pt.end_time = end_time;
                                    pt.Part_Stage = x;
                                    pt.Production_Schedule_ID = key;
                                    pt.Employee_ID = emp.Employee_ID;
                                    pt.complete = false;
                                    pt.Part_ID = ProdPart.part.Part_ID;
                                    pt.Resource_ID = tmp2.Manual_Labour_Type_ID;
                                    pt.Job_Card_ID = ProdPart.job_card_ID;
                                    pt.duration = RoundUp(tmp2.Duration, i);

                                    db.Production_Task.Add(pt);
                                    db.SaveChanges();
                                }
                            }
                        }
                    }
                }
            }
        }

        private static int RoundUp(int toRound, int toWhat)
        {
            if (toRound % toWhat == 0)
                return toRound;
            else
                return (toWhat - toRound % toWhat) + toRound;
        }

        private bool checkForChildren(int part_ID, int? child_type_ID, int how_many)
        {
            //Armand : Query the database and check how many children of child_type_ID is available 
            //that is not tied to a client order and is in-stock
            List<Part> childrenT = db.Parts.Where(x => x.Part_Type_ID == child_type_ID).Where(y => y.Part_Status_ID == 3).ToList();
            List<Part> children = new List<Part>();

            foreach (Part part in childrenT)
            {
                int pt = (from d in db.Job_Card_Detail
                      where d.Parts.Contains(part)
                      select d).Count();

                if (pt > 0)
                    children.Add(part);
            }

            int available_Children = children.Count;

            if (available_Children < how_many) //If not enough children is available
                return false;

            //Assign the available chidren to the parent part
            for (int k = 0; k < how_many; k++)
            {
                //Armand: Update chidren[k] and set its parent_ID equal to part_ID
                children[k].Parent_ID = part_ID;
            }

            db.SaveChanges();
            return false;
        }

    }
}
