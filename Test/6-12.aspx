<%@ Page Title="Generate Customer Credit Note" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-12.aspx.cs" Inherits="Test._6_12" %>
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
    var credit_item = [];
    var client_details;
    var order_ID;
    var searchedOrders;
    var orderDetails;
    var delivery_ID;
    var delivery_details;
    var part_names = [];

    $(document).ready(function () {

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
                    alertify.alert("Error", result[1]);
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
                    alertify.alert("Error", result[1]);
            }
        });



        //On search
        $("#search_form").submit(function (event) {
            //event.preventDefault();

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

                        for (var k = 0; k < searchedOrders.length; k++) {

                            var date = searchedOrders[k].Date.split("T");

                            var html = '<option value="' + searchedOrders[k].Client_Order_ID + '">#' + searchedOrders[k].Client_Order_ID + ' - '+ searchedOrders[k].Client_Name+ ' (' +
                                date[0] + ')</option>';

                            $("#order_Search_Result").append(html);
                        }
                    }
                    else alertify.alert("Error", result[1]);
                }
            });
            $("#ResultModal").modal('show');

            return false;
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
                            orderDetails = JSON.parse(result[1]).client_orders[0];

                            $("#ord_ref_number").val(orderDetails.Reference_ID);

                            var value = orderDetails.Client_Order_Type_ID;
                            $("#order_type > option[value='" + value + "']").prop("selected", true);

                            value = orderDetails.Delivery_Method_ID;
                            $("#del_method > option[value='" + value + "']").prop("selected", true);

                            //value = orderDetails.Client_Order_Status_ID;
                            //$("#order_status > option[value='" + value + "']").prop("selected", true);

                            $("#order_comment").val(orderDetails.Comment);

                            if (orderDetails.VAT_Inclu == true)
                                $("#order_vat").prop("checked", true);

                            $("#div_6_6").show();
                            $("#ResultModal").modal('hide');
                            client_ID = orderDetails.Client_ID;
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
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    },
                    success: function (msg) {
                        var result = msg.split("|");

                        if (result[0] == "true") {
                            var delivery_details = JSON.parse(result[1]).delivery_notes;

                            $("#invoice_no").empty();
                            $("#invoice_no").append('<option value="Choose">Choose a Delivery Note</option>');

                            for (var k = 0; k < delivery_details.length; k++) {
                                var date = delivery_details[k].Delivery_Note_Date.split("T");
                                var type = '<option value="' + delivery_details[k].Delivery_Note_ID + '">#' + delivery_details[k].Delivery_Note_ID + ' (' + date[0] + ')</option>';
                                $("#invoice_no").append(type);
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

        $("#Items").on('click', 'input[type=checkbox]', function ()
        {
            if ($(this).is(":checked")) {
                var part_type_ID = $(this).attr("data-part_type_ID");

                var i = parseInt($("#quantity_return_" + part_type_ID).val()) + 1;

                if (i > $("#quantity_return_" + part_type_ID).attr("max"))
                {
                    $("#w_info").html("Cannot return more than what was delivered. <br/>");
                    $(this).prop("checked", false);
                }
                else $("#quantity_return_" + part_type_ID).val(i);

            }
            else {

                var part_type_ID = $(this).attr("data-part_type_ID");

                var i = parseInt($("#quantity_return_" + part_type_ID).val()) - 1;
                $("#quantity_return_" + part_type_ID).val(i);
            }
        });


        $("#invoice_no").on('change', function () {
            delivery_ID = $("#invoice_no").val();
            //console.log(invoice_ID);
            if (delivery_ID == "" || delivery_ID == null || delivery_ID == "Choose")
            { }
            else 
            $.ajax({
                type: "GET",
                url: "api/DeliveryNoteDetails/" + delivery_ID,
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
                        delivery_details = JSON.parse(result[1]).delivery_note_details;

                        item_count = 0;
                        $("#Items").empty();

                        for (var a = 0; a < delivery_details.length; a++)
                        {
                            item_count++;
                            var ID = delivery_details[a].Part_Type_ID;
                            var row = '<tr>'+
						                '<td>' + delivery_details[a].Part_Type_ID + '</td>' +
						                '<td>' + delivery_details[a].Part_Type_Name + '</td>' +
                                        '<td>' + delivery_details[a].Client_Discount_Rate + '</td>' +
                                        '<td>' + delivery_details[a].Part_Price + '</td>' +
						                '<td>' + delivery_details[a].Quantity_Delivered + '</td>' +
                                        '<td><input type="number" disabled id="quantity_return_' + delivery_details[a].Part_Type_ID + '" value="0" max="'+delivery_details[a].Quantity_Delivered+'" readonly/></td>' +
					                '</tr>';
                            var supplier2 = {
                                Part_Type_ID: ID, Part_Price: delivery_details[a].Part_Price, Quantity_Delivered: delivery_details[a].Quantity_Delivered,
                                Client_Discount_Rate: delivery_details[a].Client_Discount_Rate
                            };
                            s_parts.push(supplier2);
                            part_names.push(delivery_details[a].Part_Type_Name);

                            $("#Items").append(row);

                            for (var k = 0; k < delivery_details[a].job_cards[0].details[0].parts.length; k++)
                            {
                                var s = { Part_ID: delivery_details[a].job_cards[0].details[0].parts[k].Part_ID, return_to: false, status: "None", Client_Order_Detail_ID: delivery_details[a].Client_Order_Detail_ID }
                                    credit_item.push(s);


                                    var row = '<tr>' +
						                '<td></td>' +
						                '<td>Part: </td>' +
                                        '<td>' + delivery_details[a].job_cards[0].details[0].parts[k].Part_Serial + '</td>' +
                                        '<td></td>' +
						                '<td><input type="checkbox" id="return_to_' + delivery_details[a].job_cards[0].details[0].parts[k].Part_ID + '" data-part_type_ID="' + delivery_details[a].job_cards[0].details[0].Part_Type_ID + '"/></td>' +
                                        '<td><select id="status_part_' + delivery_details[a].job_cards[0].details[0].parts[k].Part_ID + '"><option value="None">None</option><option value="8">Scrap</option><option value="3">Return to Stock</option><option value="2">Rework</option></select></td>' +
					                '</tr>';

                                    $("#Items").append(row);
                            }
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

        var vat = (total * 14 / 100);
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

    function print_preview()
    {
        var url_temp = '<%=ResolveUrl("~/Landing.aspx/getLastID") %>';
    
        var credit_note_ID = 0;

        $.ajax({
            type: "POST",
            url: url_temp,
            data: "{'what' : 'Credit Note'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async : false,
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status);
                console.log(xhr.responseText);
                console.log(thrownError);
            },
            success: function (msg) {
                console.log(msg.d);

                var result = msg.d.split("|");
                if (result[0] == "True") {
                    credit_note_ID = result[1];
                }
                else
                    alertify.alert('Error', result[1]);


            }
        });

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

        for (var a = 0; a < s_parts.length; a++) {

            var returned = $("#quantity_return_" + s_parts[a].Part_Type_ID).val();
            s_parts[a].Quantity_Returned = returned;
        }

        var ref = $("#ord_ref_number").val();

        var obj = { Reference: ref, client: client_details, s_parts: s_parts, p_names: part_names, Credit_ID: credit_note_ID, c_name: name, c_num: num };

        var url_ = '<%=ResolveUrl("~/ClientCreditNote.html") %>';
        var w = window.open(url_);
        w.passed_obj = obj;

        return false;
    }

    function generateCreditNote(what)
    {
        //event.preventDefault();

        var warnings = "";

        if (delivery_ID == "" || delivery_ID == null || delivery_ID == "Choose") {
            warnings = warnings + "No Delivery Note has been specified. <br/>";
            $("#invoice_no").addClass("empty");
        }

        var date = (new Date()).toISOString();
        var comment = $("#order_comment_credit").val();

        if (comment.length === 0)
            warnings += "No comment has been added. <br/>";

        var flag2 = false;

        for (var a = 0; a < credit_item.length; a++)
        {
            var flag = $("#return_to_" + credit_item[a].Part_ID).is(":checked");

            if (flag == true)
                flag2 = true;

            credit_item[a].return_to = flag;

            var status = $("#status_part_" + credit_item[a].Part_ID).val();
            credit_item[a].status = status;

            if (flag == true && status == "None")
                warnings += "Please choose a status for part #" + credit_item[a].Part_ID + "<br/>";
        }

        if (flag2 == false)
            warnings += "Cannot generate an empty credit note. Please specify items to be returned. <br/>"

        var client_email = $("#client_email").val();
        var credit = { Date: date, Return_Comment: comment, cni: credit_item, action: what, email: client_email };

        $("#w_info").html(warnings);
        if (warnings == "a") {
            $.ajax({
                type: "POST",
                url: "api/CreditNote",
                data: { data: JSON.stringify(credit) },
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
                        var credit_note_ID = result[2];

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

                            for (var a = 0; a < s_parts.length; a++) {

                                var returned = $("#quantity_return_" + s_parts[a].Part_Type_ID).val();
                                s_parts[a].Quantity_Returned = returned;
                            }

                            var ref = $("#ord_ref_number").val();

                            var obj = { Reference: ref, client: client_details, s_parts: s_parts, p_names: part_names, Credit_ID: credit_note_ID, c_name: name, c_num: num };

                            var url_ = '<%=ResolveUrl("~/ClientCreditNote.html") %>';
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

<h1 class="default-form-header">Generate Customer Credit Note</h1>
		
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
		<button type="button" class="btn btn-secondary modalbutton" id="loadOrderDetails" title ="Click to load the order details">Load Order Details</button>
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
		<div class="col-sm-6">
			<label for="client_contact" class="control-label">Contact Name: </label>
			<select class="form-control" id="Contact_details" title ="Select the contact person" data-toggle ="tooltip" data-placement ="right" >

			</select>
		</div>
        <div class="col-sm-6">

		</div>
    </div>
    <div class="row">
		<div class="col-sm-6">
			<label for="client_cont_num" class="control-label">Contact Number: </label>
			<input type="text" class="form-control" id="client_cont_num"  readonly>
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

			</select>
		</div>
		<div class="col-sm-4">
			<label for="order_type" class="control-label">Order Type: </label>
			<select id="order_type" class="form-control" disabled>

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
<fieldset id="partsFieldset">
	<legend>Credit Note Information:</legend>
	<div id="parts">
		<div class="row">
		    <div class="col-sm-6">
                <label for="invoice_no" class="control-label">Delivery Note Number: </label>
		        <select class="form-control" id="invoice_no" title ="Select the delivery note number" data-toggle ="tooltip" data-placement ="right">
                </select>
            </div>
        </div>

		
        <br/>
		<div class="table-responsive makeDivScrollable">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>Code</th>
						<th>Name</th>
                        <th>Discount %</th>
						<th>Unit Price R (VAT Excl.)</th>
						<th>Quantity</th>
                        <th>Quantity to Return</th>
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

    <div class="row">
		<div class="col-sm-12">
			<label for="order_comment_credit" class="control-label">Return Comment: </label>
			<textarea class="form-control" id="order_comment_credit" maxlength="255" title ="Enter the return comment" data-toggle ="tooltip"></textarea>
		</div>
	</div>
</fieldset>
<br/>
<div>
    <div class="Warning_Info" id="w_info"></div>
</div>
<div class="row">
	<div class="col-sm-3">

	</div>
	<div class="col-sm-3">
		<button onclick="return generateCreditNote('print')" type="button" class = "form-custom-button-columns" title ="Click to print the credit note" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-print" aria-hidden="true"></i> Print Credit Note</button>
	</div>	
	<div class="col-sm-3">
		<button onclick="return generateCreditNote('email')" type="button" class = "form-custom-button-columns" title ="Click to email the credit note" data-toggle ="tooltip"><i class="fa fa-envelope-o" aria-hidden="true"></i> Email Credit Note</button>
	</div>
    <div class="col-sm-3">
		<button onclick="return generateCreditNote('process')" type="button" class = "form-custom-button-columns"title ="Click to process the credit note" data-toggle ="tooltip" ><i class="fa fa-check" aria-hidden="true"></i> Process Credit Note</button>
	</div>
</div>
</form>
</div>
</asp:Content>
