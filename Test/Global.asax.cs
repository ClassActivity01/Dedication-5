using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Routing;
using System.Web.Http;
using System.Net.Http.Headers;

namespace Test
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            RegisterRoutes(RouteTable.Routes);
            GlobalConfiguration.Configure(WebApiConfigRegister);
        }

        static void RegisterRoutes(RouteCollection routes)
        {
            routes.MapPageRoute("AddEmployeeRoute", "AddEmployee", "~/1-1.aspx");
            routes.MapPageRoute("MaintainEmployeeRoute", "MaintainEmployee", "~/1-2.aspx");
            routes.MapPageRoute("AddEmployeeTypeRoute", "AddEmployeeCategory", "~/1-3.aspx");
            routes.MapPageRoute("MaintainEmployeeTypeRoute", "MaintainEmployeeCategory", "~/1-4.aspx");
            routes.MapPageRoute("SearchEmployeeRoute", "SearchEmployee", "~/1-5.aspx");

            routes.MapPageRoute("AddCustomerRoute", "AddCustomer", "~/2-1.aspx");
            routes.MapPageRoute("MaintainCustomerRoute", "MaintainCustomer", "~/2-2.aspx");
            routes.MapPageRoute("SearchCustomerRoute", "SearchCustomer", "~/2-3.aspx");

            routes.MapPageRoute("AddRawMaterialRoute", "AddRawMaterial", "~/3-1.aspx");
            routes.MapPageRoute("MaintainRawMaterialRoute", "MaintainRawMaterial", "~/3-2.aspx");
            routes.MapPageRoute("AddPartTypeRoute", "AddPartType", "~/3-3.aspx");
            routes.MapPageRoute("MaintainPartTypeRoute", "MaintainPartType", "~/3-4.aspx");
            routes.MapPageRoute("AddPartRoute", "AddPart", "~/3-5.aspx");
            routes.MapPageRoute("MaintainPartRoute", "MaintainPart", "~/3-6.aspx");
            routes.MapPageRoute("SearchInventoryRoute", "SearchInventory", "~/3-7.aspx");
            routes.MapPageRoute("AddPartStatusRoute", "AddPartStatus", "~/3-8.aspx");
            routes.MapPageRoute("MaintainPartStatusRoute", "MaintainPartStatus", "~/3-9.aspx");
            routes.MapPageRoute("AddUniqueRawMaterialRoute", "AddUniqueRawMaterial", "~/3-10.aspx");
            routes.MapPageRoute("MaintainUniqueRawMaterialRoute", "MaintainUniqueRawMaterial", "~/3-11.aspx");
            routes.MapPageRoute("AddComponentRoute", "AddComponent", "~/3-12.aspx");
            routes.MapPageRoute("MaintainComponentRoute", "MaintainComponent", "~/3-13.aspx");
            routes.MapPageRoute("UpdatePartStatusesRoute", "UpdatePartStatuses", "~/3-15.aspx");

            routes.MapPageRoute("GenerateJobCardRoute", "GenerateJobCard", "~/4-1.aspx");
            routes.MapPageRoute("MaintainJobCardRoute", "MaintainJobCard", "~/4-2.aspx");
            routes.MapPageRoute("AddManualLabourTypeRoute", "AddManualLabourType", "~/4-4.aspx");
            routes.MapPageRoute("MaintainManualLabourTypeRoute", "MaintainManualLabourType", "~/4-5.aspx");
            routes.MapPageRoute("ViewProductionScheduleRoute", "ViewProductionSchedule", "~/4-8.aspx");
            routes.MapPageRoute("MaintainProductionScheduleRoute", "MaintainProductionSchedule", "~/4-7.aspx");
            routes.MapPageRoute("GenerateProductionScheduleRoute", "GenerateProductionSchedule", "~/4-6.aspx");
            routes.MapPageRoute("ViewJobCardsRoute", "ViewJobCards", "~/4-9.aspx");

            routes.MapPageRoute("AddSupplierRoute", "AddSupplier", "~/5-1.aspx");
            routes.MapPageRoute("MaintainSupplierRoute", "MaintainSupplier", "~/5-2.aspx");
            routes.MapPageRoute("AddSupplierQuoteRoute", "AddSupplierQuote", "~/5-3.aspx");
            routes.MapPageRoute("PlaceSupplierOrderRoute", "PlaceSupplierOrder", "~/5-4.aspx");
            routes.MapPageRoute("MaintainSupplierOrderRoute", "MaintainSupplierOrder", "~/5-5.aspx");
            routes.MapPageRoute("SearchSupplierOrderRoute", "SearchSupplierOrder", "~/5-6-7.aspx");
            routes.MapPageRoute("ReceivePurchaseOrderRoute", "ReceivePurchaseOrder", "~/5-8.aspx");
            routes.MapPageRoute("ViewOustandingPurchaseOrdersRoute", "ViewOustandingPurchaseOrders", "~/5-9.aspx");
            routes.MapPageRoute("GenerateGoodsReturnedNoteRoute", "GenerateGoodsReturnedNote", "~/5-10.aspx");
            routes.MapPageRoute("SearchSupplierRoute", "SearchSupplier", "~/5-11.aspx");

            routes.MapPageRoute("GenerateCustomerQuoteRoute", "GenerateCustomerQuote", "~/6-1.aspx");
            routes.MapPageRoute("PlaceCustomerOrderRoute", "PlaceCustomerOrder", "~/6-2.aspx");
            routes.MapPageRoute("GeneratePriceListRoute", "GeneratePriceList", "~/6-3.aspx");
            routes.MapPageRoute("MaintainCustomerOrderRoute", "MaintainCustomerOrder", "~/6-4.aspx");
            routes.MapPageRoute("GenerateDeliveryNoteRoute", "GenerateDeliveryNote", "~/6-5.aspx");
            routes.MapPageRoute("GenerateInvoiceRoute", "GenerateInvoice", "~/6-6.aspx");
            routes.MapPageRoute("FinaliseCustomerOrderRoute", "FinaliseCustomerOrder", "~/6-7.aspx");
            routes.MapPageRoute("ViewOutstandingCustomerOrdersRoute", "ViewOutstandingCustomerOrders", "~/6-8.aspx");
            routes.MapPageRoute("SearchCustomerOrdersRoute", "SearchCustomerOrders", "~/6-9-10.aspx");
            routes.MapPageRoute("MaintainVATRoute", "MaintainVAT", "~/6-11.aspx");
            routes.MapPageRoute("GenerateCreditNoteRoute", "GenerateCreditNote", "~/6-12.aspx");

            routes.MapPageRoute("AddSubContractorRoute", "AddSubContractor", "~/7-1.aspx");
            routes.MapPageRoute("MaintainSubContractorRoute", "MaintainSubContractor", "~/7-2.aspx");
            routes.MapPageRoute("SearchSubContractorRoute", "SearchSubContractor", "~/7-3.aspx");

            routes.MapPageRoute("AddMachineRoute", "AddMachine", "~/8-1.aspx");
            routes.MapPageRoute("MaintainMachineRoute", "MaintainMachine", "~/8-2.aspx");
            routes.MapPageRoute("AddUniqueMachineRoute", "AddUniqueMachine", "~/8-3.aspx");
            routes.MapPageRoute("MaintainUniqueMachineRoute", "MaintainUniqueMachine", "~/8-4.aspx");
            routes.MapPageRoute("MaintainUniqueMachineStatusRoute", "MaintainUniqueMachineStatus", "~/8-5.aspx");
            routes.MapPageRoute("SearchMachinesRoute", "SearchMachine", "~/8-8.aspx");

            routes.MapPageRoute("LoginRoute", "Login", "~/Login.aspx");
            routes.MapPageRoute("LandingRoute", "Home", "~/Landing.aspx");
            routes.MapPageRoute("ReportsRoute", "Reports", "~/9-1.aspx");
        }

        public static void WebApiConfigRegister(HttpConfiguration config)
        {
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            config.Formatters.JsonFormatter.SupportedMediaTypes.Add(new MediaTypeHeaderValue("text/html"));
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}