<%@ Page Title="Generate Price List" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-3.aspx.cs" Inherits="Test._6_3" %>
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
    var part_names = [];

$(document).ready(function () {
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

                for (var k = 0; k < searchedClients.length; k++) {
                    var html = '<option value="' + searchedClients[k].Client_ID + '">' +searchedClients[k].Client_ID +' - '+ searchedClients[k].Name + '</option>';

                    $("#client_search_results").append(html);
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
        alertify.alert('Error', 'No Client has been chosen!');
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
});

function searchForItem() {
    var filter_text = $("#search_criteria_1").val();
    var filter_category = $("#search_category_1").val();
    var method = $('input[name=method_radio2]:checked', '#inventory_search_Modal').val();

    $.ajax({
        type: "POST",
        url: "api/SearchPartType",
        data: {data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}"},
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

            var supplier2 = { Part_Type_ID: ID, Selling_Price: 0, Name: searchedItems[k].Name };
            s_parts.push(supplier2);
            part_names.push(searchedItems[k].Name);

            var row = '<tr id="row_part_' + searchedItems[k].Part_Type_ID + '"><td>' + searchedItems[k].Part_Type_ID + '</td><td>' + searchedItems[k].Name + '</td><td>' +
                '<input type="number" disabled step="0.01" value="' + searchedItems[k].Selling_Price + '" id="p_u_' + searchedItems[k].Part_Type_ID
                + '"/></td></td>' +
                '<td><button type="button" title ="Click to remove the part" class="Add_extra_things" onclick="return removeItem(&apos;Part Type&apos;, ' + searchedItems[k].Part_Type_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

            $("#Items").append(row);

        }
        else alertify.alert('Error', 'Part Type already in list.');
    }
}

function openSearchInventory() {
    $("#inventory_search_Modal").modal('show');
}

function removeItem(which_one, ID) {

if (which_one == "Part Type") {

        for (var a = 0; a < s_parts.length; a++) {
            if (s_parts[a].Part_Type_ID == ID) {
                s_parts.splice(a, 1);
                $('#row_part_' + ID).remove();
            }
        }
    }
}

function submitList(to_do)
{
    var warnings = "";
    if(to_do == 'print')
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
            var ID = s_parts[a].Part_Type_ID;

            var price = $('#p_u_' + ID).val();
            s_parts[a].Selling_Price = price;
        }

        var obj = { client: client_details, s_parts: s_parts, p_names: part_names, c_name: name, c_num: num };

        var url_ = '<%=ResolveUrl("~/Price_List.html") %>';
        var w = window.open(url_);
        w.passed_obj = obj;
        w.print();
    }
    else
    {
        var c = $("#Contact_details").val();
        var c_ID = contact_details[c].Contact_ID;
        var name;
        var num;

        for (var p = 0; p < client_details.contact_details.length; p++) {
            if (client_details.contact_details[p].Contact_ID == c_ID) {
                name = client_details.contact_details[p].Name;
                num = client_details.contact_details[p].Number;
            }
        }

        if (s_parts.length == 0)
            warnings += "No parts in the part list. <br/>";


        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var price = $('#p_u_' + ID).val();
            s_parts[a].Selling_Price = price;
        }

        var obj = { client: client_details, parts: s_parts, c_ID: c };
        console.log(obj);

        $("#w_info").html(warnings);

        if (warnings == "")
        {
            $.ajax({
                type: "POST",
                url: "api/PriceList",
                data: { data: JSON.stringify(obj) },
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
        
    }

    return false;
}
</script>
<h1 class="default-form-header">Generate Price List</h1>
		
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
				<button id="submitSearch" type ="submit" class ="searchButton" title ="Click to search for the customer" data-toggle ="tooltip" data-placement ="left" ><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
	<button type="button" class="btn btn-secondary modalbutton" id="loadClientDetails" title ="Click to load the customer details">Load Customer Details</button>
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
			
<fieldset id="partsFieldset">
	<legend>Price List Information:</legend>
	<div id="parts">

		<button type="button" class="Add_extra_things" onclick="return openSearchInventory()" title ="Click to add the part to the list" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus"></i> Add Part to List</button>

        <br/>
		<div class="table-responsive makeDivScrollable">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>Code</th>
						<th>Name</th>
						<th>Unit Price R (VAT Excl.)</th>
                        <th>Remove</th>
					</tr>
				</thead>
				<tbody id="Items">
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
		<button onclick="return submitList('print')" type="button" class = "form-custom-button-columns" title ="Click to print price list" data-toggle ="tooltip"><i class="fa fa-print" aria-hidden="true"></i> Print Price List</button>
	</div>
	<div class="col-sm-4">
		<button onclick="return submitList('email')" type="button" class = "form-custom-button-columns" title ="Click to email price list" data-toggle ="tooltip" ><i class="fa fa-envelope-o" aria-hidden="true"></i> Email Price List</button>
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
	<h4 class="modal-title">Add Item to Price List</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the items details to search for">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category_1" title ="Select the items details to search by">
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
					<button onclick="return searchForItem()" class ="form-custom-button-modal" title ="Click to search for item"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results" title ="Select the item">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Click to add part to price list">Add Part to Price List</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
