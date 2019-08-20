using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _4_2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

   /*    
        [System.Web.Services.WebMethod]
        public static string canIRemove(int part_type_ID, int quantity, int job_card_ID)
        {
            //(Armand) Query the database and check how many parts have statuses of "Raw" tied to this job card
            int count = 20;

            if (count > quantity)
                return "False|Cannot remove some of the parts, some have already gone into production. <br/>" +
                "You can remove " + count + " parts.";
            else
               return "True|";
        }

        private static string updateJobCardSever(Job_Card job)
        {
            if (job.Job_Card_Status_ID == 1) //if job card is being cancelled.
            {
                //Update job card to cancelled only if it is in-production
                bool in_production = false;

                if (in_production == true)
                    return "False|Job card already in production. Cannot cancel.";

                //(Armand) Update all the parts tied to this job_card that are still "in-production" or "Raw" 
                //and set them to "Cancelled" 

                return "True|Job Card has been cancelled.";
            }
            else if (job.Job_Card_Status_ID == 2) //if job card is being set to complete.
            {
                //1. (Armand) Updat job card and set its status to complete

                //2. (Armand) get all the parts tied to this job_card that do not have a parent i.e. parent_ID = 0
                //and have a status of "in-production" or "Raw"
                List<Part> parts = null;

                foreach (Part p in parts)
                {

                    //3. (Armand) Update this part and set its status to "in-stock";

                    updateChildren(p.Part_ID, 2, job.Job_Card_ID); //2 is for Complete.
                }

                return "True|Job Card has been set to complete.";
            }
            else //Only some parts are being removed 
            {
                foreach (Job_Card_Detail jcd in job.details)
                {
                    if (jcd.Remove_Quantity > 0)
                    {
                        int part_type_ID = jcd.Part_Type_ID;
                        int i = 0;
                        //(Armand) Get all the parts of the above part type tied to the job card 
                        //and order them by putting the last added part first
                        List<Part> parts = null;

                        if (parts != null)
                        {
                            foreach (Part p in parts)
                            {
                                if (p.Part_Status_ID == 1) //If the part is still in raw state but not in production
                                {
                                    //1. (Armand) Update the part status to cancelled.
                                    //2. Sever the tie to the job card by deleting the entry in 
                                    //Job_Card_Detail_Part where Part_ID == p.Part_ID

                                    
                                    i++;
                                }
                            }
                        }

                        if (i == jcd.Quantity) 
                        {
                            //If all the parts have been removed then remove the entry from job_card_detail
                            //for that part_type_ID

                        }
                    }

                }

                return "True|Job Card has been updated.";

            }
        }

        private static void updateChildren(string part_ID, int status, int job_card_ID)
        {
            if (status == 2)//I.e Completed
            {
                //(Armand) Update the children where parent_ID == part_Id only for children tied to the job card.
                //and set their status to "Used" only if their status is "raw", in-production or in-stock
            }
        }*/

    }
}