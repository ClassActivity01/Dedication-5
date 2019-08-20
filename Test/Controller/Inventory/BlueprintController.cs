using Microsoft.Win32;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.Entity.Validation;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Inventory
{
    public class BlueprintController : ApiController
    {
        ProteusEntities db = new ProteusEntities();


        public string Put(int id)
        {
            try
            {
                NameValueCollection nvc = HttpContext.Current.Request.Form;
                string ID = nvc["Part_Type_ID"];
                

                string what = nvc["blueprints"];

                JArray bb = JArray.Parse(what);

                int k = 0;

                //Check if any blueprints should be removed
                foreach (JObject blueprint in bb)
                {
                    bool flag = (bool)blueprint["Removed"];

                    if (flag == true)
                    {
                        int b_ID = (int)blueprint["Blueprint_ID"];
                        string File_Type = (string)blueprint["File_Type"];


                        //Delete from db
                        db.Part_Blueprint.RemoveRange(db.Part_Blueprint.Where(x => x.Blueprint_ID == b_ID));


                        //Delete physical file
                        string newName = "Blueprint_" + b_ID + "_" + "PartType_" + ID + File_Type;

                        string completePath = HttpContext.Current.Server.MapPath("~/Files/") + newName;

                        if(System.IO.File.Exists(completePath))
                        {

                            System.IO.File.Delete(completePath);

                        }

                        k++;
                    }
                }

                int key = db.Part_Blueprint.Count() == 0 ? 1 : (from t in db.Part_Blueprint
                                                                orderby t.Blueprint_ID descending
                                                                select t.Blueprint_ID).First() + 1;

                for (int i = 0; i < HttpContext.Current.Request.Files.Count; i++)
                {
                    HttpPostedFileBase file = new HttpPostedFileWrapper(HttpContext.Current.Request.Files[i]); //Uploaded file
                                                                                                               //Use the following properties to get file's name, size and MIMEType
                    int fileSize = file.ContentLength;
                    string fileName = file.FileName;
                    string mimeType = file.ContentType;
                    System.IO.Stream fileContent = file.InputStream;




                    Model.Part_Blueprint pb = new Part_Blueprint();




                    string newName = "Blueprint_" + key + "_" + "PartType_" + ID + GetDefaultExtension(mimeType);

                    pb.Blueprint_ID = key;
                    pb.File_Type = GetDefaultExtension(mimeType);
                    pb.Name = fileName;
                    pb.Part_Type_ID = Convert.ToInt32(ID);
                    pb.location = "/Files/";

                    db.Part_Blueprint.Add(pb);

                    //To save file, use SaveAs method
                    file.SaveAs(HttpContext.Current.Server.MapPath("~/Files/") + newName); //File will be saved in application root

                    key++;
                }


                db.SaveChanges();
                return "true|Uploaded " + HttpContext.Current.Request.Files.Count + " files for part Type ID: " + ID + " and deleted " + k;

            }
            catch (DbEntityValidationException dbEx)
            {
                // Retrieve the error messages as a list of strings.
                var errorMessages = dbEx.EntityValidationErrors
                        .SelectMany(x => x.ValidationErrors)
                        .Select(x => x.ErrorMessage);

                // Join the list to a single string.
                var fullErrorMessage = string.Join("; ", errorMessages);

                // Combine the original exception message with the new one.
                var exceptionMessage = string.Concat(dbEx.Message, " The validation errors are: ", fullErrorMessage);

                return "false|Could not upload the files.|" + exceptionMessage;
            }
            catch (Exception ex)
            {
                return "false|Could not upload the files.|" + ex.ToString();
            }
        }


        public string Upload()
        {
            try
            {
                NameValueCollection nvc = HttpContext.Current.Request.Form;
                string ID = nvc["Part_Type_ID"];

                int key = db.Part_Blueprint.Count() == 0 ? 1 : (from t in db.Part_Blueprint
                                                                orderby t.Blueprint_ID descending
                                                                select t.Blueprint_ID).First() + 1;

                for (int i = 0; i < HttpContext.Current.Request.Files.Count; i++)
                {
                    HttpPostedFileBase file = new HttpPostedFileWrapper(HttpContext.Current.Request.Files[i]); //Uploaded file
                                                                                                               //Use the following properties to get file's name, size and MIMEType
                    int fileSize = file.ContentLength;
                    string fileName = file.FileName;
                    string mimeType = file.ContentType;
                    System.IO.Stream fileContent = file.InputStream;

                    
                   

                    Model.Part_Blueprint pb = new Part_Blueprint();

                    


                    string newName = "Blueprint_" + key + "_" + "PartType_" + ID + GetDefaultExtension(mimeType);

                    pb.Blueprint_ID = key;
                    pb.File_Type = GetDefaultExtension(mimeType);
                    pb.Name = fileName;
                    pb.Part_Type_ID = Convert.ToInt32(ID);
                    pb.location = "/Files/";

                    db.Part_Blueprint.Add(pb);

                    //To save file, use SaveAs method
                    file.SaveAs(HttpContext.Current.Server.MapPath("~/Files/") + newName); //File will be saved in application root

                    key++;
                }

                db.SaveChanges();
                return "true|Uploaded " + HttpContext.Current.Request.Files.Count + " files for part Type ID: " + ID;

            }
            catch (DbEntityValidationException dbEx)
            {
                // Retrieve the error messages as a list of strings.
                var errorMessages = dbEx.EntityValidationErrors
                        .SelectMany(x => x.ValidationErrors)
                        .Select(x => x.ErrorMessage);

                // Join the list to a single string.
                var fullErrorMessage = string.Join("; ", errorMessages);

                // Combine the original exception message with the new one.
                var exceptionMessage = string.Concat(dbEx.Message, " The validation errors are: ", fullErrorMessage);

                return "false|Could not upload the files.|" + exceptionMessage;
            }
            catch (Exception ex)
            {
                return "false|Could not upload the files.|" + ex.ToString();
            }

        }

        public static string GetDefaultExtension(string mimeType)
        {
            string result;
            RegistryKey key;
            object value;

            key = Registry.ClassesRoot.OpenSubKey(@"MIME\Database\Content Type\" + mimeType, false);
            value = key != null ? key.GetValue("Extension", null) : null;
            result = value != null ? value.ToString() : string.Empty;

            return result;
        }

        // GET: api/PartType/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    blueprints =
                        from p in db.Part_Blueprint
                        orderby p.Name
                        where p.Part_Type_ID == id
                        select new
                        {
                            Name = p.Name,
                            Blueprint_ID = p.Blueprint_ID,
                            File_Type = p.File_Type,
                            Removed = false
                        }
                });
                return "true|" + result.ToString();
            }
            
               
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "BluePrintController GET ID");
                return "false|Failed to retrieve blueprints for part type # "+id+".";
            }



}


        // DELETE: api/Blueprint/5
        public void Delete(int id)
        {




        }
    }
}
