<%@ Page Title="Finalise Customer Order" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-7.aspx.cs" Inherits="Test._6_7" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<script src="scripts/MyScripts/tooltip.js"></script>
<script src="scripts/bootstrap.js"></script>
<style>
 .tooltip-inner
	{
		min-width:200px;
	}
</style>
<script>

    var searchedOrderes;
    var order_ID;
    var invoices;
    var payments = [];

    $(document).ready(function () {

        //On search
        $("#search_form").submit(function (event) {
            event.preventDefault();

            var method = $('input[name=optradio]:checked', '#search_form').val();
            var criteria = $('#search_criteria').val();
            var category = $('#search_category').val();

            $.ajax({
                type: "POST",
                url: "api/SearchCustomerOrder",
                data: { data: "{'method': '" + method + "', 'criteria' : '" + criteria + "', 'category' : '" + category + "'}" },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg) {
                    var result = msg.split("|");

                    if (result[0] == "true") {
                        searchedOrders = JSON.parse(result[1]).client_orders;

                        $('#order_Search_Result').empty();
                        if (searchedOrders.length == 0) {
                            $("#order_Search_Result").append("<option value=''>No results found.</option>");
                        }
                        else {
                            for (var k = 0; k < searchedOrders.length; k++) {

                                var date = searchedOrders[k].Date.split("T");


                                var html = '<option value="' + searchedOrders[k].Client_Order_ID + '">#' + searchedOrders[k].Client_Order_ID + ' - ' + searchedOrders[k].Client_Name + ' (' +
                                    date[0] + ')</option>';

                                $("#order_Search_Result").append(html);
                            }
                        }
                    }
                    else alertify.alert("Error", result[1]);
                }
            });
            $("#ResultModal").modal('show');
        });

        //On search results click
        $('#loadOrderDetails').on('click', function () {

            order_ID = $('#order_Search_Result').val();

            if (order_ID == "" || order_ID == null)
                alertify.alert('Error', 'No Client Order has been chosen!');
            else {
                $.ajax({
                    type: "GET",
                    url: "api/CustomerOrder/"+order_ID,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    error: function (xhr, ajaxOptions, thrownError) {
                        alert(xhr.status);
                        alert(xhr.responseText);
                        alert(thrownError);
                    },
                    success: function (msg) {
                        var result = msg.split("|");

                        if (result[0] == "true") {
                            var orderDetails = JSON.parse(result[1]).client_orders[0];

                            $("#order_ref").val(orderDetails.Reference_ID);

                            var date = orderDetails.Date.split("T");

                            $("#order_date").val(date[0]);

                            if (orderDetails.VAT_Inclu == true)
                                $("#order_vat").prop("checked", true);
                            $("#ResultModal").modal('hide');
                            $("#div_6_7").show();
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });


                $.ajax({
                    type: "GET",
                    url: "api/Invoice/"+order_ID,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    error: function (xhr, ajaxOptions, thrownError) {
                        alert(xhr.status);
                        alert(xhr.responseText);
                        alert(thrownError);
                    },
                    success: function (msg) {
                        var result = msg.split("|");
                        

                        if (result[0] == "true") {
                            invoices = JSON.parse(result[1]).invoices;

                            $("#Items").empty();
                            
                            for (var k = 0; k < invoices.length; k++)
                            {
                                //alert(JSON.stringify(invoices[k].ip));
                                var amount_due = invoices[k].amount_Vat;
                                var amount_received = 0;
                                var date_received = (new Date()).toISOString().split("T");

                                for(var a = 0; a < invoices[k].ip.length; a++)
                                {
                                        amount_due = amount_due - invoices[k].ip[a].Amount_Paid;
                                }

                                var row = '<tr>'+
						                    '<td>'+ invoices[k].Invoice_ID +'</td>'+
						                    '<td>R' + invoices[k].amount_noVat + '</td>' +
                                            '<td>R' + invoices[k].amount_Vat + '</td>' +
						                    '<td>R'+ amount_due +'</td>'+
						                    '<td><input type="number" title = "Amount received" id="rec_' + invoices[k].Invoice_ID + '" value="0" min="0" max="'+ amount_due +'" step="0.01" /></td>' +
						                    '<td>'+ date_received[0] +'</td>'+
						                    '<td>' + invoices[k].Invoice_Status_Name + '</td>' +
						                    '</tr>';

                                var pay = { Invoice_ID: invoices[k].Invoice_ID, Payment_Date: date_received[0], Amount_Paid : 0, Amount_Due: amount_due };
                                payments.push(pay);

                                $("#Items").append(row);
                            }
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });

                }
            });
    });



    function finaliseOrder()
    {

        var warnings = "";

        if (order_ID == "" || order_ID == null || order_ID == "Choose") {
            warnings = warnings + "No Order has been specified. <br/>";
        }

        if (invoices.length <= 0)
            warnings += "This order has no invoices. <br/>";

        for (var a = 0; a < invoices.length; a++)
        {
            var ID = payments[a].Invoice_ID;
            var payment = $("#rec_" + ID).val();
            payments[a].Amount_Paid = payment;

            if (payment < 0)
            {
                $("#rec_" + ID).addClass("empty");
                warnings += "Cannot have negative payments. <br/>";
            }
            else if (payment > $("#rec_" + ID).attr("max"))
            {
                $("#rec_" + ID).addClass("empty");
                warnings += "Payment is more than amount due. <br/>";
            }
                
        }

        //alert("{'invoices' : " + JSON.stringify(payments) + ", 'ID' : '" + order_ID + "'}");

        $("#w_info").html(warnings);
        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/FinaliseOrder",
                data: { data: "{'invoices' : " + JSON.stringify(payments) + ", 'ID' : '" + order_ID + "'}" },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                },
                success: function (msg) {
                    var result = msg.split("|");

                    if (result[0] == "true") {
                        alertify.alert('Successful', result[1], function () { location.reload(); });
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });
        }

        return false;
    }
</script>

<h1 class="default-form-header">Finalise Customer Order</h1>
		
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Customer Order: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the customer order details to search for" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the customer order details to search by" data-toggle ="tooltip" data-placement ="bottom">
					<option value="All">All</option>
					<option value="ID">Reference No.</option>
					<option value="CID">Customer Order No.</option>
					<option value="CName">Customer Name</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>
	
				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
				</div>
				<div class="col-sm-4">
					<button id="submitSearch" type ="submit" class ="searchButton" title ="Click to search for customer order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		</fieldset>
	</form>
</div>
		
<!-- MODAL CODE -->
		
<div class="modal fade" id="ResultModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Select a Customer Order</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="order_Search_Result" title ="Select the customer order">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadOrderDetails" title ="Click to load order details">Load Order Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<br/>
<!-- FORM CODE -->
<div id="div_6_7" style="display : none">
<form id="UC6-7" class="form-horizontal">
	<fieldset>
		<legend>Order Information:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="order_ref" class="control-label">Reference No.: </label>
				<input type="text" class="form-control" id="order_ref" readonly>
			</div>
			<div class="col-sm-6">
				<label for="order_date" class="control-label">Order Date: </label>
				<input type="date" class="form-control" id="order_date"  readonly>
			</div>
			<div class="col-sm-6">
				<label for="order_vat" class="control-label">VAT Included: </label><br/>
				<input type="checkbox" id="order_vat" checked disabled>
			</div>
		</div>
	</fieldset>
	<br/>
			
	<fieldset id="partsFieldset">
		<legend>Invoice Information:</legend>
		<div class="table-responsive">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>Invoice No.</th>
						<th>Total (Vat Excl.)</th>
                        <th>Total</th>
						<th>Amount Due R</th>
						<th>Amount Received R</th>
						<th>Date Generated</th>
						<th>Payment Status</th>
					</tr>
				</thead>
				<tbody id="Items">
				</tbody>
			</table>
		</div> 	
	</fieldset>
			
	<br/>
    <div>
        <div class="Warning_Info" id="w_info"></div>
    </div>
	<div class="row">
        <div class="col-sm-8">
			
		</div>	
		<div class="col-sm-4">
			<button onclick="return finaliseOrder()" class = "form-custom-button-columns" title ="Click to reconcile customer order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-wrench" aria-hidden="true"></i> Reconcile</button>
		</div>	
	</div>
</form>
</div>
</asp:Content>
