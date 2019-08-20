<%@ Page Title="Generate Customer Quote" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-1.aspx.cs" Inherits="Test._6_1" %>
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
    var part_names = [];
    var vat_rate;

    $(document).ready(function () {

        vat_rate = getVATRate();

//On search
$("#search_form").submit(function (event) {
    event.preventDefault();

    var method = $('input[name=optradio]:checked', '#search_form').val();
    var criteria = $('#search_criteria').val();
    var category = $('#search_category').val();

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
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
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
            url: "api/Customer/"+client_ID,
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

                    $("#div_6_1").show();

                    $("#client_name").val(client_details.Name);
                    $('#Contact_details').empty();
                    $("#ResultModal").modal('hide');
                   
                    for (var p = 0; p < client_details.contact_details.length; p++)
                    {
                        var detail = { Contact_ID : client_details.contact_details[p].Contact_ID,
                            Name: client_details.contact_details[p].Name, Number: client_details.contact_details[p].Number,
                            Email_Address: client_details.contact_details[p].Email_Address
                        };

                        contact_details.push(detail);

                        if (p == 0)
                        {
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

    $("#Items").on("change", ":input[type='number']", function () {
        calculateTotal();
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

        var discounted_p = price - (price * cdr / 100);

        //console.log("Discounted: " + discounted_p);

        total += quantity * discounted_p;
    }

    total = total.toFixed(2);

    $("#Quote_Total").html("R " + total);
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

            item_count++;
            var supplier2 = { Part_Type_ID: ID, Part_Price: searchedItems[k].Selling_Price, Quantity: 1, Client_Discount_Rate: cdr};
            s_parts.push(supplier2);
            part_names.push(searchedItems[k].Name);

            var row = '<tr id="row_part_' + searchedItems[k].Part_Type_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Abbreviation + '</td><td>' + searchedItems[k].Name + '</td><td><input type="number" id="cdr_' + searchedItems[k].Part_Type_ID + '" disabled value="' + cdr + '"/></td><td>' +
                '<input type="number" disabled step="0.01" value="' + searchedItems[k].Selling_Price + '" id="p_u_' + searchedItems[k].Part_Type_ID
                + '"/></td><td><input type="number" title = "" id="p_q_' + searchedItems[k].Part_Type_ID + '"  min="1" max="999" value="1" title ="Enter the quantity"/></td>' +
                '<td><button type="button" title = "Click to remove the part" class="Add_extra_things" onclick="return removeItem(&apos;Part Type&apos;, ' + searchedItems[k].Part_Type_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

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

$(function () {
    $("#quote_exp").datepicker();
});

function submitQuote(to_do)
{
    var warnings = "";

    if (client_ID == "" || client_ID == null) {
        warnings = warnings + "No Customer has been specified. <br/>";
    }

    var date = (new Date()).toISOString();

    if (s_parts.length <= 0)
        warnings = warnings + "No items on quote. <br/>";

    for (var a = 0; a < s_parts.length; a++) {
        var ID = s_parts[a].Part_Type_ID;

        var quantity = $('#p_q_' + ID).val();
        s_parts[a].Quantity = quantity;

        if (quantity < 1)
            warnings += "No quantity has been specified for item ID: " + ID + ". <br/>";
    }

    var c = $("#Contact_details").val();


    var correct2 = $("#quote_exp").val();
    var exp;

    if (correct2.trim().length == 0 || correct2 == "")
    {
        warnings += "Please specify an expiry date. <br/>";
        exp = (new Date()).toISOString();
    }
    else exp = (new Date(correct2)).toISOString();

    var quote = {
        Date: date, Client_ID: parseInt(client_ID), Contact_ID: contact_details[c].Contact_ID, Settlement_Discount_Rate : client_details.Settlement_Discount_Rate,
        details: s_parts, Client_Quote_Expiry_Date: exp
    };


    $("#w_info").html(warnings);

    if (warnings == "") {
        $.ajax({
            type: "POST",
            url: "api/CustomerQuote",
            data: { data: "{'client' : " + JSON.stringify(quote) + ", 'action' : '" + to_do + "'}" },
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
                    var q_ID = result[2];

                    if (to_do == "print")
                    {
                        for (var a = 0; a < s_parts.length; a++) {
                            var ID = s_parts[a].Part_Type_ID;

                            var quantity = $('#p_q_' + ID).val();
                            s_parts[a].Quantity = quantity;
                        }

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


                        var obj = { client: client_details, s_parts: s_parts, p_names: part_names, Quote_ID: q_ID, c_name: name, c_num: num, VAT: vat_rate };

                        var url_ = '<%=ResolveUrl("~/Quote.html") %>';
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
<h1 class="default-form-header">Generate Customer Quote</h1>
		
<!-- Search Code -->
<div class="searchDiv">
<form id="search_form">
	<fieldset>
	<legend>Search for Customer: </legend>
		<div class="row">
		<div class="col-sm-4">
			<label for="search_criteria" class="control-label">Search Criteria: </label>
			<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the customer details to search for" data-toggle ="tooltip" data-placement ="bottom">
		</div>
		<div class="col-sm-4">
			<label for="search_category">Search By: </label>
			<select class="form-control" id="search_category" title ="Select the customer details to search by" data-toggle ="tooltip" data-placement ="bottom">
				<option value="All">All</option>
				<option value="Name">Name</option>
				<option value="Vat">Vat Number</option>
				<option value="Account">Account Number</option>
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
            <div class="col-sm-8">
			
			</div>
			<div class="col-sm-4">
				<button id="submitSearch" type ="submit" class ="searchButton" title ="Click to search for customer" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
	<button type="button" class="btn btn-secondary modalbutton" id="loadClientDetails" title ="Click to load the customers details">Load Customer Details</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
		
		
<!-- FORM CODE -->
<br />
<div id="div_6_1" style="display: none">	
<form id="UC6-1" class="form-horizontal">
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
			<select class="form-control" id="Contact_details" title ="Select a contact name" data-toggle ="tooltip" data-placement ="right">

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
			<input type="email" class="form-control" id="client_email"  readonly>
		</div>
	</div>
</fieldset>
<br/>
			
<fieldset id="partsFieldset">
	<legend>Quote Information:</legend>
    <div class="row">
        <div class="col-sm-6">
            <label for="quote_exp" class="control-label">Quote Expiration Date: </label>
			<input type="text" class="form-control" id="quote_exp" title ="Enter the Quote expiration date" data-toggle ="tooltip" data-placement ="right"/>
		</div>
    </div><br />
	<div id="parts">

		<button type="button" class="Add_extra_things" onclick="return openSearchInventory()" title ="Click to add items to the quote" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus"></i> Add Part to Quote</button>

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
				<tbody id="Items">
				</tbody>
			</table>
		</div>
	</div>

    <div class="row">
	    <div class="col-sm-4">
				
	    </div>
        <div class="col-sm-4" style="font-size:14pt;">
		    <span class="Quote_Total">Total R (VAT Excl.): </span>
	    </div>
	    <div class="col-sm-4" style="font-size:14pt;">
		    <span id="Quote_Total">R 0.00</span>
	    </div>
    </div>
</fieldset>
<br/>
<div>
    <div class="Warning_Info" id="w_info"></div>
</div>
<div class="row">
    <div class="col-sm-4">
		<!-- <button onclick="return submitQuote('process')" class = "form-custom-button-columns" title ="Click to process the quote" data-toggle ="tooltip"><i class="fa fa-check" aria-hidden="true"></i> Process Quote</button> -->
	</div>
	<div class="col-sm-4">
		<button onclick="return submitQuote('print')" class = "form-custom-button-columns" title ="Click to print the customers quote" data-toggle ="tooltip"><i class="fa fa-print" aria-hidden="true"></i> Print Customer Quote</button>
	</div>
	<div class="col-sm-4">
		<button onclick="return submitQuote('email')" class = "form-custom-button-columns" title ="Click to email the quote to the customer" data-toggle ="tooltip"><i class="fa fa-envelope-o" aria-hidden="true"></i> Email Customer Quote</button>
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
	<h4 class="modal-title">Add Item to Quote</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the parts details to search for">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category_1" title ="Select the parts details to search by">
					<option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Description">Description</option>
				</select>
			</div>	
			 <div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Exact" checked name="method_radio2">Exact</label>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Contains" name="method_radio2">Contains</label>
				
				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">

				</div>
				<div class="col-sm-4">
					<button onclick="return searchForItem()" class ="form-custom-button-modal" title ="Click to search for the part"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results" title ="Select the part">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Click to add the part to quote">Add Part to Quote</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
