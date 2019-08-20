using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _8_8 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [System.Web.Services.WebMethod]
        public static string getStatusName(int ID)
        {

            if (ID == 1)
                return "Active";
            else if (ID == 2)
                return "Broken";
            else
                return "Needs Maintenance";

        }
    }
}