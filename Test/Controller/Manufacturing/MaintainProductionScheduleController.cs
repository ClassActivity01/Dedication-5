using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Manufacturing
{
    public class MaintainProductionScheduleController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/MaintainProductionSchedule
        public string Get()
        {
            try
            {
                return generateGrid();
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "MaintainProductionScheduleController GET");
                return "false|Failed to retrieve Production Schedule.";
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
                resouce_positions[x] = "Machine|" + um[y].Unique_Machine_ID + "|" + um[y].Machine_ID + "|" + um[y].Unique_Machine_Serial;
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
                for (int i = 0; i < resouce_positions.Count() + 1; i++)
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
                        string[] resources = resouce_positions[i - 1].Split('|');

                        if (schedule2[k, i - 1] == null) //IF the cell is empty. Add an empty cell
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

                            for (int o = k; o < ((schedule2[k, i - 1].pt.duration / interval) + k); o++)
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




        // GET: api/MaintainProductionSchedule/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/MaintainProductionSchedule
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/MaintainProductionSchedule/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/MaintainProductionSchedule/5
        public void Delete(int id)
        {
        }
    }
}
