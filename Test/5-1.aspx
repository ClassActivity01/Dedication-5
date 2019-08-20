<%@ Page Title="Add New Supplier" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-1.aspx.cs" Inherits="Test.ss5" %>
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
var what;
var searchedItems;

function searchForItem() {
    var filter_text = $("#search_criteria").val();
    var filter_category = $("#search_category").val();
    what = $("#what").val();
    var method = $('input[name=method_radio2]:checked', '#inventory_search_Modal').val();

    if(what == "Part Type")
    {
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
    }else
        if(what == "Component")
        {
            $.ajax({
                type: "POST",
                url: "api/SearchComponent",
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
        }else
        {
            $.ajax({
                type: "POST",
                url: "api/SearchRawMaterial",
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
                var supplier = { Raw_Material_ID: ID, unit_price: 0, Is_Prefered: false };
                s_raw.push(supplier);

                var row = '<tr id="row_raw_' + searchedItems[k].Raw_Material_ID + '"><td>' + searchedItems[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + searchedItems[k].Name + '</td><td>' +
                    '<input type="number" title ="Enter the supplier price" step="0.01" value="0" min="0" id="r_u_' + searchedItems[k].Raw_Material_ID
                    + '"/></td><td><input type="checkbox" title ="Select if the supplier is preffered" id="r_c_' + searchedItems[k].Raw_Material_ID + '"/></td>' +
                    '<td><button type="button" title = "Click to remove the raw material" class="Add_extra_things" onclick="return removeItem(&apos;Raw Material&apos;, ' + searchedItems[k].Raw_Material_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

                $("#Items").append(row);
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
                var supplier = { Part_Type_ID: ID, unit_price: 0, Is_Prefered: false };
                s_parts.push(supplier);

                var row = '<tr id="row_part_' + searchedItems[k].Part_Type_ID + '"><td>' + searchedItems[k].Part_Type_ID + '</td><td>Part Type</td><td>' + searchedItems[k].Name + '</td><td>' +
                    '<input type="number" title ="Enter the supplier price" step="0.01" value="0" min="0" id="p_u_' + searchedItems[k].Part_Type_ID
                    + '"/></td><td><input type="checkbox" title ="Select if the supplier is preffered" id="p_c_' + searchedItems[k].Part_Type_ID + '"/></td>' +
                    '<td><button type="button" title = "Click to remove the part type" class="Add_extra_things" onclick="return removeItem(&apos;Part Type&apos;, ' + searchedItems[k].Part_Type_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

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
                var supplier = { Component_ID: ID, unit_price: 0, Is_Prefered: false };
                s_components.push(supplier);

                var row = '<tr id="row_component_' + searchedItems[k].Component_ID + '"><td>' + searchedItems[k].Component_ID + '</td><td>Component</td><td>' + searchedItems[k].Name + '</td><td>' +
                    '<input type="number" title ="Enter the supplier price" step="0.01" value="0" min="0" id="c_u_' + searchedItems[k].Component_ID
                    + '"/></td><td><input type="checkbox" title ="Select if the supplier is preffered" id="c_c_' + searchedItems[k].Component_ID + '"/></td>' +
                    '<td><button type="button" title = "Click to remove the component" class="Add_extra_things" onclick="return removeItem(&apos;Component&apos;, ' + searchedItems[k].Component_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

                $("#Items").append(row);
            }
            else alertify.alert('Error', 'Component already in list.');


        }
    }


}

function openSearchInventory()
{
    $("#inventory_search_Modal").modal('show');
}

function removeItem(which_one, ID)
{
    //console.log("Hello");
    if (which_one == "Raw Material") {

        for (var a = 0; a < s_raw.length; a++) {
            if (s_raw[a].Raw_Material_ID == ID) {
                s_raw.splice(a, 1);
                $('#row_raw_' + ID).remove();
            }
        }

        //console.log(s_raw);


    }
    else if (which_one == "Part Type") {

        for (var a = 0; a < s_parts.length; a++) {
            if (s_parts[a].Part_Type_ID == ID) {
                s_parts.splice(a, 1);
                $('#row_part_' + ID).remove();
            }
        }
    }
    else if (which_one == "Component") {

        for (var a = 0; a < s_components.length; a++) {
            if (s_components[a].Component_ID == ID) {
                s_components.splice(a, 1);

                $('#row_component_' + ID).remove();
            }
        }
    }
}

$(document).ready(function () {
    $("#UC5-1").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        var name = $("#supplier_Name").val();
        var status = $("#supplier_Status").val();
        var c_name = $("#supplier_contact_Name").val();
        var C_email = $("#supplier_Email").val();
        var c_number = $("#supplier_number").val().replace(/ /g, '');
        var address = $("#client_Address").val();
        var city = $("#client_City").val();
        var province = $("#province").val();
        var zip = $("#zip").val();
        var reference = $("#supplier_bank_Reference").val();
        var account = $("#supplier_bank_number").val();
        var bank_name = $("#supplier_bank_name").val();
        var branch_code = $("#supplier_bank_branch").val();
        var foreign = $('#foreign').is(":checked");

        var patt = new RegExp("^[0-9]*$");
        var res = patt.test(c_number);

        if (res == false) {
            warnings = warnings + "Contact number may not contain characters. <br/>";
            $("#supplier_number").addClass("empty");
        }

        if (c_number.length < 10) {
            warnings = warnings + "Contact number is too short. <br/>";
            $("#supplier_number").addClass("empty");
        }

        if (province == "Choose") {
            warnings = warnings + "Please choose a province. <br/>";
            $("#province").addClass("empty");
        }

		var res = patt.test(zip);

			if (res == false) {
			warnings = warnings + "Zip code may only contain numbers. <br/>";
			$("#zip").addClass("empty");
		}
			
		if (zip.length < 4) {
			warnings = warnings + "Zip code must be 4 characters. <br/>";
			$("#zip").addClass("empty");
		}
		
		
        //Get the different inventory item values
        for (var a = 0; a < s_components.length; a++) {
            var ID = s_components[a].Component_ID;

            var prefer = $('#c_c_' + ID).is(":checked");
            var price = $('#c_u_' + ID).val();

            s_components[a].unit_price = price;
            s_components[a].Is_Prefered = prefer;    
        }

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var prefer = $('#p_c_' + ID).is(":checked");
            var price = $('#p_u_' + ID).val();

            s_parts[a].unit_price = price;
            s_parts[a].Is_Prefered = prefer;
        }

        for (var a = 0; a < s_raw.length; a++) {
            var ID = s_raw[a].Raw_Material_ID;

            var prefer = $('#r_c_' + ID).is(":checked");
            var price = $('#r_u_' + ID).val();

            s_raw[a].unit_price = price;
            s_raw[a].Is_Prefered = prefer;
        }

        var supplier = {
            Name: name, Address: address, City: city, Zip: zip, Bank_Account_Number: account,
            Bank_Reference: reference, Contact_Name: c_name, Foreign_Bank: foreign,
            Bank_Branch : branch_code, Bank_Name : bank_name, Email : C_email, Contact_Number : c_number, Status : status,
            Province_ID : province};

        //console.log(supplier);

        $("#w_info").html(warnings);
       
        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/Supplier",
                data: { data: JSON.stringify({ supplier: supplier, components: s_components, parts: s_parts, raw: s_raw }) },
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

});

</script>


<h1 class="default-form-header">Add New Supplier</h1>
<form id="UC5-1" class="form-horizontal">
    <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#supplier" title ="Click to select the supplier tab">Supplier</a></li>
            <li><a data-toggle="tab" href="#inventory" title ="Click to select the inventory tab">Inventory Items</a></li>
        </ul>
        <br/>
    
    <div class="tab-content">
    <div id="supplier" class="tab-pane fade in active">
	<fieldset>
		<legend>General Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="supplier_Name" class="control-label">Supplier Name: </label>
				<input type="text" class="form-control" id="supplier_Name" placeholder="Supplier Name" maxlength="40" title ="Enter the suppliers name" data-toggle ="tooltip" data-placement ="bottom"/>
			</div>					
			<div class="col-sm-4">
				<label for="supplier_Status">Supplier Status: </label>
				<select class="form-control" id="supplier_Status" title ="Select supplier status" data-toggle ="tooltip" data-placement ="right">
					<option value="1">Active</option>
					<option value="0">In-Active</option>
				</select>
			</div>
			<div class="col-sm-4">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="supplier_contact_Name" class="control-label">Supplier Contact Name: </label>
				<input type="text" class="form-control" id="supplier_contact_Name" placeholder="Jane Doe" maxlength="40" title ="Enter the suppliers contact name" data-toggle ="tooltip" data-placement ="bottom"/>
			</div>
			<div class="col-sm-4">
				<label for="supplier_Email" class="control-label">Contact Email: </label>
				<input type="email" class="form-control" id="supplier_Email" placeholder="example@example.com" maxlength="254" title ="Enter the contact email address" data-toggle ="tooltip" data-placement ="bottom"/>
			</div>	
					
			<div class="col-sm-4">
				<label for="supplier_number">Supplier Contact Number: </label>
				<input type="text" class="form-control" id="supplier_number" placeholder="083 000 0000" maxlength="15" title ="Enter the suppliers contact number" data-toggle ="tooltip" data-placement ="bottom">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="client_Address" class="control-label">Address: </label>
				<input type="text" class="form-control" id="client_Address" placeholder="93 Example Street" maxlength="95" title ="Enter the suppliers address" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-3">
				<label for="client_City" class="control-label">City: </label>
				<input type="text" class="form-control" id="client_City" placeholder="Exampletopia" maxlength="35" title ="Enter the suppliers city" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-3">
				<label for="province">Province: </label>
				<select class="form-control" id="province" title ="Select a province" data-toggle ="tooltip" data-placement ="bottom">
					<option value="Choose">Choose an option</option>
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
				<label for="zip" class="control-label">Postal Code: </label>
				<input type="text" class="form-control" id="zip" maxlength="4" placeholder="0000" title ="Enter the suppliers postal code" data-toggle ="tooltip" data-placement ="bottom">
			</div>
		</div>
	</fieldset>
     <br />

	<fieldset>
		<legend>Bank Information:</legend>
		<div class="row">
			<div class="col-sm-5">
				<label for="supplier_bank_Reference" class="control-label">Reference Name: </label>
				<input type="text" class="form-control" id="supplier_bank_Reference" placeholder="EE Example" maxlength="20" title ="Enter the suppliers reference name" data-toggle ="tooltip" data-placement ="right">
			</div>
			<div class="col-sm-7">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="supplier_bank_number" class="control-label">Account Number: </label>
				<input type="text" class="form-control" id="supplier_bank_number" placeholder="000000000" maxlength="20" title ="Enter the account number" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-3">
				<label for="supplier_bank_name">Bank Name: </label>
				<input type="text" class="form-control" id="supplier_bank_name" placeholder="ABSA" maxlength="35" title ="Enter the bank name" data-toggle ="tooltip" data-placement ="bottom">
			</div>
            <div class="col-sm-2">
				<label for="foreign">Foreign: </label><br />
				<input type="checkbox" id="foreign" title ="Select if the bank is foreign" data-toggle ="tooltip" data-placement ="bottom"/>
			</div>
			<div class="col-sm-3">
				<label for="supplier_bank_branch" class="control-label">Branch Code/Swift Code: </label>
				<input type="text" class="form-control" id="supplier_bank_branch" placeholder="1234" maxlength="6" title ="Enter the branch code" data-toggle ="tooltip" data-placement ="right">
			</div>
		</div>
	</fieldset>

        <div class="row">
		<div class="col-sm-8">

		</div>	
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" title ="Click to add the supplier" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add New Supplier</button>
		</div>
	</div>

	</div>
		
    <div id="inventory" class="tab-pane fade">
    <fieldset id="itemsFieldSet">
    <legend>Inventory Supplied by Supplier:</legend>
        <div class="row" >
            <div class="col-sm-12">
                <button type="button" class="Add_extra_things" onclick="return openSearchInventory()" title ="Click to add items supplied by the Supplier" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus"></i> Choose Inventory</button>
            </div>
        </div>
	    
        <br/>
	    <div class="table-responsive makeDivScrollable">
		    <table class="table table-hover" >
			    <thead>
				    <tr>
					    <th>Code</th>
                        <th>Type</th>
					    <th>Name</th>
					    <th>Price per Unit</th>
                        <th>Is Preffered?</th>
                        <th>Remove</th>
				    </tr>
			    </thead>
			    <tbody id="Items">
			    </tbody>
		    </table>
	    </div>
    </fieldset>
    </div>
    </div>

	<br/>

    <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
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
	<h4 class="modal-title">Add Item to Inventory Supplied</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the details to search the inventory item by">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the details to search the inventory item by">
					<option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Description">Description</option>
				</select>
			</div>	
			<div class="col-sm-4">
                <label for="what">Search For: </label>
				<select class="form-control" id="what" title ="Select the the inventory item type">
					<option value="Part Type">Part Type</option>
                    <option value="Component">Component</option>
                    <option value="Raw Material">Raw Material</option>
				</select>
			</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="method_radio2">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio2">Contains</label>
			
				</div>
				<div class="col-sm-4">
					<button id="submitSearch" onclick="return searchForItem()" class ="form-custom-button-modal" title ="Search for the inevntory item"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Click to add inventory item">Assign Item</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
