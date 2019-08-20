<%@ Page Title="Help" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="Test.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">

<script type="text/javascript">

    $(document).ready(function ($) {
        scrolltoPlace();

    });

    function scrolltoPlace()
    {
        var where = getUrlParameter('where');

        $('html, body').animate({
            scrollTop: $("#" + where).offset().top
        }, 2000);
    
    }

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };

</script>

    <h1 class="default-form-header">Help Document</h1><br />
    <form class="form-horizontal">
        <div id="Employee">
            <h2>Employees</h2>
            <div id="AddEmployee">
                <h3>Add Employee</h3>

            </div>
            <div id="MaintainEmployee">
                <h3>Maintain Employee</h3>

            </div>
            <div id="AddEmployeeCategory">
                <h3>Add Employee Category</h3>

            </div>
            <div id="MaintainEmployeeCategory">
                <h3>Maintain Employee Category</h3>

            </div>
            <div id="SearchEmployee">
                <h3>Search Employees</h3>

            </div>
        </div><br />

        <div id="Customer">
            <h2>Customers</h2>
            <div id="AddCustomer">
                <h3>Add Customer</h3>

            </div>
            <div id="MaintainCustomer">
                <h3>Maintain Customer</h3>

            </div>
            <div id="SearchCustomer">
                <h3>Search Customers</h3>

            </div>
        </div><br />

        <div id="Inventory">
            <h2>Inventory</h2>
            <div id="AddRawMaterial">
                <h3>Add Raw Material</h3>

            </div>
            <div id="MaintainRawMaterial">
                <h3>Maintain Raw Material</h3>

            </div>
            <div id="AddUniqueRawMaterial">
                <h3>Add Unique Raw Material</h3>

            </div>
            <div id="MaintainUniqueRawMaterial">
                <h3>Maintain Unique Raw Material</h3>

            </div>
            <div id="AddPartType">
                <h3>Add Part Type</h3>

            </div>
            <div id="MaintainPartType">
                <h3>Maintain Part Type</h3>

            </div>
            <div id="AddPart">
                <h3>Add Part</h3>

            </div>
            <div id="MaintainPart">
                <h3>Maintain Part</h3>

            </div>
            <div id="AddPartStatus">
                <h3>Add Part Status</h3>

            </div>
            <div id="MaintainPartStatus">
                <h3>Maintain Part Status</h3>

            </div>
            <div id="AddComponent">
                <h3>Add Component</h3>

            </div>
            <div id="MaintainComponent">
                <h3>Maintain Component</h3>

            </div>
            <div id="UpdatePartStatuses">
                <h3>Update Part Statuses</h3>

            </div>
            <div id="SearchInventory">
                <h3>Search Inventory</h3>

            </div>
        </div><br />

        <div id="Manufacturing">
            <h2>Manufacturing</h2>
            <div id="GenerateJobCard">
                <h3>Generate Job Card</h3>

            </div>
            <div id="MaintainJobCard">
                <h3>Maintain Job Card</h3>

            </div>
            <div id="AddManualLabourType">
                <h3>Add Manual Labour Type</h3>

            </div>
            <div id="MaintainManualLabourType">
                <h3>Maintain Manual Labour Type</h3>

            </div>
            <div id="GenerateProductionSchedule">
                <h3>Generate Production Schedule</h3>

            </div>
            <div id="MaintainProductionSchedule">
                <h3>Maintain Production Schedule</h3>

            </div>
            <div id="ViewProductionSchedule">
                <h3>View Production Schedule</h3>

            </div>
        </div><br />

        <div id="Supplier">
            <h2>Supplier</h2>
            <div id="AddSupplier">
                <h3>Add Supplier</h3>

            </div>
            <div id="MaintainSupplier">
                <h3>Maintain Supplier</h3>

            </div>
            <div id="AddSupplierQuote">
                <h3>Receive Supplier Quote</h3>

            </div>
            <div id="PlaceSupplierOrder">
                <h3>Place Purchase Order</h3>

            </div>
            <div id="MaintainSupplierOrder">
                <h3>Maintain Purchase Order</h3>

            </div>
            <div id="SearchSupplierOrder">
                <h3>Search Supplier Quote/Purchase Order</h3>

            </div>
            <div id="ReceivePurchaseOrder">
                <h3>Receive Purchase Order</h3>

            </div>
            <div id="ViewOustandingPurchaseOrders">
                <h3>View Outstanding Purchase Orders</h3>

            </div>
            <div id="SearchSupplier">
                <h3>Search Suppliers</h3>

            </div>
            <div id="GenerateGoodsReturnedNote">
                <h3>Generate Goods Returned Note</h3>

            </div>
        </div><br />

        <div id="Ordering">
            <h2>Ordering</h2>
            <div id="GenerateCustomerQuote">
                <h3>Generate Customer Order</h3>

            </div>
            <div id="PlaceCustomerOrder">
                <h3>Place Customer Order</h3>

            </div>
            <div id="MaintainCustomerOrder">
                <h3>Maintain Customer Order</h3>

            </div>
            <div id="GeneratePriceList">
                <h3>Generate Price List</h3>

            </div>
            <div id="GenerateDeliveryNote">
                <h3>Generate Delivery Note</h3>

            </div>
            <div id="GenerateInvoice">
                <h3>Generate Invoice</h3>

            </div>
            <div id="ViewOutstandingCustomerOrders">
                <h3>View Outstanding Customer Orders</h3>

            </div>
            <div id="FinaliseCustomerOrder">
                <h3>Finalise Customer Order</h3>

            </div>
            <div id="SearchCustomerOrders">
                <h3>Search Customer Quote/Order</h3>

            </div>
            <div id="MaintainVAT">
                <h3>Maintain VAT</h3>

            </div>
            <div id="GenerateCreditNote">
                <h3>Generate Customer Credit Note</h3>

            </div>
        </div><br />

        <div id="SubContractor">
            <h2>Sub-Contractors</h2>
            <div id="AddSubContractor">
                <h3>Add Sub-ontractor</h3>

            </div>
            <div id="MaintainSubContractor">
                <h3>Maintain Sub-Contractor</h3>

            </div>
            <div id="SearchSubContractor">
                <h3>Search Sub-Contractor</h3>

            </div>
        </div><br />

        <div id="Equipment">
            <h2>Equipment</h2>
            <div id="AddMachine">
                <h3>Add Machine</h3>

            </div>
            <div id="MaintainMachine">
                <h3>Maintain Machine</h3>

            </div>
            <div id="AddUniqueMachine">
                <h3>Add Unique Machine</h3>

            </div>
            <div id="MaintainUniqueMachine">
                <h3>Maintain Unique Machine</h3>

            </div>
            <div id="MaintainUniqueMachineStatus">
                <h3>Maintain Unique Machine Status</h3>

            </div>
            <div id="SearchMachine">
                <h3>Search Machines</h3>

            </div>
        </div>
    </form>
</asp:Content>
