using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Test.Controller;

namespace Test
{
    public partial class Landing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        static SqlConnection sqlcon;
       
        static SqlCommand sqlcmd;

        [System.Web.Services.WebMethod]
        public static string restore()
        {
            try
            {


                sqlcon.ConnectionString = (System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ToString());
                sqlcon.Open();
                string destdir = "C:\\backupdb\\11082014_121403.Bak";

                sqlcmd = new SqlCommand("Restore database UsersDB from disk='C:11082014_143650.Bak' ", sqlcon);
                sqlcmd.ExecuteNonQuery();


                return "true|Databas has been restored.";
            }
            catch (Exception ex)
            {
                ExceptionLog.LogException(ex, "Restore");
                return "false|Error during restore of database!";
            }


        }

        /*
        private static string sendSms(string code, string cellphone)
        {
            try
            {
                string sURL = "http://www.stepsdatabase.com/sms4pro/smsOUT.aspx";
                sURL += "?sUser=" + "natasha";
                sURL += "&sPass=" + "Tiekie";
                sURL += "&sVs=1.1";
                sURL += "&sDomain=" + "sms4pro.com";
                sURL += "&cellNum=" + cellphone;
                sURL += "&from=35528";
                sURL += "&messID=" + "1";
                sURL += "&msg=" + "This is your special code: " + code;
                sURL += "&comp=" + "Lenono";


                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(sURL);

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                Stream resStream = response.GetResponseStream();
                string var = resStream.ToString();

                return "True|" + var;
            }
            catch (Exception ex)
            {
                return "False| " + ex.ToString();

            }
        }*/

    }
}