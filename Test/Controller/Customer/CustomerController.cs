using Newtonsoft.Json.Linq;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;
using System.Text;
using System;
using System.Collections.Generic;

namespace Test.Controller
{
    public class CustomerController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // GET: api/Customer
        public string Get()
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    clients =
                        from p in db.Clients
                        orderby p.Name
                        select new
                        {
                            Client_ID = p.Client_ID,
                            Name = p.Name,
                            Address = p.Address,
                            City = p.City,
                            Zip = p.Zip,
                            Overdue_Payment = p.Overdue_Payment,
                            Vat_Number = p.Vat_Number,
                            Account_Name = p.Account_Name,
                            Contract_Discount_Rate = p.Contract_Discount_Rate,
                            Client_Status = p.Client_Status,
                            Province_ID = p.Province_ID,
                            Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                            contact_details =
                                from d in db.Client_Contact_Person_Detail
                                where d.Client_ID == p.Client_ID
                                orderby d.Name
                                select new
                                {
                                    Contact_ID = d.Contact_ID,
                                    Name = d.Name,
                                    Number = d.Number,
                                    Job_Description = d.Job_Description,
                                    Email_Address = d.Email_Address
                                },

                            part_discounts = 
                                from pd in db.Client_Discount_Rate
                                where pd.Client_ID == p.Client_ID
                                select new
                                {
                                    Discount_Rate = pd.Discount_Rate,
                                    Part_Type_ID = pd.Part_Type_ID,
                                    Part_Type_Name = pd.Part_Type.Name,
                                    Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerController GET");
                return "false|Failed to retrieve Customers.";
            }
        }

        // GET: api/Customer/5
        public string Get(int id)
        {
            try
            {
                JObject result = JObject.FromObject(new
                {
                    clients =
                        from p in db.Clients
                        where p.Client_ID == id
                        orderby p.Name
                        select new
                        {
                            Client_ID = p.Client_ID,
                            Name = p.Name,
                            Address = p.Address,
                            City = p.City,
                            Zip = p.Zip,
                            Overdue_Payment = p.Overdue_Payment,
                            Vat_Number = p.Vat_Number,
                            Account_Name = p.Account_Name,
                            Contract_Discount_Rate = p.Contract_Discount_Rate,
                            Client_Status = p.Client_Status,
                            Province_ID = p.Province_ID,
                            Settlement_Discount_Rate = p.Settlement_Discount_Rate,

                            contact_details =
                                from d in db.Client_Contact_Person_Detail
                                where d.Client_ID == p.Client_ID
                                orderby d.Name
                                select new
                                {
                                    Contact_ID = d.Contact_ID,
                                    Name = d.Name,
                                    Number = d.Number,
                                    Job_Description = d.Job_Description,
                                    Email_Address = d.Email_Address
                                },

                            part_discounts =
                                from pd in db.Client_Discount_Rate
                                where pd.Client_ID == p.Client_ID
                                select new
                                {
                                    Discount_Rate = pd.Discount_Rate,
                                    Part_Type_ID = pd.Part_Type_ID,
                                    Part_Type_Name = pd.Part_Type.Name,
                                    Part_Type_Abbreviation = pd.Part_Type.Abbreviation
                                }
                        }
                });
                return "true|" + result.ToString();
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerController GET ID");
                return "false|Failed to retrieve Customer.";
            }
        }

        // POST: api/Customer
        public string Post(HttpRequestMessage value)
        {
            try
            {
                Model.Client client = new Model.Client();
                
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject clientDetails = (JObject)json["client"];
                JArray partDiscounts = (JArray)json["discounts"];
                JArray contactDetails = (JArray)json["contacts"];

                int key = db.Clients.Count() == 0 ? 1 : (from t in db.Clients
                                                           orderby t.Client_ID descending
                                                           select t.Client_ID).First() + 1;
                client.Client_ID = key;
                client.Name = (string)clientDetails["Name"];
                client.Address = (string)clientDetails["Address"];
                client.City = (string)clientDetails["City"];
                client.Zip = (string)clientDetails["Zip"];
                client.Overdue_Payment = 0;
                client.Vat_Number = (string)clientDetails["Vat_Number"];
                client.Account_Name = (string)clientDetails["Account_Name"];
                client.Contract_Discount_Rate = (int)clientDetails["Contract_Discount_Rate"];
                client.Client_Status = Convert.ToBoolean(Convert.ToInt32(clientDetails["Client_Status"]));
                client.Province_ID = (int)clientDetails["Province_ID"];
                client.Settlement_Discount_Rate = (int)clientDetails["Settlement_Discount_Rate"];

                string errorString = "false|";
                bool error = false;

                if ((from t in db.Clients
                     where t.Name == client.Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer Name entered already exists on the system. ";
                }

                if ((from t in db.Clients
                     where t.Name == client.Vat_Number
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer VAT Number entered already exists on the system. ";
                }
                
                if ((from t in db.Clients
                     where t.Address == client.Address && t.City == client.City && t.Zip == client.Zip
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer Address entered already exists on the system. ";
                }

                if ((from t in db.Clients
                     where t.Vat_Number == client.Vat_Number && client.Vat_Number != ""
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer VAT Number entered already exists on the system. ";
                }

                if ((from t in db.Clients
                     where t.Account_Name == client.Account_Name
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer VAT Number entered already exists on the system. ";
                }

                if (error)
                    return errorString;

                db.Clients.Add(client);

                int contact_key = db.Client_Contact_Person_Detail.Count() == 0 ? 1 : (from t in db.Client_Contact_Person_Detail
                                                                                  orderby t.Contact_ID descending
                                                                                  select t.Contact_ID).First() + 1;

                foreach (JObject contact in contactDetails)
                {
                    Client_Contact_Person_Detail ccpd = new Client_Contact_Person_Detail();
                    ccpd.Contact_ID = contact_key;
                    contact_key++;
                    ccpd.Client_ID = key;

                    ccpd.Number = (string)contact["Number"];
                    ccpd.Name = (string)contact["Name"];
                    ccpd.Job_Description = (string)contact["Job_Description"];
                    ccpd.Email_Address = (string)contact["Email_Address"];

                    errorString = "false|";
                    error = false;

                    if ((from t in db.Client_Contact_Person_Detail
                         where t.Email_Address == ccpd.Email_Address
                         select t).Count() != 0)
                    {
                        error = true;
                        errorString += "The Customer Contact Email for "+ccpd.Name+" entered already exists on the system. ";
                    }

                    if ((from t in db.Client_Contact_Person_Detail
                         where t.Number == ccpd.Number
                         select t).Count() != 0)
                    {
                        error = true;
                        errorString += "The Customer Contact Number for " + ccpd.Name + " entered already exists on the system. ";
                    }

                    if (error)
                        return errorString;

                    db.Client_Contact_Person_Detail.Add(ccpd);
                }

                foreach (JObject part in partDiscounts)
                {
                    Client_Discount_Rate cdr = new Client_Discount_Rate();

                    cdr.Client_ID = key;
                    cdr.Part_Type_ID = (int)part["Part_Type_ID"];
                    cdr.Discount_Rate = (float)part["Discount_Rate"];

                    db.Client_Discount_Rate.Add(cdr);
                }

                db.SaveChanges();
                return "true|Customer # "+key+" successfully added.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerController POST");
                return "false|An error has occured adding the Customer to the system.";
            }
        }

        // PUT: api/Customer/5
        public string Put(int id, HttpRequestMessage value)
        {
            try
            {
                Client client = new Client();
                client = (from p in db.Clients
                             where p.Client_ID == id
                             select p).First();

                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject clientDetails = (JObject)json["client"];
                JArray partDiscounts = (JArray)json["discounts"];
                JArray contactDetails = (JArray)json["contacts"];

                client.Name = (string)clientDetails["Name"];
                client.Address = (string)clientDetails["Address"];
                client.City = (string)clientDetails["City"];
                client.Zip = (string)clientDetails["Zip"];
                client.Vat_Number = (string)clientDetails["Vat_Number"];
                client.Account_Name = (string)clientDetails["Account_Name"];
                client.Contract_Discount_Rate = (int)clientDetails["Contract_Discount_Rate"];
                client.Client_Status = Convert.ToBoolean(Convert.ToInt32(clientDetails["Client_Status"]));
                client.Province_ID = (int)clientDetails["Province_ID"];
                client.Settlement_Discount_Rate = (int)clientDetails["Settlement_Discount_Rate"];


                string errorString = "false|";
                bool error = false;

                if ((from t in db.Clients
                     where t.Name == client.Name && t.Client_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer Name entered already exists on the system. ";
                }

                if ((from t in db.Clients
                     where t.Name == client.Vat_Number && t.Client_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer VAT Number entered already exists on the system. ";
                }

                if ((from t in db.Clients
                     where (t.Address == client.Address && t.City == client.City && t.Zip == client.Zip) && t.Client_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer address entered already exists on the system. ";
                }

                if ((from t in db.Clients
                     where (t.Vat_Number == client.Vat_Number && client.Vat_Number != "") && t.Client_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer VAT Number entered already exists on the system. ";
                }

                if ((from t in db.Clients
                     where t.Account_Name == client.Account_Name && t.Client_ID != id
                     select t).Count() != 0)
                {
                    error = true;
                    errorString += "The Customer VAT Number entered already exists on the system. ";
                }

                if (error)
                    return errorString;


                int contact_id = db.Client_Contact_Person_Detail.Count() == 0 ? 1 : (from t in db.Client_Contact_Person_Detail
                                                                                      orderby t.Contact_ID descending
                                                                                      select t.Contact_ID).First() + 1;
                List<Client_Contact_Person_Detail> clientUpdated = new List<Client_Contact_Person_Detail>();
                foreach (JObject contact in contactDetails)
                {
                    string email = (string)contact["Email_Address"];
                    Client_Contact_Person_Detail ccpd = new Client_Contact_Person_Detail();
                    ccpd = (from p in db.Client_Contact_Person_Detail
                            where p.Email_Address == email
                            select p).FirstOrDefault();

                    if(ccpd != null)
                    {
                        ccpd.Number = (string)contact["Number"];
                        ccpd.Name = (string)contact["Name"];
                        ccpd.Job_Description = (string)contact["Job_Description"];
                        ccpd.Email_Address = (string)contact["Email_Address"];

                        errorString = "false|";
                        error = false;

                        if ((from t in db.Client_Contact_Person_Detail
                             where t.Email_Address == ccpd.Email_Address && t.Contact_ID != ccpd.Contact_ID
                             select t).Count() != 0)
                        {
                            error = true;
                            errorString += "The Customer Contact Email for " + ccpd.Name + " entered already exists on the system. ";
                        }

                        if ((from t in db.Client_Contact_Person_Detail 
                             where t.Number == ccpd.Number && t.Contact_ID != ccpd.Contact_ID
                             select t).Count() != 0)
                        {
                            error = true;
                            errorString += "The Customer Contact Number for " + ccpd.Name + " entered already exists on the system. ";
                        }

                        if (error)
                            return errorString;

                        clientUpdated.Add(ccpd);
                    }
                    else
                    {
                        ccpd = new Client_Contact_Person_Detail();
                        ccpd.Client_ID = id;
                        ccpd.Contact_ID = contact_id;
                        contact_id++;
                        ccpd.Number = (string)contact["Number"];
                        ccpd.Name = (string)contact["Name"];
                        ccpd.Job_Description = (string)contact["Job_Description"];
                        ccpd.Email_Address = (string)contact["Email_Address"];

                        errorString = "false|";
                        error = false;

                        if ((from t in db.Client_Contact_Person_Detail
                             where t.Email_Address == ccpd.Email_Address
                             select t).Count() != 0)
                        {
                            error = true;
                            errorString += "The Customer Contact Email for " + ccpd.Name + " entered already exists on the system. ";
                        }

                        if ((from t in db.Client_Contact_Person_Detail
                             where t.Number == ccpd.Number
                             select t).Count() != 0)
                        {
                            error = true;
                            errorString += "The Customer Contact Number for " + ccpd.Name + " entered already exists on the system. ";
                        }

                        if (error)
                            return errorString;

                        db.Client_Contact_Person_Detail.Add(ccpd);
                        clientUpdated.Add(ccpd);
                    }
                }

                List<Client_Contact_Person_Detail> clientContacts = new List<Client_Contact_Person_Detail>();
                clientContacts = (from p in db.Client_Contact_Person_Detail
                                  where p.Client_ID == client.Client_ID
                                  select p).ToList();

                foreach(Client_Contact_Person_Detail clientC in clientContacts)
                {
                    if (!clientUpdated.Contains(clientC))
                    {
                        try
                        {
                            var itemToRemove = db.Client_Contact_Person_Detail.SingleOrDefault(x => x.Contact_ID == clientC.Contact_ID);
                            if (itemToRemove != null)
                            {
                                db.Client_Contact_Person_Detail.Remove(itemToRemove);
                                db.SaveChanges();
                            }

                            return "true|The Customer Contact "+clientC.Name+" has successfully been removed from the system.";
                        }
                        catch
                        {
                            return "false|The Customer Contact " + clientC.Name + " is in use and cannot be removed from the system.";
                        }
                    }
                }


                db.Client_Discount_Rate.RemoveRange(db.Client_Discount_Rate.Where(x => x.Client_ID == id));

                foreach (JObject part in partDiscounts)
                {
                    Client_Discount_Rate cdr = new Client_Discount_Rate();

                    cdr.Client_ID = client.Client_ID;
                    cdr.Part_Type_ID = (int)part["Part_Type_ID"];
                    cdr.Discount_Rate = (float)part["Discount_Rate"];

                    db.Client_Discount_Rate.Add(cdr);
                }

                db.SaveChanges();
                return "true|Customer successfully updated.";
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "CustomerController PUT");
                return "false|An error has occured updating the Customer on the system.";
            }
        }

        // DELETE: api/Customer/5
        public string Delete(int id)
        {
            try
            {
                var itemToRemove = db.Clients.SingleOrDefault(x => x.Client_ID == id);
                db.Client_Contact_Person_Detail.RemoveRange(db.Client_Contact_Person_Detail.Where(x => x.Client_ID == id));
                db.Client_Discount_Rate.RemoveRange(db.Client_Discount_Rate.Where(x => x.Client_ID == id));
                if (itemToRemove != null)
                {
                    db.Clients.Remove(itemToRemove);
                    db.SaveChanges();
                }

                return "true|The Customer has successfully been removed from the system.";
            }
            catch (Exception e)
            {
                ExceptionLog.LogException(e, "CustomerController DELETE");
                return "false|The Customer is in use and cannot be removed from the system.";
            }
        }
    }
}
