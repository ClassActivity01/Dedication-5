<%@ Page Title="Maintain Customer Order" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-4.aspx.cs" Inherits="Test._6_4" %>
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

    var client_ID;
    var contact_details = [];
    var s_parts = [];
    var client_details;
    var item_count = 0;
    var order_ID;
    var searchedOrders;
    var orderDetails;

    $(document).ready(function () {

        $.ajax({
            type: "GET",
            url: "api/CustomerOrderStatus",
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
                    var status = JSON.parse(result[1]).order_statuses;

                    $('#order_status').empty();

                    for (var k = 0; k < status.length; k++) {
                        var html = '<option value="' + status[k].Client_Order_Status_ID + '">' + status[k].Name + '</option>';

                        $("#order_status").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });

        $.ajax({
            type: "GET",
            url: "api/DeliveryMethod",
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
                    var delivery = JSON.parse(result[1]).delivery_methods;

                    $('#del_method').empty();

                    for (var k = 0; k < delivery.length; k++) {
                        var html = '<option value="' + delivery[k].Delivery_Method_ID + '">' + delivery[k].Name + '</option>';

                        $("#del_method").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });

        $.ajax({
            type: "GET",
            url: "api/CustomerOrderType",
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
                    var order = JSON.parse(result[1]).client_order_types;

                    $('#order_type').empty();

                    for (var k = 0; k < order.length; k++) {
                        var html = '<option value="' + order[k].Client_Order_Type_ID + '">' + order[k].Type + '</option>';

                        $("#order_type").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });



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
                alertify.alert('Error', 'No Customer Order has been chosen!');
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
                            orderDetails = JSON.parse(result[1]).client_orders[0];

                            $("#ord_ref_number").val(orderDetails.Reference_ID);

                            $("#item_ID").html("#" + order_ID + " ");

                            var value = orderDetails.Client_Order_Type_ID;
                            $("#order_type > option[value='" + value + "']").prop("selected", true);

                            value = orderDetails.Delivery_Method_ID;
                            $("#del_method > option[value='" + value + "']").prop("selected", true);

                            value = orderDetails.Client_Order_Status_ID;
                            $("#order_status > option[value='" + value + "']").prop("selected", true);

                            $("#order_comment").val(orderDetails.Comment);

                            if (orderDetails.VAT_Inclu == true)
                                $("#order_vat").prop("checked", true);

                            $("#Items").empty();

                            for (var a = 0; a < orderDetails.details.length; a++) {
                                var ID = orderDetails.details[a].Part_Type_ID;

                                item_count++;
                                var supplier2 = { Client_Order_Detail_ID: orderDetails.details[a].Client_Order_Detail_ID,
                                    Part_Type_ID: ID, Part_Price: orderDetails.details[a].Part_Price, Quantity: orderDetails.details[a].Quantity, Client_Discount_Rate: orderDetails.details[a].Client_Discount_Rate,
                                    Quantity_Delivered: orderDetails.details[a].Quantity_Delivered
                                };
                                s_parts.push(supplier2);

                                var row = '<tr id="row_part_' + ID + '"><td>' + item_count + '</td><td>' + orderDetails.details[a].Part_Type_Abbreviation + '</td><td>' + orderDetails.details[a].Part_Type_Name + '</td><td><input type="number" id="cdr_' + ID
                                    + '" disabled value="' + orderDetails.details[a].Client_Discount_Rate + '"/></td><td>' +
                                    '<input type="number" disabled step="0.01" value="' + orderDetails.details[a].Part_Price + '" id="p_u_' + ID
                                    + '"/></td><td><input type="number" disabled id="p_q_' + ID + '"  min="1" value="' + orderDetails.details[a].Quantity + '"/></td></tr>';

                                $("#Items").append(row);
                            }

                            $("#ResultModal").modal('hide');
                            $("#div_6_4").show();
                            client_ID = orderDetails.Client_ID;
                            calculateTotal();
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }

                });

                $.ajax({
                    type: "GET",
                    url: "api/Customer/"+client_ID,
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
                            client_details = JSON.parse(result[1]).clients[0];

                            $("#client_name").val(client_details.Name);
                            $('#Contact_details').empty();

                            var c_ID_pos = 0;

                            for (var p = 0; p < client_details.contact_details.length; p++) {
                                var detail = {
                                    Contact_ID: client_details.contact_details[p].Contact_ID,
                                    Name: client_details.contact_details[p].Name, Number: client_details.contact_details[p].Number,
                                    Email_Address: client_details.contact_details[p].Email_Address
                                };

                                contact_details.push(detail);

                                if (client_details.contact_details[p].Contact_ID == orderDetails.Contact_ID) {
                                    c_ID_pos = p;
                                    $("#client_cont_num").val(contact_details[p].Number);
                                    $("#client_email").val(contact_details[p].Email_Address);
                                }

                                var html = '<option value="' + p + '">' + client_details.contact_details[p].Name + '</option>';

                                $('#Contact_details').append(html);
                            }

                            $("#Contact_details > option[value='" + c_ID_pos + "']").prop("selected", true);
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });


            }
        });

        $("#Contact_details").on('change', function () {
            var k = $("#Contact_details").val();
            $("#client_cont_num").val(contact_details[k].Number);
            $("#client_email").val(contact_details[k].Email_Address);
        });
    });

    function calculateTotal() {
        var total = 0;

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var quantity = $('#p_q_' + ID).val();
            var price = $('#p_u_' + ID).val();
            var cdr = $('#cdr_' + ID).val();

            //console.log("CDR: " + cdr);
            //console.log("Price: " + price);

            var discounted_p = parseFloat(price) - (parseFloat(price) * parseInt(cdr) / 100);

            //console.log("Discounted: " + discounted_p);

            total += parseInt(quantity) * discounted_p;
        }

        var vat_rate = getVATRate();
        
        var vat = (total * vat_rate / 100);
        var total2 = total + vat;

        //console.log(vat);

        vat = vat.toFixed(2);
        total = total.toFixed(2);
        total2 = total2.toFixed(2);

        $("#Order_Total").html("R " + total);
        $("#Vat_Total").html("R " + vat);
        $("#Order_SubTotal").html("R " + total2);
    }

    function cancelOrder()
    {
        var warnings = "";
        if (order_ID == "" || order_ID == null) {
            warnings = warnings + "No Customer Order has been specified. <br/>";
        }


        $("#w_info").html(warnings);
        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: url9,
                data: "{'ID' : '" + order_ID + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                },
                success: function (msg) {
                    console.log(msg.d);
                    
                    var result = msg.d.split("|");
                    if (result[0] == "True") {
                        console.log(result[1]);
                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
        }

        return false;

    }

    function updateOrder()
    {
        var warnings = "";

        if (order_ID == "" || order_ID == null) {
            warnings = warnings + "No Customer Order has been specified. <br/>";
        }

        var status = $("#order_status").val();
        var delivery = $("#del_method").val();
        var type = $("#order_type").val();

        var reference = $("#ord_ref_number").val();
        var comment = $("#order_comment").val();
        var vat = $("#order_vat").is(":checked");

        var c = $("#Contact_details").val();

        var data = "{'status_ID' : '" + status + "', 'order_type' : '" + type + "', 'delivery_method' : '" + delivery + "', 'reference': '" + reference + "', 'vat':'" + vat + "', 'comment': '" + comment + "', 'Contact_ID' : " + contact_details[c].Contact_ID + "}";

        $("#w_info").html(warnings);
        if (warnings == "") {
            $.ajax({
                type: "PUT",
                url: "api/CustomerOrder/"+order_ID,
                data: { data: data },
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

<h1 class="default-form-header">Maintain Customer Order <span id="item_ID"></span></h1>
		
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Customer Order: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the order details to search for" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the order details to search by" data-toggle ="tooltip" data-placement ="bottom">
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
					<button id="submitSearch" type ="submit" class ="searchButton" title ="Click to search for the order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
			<select multiple class="form-control" id="order_Search_Result" title ="Select the order">

			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadOrderDetails" title ="Click to load order details">Load Order Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->


<br />
<div id="div_6_4" style="display: none">	
<form id="UC6-4" class="form-horizontal">
<fieldset>
	<legend>Customer Information:</legend>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_name" class="control-label">Customer Name: </label>
			<input type="text" class="form-control" id="client_name"  readonly>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_contact" class="control-label">Contact Name: </label>
			<select class="form-control" id="Contact_details" title ="Select the contact person" data-toggle ="tooltip" data-placement ="right">

			</select>
		</div>
        <div class="col-sm-6">
		</div>
    </div>
    <div class="row">
		<div class="col-sm-6">
			<label for="client_cont_num" class="control-label">Contact Number: </label>
			<input type="text" class="form-control" id="client_cont_num" readonly>
		</div>
		<div class="col-sm-6">
			<label for="client_email" class="control-label">Contact Email: </label>
			<input type="email" class="form-control" id="client_email" readonly>
		</div>
	</div>
</fieldset>
<br/>
<fieldset>
	<legend>Order Information:</legend>
				
	<div class="row">
		<div class="col-sm-6">
			<label for="ord_ref_number" class="control-label">Reference Number: </label>
			<input type="text" class="form-control" id="ord_ref_number" placeholder="XXX000" maxlength="10" title ="Enter the reference number" data-toggle ="tooltip" data-placement ="bottom">
		</div>
		<div class="col-sm-6">
			<label for="order_vat" class="control-label">VAT Included: </label><br/>
			<input type="checkbox" id="order_vat" checked title ="Select if VAT is included" data-toggle ="tooltip" data-placement ="right">
		</div>
	</div>
	<div class="row">
		<div class="col-sm-4">
			<label for="del_method" class="control-label">Delivery Method: </label>
			<select id="del_method" class="form-control" title ="Select the delivery method" data-toggle ="tooltip" data-placement ="bottom">

			</select>
		</div>
		<div class="col-sm-4">
			<label for="order_type" class="control-label">Order Type: </label>
			<select id="order_type" class="form-control" title ="Select the order type" data-toggle ="tooltip" data-placement ="bottom">

			</select>
		</div>
        <div class="col-sm-4">
			<label for="order_status" class="control-label">Order Status: </label>
			<select id="order_status" class="form-control" title ="Select the order status" data-toggle ="tooltip" data-placement ="bottom">
			</select>
		</div>
	</div>
    <div class="row">
		<div class="col-sm-12">
			<label for="order_commentw" class="control-label">Order Comments: </label>
			<textarea class="form-control" id="order_comment" maxlength="255" title ="Enter the order comments" data-toggle ="tooltip"></textarea>
		</div>
	</div>
</fieldset>
<br />		
<fieldset id="partsFieldset">
	<legend>Order Items Information:</legend>
	<div id="parts">

        <br/>
		<div class="table-responsive makeDivScrollable">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>No.</th>
						<th>Code</th>
						<th>Name</th>
                        <th>Discount %</th>
						<th>Unit Price R (VAT Excl.)</th>
						<th>Quantity</th>
					</tr>
				</thead>
				<tbody id="Items">
				</tbody>
			</table>
		</div>
	</div>



    <div class="row">
        <div class="col-sm-offset-8 col-sm-4">
			<table class="table table-bordered" >
				<tbody style="text-align: right">
					<tr>
						<td>Sub Total</td><td><span id="Order_Total">R 0.00</span></td>
					</tr>
					<tr>
						<td>VAT</td><td><span id="Vat_Total">R 0.00</span></td>
					</tr>
					<tr>
						<td>Total</td><td><span id="Order_SubTotal">R 0.00</span></td>
					</tr>
				</tbody>
			</table>
		</div>
    </div>
</fieldset>
<br/>
<div>
    <div class="Warning_Info" id="w_info"></div>
</div>
<div class="row">
	<div class="col-sm-offset-8 col-sm-4">
		<button onclick="return updateOrder()" class="form-custom-button-columns" title ="Click to update the order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-wrench" aria-hidden="true"></i> Update Order</button>
	</div>
</div>
</form>
</div>
</asp:Content>
