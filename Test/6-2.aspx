<%@ Page Title="Place Customer Order" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-2.aspx.cs" Inherits="Test._6_2" %>
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
    var s_parts2 = [];
    var client_details;
    var item_count = 0;
    var type_of_order = "Quote";
    var quote_ID;
    var searchedQuotes;
    var part_names = [];
    var part_names2 = [];
    var vat_rate = 14;

$(document).ready(function () {

    vat_rate = getVATRate();

    //On search
    $("#search_form").submit(function (event) {
        event.preventDefault();

        var method = $('input[name=optradio]:checked', '#search_form').val();
        var criteria = $('#search_criteria').val();
        var category = $('#search_category').val();
        type_of_order = $('#type_of_order').val();

        $.ajax({
            type: "POST",
            url: "api/SearchCustomer",
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
                    searchedClients = JSON.parse(result[1]).clients;

                    $('#client_search_results').empty();
                    if (searchedClients.length == 0) {
                        $("#client_search_results").append("<option value=''>No results found.</option>");
                    }
                    else {
                        for (var k = 0; k < searchedClients.length; k++) {
                            var html = '<option value="' + searchedClients[k].Client_ID + '">' + searchedClients[k].Client_ID + ' - ' + searchedClients[k].Name + '</option>';

                            $("#client_search_results").append(html);
                        }
                    }
                }else
                    alertify.alert('Error', result[1], function () { });
            }
        });
        $("#ResultModal").modal('show');
    });

    //On search results click
    $('#loadClientDetails').on('click', function () {
        client_ID = $('#client_search_results').val();

        if (client_ID == "" || client_ID == null)
            alertify.alert('Error', 'No Customer has been chosen!');
        else
            $.ajax({
                type: "GET",
                url: "api/Customer/" + client_ID,
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
                        client_details = JSON.parse(result[1]).clients[0];

                        if ($("#type_of_order").val() == "AdHoc") {
                            $("#div_6_1_Ad_Hoc").show();
                            $("#div_6_1_Quote").hide();
                        }
                        else {
                            $("#div_6_1_Ad_Hoc").hide();
                            $("#div_6_1_Quote").show();
                        }

                        

                        $('#Customer_Name_Span').html(client_details.Name);
                        $("#client_name").val(client_details.Name);
                        $('#Contact_details').empty();
                        $("#ResultModal").modal('hide');

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
                            $("#Contact_details").append(html);

                        }
                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
    });

    $("#Contact_details").on('change', function ()
        {
            var k = $("#Contact_details").val();
            $("#client_cont_num").val(contact_details[k].Number);
            $("#client_email").val(contact_details[k].Email_Address);

    });

    $("#Contact_details_2").on('change', function () {
        var k = $("#Contact_details_2").val();
        $("#client_cont_num_2").val(contact_details[k].Number);
        $("#client_email_2").val(contact_details[k].Email_Address);

    });

    $("#Items").on("change", ":input[type='number']", function () {
            calculateTotal();
    });

    $("#Items_2").on("change", ":input[type='number']", function () {
        calculateTotal2();
    });
    
    $('#loadQuoteDetails').on('click', function () {
        quote_ID = $('#quote_search_results').val();

        if (quote_ID == "" || quote_ID == null)
            alertify.alert('Error', 'No Quote has been chosen!');
        else
            $.ajax({
                type: "GET",
                url: "api/CustomerQuote/" + quote_ID,
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
                        var quote_details = JSON.parse(result[1]).client_quotes[0];
                        //alert(result[1]);

                        $("#client_name_2").val(quote_details.Client_Name);
                        var date = quote_details.Client_Quote_Expiry_Date.split("T");
                        $("#quote_exp_date").val(date[0]);

                        $("#Items_2").empty();

                        for (var p = 0; p < quote_details.contact_details.length; p++) {
                            var detail = {
                                Contact_ID: quote_details.contact_details[p].Contact_ID,
                                Name: quote_details.contact_details[p].Name, Number: quote_details.contact_details[p].Number,
                                Email_Address: quote_details.contact_details[p].Email_Address
                            };

                            contact_details.push(detail);

                            if (p == 0) {
                                $("#client_cont_num_2").val(contact_details[p].Number);
                                $("#client_email_2").val(contact_details[p].Email_Address);
                            }

                            var html = '<option value="' + p + '">' + quote_details.contact_details[p].Name + '</option>';
                            $("#Contact_details_2").append(html);

                        }

                        for (var a = 0; a < quote_details.details.length; a++)
                        {
                            var ID = quote_details.details[a].Part_Type_ID;

                            item_count++;
                            var supplier2 = { Part_Type_ID: ID, Part_Price: quote_details.details[a].Part_Price, Quantity: quote_details.details[a].Quantity, Client_Discount_Rate: quote_details.details[a].Client_Discount_Rate, Quantity_Delivered: 0 };
                            s_parts2.push(supplier2);
                            part_names2.push(quote_details.details[a].Part_Type_Name);


                            var row = '<tr id="row_part2_' + ID + '"><td>' + item_count + '</td><td>' + quote_details.details[a].Part_Type_Abbreviation + '</td><td>' + quote_details.details[a].Part_Type_Name + '</td><td><input type="number" id="cdr2_' + ID
                                + '" disabled value="' + quote_details.details[a].Client_Discount_Rate + '"/></td><td>' +
                                '<input type="number" disabled step="0.01" value="' + quote_details.details[a].Part_Price + '" id="p2_u_' + ID
                                + '"/></td><td><input type="number" id="p2_q_' + ID + '"  min="1" value="' + quote_details.details[a].Quantity + '"/>' +
                                '</td><td><button type="button" title ="Click to remove the part" class="Add_extra_things" onclick="return removeItem2(' + ID + ')"><i class="fa fa-minus"></i></button></td>';

                            $("#Items_2").append(row);
                        }


                        calculateTotal2();

                        $("#QuoteModal").modal('hide');
                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
    });
});

function calculateTotal2()
{
    var total = 0;
    for (var a = 0; a < s_parts2.length; a++) {
        var ID = s_parts2[a].Part_Type_ID;

        var quantity = $('#p2_q_' + ID).val();
        var price = $('#p2_u_' + ID).val();
        var cdr = $('#cdr2_' + ID).val();

        //console.log("CDR: " + cdr);
        //console.log("Price: " + price);

        var discounted_p = price - (price * parseInt(cdr) / 100);

        //console.log("Discounted: " + discounted_p);

        total += quantity * discounted_p;
    }

    var vat = (total * vat_rate / 100);
    var total2 = total + vat;

    vat = parseFloat(vat).toFixed(2);
    total = total.toFixed(2);
    total2 = total2.toFixed(2);

    $("#Order_Total_2").html("R " + total);
    $("#Vat_Total_2").html("R " + vat);
    $("#Order_SubTotal_2").html("R " + total2);
}

function calculateTotal() {
    var total = 0;

    for (var a = 0; a < s_parts.length; a++) {
        var ID = s_parts[a].Part_Type_ID;

        var quantity = $('#p_q_' + ID).val();
        var price = $('#p_u_' + ID).val();
        var cdr = $('#cdr_' + ID).val();

        //console.log("CDR: " + cdr);
        //console.log("Price: " + price);

        var discounted_p = price - (price * cdr / 100);

        //console.log("Discounted: " + discounted_p);

        total += quantity * discounted_p;
    }

    var vat = (total * vat_rate / 100);
    var total2 = total + vat;

    vat = parseFloat(vat).toFixed(2);
    total = total.toFixed(2);
    total2 = total2.toFixed(2);

    $("#Order_Total").html("R " + total);
    $("#VAT_Total").html("R " + vat);
    $("#Order_SubTotal").html("R " + total2);
}

function searchForItem() {
    var filter_text = $("#search_criteria_1").val();
    var filter_category = $("#search_category_1").val();
    var method = $('input[name=method_radio2]:checked', '#inventory_search_Modal').val();

    $.ajax({
        type: "POST",
        url: "api/SearchPartType",
        data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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
                searchedItems = JSON.parse(result[1]).part_types;

                $("#item_search_results").empty();
                if (searchedItems.length == 0) {
                    $("#item_search_results").append("<option value=''>No results found.</option>");
                }
                else {
                    for (var k = 0; k < searchedItems.length; k++) {
                        var type = '<option value="' + k + '">' + searchedItems[k].Abbreviation + ' - ' + searchedItems[k].Name + '</option>';
                        $("#item_search_results").append(type);
                    }
                }
            }
            else { alertify.alert('Error', result[1]); }
        }
    });
}

function addItem2() {
    var k = $("#item_search_results").val();
    // console.log(k);

    if (k == "" || k == null)
        alertify.alert('Error', 'No Part has been chosen!');
    else {
        var found = false;
        var ID = searchedItems[k].Part_Type_ID;

        for (var a = 0; a < s_parts.length; a++) {
            if (s_parts[a].Part_Type_ID == ID) {

                found = true;
            }
        }

        if (found == false) {
            var cdr = 0;

            for (var a = 0; a < client_details.part_discounts.length; a++)
            {
                if (client_details.part_discounts[a].Part_Type_ID == ID)
                    cdr = client_details.part_discounts[a].Discount_Rate;
            }

            var stock = searchedItems[k].Stock_Available;

            item_count++;
            var supplier2 = { Part_Type_ID: ID, Part_Price: searchedItems[k].Selling_Price, Quantity: 1, Client_Discount_Rate: cdr};
            s_parts.push(supplier2);
            part_names.push(searchedItems[k].Name);

            
            var row = '<tr id="row_part_' + searchedItems[k].Part_Type_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Abbreviation + '</td><td>' + searchedItems[k].Name + '</td><td><input type="number" id="cdr_' + searchedItems[k].Part_Type_ID + '" disabled value="' + cdr + '"/></td><td>' +
                '<input type="number" disabled step="0.01" value="' + searchedItems[k].Selling_Price + '" id="p_u_' + searchedItems[k].Part_Type_ID
                + '"/></td><td><input type="number" title = "Enter the quantity"max="999" id="p_q_' + searchedItems[k].Part_Type_ID + '"  min="1" value="1"/></td>' +
                '<td>'+stock+'</td>' + 
                '<td><button type="button" title ="Click to remove the part" class="Add_extra_things" onclick="return removeItem(&apos;Part Type&apos;, ' + searchedItems[k].Part_Type_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

            $("#Items").append(row);
            calculateTotal();

        }
        else alertify.alert('Error', 'Part Type already in list.');
    }
}

function openSearchInventory() {
    $("#inventory_search_Modal").modal('show');
}

function removeItem(which_one, ID) {

    item_count--;
if (which_one == "Part Type") {

        for (var a = 0; a < s_parts.length; a++) {
            if (s_parts[a].Part_Type_ID == ID) {
                s_parts.splice(a, 1);
                part_names.splice(a, 1);
                $('#row_part_' + ID).remove();
            }
        }
    }
calculateTotal();
}

function removeItem2(ID)
{
    for (var a = 0; a < s_parts2.length; a++) {
        if (s_parts2[a].Part_Type_ID == ID) {
            s_parts2.splice(a, 1);
            part_names2.splice(a, 1);
            $('#row_part2_' + ID).remove();
        }
    }

    calculateTotal2();
}

function submitOrder(to_do, typeOrder)
{
    var warnings = "";

    if (client_ID == "" || client_ID == null) {
        warnings = warnings + "No Customer has been specified. <br/>";
    }

    if (typeOrder == "Quote")
    {
        var date = (new Date()).toISOString();

        var selectedText = document.getElementById('quote_exp_date').value;
        var selectedDate = new Date(selectedText);
        var now = new Date();

        if (selectedDate < now) {
            warnings += "Quote has expired. Please add a new <a href='#' onclick='addQuote()'>quote</a> or place an Ad-Hoc Order. <br/>";
        }

        if (s_parts2.length <= 0)
            warnings += "No items on the order. <br/>";


        for (var a = 0; a < s_parts2.length; a++) {
            var ID = s_parts2[a].Part_Type_ID;

            var quantity = $('#p2_q_' + ID).val();
            s_parts2[a].Quantity = quantity;

            if (quantity < 1)
                warnings += "No quantity has been specified for item ID: " + ID + ". <br/>";
        }

        var c = $("#Contact_details_2").val();
        var ref = $("#ord_ref_number_2").val();

        if (ref.trim().length <= 0)
        {
            $("#ord_ref_number_2").addClass("empty");
            warnings = warnings + "No reference number has been specified. <br/>";
        }

        var sdr = client_details.Settlement_Discount_Rate;
        var ordertype = $("#order_type_2").val();
        var delivery = $("#del_method_2").val();
        var comment = $("#order_comment_2").val();
        var vat = $("#order_vat_2").is(":checked");

        if (comment.trim().length <= 0) {
            $("#ord_ref_number_2").addClass("empty");
            warnings = warnings + "No comments has been added. <br/>";
        }



        var order = { VAT_Inclu : vat, 
            Date: date, Reference_ID: ref, Client_ID: client_ID[0], Contact_ID: contact_details[c].Contact_ID, Settlement_Discount_Rate: sdr,
            Client_Order_Type_ID: parseInt(ordertype), Client_Order_Status_ID: 0,
            Delivery_Method_ID: parseInt(delivery), Job_Card_ID: 0, Comment: comment, details: s_parts2
        };

        $("#w_info_2").html(warnings);
    }
    else
    {
        var date = (new Date()).toISOString();

        if (s_parts.length <= 0)
            warnings += "No items on the order. <br/>";

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var quantity = $('#p_q_' + ID).val();
            s_parts[a].Quantity = quantity;

            if (quantity < 1)
                warnings += "No quantity has been specified for item ID: " + ID + ". <br/>";
        }

        var c = $("#Contact_details").val();
        var ref = $("#ord_ref_number").val();

        if (ref.length === 0) warnings = warnings + "No reference number has been specified. <br/>";


        var sdr = client_details.Settlement_Discount_Rate;
        var ordertype = $("#order_type").val();
        var delivery = $("#del_method").val();
        var comment = $("#order_comment").val();
        var vat = $("#order_vat").is(":checked");


        if (comment.length === 0) warnings = warnings + "No comment has been added. <br/>";

        var order = {
            VAT_Inclu: vat, Client_ID: client_ID[0],
            Date : date, Reference_ID : ref, Contact_ID: contact_details[c].Contact_ID, Settlement_Discount_Rate : sdr, 
            Client_Order_Type_ID : parseInt(ordertype), Client_Order_Status_ID : 0, 
            Delivery_Method_ID: parseInt(delivery), Job_Card_ID: 0, Comment: comment, details: s_parts
        };

        $("#w_info").html(warnings);
    }

    if (warnings == "") {
        $.ajax({
            type: "POST",
            url: "api/CustomerOrder",
            data: { data: "{'client' : " + JSON.stringify(order) + ", 'action' : '" + to_do + "'}" },
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
                    if (to_do == "print") {
                        var order_ID = result[2];

                        if (typeOrder == "Quote")
                        {
                            var vat = $("#order_vat_2").is(":checked");

                            var c = $("#Contact_details_2").val();
                            var ref = $("#ord_ref_number_2").val();
                            var c_ID = contact_details[c].Contact_ID;
                            var name;
                            var num;

                            

                            for (var p = 0; p < client_details.contact_details.length; p++) {

                                if (client_details.contact_details[p].Contact_ID == c_ID) {
                                    name = client_details.contact_details[p].Name;
                                    num = client_details.contact_details[p].Number;
                                }
                            }

                            
                            obj = { client: client_details, s_parts: s_parts2, p_names: part_names2, Order_ID: order_ID, c_name: name, c_num: num, VAT_Exemp: vat, order_type : $("#order_type_2").val() };
                        }
                        else
                        {
                            var vat = $("#order_vat").is(":checked");

                            var c = $("#Contact_details").val();
                            var ref = $("#ord_ref_number").val();
                            var c_ID = contact_details[c].Contact_ID;
                            var name;
                            var num;

                            for (var p = 0; p < client_details.contact_details.length; p++) {

                                if (client_details.contact_details[p].Contact_ID == c_ID) {
                                    name = client_details.contact_details[p].Name;
                                    num = client_details.contact_details[p].Number;
                                }
                            }

                            for (var a = 0; a < s_parts.length; a++) {
                                var ID = s_parts[a].Part_Type_ID;

                                var quantity = $('#p_q_' + ID).val();
                                s_parts[a].Quantity = quantity;
                            }

                            obj = { client: client_details, s_parts: s_parts, p_names: part_names, Order_ID: order_ID, c_name: name, c_num: num, VAT_Exemp: vat, Reference: ref, VAT: vat_rate, order_type : $("#order_type").val() };
                        }


                        var url_ = '<%=ResolveUrl("~/customer_order.html") %>';
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


function searchQuote()
{
    var method = $('input[name=optradio_quote]:checked', '#search_form_quote').val();
    var criteria = $('#search_criteria_quote').val();
    var category = $('#search_category_quote').val();

    $.ajax({
        type: "PUT",
        url: "api/SearchCustomerQuote/"+client_ID,
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
                searchedQuotes = JSON.parse(result[1]).client_quotes;
                $("#quote_search_results").empty();


                if (searchedQuotes.length == 0) {
                    $("#quote_search_results").append("<option value=''>No results found.</option>");
                }
                else {
                    for (var k = 0; k < searchedQuotes.length; k++) {
                        var date = searchedQuotes[k].Date.split("T");
                        var type = '<option value="' + searchedQuotes[k].Client_Quote_ID + '">' + searchedQuotes[k].Client_Quote_ID + ' - ' + searchedQuotes[k].Client_Name + ' (' + date[0] + ')</option>';
                        $("#quote_search_results").append(type);
                    }
                }
            }
            else { alertify.alert('Error', result[1]); }
        }

    });
    $("#QuoteModal").modal('show');
    return false;
}

function openSearchInventory() {
    $("#inventory_search_Modal").modal('show');
}

function addQuote()
{
    var url = "/GenerateCustomerQuote";
    window.open(url, '_blank');
}
</script>
<h1 class="default-form-header">Place Customer Order</h1>
		
<!-- Search Code -->
<div class="searchDiv">
<form id="search_form">
	<fieldset>
	<legend>Search for Customer: </legend>
        <div class="row">
            <div class="col-sm-4">
			    <label for="type_of_order">Type of Order: </label>
				<select class="form-control" id="type_of_order" title ="Select the order type" data-toggle ="tooltip" data-placement ="right">
					<option value="AdHoc">Ad-Hoc Order</option>
					<option value="Quote">Quote-Based Order</option>
				</select>
			</div>
        </div>
		<div class="row">
		<div class="col-sm-4">
			<label for="search_criteria" class="control-label">Search Criteria: </label>
			<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the customer details to search for " data-toggle ="tooltip" data-placement ="bottom">
		</div>
		<div class="col-sm-4">
			<label for="search_category">Search By: </label>
			<select class="form-control" id="search_category" title ="Select the customer details to search by" data-toggle ="tooltip" data-placement ="bottom">
				<option value="All">All</option>
				<option value="Name">Name</option>
				<option value="Vat">VAT No.</option>
				<option value="Account">Account No.</option>
				<option value="ID">Customer No.</option>
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
				<button id="submitSearch" type ="submit" class ="searchButton" title ="Click here to search for the customer" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
	<h4 class="modal-title">Select a Customer</h4>
	</div>
	<div class="modal-body">
		<select multiple class="form-control" id="client_search_results" title ="Select a customer">
		</select>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" id="loadClientDetails" title ="Click to load customers details">Load Customer Details</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="QuoteModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true" style="color:white">&times;</span>
		</button>
		<h4 class="modal-title">Select a Quote</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="quote_search_results" title ="Select a quote">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadQuoteDetails" title ="Click to load the quote details">Load Quote Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<br />
<div id="div_6_1_Quote" style="display: none">	
<form id="search_form_quote">
	<fieldset>
	<legend>Search for Quote for Customer <span id="Customer_Name_Span"></span>: </legend>
		<div class="row">
		<div class="col-sm-4">
			<label for="search_criteria" class="control-label">Search Criteria: </label>
			<input type="text" class="form-control" id="search_criteria_quote" placeholder="Search Criteria" title ="Enter the quote details to search for" data-toggle ="tooltip" data-placement ="bottom"/>
		</div>
		<div class="col-sm-4">
			<label for="search_category">Search By: </label>
			<select class="form-control" id="search_category_quote" title ="Select the quote details to search by" data-toggle ="tooltip" data-placement ="bottom">
				<option value="All">All</option>
				<option value="ID">Customer Quote No.</option>
				<option value="CName">Customer Name</option>
			</select>
		</div>	
		<div class="col-sm-4">
				<label class="control-label">Search Method: </label><br/>
				<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio_quote">Exact</label>
				<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio_quote">Contains</label>
		
			</div>
		</div>
		<div class="row">
            <div class="col-sm-8">
				
			</div>
			<div class="col-sm-4">
				<button type="button" onclick="return searchQuote()" class="searchButton" title ="Click here to search for the quote" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
		</div>
	</fieldset>
</form>

<br />

<form id="UC6-1_Quote" class="form-horizontal">
<fieldset>
	<legend>Customer Information:</legend>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_name" class="control-label">Customer Name: </label>
			<input type="text" class="form-control" id="client_name_2" readonly>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_contact" class="control-label">Contact Name: </label>
			<select class="form-control" id="Contact_details_2" title ="Select the contact person" data-toggle ="tooltip" data-placement ="right">
			</select>
		</div>
        <div class="col-sm-6">
            <br /><br />
            <button type="button" class="Add_extra_things" ><i class="fa fa-plus"></i> Add Contact</button>
		</div>
    </div>
    <div class="row">
		<div class="col-sm-6">
			<label for="client_cont_num" class="control-label">Contact Number: </label>
			<input type="text" class="form-control" id="client_cont_num_2" readonly>
		</div>
		<div class="col-sm-6">
			<label for="client_email" class="control-label">Contact Email: </label>
			<input type="email" class="form-control" id="client_email_2" readonly>
		</div>
	</div>
</fieldset>
<br/>
<fieldset>
	<legend>Order Information:</legend>
				
	<div class="row">
		<div class="col-sm-6">
			<label for="ord_ref_number" class="control-label">Reference Number: </label>
			<input type="text" class="form-control" id="ord_ref_number_2" placeholder="XXX000" maxlength="10" title ="Enter the order reference number" data-toggle ="tooltip" data-placement ="bottom"/>
		</div>
		<div class="col-sm-6">
			<label for="order_vat" class="control-label">VAT Included: </label><br/>
			<input type="checkbox" id="order_vat_2" checked title ="Select if VAT is included" data-toggle ="tooltip" data-placement ="right">
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<label for="del_method" class="control-label">Delivery Method: </label>
			<select id="del_method_2" class="form-control" title ="Select the delivery method" data-toggle ="tooltip" data-placement ="bottom">
                <option value="1">Partial Delivery</option>
				<option value="2">Full Delivery</option>
			</select>
		</div>
		<div class="col-sm-6">
			<label for="order_type" class="control-label">Order Type: </label>
			<select id="order_type_2" class="form-control" title ="Select the order type" data-toggle ="tooltip">
				<option value="1">Cash Sale</option>
				<option value="2">Contracted Sale</option>
			</select>
		</div>
	</div>
    <div class="row">
		<div class="col-sm-12">
			<label for="order_comment_2" class="control-label">Order Comments: </label>
			<textarea class="form-control" id="order_comment_2" maxlength="500" title ="Enter order comments" data-toggle ="tooltip">Add your comment here.</textarea>
		</div>
	</div>
</fieldset>
<br />    
    	
<fieldset id="partsFieldset_2">
	<legend>Quote Information:</legend>
    <div class="row">
        <div class="col-md-4">
            <label for="quote_exp_date" class="control-label">Quote Expiry Date: </label>
            <input type="text" class="form-control" id="quote_exp_date" disabled />
        </div>

    </div>
	<div id="parts_2">
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
                        <th>Remove</th>
					</tr>
				</thead>
				<tbody id="Items_2">
				</tbody>
			</table>
		</div>
	</div>



    <div class="row">
        <div class="col-sm-offset-8 col-sm-4">
			<table class="table table-bordered" >
				<tbody style="text-align: right">
					<tr>
						<td>Sub Total</td><td><span id="Order_Total_2">R 0.00</span></td>
					</tr>
					<tr>
						<td>VAT</td><td><span id="Vat_Total_2">R 0.00</span></td>
					</tr>
					<tr>
						<td>Total</td><td><span id="Order_SubTotal_2">R 0.00</span></td>
					</tr>
				</tbody>
			</table>
		</div>
    </div>
</fieldset>
<br/>
<div>
    <div class="Warning_Info" id="w_info_2"></div>
</div>
<div class="row">
	<div class="col-sm-3">
	</div>
	<div class="col-sm-3">
		<button onclick="return submitOrder('print', 'Quote')" class = "form-custom-button-columns" title ="Click to proccess and print the order" data-toggle ="tooltip"><i class="fa fa-print" aria-hidden="true"></i> Process and Print Order</button>
	</div>
	<div class="col-sm-3">
		<button onclick="return submitOrder('email', 'Quote')" class = "form-custom-button-columns" title ="Click to proccess and email the order" data-toggle ="tooltip"><i class="fa fa-envelope-o" aria-hidden="true"></i> Process and Email Order</button>
	</div>
    <div class="col-sm-3">
		<button type="button" onclick="return submitOrder('process', 'Quote')" class="form-custom-button-columns" title ="Click to proccess the order" data-toggle ="tooltip"><i class="fa fa-check" aria-hidden="true"></i> Process Order</button>
	</div>
</div>
</form>
</div>		
		
<!-- FORM CODE -->
<div id="div_6_1_Ad_Hoc" style="display: none">	
<form id="UC6-1_Ad_Hoc" class="form-horizontal">
<fieldset>
	<legend>Customer Information:</legend>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_name" class="control-label">Customer Name: </label>
			<input type="text" class="form-control" id="client_name" readonly>
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
		<div class="col-sm-6">
			<label for="del_method" class="control-label">Delivery Method: </label>
			<select id="del_method" class="form-control" title ="Select the delivery method" data-toggle ="tooltip" data-placement ="bottom">
				<option value="1">Partial Delivery</option>
				<option value="2">Full Delivery</option>
			</select>
		</div>
		<div class="col-sm-6">
			<label for="order_type" class="control-label">Order Type: </label>
			<select id="order_type" class="form-control" title ="Select the order type" data-toggle ="tooltip">
				<option value="1">Cash Sale</option>
				<option value="2">Contracted Sale</option>
			</select>
		</div>
	</div>
    <div class="row">
		<div class="col-sm-12">
			<label for="order_commentw" class="control-label">Order Comments: </label>
			<textarea class="form-control" id="order_comment" maxlength="500" title ="Enter the order comments" data-toggle ="tooltip">Add your comment here.</textarea>
		</div>
	</div>
</fieldset>
	<br/>	
<fieldset id="partsFieldset">
	<legend>Order Items:</legend>
	<div id="parts">

		<button type="button" class="Add_extra_things" onclick="return openSearchInventory()" title ="Select to add parts to the quote" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus"></i> Add Part to Order</button>

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
                        <th>Stock Available</th>
                        <th>Remove</th>
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
						<td>VAT</td><td><span id="VAT_Total">R 0.00</span></td>
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
		<button onclick="return submitOrder('print', 'AdHoc')" class = "form-custom-button-columns" title ="Click to proccess and print order" data-toggle ="tooltip"><i class="fa fa-print" aria-hidden="true"></i> Process and Print Order</button>
	</div>
	<div class="col-sm-4">
		<button onclick="return submitOrder('email', 'AdHoc')" class = "form-custom-button-columns" title ="Click to proccess and email order" data-toggle ="tooltip"><i class="fa fa-envelope-o" aria-hidden="true"></i> Process and Email Order</button>
	</div>
    <div class="col-sm-4">
		<button type="button" onclick="return submitOrder('process', 'AdHoc')" class="form-custom-button-columns" title ="Click to proccess order" data-toggle ="tooltip"><i class="fa fa-check" aria-hidden="true"></i> Process Order</button>
	</div>
</div>
</form>
</div>


    <!-- PART MODAL CODE -->
<div class="modal fade" id="inventory_search_Modal">
<div class="modal-dialog" role="document" style="width : 80%">
<div class="modal-content">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
	<h4 class="modal-title">Add Item to Order</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the parts details to search for">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category_1" title ="Select the the parts details to search by">
					<option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Description">Description</option>
				</select>
			</div>	
			 <div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="method_radio2">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio2">Contains</label>
					
				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">

				</div>
				<div class="col-sm-4">
					<button onclick="return searchForItem()" class ="form-custom-button-modal" title ="Click to search for part"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results" title ="Select a part">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Click to add part to order">Add Part to Order</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
