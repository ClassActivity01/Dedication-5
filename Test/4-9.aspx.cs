using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _4_9 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

   /*     [System.Web.Services.WebMethod]
        public static string getJobCards()
        {

            //GET all the job cards with status of "in-production" or "started"

            List<Job_Card> job = new List<Job_Card>();
            job.Add(new Job_Card());
            job[0].Job_Card_ID = 1;
            job[0].Job_Card_Priority_ID = 1;
            job[0].Job_Card_Date = new DateTime(2016, 11, 12);
            job[0].Job_Card_Status_Name = "In-Production";
            job[0].Job_Card_Status_ID = 2;
            job[0].details = new List<Job_Card_Detail>();
            job[0].details.Add(new Job_Card_Detail());
            job[0].details[0].Job_Card_Details_ID = 1;
            job[0].details[0].Job_Card_ID = 1;
            job[0].details[0].Non_Manual = false;
            job[0].details[0].Part_Type_ID = 1;
            job[0].details[0].Quantity = 20;
            job[0].details[0].Part_Type_Name = "Pump A";
            job[0].details.Add(new Job_Card_Detail());
            job[0].details[1].Job_Card_Details_ID = 1;
            job[0].details[1].Job_Card_ID = 1;
            job[0].details[1].Non_Manual = false;
            job[0].details[1].Part_Type_ID = 2;
            job[0].details[1].Quantity = 20;
            job[0].details[1].Part_Type_Name = "Pump B";
            job[0].parts = new List<Part>();
            job[0].parts.Add(new Part());
            job[0].parts[0].Part_ID = "VSH - 123";
            job[0].parts[0].Part_Status_Name = "Raw";
            job[0].parts[0].Part_Type_ID = 1;
            job[0].parts.Add(new Part());
            job[0].parts[1].Part_ID = "VSH - 124";
            job[0].parts[1].Part_Status_Name = "Raw";
            job[0].parts[1].Part_Type_ID = 1;
            job[0].parts.Add(new Part());
            job[0].parts[2].Part_ID = "VSH - 125";
            job[0].parts[2].Part_Status_Name = "Raw";
            job[0].parts[2].Part_Type_ID = 2;

            string manual = "True|" + JsonConvert.SerializeObject(job);

            return manual;

        }*/
    }
}