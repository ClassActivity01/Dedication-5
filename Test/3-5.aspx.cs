using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _3_5 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 /*       [System.Web.Services.WebMethod]
        public static string getPartStatuses()
        {
            List<Part_Status> ps = new List<Part_Status>();
            ps.Add(new Part_Status());
            ps[0].Part_Status_ID = 1;
            ps[0].Name = "Raw";
            ps.Add(new Part_Status());
            ps[1].Part_Status_ID = 2;
            ps[1].Name = "In-Production";
            ps.Add(new Part_Status());
            ps[2].Part_Status_ID = 3;
            ps[2].Name = "In-Stock";
            ps.Add(new Part_Status());
            ps[3].Part_Status_ID = 4;
            ps[3].Name = "Returned";
            ps.Add(new Part_Status());
            ps[4].Part_Status_ID = 5;
            ps[4].Name = "Cancelled";

            string part_statuses = JsonConvert.SerializeObject(ps);

            return part_statuses;



        }

        [System.Web.Services.WebMethod]
        public static string addPart(Part part)
        {


            return part.Part_ID;

        }

    */
    }
}