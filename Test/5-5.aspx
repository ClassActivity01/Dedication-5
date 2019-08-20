<%@ Page Title="Maintain Purchase Order" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-5.aspx.cs" Inherits="Test._5_5" %>
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
    var order_ID;
    var searchedOrders;
    var vat_rate = 14;
    $(document).ready(function () {

        vat_rate = getVATRate();


        $.ajax({
            type: "GET",
            url: "api/SupplierOrderStatus",
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
                    var status = JSON.parse(result[1]).supplier_order_statuses;

                    //console.log(status);
                    $('#order_status').empty();

                    for (var k = 0; k < status.length; k++) {
                        var html = '<option value="' + status[k].Supplier_Order_Status_ID + '">' + status[k].Name + '</option>';

                        $("#order_status").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });

        $("#UC5-5").submit(function (event) {
            event.preventDefault();
            var status_id = $('#order_status').val();

            $.ajax({
                type: "PUT",
                url: "api/SupplierOrder/" + order_ID,
                data: { data: JSON.stringify({ Supplier_Order_Status_ID : status_id}) },
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
        });

        $("#search_form").submit(function (event) {
            event.preventDefault();

            var method = $('input[name=optradio]:checked', '#search_form').val()
            var criteria = $('#search_criteria').val();
            var category = $('#search_category').val();

            $.ajax({
                type: "POST",
                url: "api/SearchSupplierOrder",
                data: { data: "{'method': '" + method + "', 'criteria' : '" + criteria + "', 'category' : '" + category + "'}" },
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
                        searchedOrders = JSON.parse(result[1]).supplier_orders;

                        $('#supplier_Search_Result').empty();

                        for (var k = 0; k < searchedOrders.length; k++) {
                            var date = searchedOrders[k].Date.split("T");

                            var html = '<option value="' + searchedOrders[k].Supplier_Order_ID + '">' + searchedOrders[k].Supplier_Order_ID + " - " +searchedOrders[k].Supplier_Name + ' (' + date[0] + ')</option>';

                            $("#supplier_Search_Result").append(html);
                        }
                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
            $("#ResultModal").modal('show');
        });

        //On search results click
        $('#loadSupplierDetailsButton').on('click', function () {
            order_ID = $("#supplier_Search_Result").val();

            if (order_ID == null || order_ID == "") {
                alertify.alert("No Purchase Order has been chosen.");
            }
            else {
                $.ajax({
                    type: "GET",
                    url: "api/SupplierOrder/"+order_ID,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    },
                    success: function (msg) {
                        var result = msg.split("|");

                        if (result[0] == "true") {
                            var order_details = JSON.parse(result[1]).supplier_orders[0];
                            var row;
                            $("#Order_Items").empty();
                            var total = 0;

                            var date = order_details.Date.split("T");

                            $("#supplier_Name").val(order_details.Supplier_Name);
                            $("#supplier_ID").val(order_details.Supplier_ID);
                            $("#Order_date").val(date[0]);
                            $("#order_ID").val(order_ID);

                            $("#item_ID").html("#" + order_ID + " ");

                            var value = order_details.Supplier_Order_Status_ID;
                            $("#order_status > option[value='" + value + "']").prop("selected", true);
                            $("#ResultModal").modal('hide');

                            for (var k = 0; k < order_details.cs.length; k++) {

                                row = '<tr><td>' + order_details.cs[k].Component_ID + '</td><td>Component</td><td>' + order_details.cs[k].Component_Name
                                    + '</td><td>' + order_details.cs[k].Quantity_Requested + '</td><td>' + order_details.cs[k].Quantity_Received + '</td><td>R ' + order_details.cs[k].Price + '</td></tr>';

                                total = total + (order_details.cs[k].Price * order_details.cs[k].Quantity_Requested);

                                $("#Order_Items").append(row);
                            }

                            for (var k = 0; k < order_details.ps.length; k++) {

                                row = '<tr><td>' + order_details.ps[k].Part_Type_ID + '</td><td>Part Type</td><td>' + order_details.ps[k].Part_Type_Name
                                    + '</td><td>' + order_details.ps[k].Quantity + '</td><td>' + order_details.ps[k].Quantity_Received + '</td><td>R ' + order_details.ps[k].Price + '</td></tr>';

                                total = total + (order_details.ps[k].Price * order_details.ps[k].Quantity);


                                $("#Order_Items").append(row);
                            }

                            for (var k = 0; k < order_details.rms.length; k++) {

                                row = '<tr><td>' + order_details.rms[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + order_details.rms[k].Raw_Material_Name
                                    + ' (' + order_details.rms[k].Dimensions + ')</td><td>' + order_details.rms[k].Quantity + '</td><td>' + order_details.rms[k].Quantity_Received + '</td><td>R ' + order_details.rms[k].Price + '</td></tr>';

                                total = total + (order_details.rms[k].Price * order_details.rms[k].Quantity);


                                $("#Order_Items").append(row);
                            }

                            

                            var VAT = total * vat_rate / 100;
                            var total2 = VAT + total;

                            row = '<tr><td></td><td></td><td></td><td></td><td>Order Total:</td><td>R ' + total.toFixed(2) + '</td></tr>'
                            + '<tr><td></td><td></td><td></td><td></td><td>VAT Total:</td><td>R ' + parseFloat(VAT).toFixed(2) + '</td></tr>'
                            + '<tr><td></td><td></td><td></td><td></td><td>Order Total with VAT:</td><td>R ' + total2.toFixed(2) + '</td></tr>';

                            $("#Order_Items").append(row);
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });
            }

            $("#div_5_5").show();
        });
    });
</script>

<h1 class="default-form-header">Maintain Purchase Order <span id="item_ID"></span></h1>
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Purchase Order: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter what to search the purchase order by" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category"title ="Select what to search the purchase order by" data-toggle ="tooltip" data-placement ="bottom" >
					<option value="All">All</option>
                    <option value="ID">Order No.</option>
                    <option value="Date">Date</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>
					
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					
				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
                    <button id="submitSearch" type ="submit" class ="searchButton"title ="Search for the purchase order" data-toggle ="tooltip" data-placement ="left" ><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Purchase Order</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="supplier_Search_Result" title ="Select the purchase order">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadSupplierDetailsButton" title ="Click to load order details">Load Order Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<br />
<div id="div_5_5" style="display : none">
<form id="UC5-5" class="form-horizontal">
	<fieldset>
		<legend>General Information of Order:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="supplier_Name" class="control-label">Supplier Name: </label>
				<input type="text" class="form-control" id="supplier_Name" disabled>
			</div>
			<div class="col-sm-2">
				<label for="supplier_ID" class="control-label">Supplier No.: </label>
				<input type="number" class="form-control" id="supplier_ID" disabled>
			</div>	
			<div class="col-sm-3">
				<label for="Order_date_adHoc">Order Date: </label>
				<input type="date" class="form-control" id="Order_date" disabled>
			</div>
			<div class="col-sm-3">
				<label for="order_ID">Reference Number: </label>
				<input type="text" class="form-control" id="order_ID" placeholder="000fff" disabled>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="order_status">Order Status: </label>
				<select class="form-control" id="order_status">

				</select>
			</div>
			<div class="col-sm-8">
			</div>
		</div>
	</fieldset>
    <br />

	<fieldset>
		<legend>Items Ordered:</legend>
		<div class="table-responsive">
				<table class="sortable table table-hover">
					<thead>
						<tr>
							<th>Code</th>
							<th>Inventory Type</th>
							<th>Name</th>
							<th>Quantity</th>
                            <th>Quantity Received</th>
							<th>Price (R)</th>
						</tr>
					</thead>
					<tbody id="Order_Items">
					</tbody>
				</table>
			</div> 
	</fieldset>
	<br/>
	<div class="row">
		<div class="col-sm-4">
		</div>	
		<div class="col-sm-4">
		</div>
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns"><i class="fa fa-wrench" aria-hidden="true"></i> Update Supplier Order</button>
		</div>
	</div>
			
</form>
</div>
</asp:Content>
