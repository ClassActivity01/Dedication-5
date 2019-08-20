using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{
    public partial class _3_4 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

/*        [System.Web.Services.WebMethod]
        public static string getPartTypeDetails(int ID)
        {
            Part_Type pt = new Part_Type();
            pt.Part_Type_ID = 1;
            pt.Name = "Pump A";
            pt.Abbreviation = "VSH";
            pt.Average_Completion_Time = 0;
            pt.Description = "This is a pump";
            pt.Dimension = "23mm X 33mm X 24mm";
            pt.Manufactured = true;
            pt.Maximum_Level = 23;
            pt.Max_Discount_Rate = 33;
            pt.Minimum_Level = 10;
            pt.ml_pt = new List<Manual_Labour_Type_Part>();
            pt.ml_pt.Add(new Manual_Labour_Type_Part());
            pt.ml_pt[0].Manual_Labour_Type_ID = 1;
            pt.ml_pt[0].Stage_In_Manufacturing = 1;
            pt.ml_pt[0].Manual_Labour_Name = "Welding";
            pt.m_pt = new List<Machine_Part>();
            pt.m_pt.Add(new Machine_Part());
            pt.m_pt[0].Machine_ID = 1;
            pt.m_pt[0].Stage_In_Manufacturing = 2;
            pt.m_pt[0].Machine_Name = "Cutter";
            pt.ps = new List<Part_Supplier>();
            pt.ps.Add(new Part_Supplier());
            pt.ps[0].Is_Prefered = true;
            pt.ps[0].Supplier_ID = 1;
            pt.ps[0].unit_price = 123.33;
            pt.recipe = new List<Recipe>();
            pt.recipe.Add(new Recipe());
            pt.recipe[0].Quantity_Required = 2;
            pt.recipe[0].Recipe_ID = 1;
            pt.recipe[0].Recipe_Type = "Raw Material";
            pt.recipe[0].resouce_ID = 1;
            pt.recipe[0].Stage_in_Manufacturing = 1;
            pt.recipe[0].resouce_name = "Steel";
            pt.recipe[0].Quantity_Required = 3;
            pt.recipe.Add(new Recipe());
            pt.recipe[1].Quantity_Required = 22;
            pt.recipe[1].Recipe_ID = 2;
            pt.recipe[1].Recipe_Type = "Part Type";
            pt.recipe[1].resouce_ID = 2;
            pt.recipe[1].Stage_in_Manufacturing = 1;
            pt.recipe[1].resouce_name = "Pump A";
            pt.recipe[1].Quantity_Required = 3;

            pt.recipe.Add(new Recipe());
            pt.recipe[2].Quantity_Required = 2;
            pt.recipe[2].Recipe_ID = 3;
            pt.recipe[2].Recipe_Type = "Component";
            pt.recipe[2].resouce_ID = 1;
            pt.recipe[2].Stage_in_Manufacturing = 2;
            pt.Selling_Price = 22.34;
            pt.recipe[2].resouce_name = "Bolt";
            pt.recipe[2].Quantity_Required = 3;


            string rm = "True|" + JsonConvert.SerializeObject(pt);

            return rm;

        }

        [System.Web.Services.WebMethod]
        public static string updatePartType(Part_Type pt)
        {

            return "False|Removed";
        }

        [System.Web.Services.WebMethod]
        public static string deletePartType(int ID)
        {

            return "False|Removed";
        } */
    }
}