<%@ Page Title="Generate Invoice" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-6.aspx.cs" Inherits="Test._6_6" %>
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
    var del_details;
    var del_ID;
    var total_invoice = 0;
    var total_invoice_no_vat = 0;
    var part_names = [];
    var vat_rate = 14;

    $(document).ready(function () {

        vat_rate = getVATRate();

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
                    url: "api/CustomerOrder/" + order_ID,
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

                            var value = orderDetails.Client_Order_Type_ID;
                            $("#order_type > option[value='" + value + "']").prop("selected", true);

                            value = orderDetails.Delivery_Method_ID;
                            $("#del_method > option[value='" + value + "']").prop("selected", true);

                            value = orderDetails.Client_Order_Status_ID;
                            $("#order_status > option[value='" + value + "']").prop("selected", true);

                            $("#order_comment").val(orderDetails.Comment);

                            if (orderDetails.VAT_Inclu == true)
                                $("#order_vat").prop("checked", true);

                            $("#ResultModal").modal('hide');
                            $("#div_6_6").show();
                            client_ID = orderDetails.Client_ID;
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }

                });

                $.ajax({
                    type: "GET",
                    url: "api/Customer/" + client_ID,
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

                            $('#Contact_details').empty();


                            for (var p = 0; p < client_details.contact_details.length; p++) {
                                var detail = {
                                    Contact_ID: client_details.contact_details[p].Contact_ID,
                                    Name: client_details.contact_details[p].Name, Number: client_details.contact_details[p].Number,
                                    Email_Address: client_details.contact_details[p].Email_Address
                                };

                                contact_details.push(detail);

                                if (p == 0) {
                                    $("#client_cont_num").val(contact_details[p].Number);
                                    $("#client_email").val(contact_details[p].Email_Address);
                                }

                                var html = '<option value="' + p + '">' + client_details.contact_details[p].Name + '</option>';

                                $('#Contact_details').append(html);
                            }

                            $("#client_name").val(client_details.Name);
                            $("#client_account").val(client_details.Account_Name);
                            $("#client_vat").val(client_details.Vat_Number);
                            $("#client_Address").val(client_details.Address);
                            $("#client_City").val(client_details.City);
                            var value = client_details.Province_ID;
                            $("#province > option[value='" + value + "']").prop("selected", true);
                            $("#client_ext").val(client_details.Zip);

                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });

                $.ajax({
                    type: "GET",
                    url: "api/DeliveryNote/"+order_ID,
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
                            var delDetails = JSON.parse(result[1]).delivery_notes;

                            $("#del_no").empty();
                            $("#del_no").append('<option value="Choose">Choose a Delivery Note</option>');

                            for (var k = 0; k < delDetails.length; k++) {
                                var date = delDetails[k].Delivery_Note_Date.split("T");
                                var type = '<option value="' + delDetails[k].Delivery_Note_ID + '">#' + delDetails[k].Delivery_Note_ID + ' ('+date[0]+')</option>';
                                $("#del_no").append(type);
                            }

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

        $("#del_no").on('change', function () {
            del_ID = $("#del_no").val();

            if (del_ID == "" || del_ID == null || del_ID == "Choose")
            { }
            else 
            $.ajax({
                type: "GET",
                url: "api/DeliveryNoteDetails/"+del_ID,
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
                        del_details = JSON.parse(result[1]).delivery_note_details;


                        item_count = 0;
                        $("#Items").empty();

                        for(var a = 0; a < del_details.length; a++)
                        {
                            item_count++;
                            var ID = del_details[a].Part_Type_ID;
                            var row = '<tr>'+
						                '<td>'+ item_count +'</td>'+
						                '<td>' + del_details[a].Part_Type_Abbreviation + '</td>' +
						                '<td>'+del_details[a].Part_Type_Name +'</td>'+
                                        '<td>'+del_details[a].Client_Discount_Rate +'</td>'+
                                        '<td>' + del_details[a].Part_Price + '</td>' +
						                '<td>'+del_details[a].Quantity_Delivered +'</td>'+
					                '</tr>';

                            var supplier2 = {
                                Part_Type_ID: ID, Part_Price: del_details[a].Part_Price, Quantity_Delivered: del_details[a].Quantity_Delivered,
                                Client_Discount_Rate: del_details[a].Client_Discount_Rate
                            };
                            s_parts.push(supplier2);
                            part_names.push(del_details[a].Part_Type_Name);

                            $("#Items").append(row);
						    
                        }
                        calculateTotal();
                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
        });
    });

    function calculateTotal() {
        var total = 0;

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var quantity = s_parts[a].Quantity_Delivered;
            var price = s_parts[a].Part_Price;
            var cdr = s_parts[a].Client_Discount_Rate;

            //console.log("CDR: " + cdr);
            //console.log("Price: " + price);

            var discounted_p = price - (price * cdr / 100);

            //console.log("Discounted: " + discounted_p);

            total += quantity * discounted_p;
            //console.log("Total: " + total);

        }

        var vat = (total * vat_rate / 100);
        var total2 = total + vat;

        total_invoice = total2;
        total_invoice_no_vat = total;

        //console.log(vat);
        //console.log(total);
        //console.log(total2);

        vat = vat.toFixed(2);
        total = total.toFixed(2);
        total2 = total2.toFixed(2);

        $("#Order_Total").html("R " + total);
        $("#Vat_Total").html("R " + vat);
        $("#Order_SubTotal").html("R " + total2);
    }

    function generateInvoice(what)
    {
        var warnings = "";

        if (del_ID == "" || del_ID == null || del_ID == "Choose") {
            warnings = warnings + "No Delivery Note has been specified. <br/>";
            $("#del_no").addClass("empty");
        }

        var date = (new Date()).toISOString();
        var client_email = $("#client_email").val();

        var invoice = { Client_Order_ID : parseInt(order_ID),
            Invoice_Date: date, Invoice_Status_ID: 0, Delivery_Note_ID: parseInt(del_ID),
            amount_noVat: total_invoice_no_vat, amount_Vat: total_invoice, action: what, email: client_email
        };

        $("#w_info").html(warnings);
        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/Invoice",
                data: { data: JSON.stringify(invoice)},
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
                        var invoice_ID = result[2];

                        if (what == 'print')
                        {
                            var c = $("#Contact_details").val();
                        var c_ID = contact_details[c].Contact_ID;
                        var name;
                        var num;

                        for (var p = 0; p < client_details.contact_details.length; p++)
                        {

                            if(client_details.contact_details[p].Contact_ID == c_ID)
                            {
                                name = client_details.contact_details[p].Name;
                                num = client_details.contact_details[p].Number;
                            }
                        }

                        var ref = $("#ord_ref_number").val();
                        var del = $("#del_no").val();

                        var obj = { Reference: ref, Delivery_Note_ID: del, client: client_details, s_parts: s_parts, p_names: part_names, Invoice_ID: invoice_ID, c_name: name, c_num: num };

                        var url_ = '<%=ResolveUrl("~/Invoice.html") %>';
                        var w = window.open(url_);
                        w.passed_obj = obj;
                        w.print();
                        }

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

<h1 class="default-form-header">Generate Invoice</h1>
		
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



<br />
<div id="div_6_6" style="display: none">	
<form id="UC6-6" class="form-horizontal">


<fieldset>
	<legend>Customer Information:</legend>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_name" class="control-label">Customer Name: </label>
			<input type="text" class="form-control" id="client_name"  disabled>
		</div>
	</div>
	<div class="row">	
		<div class="col-sm-4">
			<label for="client_Address" class="control-label">Address: </label>
			<input type="text" class="form-control" id="client_Address" disabled>
		</div>
		<div class="col-sm-3">
			<label for="client_City" class="control-label">City: </label>
			<input type="text" class="form-control" id="client_City" disabled>
		</div>
		<div class="col-sm-3">
			<label for="province">Province: </label>
			<select class="form-control" id="province"  disabled>
				<option value="3">Gauteng</option>
                        <option value="5">Limpopo</option>
                        <option value="6">Mpumulanga</option>
                        <option value="2">Free State</option>
                        <option value="4">KwaZulu-Natal</option>
                        <option value="7">North West</option>
                        <option value="1">Eastern Cape</option>
                        <option value="8">Northern Cape</option>
                        <option value="9">Western Cape</option>
			</select>
		</div>
		<div class="col-sm-2">
			<label for="client_ext" class="control-label">Zip Code: </label>
			<input type="number" class="form-control" id="client_ext" readonly>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_vat" class="control-label">VAT Number: </label>
			<input type="text" class="form-control" id="client_vat" readonly>
		</div>
		<div class="col-sm-6">
			<label for="client_account" class="control-label">Account Name: </label>
			<input type="text" class="form-control" id="client_account" readonly>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_contact" class="control-label">Contact Name: </label>
			<select class="form-control" disabled id="Contact_details" title ="Select the contact person" data-toggle ="tooltip" data-placement ="right">
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
			<input type="text" class="form-control" id="ord_ref_number" placeholder="XXX000" disabled>
		</div>
		<div class="col-sm-6">
			<label for="order_vat" class="control-label">VAT Included: </label><br/>
			<input type="checkbox" id="order_vat" checked disabled>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-4">
			<label for="del_method" class="control-label">Delivery Method: </label>
			<select id="del_method" class="form-control" disabled>
				<option>Partial Delivery</option>
				<option>Full Delivery</option>
			</select>
		</div>
		<div class="col-sm-4">
			<label for="order_type" class="control-label">Order Type: </label>
			<select id="order_type" class="form-control" disabled>
				<option>Cash Sale</option>
				<option>Contracted Sale</option>
			</select>
		</div>
        <div class="col-sm-4">
			<label for="order_status" class="control-label">Order Status: </label>
			<select id="order_status" class="form-control" disabled>
			</select>
		</div>
	</div>
    <div class="row">
		<div class="col-sm-12">
			<label for="order_commentw" class="control-label">Order Comments: </label>
			<textarea class="form-control" id="order_comment" disabled></textarea>
		</div>
	</div>
</fieldset>
<br />
<fieldset>
	<legend>Delivery Note Number:</legend>
	<div class="row">
		<div class="col-sm-6">
			<label for="del_no" class="control-label">Delivery Note Number: </label>
			<select class="form-control" id="del_no" title ="Select the delivery note number" data-toggle ="tooltip" data-placement ="right">
			</select>
		</div>
	</div>
</fieldset>
    <br />
<fieldset id="partsFieldset">
	<legend>Invoice Information:</legend>
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
	<div class="col-sm-4">
	</div>
	<div class="col-sm-4">
		<button onclick="return generateInvoice('print')" class = "form-custom-button-columns" title ="Click to print invoice" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-print" aria-hidden="true"></i> Print Invoice</button>
	</div>	
	<div class="col-sm-4">
		<button onclick="return generateInvoice('email')" class = "form-custom-button-columns" title ="Click to email the invoice" data-toggle ="tooltip"><i class="fa fa-envelope-o" aria-hidden="true"></i> Email Invoice</button>
	</div>
</div>
</form>
</div>
</asp:Content>
