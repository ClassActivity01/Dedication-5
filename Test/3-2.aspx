<%@ Page Title="Maintain Raw Material" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-2.aspx.cs" Inherits="Test._3_2" %>
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
<h1 class="default-form-header">Maintain Raw Material <span id="item_ID"></span></h1>
		
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Raw Material: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the raw materials details to search by" data-toggle ="tooltip" data-placement ="right">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select what to search the raw material by" data-toggle ="tooltip" data-placement="bottom">
					<option value="All">All</option>
				    <option value="Name">Name</option>
					<option value="ID">Raw Material No.</option>
					<option value="Description">Description</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Contains" name="optradio">Contains</label>
			
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					<button id="submitSearch" type ="submit" class ="searchButton" title ="Click here to search for the raw material" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Raw Material</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="raw_material_search_results" title ="Select a raw material">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadRawMaterialDetails" title ="Click to load the raw materials details">Load Raw Material Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<style>
    #div_3_2 { display:none;}
</style>
<br />
<div id="div_3_2">
    <form id="UC3-1" class="form-horizontal">
        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#raw" title ="Click to select the raw material tab">Raw Material</a></li>
            <li><a data-toggle="tab" href="#supplier" title ="Click to select the suppliers tab">Supplier</a></li>
        </ul>
        <br/>

    <div class="tab-content">
    <div id="raw" class="tab-pane fade in active">
	<fieldset>
		<legend>Raw Material Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="mat_name" class="control-label">Material Name: </label>
				<input type="text" class="form-control" id="mat_name"  title ="Enter the raw materials name" data-toggle ="tooltip" data-placement ="right">
			</div>
			<div class="col-sm-8">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<label for="mat_desc">Material Description:</label>
				<textarea class="form-control" rows="3" id="mat_desc" maxlength="250"  title ="Enter the raw materials description" data-toggle ="tooltip"></textarea>
			</div>
		</div>
	</fieldset>



        <div class="row">
        <div class="col-sm-4">

		</div>	
		<div class="col-sm-4">
			<button onclick="return updateRawMaterial()" class = "form-custom-button-columns"  title ="Click to update the raw material details" data-toggle ="tooltip"><i class="fa fa-wrench" aria-hidden="true"></i> Update Raw Material</button>
		</div>	
		<div class="col-sm-4">
			<button onclick="return removeRawMaterial()" class = "form-custom-button-columns"title ="Click to remove the raw material" data-toggle ="tooltip" ><i class="fa fa-times" aria-hidden="true"></i> Remove Raw Material</button>
		</div>
	</div>


	</div>


    <div id="supplier" class="tab-pane fade">
	<fieldset>
		<legend>Supplier Information:</legend>
			<button type="button" class="Add_extra_things" onclick="openModal()"title ="Click to assign a supplier to a raw material" data-toggle ="tooltip" data-placement ="right" ><i class="fa fa-plus" aria-hidden="true"></i> Add Supplier for Raw Material</button>
		    <div id="supplierDetailsDiv"></div>
            
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
</div>
    <!-- PART MODAL CODE -->
		
<div class="modal fade" id="supplierSearchModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Add Supplier</h4>
		</div>
		<div class="modal-body">
			<div class="row">
				<div class="col-sm-6">
                    <label for="supplier_search" class="control-label">Search By:</label>
					<input type="text" class="form-control" id="supplier_search" placeholder="Filter Results..." title ="Enter the suppliers details to search by"/>
				</div>
				<div class="col-sm-6">
                    <label for="filter_select" class="control-label">Search By:</label>
					<select class="form-control" id="filter_select" title ="Select the suppliers details to search by">
						<option value="All">All</option>
						<option value="Name">Name</option>
						<option value="Email">Email</option>
                        <option value="CName">Contact Name</option>
						<option value="Contact_Number">Contact Number</option>
					</select>
				</div>
			</div>
            <div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Exact" name="method_radio" checked>Exact</label>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Contains" name="method_radio">Contains</label>
				
				</div>
                <div class="col-sm-4">
					<button class = "form-custom-button-modal" style="" onclick="return FilterSearch()" title ="Filter search results"><i class="fa fa-check" aria-hidden="true"></i> Filter</button>
				</div>
            </div>
			<div class="row">
				<div class="col-sm-12">
					<select multiple class="form-control" id="supplier_search_results" title ="Select a supplier">
					</select>
				</div>
			</div>
		</div>
		<div class="modal-footer">
            <button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		    <button type="button" class="btn btn-secondary modalbutton" onclick="addSupplier()" title ="Click to assign the supplier to a raw material">Assign Supplier to Raw Material</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
var suppliers = [];
var i = 0;
var searched_Suppliers;
var raw_material_ID;

function updateRawMaterial()
{
    var warnings = "";

    var name = $("#mat_name").val();
    var descr = $("#mat_desc").val();

    if (name.length === 0 || descr.length === 0) {
        warnings = warnings + "One or more fields are empty. <br/>";
        $("#w_info").html(warnings);
    }

    if (name.length === 0) {
        $("#mat_name").addClass("empty");
    }

    if (descr.length === 0) {
        $("#mat_desc").addClass("empty");
    }

    for (var p = 0; p < suppliers.length; p++) {
        var ID = suppliers[p].Supplier_ID;

        var isChecked = $('#supplier_pref_' + ID).is(':checked');
        var price = $('#price_' + ID).val();

        suppliers[p].unit_price = price;
        suppliers[p].Is_Prefered = isChecked;
    }

    var rm = { Name: name, Description: descr, Minimum_Stock_Instances: 0};

    if (warnings == "") {
        $.ajax({
            type: "PUT",
            url: "api/RawMaterial/" + raw_material_ID,
            data: { data: JSON.stringify({ raw: rm, suppliers: suppliers }) },
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

function removeRawMaterial()
{
    if (raw_material_ID == "" || raw_material_ID == null) {
        var warnings = "Cannot Delete - No Raw Material has been chosen. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Raw Material?', function () {
        $.ajax({
            type: "DELETE",
            url: "api/RawMaterial/" + raw_material_ID,
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
    }, function () { });

    return false;
}

$(document).ready(function () {

//On search
$("#search_form").submit(function (event) {
    event.preventDefault();

    var method = $('input[name=optradio]:checked', '#search_form').val()
    var criteria = $('#search_criteria').val();
    var category = $('#search_category').val();

    $.ajax({
        type: "POST",
        url: "api/SearchRawMaterial",
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
                raw_materials = JSON.parse(result[1]).raw_materials;

                $('#raw_material_search_results').empty();

                if (raw_materials.length == 0) {
                    $("#raw_material_search_results").append("<option value=''>No results found.</option>");
                }
                else {

                    for (var k = 0; k < raw_materials.length; k++) {
                        var html = '<option value="' + raw_materials[k].Raw_Material_ID + '">' + raw_materials[k].Raw_Material_ID + ' - ' + raw_materials[k].Name + '</option>';
                        $("#raw_material_search_results").append(html);
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
$('#loadRawMaterialDetails').on('click', function () {
    raw_material_ID = $('#raw_material_search_results').val();

    if (raw_material_ID == "" || raw_material_ID == null)
        alertify.alert('Error', 'No Raw Material has been chosen!');
    else
        $.ajax({
            type: "GET",
            url: "api/RawMaterial/" + raw_material_ID,
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
                    var rm_Details = JSON.parse(result[1]).raw_materials[0];
                    console.log(rm_Details);

                    raw_material_ID = rm_Details.Raw_Material_ID;
                    $("#div_3_2").show();

                    $("#item_ID").html("#" + raw_material_ID + " ");

                    $("#mat_name").val(rm_Details.Name);
                    $("#mat_desc").val(rm_Details.Description);

                    suppliers = [];
                    $('#ResultModal').modal('hide');
                    for (var a = 0; a < rm_Details.Raw_Material_Suppliers.length; a++) {
                        var ID = rm_Details.Raw_Material_Suppliers[a].Supplier_ID;

                        var s = '<div class="row" id="supplier_' + ID + '">' +
                        '<div class="col-sm-4">' +
                            '<label for="supplier_name_' + ID + '" class="control-label">Supplier Name: </label>' +
                            '<input type="text" class="form-control" id="supplier_name_' + ID + '" disabled/>' +
                        '</div>' +
                        '<div class="col-sm-4">' +
                            '<label for="price_' + ID + '" class="control-label">Supplier Price: </label>' +
                            '<input type="number" class="form-control" id="price_' + ID + '" value="0.00" step="0.01"/>' +
                        '</div>' +
                        '<div class="col-sm-3">' +
                            '<label class="checkbox" for="supplier_pref_' + ID + '">Preferred:</label>' +
                            '<input type="checkbox" class="checkbox" id="supplier_pref_' + ID + '"/>' +
                        '</div>' +
                        '<div class="col-sm-1">' +
                            '<br />' +
                            '<button type="button" class="Add_extra_things" style="display: block; margin: 0 auto;" onclick="removeSupplier(' + ID + ')">Remove <i class="fa fa-minus" aria-hidden="true"></i></button>' +
                        '</div>' +
                        '</div>';

                        
                        var supplier = { Supplier_ID: ID, unit_price: 0, Is_Prefered: false };
                        suppliers.push(supplier);

                        $("#supplierDetailsDiv").append(s);

                        $("#supplier_name_" + ID).val(rm_Details.Raw_Material_Suppliers[a].Name);
                        $("#price_" + ID).val(rm_Details.Raw_Material_Suppliers[a].unit_price);
                        
                        if (rm_Details.Raw_Material_Suppliers[a].Is_Prefered == true)
                            $('#supplier_pref_' + ID).prop('checked', true);
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
    });
});


function addSupplier()
{
    var k = $("#supplier_search_results").val();

	if (k == "" || k == null)
	    alertify.alert('Error', 'No Supplier has been chosen!');
	else
	{
	    i++;
	    var found = false;

	    var ID = searched_Suppliers[k].Supplier_ID;

	    for (var a = 0; a < suppliers.length; a++) {
	        if (suppliers[a].Supplier_ID == ID) {

	            found = true;
	        }
	    }

	    if (found == false)
	    {
	        var s = '<div class="row" id="supplier_'+ID+'">' +
                '<div class="col-sm-4">' +
                    '<label for="supplier_name_'+ID+'" class="control-label">Supplier Name: </label>' +
                    '<input type="text" class="form-control" id="supplier_name_' + ID + '"disabled/>' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="price_' + ID + '" class="control-label">Supplier Price: </label>' +
                    '<input type="number" class="form-control" id="price_' + ID + '" value="0.00" step="0.01" title = "Enter the suppliers price"/>' +
                '</div>' +
                '<div class="col-sm-3">' +
                    '<label class="checkbox" for="supplier_pref_' + ID + '">Preferred:</label>' +
                    '<input type="checkbox" class="checkbox" id="supplier_pref_' + ID + '" title = "Select if the supplier is preferred"/>' +
                '</div>' +
                '<div class="col-sm-1">' +
                    '<br />' +
                    '<button type="button" class="Add_extra_things" style="display: block; margin: 0 auto;" onclick="removeSupplier(' + ID + ')" title = "Click to remove the supplier">Remove <i class="fa fa-minus" aria-hidden="true"></i></button>' +
                '</div>' +
            '</div>';


	        var supplier = { Supplier_ID: searched_Suppliers[k].Supplier_ID, unit_price: 0, Is_Prefered: false };
	        suppliers.push(supplier);
	        //console.log(supplier);

	        $("#supplierDetailsDiv").append(s);

	        $("#supplier_name_"+ID).val(searched_Suppliers[k].Name);
	    }
	    else
	        alertify.alert('Error', 'Supplier already in list.');
	}
}
			
function removeSupplier(i)
{
	var ID = i;
	for (var a = 0; a < suppliers.length; a++) {
	    if (suppliers[a].Supplier_ID == ID) {
	        suppliers.splice(a, 1);
	    }
	}

	$('#supplier_' + i).remove();
}

function openModal()
{
	$("#supplierSearchModal").modal('show');
}

function FilterSearch() {
	var filter_text = $("#supplier_search").val();
	var filter_category = $("#filter_select").val();
	var method = $('input[name=method_radio]:checked', '#supplierSearchModal').val();

	$.ajax({
	    type: "POST",
	    url: "api/SearchSupplier",
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

	            searched_Suppliers = JSON.parse(result[1]).suppliers;
	            $("#supplier_search_results").empty();

	            for (var k = 0; k < searched_Suppliers.length; k++) {
	                var type = '<option value="' + k + '">' + searched_Suppliers[k].Name + ' - ' + searched_Suppliers[k].Contact_Name + ' - ' + searched_Suppliers[k].Contact_Number + ' - ' + searched_Suppliers[k].Email + '</option>';
	                $("#supplier_search_results").append(type);
	            }
	        }
	        else {
	            alertify.alert('Error', result[1], function () { });
	        }
	    }
	});
}

</script>
</asp:Content>
