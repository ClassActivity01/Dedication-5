<%@ Page Title="Receive Purchase Order" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-8.aspx.cs" Inherits="Test._5_8" %>
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

    var s_components = [];
    var s_parts = [];
    var s_raw = [];
    var order_ID;
    var vat_rate = 14;

    function calculateTotal2() {
        var total = 0;

        //Get the different inventory item values
        for (var a = 0; a < s_components.length; a++) {
            var ID = s_components[a].Component_ID;

            var quantity = $('#receive_c_' + ID).val();
            var price = s_components[a].Price;

            total += quantity * price;
        }

        for (var a = 0; a < s_raw.length; a++) {
            var ID = s_raw[a].Raw_Material_ID;

            var quantity = $('#receive_r_' + ID).val();
            var price = s_raw[a].Price;

            total += quantity * price;
        }

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var quantity = $('#receive_p_' + ID).val();
            var price = s_parts[a].Price;

            total += quantity * price;
        }

        var vat = (total * vat_rate / 100);
        var total2 = total + vat;

        vat = parseFloat(vat).toFixed(2);
        total = total.toFixed(2);
        total2 = total2.toFixed(2);

        $("#subtotal2").html("R " + total);
        $("#vat2").html("R " + vat);
        $("#total2").html("R " + total2);
    }

    $(document).ready(function () {

        vat_rate = getVATRate();

        $("#UC5-8").submit(function (e) {
            e.preventDefault();

            var empty = checkEmpty();

            if (empty == false) {
                warnings = warnings + "One or more fields are empty. <br/>";
                $("#w_info").html(warnings);
                return false;
            }

            var warnings = "";

            if (order_ID == null || order_ID == "") {
                warnings += "No Purchase Order has been chosen. <br/>";
            }

            //Get the different inventory item values
            for (var a = 0; a < s_components.length; a++) {
                var ID = s_components[a].Component_ID;
                var quantity = $('#receive_c_' + ID).val();

                s_components[a].Quantity_Received += parseInt(quantity);
            }

            for (var a = 0; a < s_raw.length; a++) {
                var ID = s_raw[a].Raw_Material_ID;

                var quantity = $('#receive_r_' + ID).val();

                s_raw[a].Quantity_Received += parseInt(quantity);
            }

            for (var a = 0; a < s_parts.length; a++) {
                var ID = s_parts[a].Part_Type_ID;

                var quantity = $('#receive_p_' + ID).val();

                s_parts[a].Quantity_Received += parseInt(quantity);
            }

            $("#w_info").html(warnings);


            var order = {
                cs: s_components, ps: s_parts, rms: s_raw
            };

            if (warnings == "") {
                $.ajax({
                    type: "PUT",
                    url: "api/ReceiveSupplierOrder/" + order_ID,
                    data: {data: JSON.stringify(order) },
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
                        if (searchedOrders.length == 0) {
                            $("#supplier_Search_Result").append("<option value=''>No results found.</option>");
                        }
                        else {
                            for (var k = 0; k < searchedOrders.length; k++) {
                                var date = searchedOrders[k].Date.split("T");
                                var html = '<option value="' + searchedOrders[k].Supplier_Order_ID + '">' + searchedOrders[k].Supplier_Order_ID + ' - ' + searchedOrders[k].Supplier_Name + ' (' + date[0] + ')</option>';
                                $("#supplier_Search_Result").append(html);
                            }
                        }
                    }
                    else
                        alertify.alert('Error', result[1], function () { });
                }
            });
            $("#ResultModal").modal('show');
        });

        //On search results click
        $('#loadSupplierOrder').on('click', function () {
            order_ID = $("#supplier_Search_Result").val();

            if (order_ID == null || order_ID == "") {
                alertify.alert("No Purchase Order has been chosen.");
            }
            else {
                $.ajax({
                    type: "GET",
                    url: "api/SupplierOrder/" + order_ID,
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
                        s_components = [];
                        s_parts = [];
                        s_raw = [];

                        if (result[0] == "true") {
                            var order_details = JSON.parse(result[1]).supplier_orders[0];

                            var row;
                            $("#Order_Items").empty();
                            var total = 0;

                            var date = order_details.Date.split("T");

                            $("#supplier_Name").val(order_details.Supplier_Name);
                            $("#supplier_ID").val(order_details.Supplier_ID);
                            $("#Order_date").val(date[0]);
                            $("#order_ID").val(order_details.Supplier_Order_ID);

                            var value = order_details.Supplier_Order_Status_ID;
                            $("#order_status > option[value='" + value + "']").prop("selected", true);
                            $("#ResultModal").modal('hide');

                            var total = 0;

                            for (var k = 0; k < order_details.cs.length; k++) {
                                var max = order_details.cs[k].Quantity_Requested - order_details.cs[k].Quantity_Received;

                                row = '<tr><td>' + order_details.cs[k].Component_ID + '</td><td>Component</td><td>' + order_details.cs[k].Component_Name
                                    + '</td><td>' + order_details.cs[k].Price + '</td>' +
                                    '<td>' + order_details.cs[k].Quantity_Requested + '</td><td>' + order_details.cs[k].Quantity_Received + '</td>' +
                                    '<td><input type="number" id="receive_c_' + order_details.cs[k].Component_ID
                                    +'" min="0" value="0" max="'+ max +'" /></td></tr>';

                                var supplier2 = { Component_ID: order_details.cs[k].Component_ID, Price: order_details.cs[k].Price, Quantity_Requested: order_details.cs[k].Quantity_Requested, Quantity_Received: order_details.cs[k].Quantity_Received };
                                s_components.push(supplier2);

                                total += order_details.cs[k].Price * order_details.cs[k].Quantity_Received;

                                $("#Order_Items").append(row);
                            }

                            for (var k = 0; k < order_details.ps.length; k++) {
                                var max = order_details.ps[k].Quantity - order_details.ps[k].Quantity_Received;

                                row = '<tr><td>' + order_details.ps[k].Part_Type_ID + '</td><td>Part Type</td><td>' + order_details.ps[k].Part_Type_Name
                                    + '</td><td>' + order_details.ps[k].Price + '</td>' +
                                    '<td>' + order_details.ps[k].Quantity + '</td><td>' + order_details.ps[k].Quantity_Received + '</td>' +
                                    '<td><input type="number" id="receive_p_' + order_details.ps[k].Part_Type_ID
                                    + '" min="0" value="0" max="' + max + '" /></td></tr>';

                                var supplier2 = { Part_Type_ID: order_details.ps[k].Part_Type_ID, Price: order_details.ps[k].Price, Quantity: order_details.ps[k].Quantity, Quantity_Received: order_details.ps[k].Quantity_Received };
                                s_parts.push(supplier2);

                                total += order_details.ps[k].Price * order_details.ps[k].Quantity_Received;

                                $("#Order_Items").append(row);
                            }

                            for (var k = 0; k < order_details.rms.length; k++) {

                                var max = order_details.rms[k].Quantity - order_details.rms[k].Quantity_Received;

                                row = '<tr><td>' + order_details.rms[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + order_details.rms[k].Raw_Material_Name
                                    + ' (' + order_details.rms[k].Dimensions + ')</td><td>' + order_details.rms[k].Price + '</td>' +
                                    '<td>' + order_details.rms[k].Quantity + '</td><td>' + order_details.rms[k].Quantity_Received + '</td>' +
                                    '<td><input type="number" id="receive_r_' + order_details.rms[k].Raw_Material_ID
                                    + '" min="0" value="0" max="' + max + '" /></td></tr>';

                                var supplier2 = {
                                    Raw_Material_ID: order_details.rms[k].Raw_Material_ID, Price: order_details.rms[k].Price,
                                    Dimensions: order_details.rms[k].Dimensions, Quantity: order_details.rms[k].Quantity, Quantity_Received: order_details.rms[k].Quantity_Received
                                };
                                s_raw.push(supplier2);

                                total += order_details.rms[k].Price * order_details.rms[k].Quantity_Received;

                                $("#Order_Items").append(row);
                            }

                            var VAT = total * vat_rate / 100;
                            var total2 = VAT + total;

                            row = '<tr><td></td><td></td><td></td><td></td><td></td><td>Sub Total:</td><td><span id="subtotal2">R ' + total + '</span></td></tr>'
                            + '<tr><td></td><td></td><td></td><td></td><td></td><td>VAT:</td><td><span id="vat2">R ' + VAT + '</span></td></tr>'
                            + '<tr><td></td><td></td><td></td><td></td><td></td><td>Order Total:</td><td><span id="total2">R ' + total2 + '</span></td></tr>';

                            $("#Order_Items").append(row);
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });
            }

            $("#div_5_8").show();
        });

        $("#Order_Items").on("change", ":input[type='number']", function () {
            calculateTotal2();
        });
});
</script>

<h1 class="default-form-header">Receive Purchase Order</h1>
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Find Purchase Order: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter what to search the purchase order by" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select what to search the purchase order by" data-toggle ="tooltip" data-placement ="bottom">
                    <option value="All">All</option>
					<option value="ID">Supplier Order No.</option>
                    <option value="Date">Date</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" name="optradio" value="Exact" checked>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" name="optradio" value="Contains">Contains</label>
		
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					
				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">		
                    <button id="submitSearch" type ="submit" class ="searchButton" title ="Click here to search for the purchase order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>				
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
			<select multiple class="form-control" id="supplier_Search_Result" title ="Select a purchase order">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadSupplierOrder" title ="Click to load the purchase order details">Load Order Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
		
<br />
<div id="div_5_8" style="display : none">
<form id="UC5-8" class="form-horizontal">
	<fieldset>
		<legend>General Information of Order:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="supplier_Name" class="control-label">Supplier Name: </label>
				<input type="text" class="form-control" id="supplier_Name" value="Supplier Name" disabled>
			</div>
			<div class="col-sm-2">
				<label for="supplier_ID" class="control-label">Supplier No: </label>
				<input type="number" class="form-control" id="supplier_ID" value="1" disabled>
			</div>	
			<div class="col-sm-3">
				<label for="Order_date_adHoc">Order Date: </label>
				<input type="date" class="form-control" id="Order_date" disabled>
			</div>
			<div class="col-sm-3">
				<label for="order_ID">Order No: </label>
				<input type="text" class="form-control" id="order_ID" placeholder="000fff" disabled>
			</div>
		</div>
	</fieldset>
    <br />
	<fieldset>
		<legend>Items Ordered:</legend>
		<div class="table-responsive makeDivScrollable">
				<table class="sortable table table-hover">
					<thead>
						<tr>
							<th>Code</th>
							<th>Inventory Type</th>
							<th>Name</th>
                            <th>Unit Price (Vat Exlc.)</th>
							<th>Quantity</th>
                            <th>Quantity Received</th>
                            <th>Receive how many?</th>
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
