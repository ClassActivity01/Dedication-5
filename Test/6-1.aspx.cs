using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _6_1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

  /*      [System.Web.Services.WebMethod]
        public static string submitQuote(Client_Quote client, string action)
        {
            //action is either print or email
            //this method first checks if the quote exists 

            return Convert.ToString(client.Client_ID);
        }

        private static string estimateOrderCompletionTime(Client_Quote quote)
        {

            //Create two lists
            //One to hold the part type ids with their counts
            //And one to hold part names and times
            List<int> num_of_parts_available = new List<int>();
            List<TimeSpan> average_times = new List<TimeSpan>();
            string return_message = "";
            foreach (Client_Quote_Detail cqd in quote.details)
            {
                //(Armand) Count how many parts of each part type on the quote 
                //are available that are in-stock and not tied to a Client Order
                List<Part> parts = null;
                int count = 0;

                num_of_parts_available.Add(count);

                //Armand: Get the part name
                string part_name = "";

                return_message += "There are " + Convert.ToString(count) + " " + part_name +
                    " available. <br/>";
                //Calculate how long it will take to manufacture the remaining parts
                if (count < cqd.Quantity)
                {
                    int how_many = cqd.Quantity - count;


                    //Armand: get a list of all the tasks for this part_type where stage = 1
                    //Remember to save the dates of the ps that the task belongs to as well
                    List<Production_Task> tasks = null;

                    if (tasks != null)
                    {
                        TimeSpan total = new TimeSpan();
                        total = TimeSpan.FromDays(0);
                        //foreach task add the end time to the start time and add that total to the total timespan
                        foreach (Production_Task t in tasks)
                        {
                            //1. Get the date of the current task
                            DateTime start_date = t.ps_date;

                            //Armand: first get the end time of the very last stage which could be in
                            //another production schedule from another day which should be a single task
                            //Remeber to save that ps date as well.
                            Production_Task tasks2 = null;

                            DateTime end_date = tasks2.ps_date;

                            //Calculate how many days, hours and minutes passed before this part was completed.
                            int days = (end_date - start_date).Days;
                            TimeSpan hours_minutes = tasks2.end_time.Subtract(t.start_time);

                            int minutes = hours_minutes.Minutes;
                            int hours = hours_minutes.Hours;

                            TimeSpan total2 = new TimeSpan(days, hours, minutes, 0);
                            total.Add(total2);

                        }

                        //Now to calculate the average for this part type
                        int a = Convert.ToInt32((total.TotalMinutes / tasks.Count));
                        TimeSpan average_min = new TimeSpan(0, 0, a, 0);

                        return_message += "It takes " + average_min.ToString() + " to manufacuture. " + Convert.ToString(how_many) +
                            " still need to be manufactured.";
                    }
                    else //Get the average from the database
                    {
                        //Armand get the average from the database for qcd.part_type_ID
                        Part_Type p = new Part_Type();
                      
                        return_message += "It takes " + p.Average_Completion_Time.ToString() + " to manufacuture. " + Convert.ToString(how_many) +
                            " still need to be manufactured.";
                    }


                }
            }



            return "True|" + return_message;
        }

    */
    }
}