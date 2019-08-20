<%@ Page Title="Receive Supplier Quote" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-3.aspx.cs" Inherits="Test._5_3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<script src="scripts/MyScripts/getterScripts.js"></script>
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
var what;
var searchedItems;
var supplier_ID;
var searchedSuppliers;
var item_count = 0;
var vat_rate = 14;

function searchForItem() {
    var filter_text = $("#search_criteria").val();
    var filter_category = $("#search_category").val();
    what = $("#what").val();
    var method = $('input[name=method_radio2]:checked', '#inventory_search_Modal').val();

    if (supplier_ID == "" || supplier_ID == undefined || supplier_ID == null)
    {
        alertify.alert('Error', "Cannot search if no supplier has been specified.");
        return false;
    }

    if (what == "Part Type") {
        $.ajax({
            type: "PUT",
            url: "api/SearchPartType/" + supplier_ID,
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
    } else
        if (what == "Component") {
            $.ajax({
                type: "PUT",
                url: "api/SearchComponent/" + supplier_ID,
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

                        searchedItems = JSON.parse(result[1]).components;
                        $("#item_search_results").empty();

                        if (searchedItems.length == 0) {
                            $("#item_search_results").append("<option value=''>No results found.</option>");
                        }
                        else {
                            for (var k = 0; k < searchedItems.length; k++) {
                                var type = '<option value="' + k + '">' + searchedItems[k].Name + '</option>';
                                $("#item_search_results").append(type);
                            }
                        }
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
        } else {
            $.ajax({
                type: "PUT",
                url: "api/SearchRawMaterial/" + supplier_ID,
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
                        searchedItems = JSON.parse(result[1]).raw_materials;
                        $("#item_search_results").empty();

                        if (searchedItems.length == 0) {
                            $("#item_search_results").append("<option value=''>No results found.</option>");
                        }
                        else {
                            for (var k = 0; k < searchedItems.length; k++) {
                                var type = '<option value="' + k + '">' + searchedItems[k].Name + '</option>';
                                $("#item_search_results").append(type);
                            }
                        }
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
        }
}

function addItem2() {
    var k = $("#item_search_results").val();
    // console.log(k);

    if (k == "" || k == null)
        alertify.alert('Error', 'No Inventory Item has been chosen!');
    else {
        var found = false;

        if (what == "Raw Material") {

            var ID = searchedItems[k].Raw_Material_ID;

            for (var a = 0; a < s_raw.length; a++) {
                if (s_raw[a].Raw_Material_ID == ID) {

                    found = true;
                }
            }

            if (found == false)
            {
                item_count++;
                var dimensions;

                alertify.prompt('Please enter the dimensions for the raw material', 'a x b', function (evt, value) {
                    dimensions = value;

                    if (dimensions == null || dimensions == '')
                    { }
                    else
                    {
                        var price = getPrice(ID, "Raw Material", supplier_ID);
                        

                        var supplier2 = { Raw_Material_ID: ID, Price: price, Dimension: dimensions, Quantity: 1 };
                        s_raw.push(supplier2);

                        var row = '<tr id="row_raw_' + searchedItems[k].Raw_Material_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + searchedItems[k].Name + ' (' + dimensions + ')</td><td>' +
                            '<input type="number" title = "Enter the unit price" step="0.01" value="'+price+'" min="0" id="r_u_' + searchedItems[k].Raw_Material_ID
                            + '"/></td><td><input type="number" title = "Enter the quantity" id="r_q_' + searchedItems[k].Raw_Material_ID + '" min="1" max="999" value="1"/></td>' +
                            '<td><button type="button" title = "Click to remove the raw material" class="Add_extra_things" onclick="return removeItem(&apos;Raw Material&apos;, ' + searchedItems[k].Raw_Material_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

                        $("#Items").append(row);
                    }
                });
               
          //      dimensions = prompt("Please enter the dimensions for the raw material", "a x b");
                   
                

                
            }
            else alertify.alert('Error', 'Raw Material already in list.');

        }
        else if (what == "Part Type") {
            var ID = searchedItems[k].Part_Type_ID;

            for (var a = 0; a < s_parts.length; a++) {
                if (s_parts[a].Part_Type_ID == ID) {

                    found = true;
                }
            }

            if (found == false) {

                item_count++;
                var price = getPrice(ID, "Part Type", supplier_ID);
                var supplier2 = { Part_Type_ID: ID, Price: price, Quantity: 1 };
                s_parts.push(supplier2);

                

                var row = '<tr id="row_part_' + searchedItems[k].Part_Type_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Part_Type_ID + '</td><td>Part Type</td><td>' + searchedItems[k].Name + '</td><td>' +
                    '<input type="number" title = "Enter the unit price" step="0.01" min="0" value="' + price + '" id="p_u_' + searchedItems[k].Part_Type_ID
                    + '"/></td><td><input type="number" title = "Enter the quantity" id="p_q_' + searchedItems[k].Part_Type_ID + '"  min="1" max="999" value="1"/></td>' +
                    '<td><button type="button" title = "Click to remove the part type"  class="Add_extra_things" onclick="return removeItem(&apos;Part Type&apos;, ' + searchedItems[k].Part_Type_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

                $("#Items").append(row);
                    
            }
            else alertify.alert('Error', 'Part Type already in list.');
        }
        else if (what == "Component") {

            var ID = searchedItems[k].Component_ID;

            for (var a = 0; a < s_components.length; a++) {
                if (s_components[a].Component_ID == ID) {

                    found = true;
                }
            }

            if (found == false) {

                item_count++;

                var price = getPrice(ID, "Component", supplier_ID);

                var supplier2 = { Component_ID: ID, Price : price, Quantity : 1 };
                s_components.push(supplier2);

                

                var row = '<tr id="row_component_' + searchedItems[k].Component_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Component_ID + '</td><td>Component</td><td>' + searchedItems[k].Name + '</td><td>' +
                    '<input type="number" title = "Enter the unit price" step="0.01" min="0" value="' + price + '" id="c_u_' + searchedItems[k].Component_ID
                    + '"/></td><td><input type="number" title = "Enter the quantity" id="c_q_' + searchedItems[k].Component_ID + '"  min="1" max="999" value="1"/></td>' +
                    '<td><button type="button" title = "Click to remove the component"  class="Add_extra_things" onclick="return removeItem(&apos;Component&apos;, ' + searchedItems[k].Component_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

                $("#Items").append(row);
            }
            else alertify.alert('Error', 'Component already in list.');
        }
    }
}

function calculateTotal() {
    var total = 0;

    //Get the different inventory item values
    for (var a = 0; a < s_components.length; a++) {
        var ID = s_components[a].Component_ID;

        var quantity = $('#c_q_' + ID).val();
        var price = $('#c_u_' + ID).val();

        total += quantity * price;
    }

    for (var a = 0; a < s_raw.length; a++) {
        var ID = s_raw[a].Raw_Material_ID;

        var quantity = $('#r_q_' + ID).val();
        var price = $('#r_u_' + ID).val();

        total += quantity * price;
    }

    for (var a = 0; a < s_parts.length; a++) {
        var ID = s_parts[a].Part_Type_ID;

        var quantity = $('#p_q_' + ID).val();
        var price = $('#p_u_' + ID).val();

        total += quantity * price;
    }

    total = total.toFixed(2);

    $("#Quote_Total").html("R " + total);

}

function openSearchInventory()
{
    $("#inventory_search_Modal").modal('show');
}

function removeItem(which_one, ID)
{

    item_count--;
    //console.log("Hello");
    if (which_one == "Raw Material") {

        for (var a = 0; a < s_raw.length; a++) {
            if (s_raw[a].Raw_Material_ID == ID) {
                s_raw.splice(a, 1);
                $('#row_raw_' + ID).remove();
            }
        }
    }
    else if (which_one == "Part Type") {

        for (var a = 0; a < s_parts.length; a++) {
            if (s_parts[a].Part_Type_ID == ID) {
                s_parts.splice(a, 1);
                $('#row_part_' + ID).remove();
            }
        }
    }
    else if (what == "Component") {

        for (var a = 0; a < s_components.length; a++) {
            if (s_components[a].Component_ID == ID) {
                s_components.splice(a, 1);

                $('#row_component_' + ID).remove();
            }
        }
    }

    calculateTotal();
}

$(document).ready(function () {

    $("#UC5-3").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        if (supplier_ID == "" || supplier_ID == null)
        {
            warnings = warnings + "No Supplier has been specified. <br/>";
        }

        var reference = $("#quote_reference").val();

        if (reference.trim().length <= 0)
        {
            $('#quote_reference').addClass("empty");
            warnings = warnings + "No reference has been specified. <br/>";
        }

        var correct = $("#quote_date").val();
        var correct2 = $("#quote_exp").val();

        var d1 = new Date(correct);
        var d2 = new Date(correct2);

        if (d1 > d2)
            warnings += "Expiry date must occur after quote date. <br/>";


        var date = (new Date(correct)).toISOString();
        var exp = (new Date(correct2)).toISOString();

        if (s_raw.length <= 0 && s_parts.length <= 0 && s_components <= 0)
            warnings = warnings + "There are no items on the quote. <br/>";

        //Get the different inventory item values
        for (var a = 0; a < s_components.length; a++) {
            var ID = s_components[a].Component_ID;

            var quantity = $('#c_q_' + ID).val();
            var price = $('#c_u_' + ID).val();

            s_components[a].Price = price;
            s_components[a].Quantity = quantity;

            if (quantity < 1)
            {
                warnings += "Quantity cannot be less than 1 for Component #" + ID + ". <br/>";
                $('#c_q_' + ID).addClass("empty");
            }

            if (price < 0)
            {
                warnings += "Price cannot be less than 0 for Component #" + ID + ". <br/>";
                $('#c_u_' + ID).addClass("empty");
            }
        }

        for (var a = 0; a < s_raw.length; a++) {
            var ID = s_raw[a].Raw_Material_ID;

            var quantity = $('#r_q_' + ID).val();
            var price = $('#r_u_' + ID).val();

            s_raw[a].Price = price;
            s_raw[a].Quantity = quantity;

            if (quantity < 1) {
                warnings += "Quantity cannot be less than 1 for Raw Material #" + ID + ". <br/>";
                $('#r_q_' + ID).addClass("empty");
            }

            if (price < 0) {
                warnings += "Price cannot be less than 0 for Raw Material #" + ID + ". <br/>";
                $('#r_u_' + ID).addClass("empty");
            }
        }

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var quantity = $('#p_q_' + ID).val();
            var price = $('#p_u_' + ID).val();

            s_parts[a].Price = price;
            s_parts[a].Quantity = quantity;

            if (quantity < 1) {
                warnings += "Quantity cannot be less than 1 for Part Type #" + ID + ". <br/>";
                $('#p_q_' + ID).addClass("empty");
            }

            if (price < 0) {
                warnings += "Price cannot be less than 0 for Part Type #" + ID + ". <br/>";
                $('#p_u_' + ID).addClass("empty");
            }
        }

        var quote = { Supplier_ID: supplier_ID, Supplier_Quote_Reference: reference, Supplier_Quote_Date: date, Supplier_Quote_Expiry_Date : exp };

        $("#w_info").html(warnings);

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/SupplierQuote",
                data: {data: JSON.stringify({quote: quote, components: s_components, parts: s_parts, raw: s_raw})},
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

        var method = $('input[name=optradio_a]:checked', '#search_form').val()
        var criteria = $('#search_criteria_a').val();
        var category = $('#search_category_a').val();

        $.ajax({
            type: "POST",
            url: "api/SearchSupplier",
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
                    searchedSuppliers = JSON.parse(result[1]).suppliers;

                    $('#supplier_Search_Result').empty();

                    for (var k = 0; k < searchedSuppliers.length; k++) {
                        var html = '<option value="' + k + '">' + searchedSuppliers[k].Name + ' - ' + searchedSuppliers[k].Contact_Name + ' - ' + searchedSuppliers[k].Contact_Number + ' - ' + searchedSuppliers[k].Email + '</option>';

                        $("#supplier_Search_Result").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1], function () { });

            }

        });
        $("#ResultModal").modal('show');
    });

    //On search results click
    $('#loadSupplierDetailsButton').on('click', function () {

        k = $('#supplier_Search_Result').val();

        if (k == "" || k == null)
            alertify.alert('Error', 'No Supplier has been chosen!');
        else
        {
            $("#supplier_Name").val(searchedSuppliers[k].Name);
            $("#supplier_ID").val(searchedSuppliers[k].Supplier_ID);
            supplier_ID = searchedSuppliers[k].Supplier_ID;
            $('#ResultModal').modal('hide');

            $("#Items").empty();

            s_components = [];
            s_parts = [];
            s_raw = [];

        }
    });

    $('#Items').on('change', 'input[type=number]', function () {
        calculateTotal();

    });
});



</script>

<h1 class="default-form-header">Receive Supplier Quote</h1>
		
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Find Supplier: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_a" placeholder="Search Criteria" title ="Enter the details to search the supplier by" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category_a" title ="Select the details to search the supplier by" data-toggle ="tooltip" data-placement ="bottom">
                    <option value="All">All</option>
					<option value="Name">Name</option>
					<option value="Email">Email</option>
                    <option value="CName">Contact Name</option>
					<option value="Contact_Number">Contact Number</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" name="optradio_a" checked>Exact</label>
					<label class="radio-inline"title ="Select the search method" ><input type="radio" value="Contains" name="optradio_a">Contains</label>
		
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					
				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
                    <button type ="submit" class ="searchButton" title ="Click to search for the supplier" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Supplier</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="supplier_Search_Result" title ="Select a supplier">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadSupplierDetailsButton" title ="Click to load the suppliers details">Load Supplier Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
	
<!-- FORM CODE -->
<br />
<form id="UC5-3" class="form-horizontal">
<fieldset>
	<legend>Quote Information:</legend>
	<div class="row">
		<div class="col-sm-4">
			<label for="supplier_Name" class="control-label">Supplier Name: </label>
			<input type="text" class="form-control" id="supplier_Name"  title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
		</div>
		<div class="col-sm-2">
			<label for="supplier_ID" class="control-label">Supplier No: </label>
			<input type="number" class="form-control" id="supplier_ID" value="0" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
		</div>	
		<div class="col-sm-3">
            <label for="quote_reference" class="control-label">Reference No: </label>
			<input type="text" class="form-control" id="quote_reference" placeholder="000fff" maxlength="10" title ="Enter the Reference Number" data-toggle ="tooltip" data-placement ="right">
		</div>
		<div class="col-sm-3">
		</div>
	</div>

    <script>
      $( function() {
          $("#quote_date").datepicker();
          $("#quote_exp").datepicker();
      } );
  </script>
    <div class="row">
        <div class="col-sm-6">
            <label for="quote_date" class="control-label">Quote Date: </label>
			<input type="text" class="form-control" id="quote_date" title ="Enter the Quote date" data-toggle ="tooltip" data-placement ="bottom">
		</div>
        <div class="col-sm-6">
            <label for="quote_exp" class="control-label">Quote Expiry Date: </label>
			<input type="text" class="form-control" id="quote_exp" title ="Enter the Quote expiry date" data-toggle ="tooltip" data-placement ="bottom">
		</div>
    </div>
    
</fieldset>
	<br/>
<fieldset id="itemsFieldset">
	<legend>Add Item to Quote:</legend>
    <button type="button" class="Add_extra_things" onclick="return openSearchInventory()" title ="Click to add item to quote" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus"></i> Add Inventory</button>
		<h4>Items on Quote:</h4>
		<div class="table-responsive makeDivScrollable">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>Item no.</th>
						<th>Item Code</th>
                        <th>Inventory Type</th>
						<th>Item Name</th>
						<th>Unit Price R (Vat Excl.)</th>
                        <th>Quantity</th>
                        <th>Remove</th>
					</tr>
				</thead>
				<tbody id="Items">
				</tbody>
			</table>
		</div>
</fieldset>
			
<br/>
		
<div class="row">
	<div class="col-sm-6">
				
	</div>
	<div class="col-sm-3" style="font-size:14pt;">
		<span class="Quote_Total">Total R (VAT Excl.): </span>
	</div>
    <div class="col-sm-3" style="font-size:14pt;" id="Quote_Total">

	</div>
</div>
<br/>
    <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	</div>     
<div class="row">
	<div class="col-sm-8">
        
	</div>	
	<div class="col-sm-4">
		<button type = "submit" class = "form-custom-button-columns" title ="Click to add the Supplier quote" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Receive Supplier Quote</button>
	</div>
</div>
			
</form>

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
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the inventory items details to search for">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the inventory item details to search by">
					<option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Description">Description</option>
				</select>
			</div>	
			<div class="col-sm-4">
                <label for="what">Search For: </label>
				<select class="form-control" id="what" title ="Select the inventory item type">
					<option value="Part Type">Part Type</option>
                    <option value="Component">Component</option>
                    <option value="Raw Material">Raw Material</option>
				</select>
			</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" name="method_radio2" checked>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio2">Contains</label>
					
				</div>
				<div class="col-sm-4">
					<button id="submitSearch" onclick="return searchForItem()" class ="form-custom-button-modal" title ="Click to search for the inventory item"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results" title ="Select the inventory item">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Click to add inventory item to quote">Add Inventory Item Quote</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
