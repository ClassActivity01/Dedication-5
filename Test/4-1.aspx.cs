using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _4_1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

   /*  
        //SIDE NOTE... This can be turned into a recursive function should there ever be multilevel child dependencies
        
        private static void checkForChildren(int part_type_ID, int quantity_requested, int job_card_ID, string type)
        {

            //(Armand) Check for dependencies i.e check if the part_type has any part dependencies in the recipe table 
            //and make a list of children part_types.
            List<Recipe> dependencies = null;

            if (dependencies != null)
            {
                foreach (Recipe pt in dependencies)
                {
                    int child_ID = pt.resouce_ID;

                    //(Armand) first check if there isn't alreayd an entry for the child's ID in job_card_detail
                    //where jcd.Part_Type_ID == child_ID and Job_Card_ID == job_card_ID and assign to jcd
                    Job_Card_Detail jcd = null;

                    int quantity = quantity_requested * pt.Quantity_Required;

                    if (jcd != null)
                    {
                        //add the required children parts to the quantity already requested
                        int new_quantity;
                        if (quantity > jcd.Quantity)
                            new_quantity = jcd.Quantity + (jcd.Quantity - quantity_requested * pt.Quantity_Required);
                        else
                            new_quantity = jcd.Quantity;

                        //update this existing record with the new quantity.
                    }
                    else
                    {
                        //(Armand) insert a new record in the table job_card_detail and set its non-manual to true

                        //The id of the last inserted record i.e. the one above
                        int job_card_detail_ID = 1;

                        int available = checkForPartAvailability(child_ID, quantity, job_card_detail_ID);

                        //Calculate how many new parts must be generated
                        int how_many = quantity - available;

                        //Generate the new child parts
                        generateUniqueParts(how_many, child_ID, 0, job_card_detail_ID, type);
                    }
                }
            }
        }

        private static int checkForPartAvailability(int part_type_ID, int quantity_requested, int job_card_detail_ID)
        {
            int available = 0;

            //(Armand) Check for stock availability i.e in-stock
            List<Part> available_parts = null;

            if (available_parts != null)
            {
                foreach (Part part in available_parts)
                {
                    //(Armand) DO a select to determine whether this part is tied to a client order
                    bool isTiedtoClientOrder = false;

                    if (available >= quantity_requested)
                        break;

                    if (isTiedtoClientOrder == false)
                    {
                        available++;
                        assignAvailableParts(part.Part_ID, job_card_detail_ID);
                    }
                }
            }

            return available;
        }

        private static void assignAvailableParts(string part_ID, int job_card_detail_ID)
        {
            //(Armand) Create a new job_card_detail_part with the above parameters and insert
        }

        private static void generateUniqueParts(int how_many, int part_type_ID, int parent_ID, int job_card_detail_ID, string type)
        {
            if (type == "Client Order")
            {
                //(Armand) Check for parts that are in-stock and not tied to any other client order
                List<Part> in_stock_parts = null;

                if (in_stock_parts != null)
                {
                    foreach (Part part in in_stock_parts)
                    {
                        //now we assign the part to this job card
                        assignAvailableParts(part.Part_ID, job_card_detail_ID);
                        how_many--;
                    }
                }
            }
            //(Armand) Check for cancelled parts
            List<Part> cancelled_parts = null;

            if (cancelled_parts != null)
            {
                foreach (Part part in cancelled_parts)
                {
                    //(Armand) Update the part in the part table and set its status to "Raw" if its stage is 1
                    //or set its status to "in-production"

                    assignAvailableParts(part.Part_ID, job_card_detail_ID);
                    how_many--;
                }
            }

            //Now to make new parts
            for (int k = 0; k < how_many; k++)
            {
                //(Armand) Get the abbreviatio for the part_type
                string abbreviation = "VSH";

                //(Armand) Generate the new number;
                int num = 123;

                string part_ID = abbreviation + "-" + Convert.ToString(num);

                //(Armand) Insert a new part into the part table.
                //part_ID = unique_ID
                //part_type_ID = part_type_ID
                //part_status_ID = the ID of whatever "Raw" is
                //part_date_added = the current date and time
                //part_cost_price = 0.00
                //part_stage = 1
                //parent_ID = parentID

                assignAvailableParts(part_ID, job_card_detail_ID);
            }
        }*/
    }
}