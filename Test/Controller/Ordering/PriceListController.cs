using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Test.Model;

namespace Test.Controller.Ordering
{
    public class PriceListController : ApiController
    {
        ProteusEntities db = new ProteusEntities();

        // POST: api/PriceList
        public string Post(HttpRequestMessage value)
        {
            try
            {
                string message = HttpContext.Current.Server.UrlDecode(value.Content.ReadAsStringAsync().Result).Substring(5);
                JObject json = JObject.Parse(message);

                JObject clientDetails = (JObject)json["client"];
                JArray contactDetails = (JArray)clientDetails["contact_details"];
                JArray parts = (JArray)json["parts"];
                int c = (int)json["c_ID"];

                string to = (string)contactDetails[c]["Email_Address"];
                string subject = "WME Price List";

                string body = "Walter Meano Engineering Price List for " + (string)clientDetails["Name"] + "\n\nItems on Price List:\n";

                foreach (JObject part in parts)
                {


                    body += (string)part["Name"] + "\t\tR " + (decimal)part["Selling_Price"] + " per unit\n";
                }

                Email.SendEmail(to, subject, body);
                return "true|Price List successfully sent to " + to;
            }
            catch(Exception e)
            {
                ExceptionLog.LogException(e, "PriceListController");
                return "false|An error has occured sending the email to the customer.";
            }
        }
    }
}
