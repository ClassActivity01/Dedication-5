using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

namespace Test.Controller
{
    public class BackUpController : ApiController
    {
        SqlConnection sqlcon = new SqlConnection();

        SqlCommand sqlcmd = new SqlCommand();


        public string back_up()
        {
            try
            {
                sqlcon.ConnectionString = "Data Source=localhost;Initial Catalog=Proteus;Integrated Security=True;MultipleActiveResultSets=True;Application Name=EntityFramework";
                string completePath = HttpContext.Current.Server.MapPath("~/Backup/");

                sqlcon.Open();
                sqlcmd = new SqlCommand("backup database Proteus to disk='" + completePath + "backup.Bak'", sqlcon);
                sqlcmd.ExecuteNonQuery();

                return "true|Database has been sucessfully backed up.";
            }
            catch (Exception ex)
            {
                ExceptionLog.LogException(ex, "Backup");
                return "false|Error during backup of database!|";// + ex.ToString();
            }


        }


        public string Get()
        {
            try
            {


                sqlcon.ConnectionString = "Data Source=localhost;Initial Catalog=Proteus;Integrated Security=True;MultipleActiveResultSets=True;Application Name=EntityFramework";
                sqlcon.Open();
                string completePath = HttpContext.Current.Server.MapPath("~/Backup/") + "backup.bak";

                sqlcmd = new SqlCommand("ALTER DATABASE Proteus SET SINGLE_USER WITH ROLLBACK IMMEDIATE", sqlcon);
                sqlcmd.ExecuteNonQuery();

                //string command = "RESTORE DATABASE B FROM DISK = '" + completePath + "'" +
                //                    "WITH MOVE 'DataFileLogicalName' TO 'C:\SQL Directory\DATA\B.mdf',"+
                //                    "MOVE 'LogFileLogicalName' TO 'C:\SQL Directory\DATA\B.ldf',"+
                //                    "REPLACE";

                sqlcmd = new SqlCommand("Restore database UsersDB from disk='"+completePath+"' ", sqlcon);
                sqlcmd.ExecuteNonQuery();

                sqlcmd = new SqlCommand("ALTER DATABASE Proteus SET MULTI_USER", sqlcon);
                sqlcmd.ExecuteNonQuery();

               


                return "true|Databas has been restored.";
            }
            catch (Exception ex)
            {
                ExceptionLog.LogException(ex, "Restore");
                return "false|Error during restore of database!|" + ex.ToString();
            }


        }
    }
}