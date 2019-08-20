<%@ Page Title="Add Raw Material" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-1.aspx.cs" Inherits="Test._3_1" %>
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
var suppliers = [];
var i = 0;
var searched_Suppliers;


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
                    '<input type="text" class="form-control" id="supplier_name_' + ID + '" disabled/>' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="price_' + ID + '" class="control-label">Supplier Price: </label>' +
                    '<input type="number" class="form-control" id="price_' + ID + '" value="0.00" step="0.01" min="0" title = "Enter the suppliers price"/>' +
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

	console.log(suppliers);
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
	    data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category+"'}" },
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
	            //console.log(searched_Suppliers);
	            if (searched_Suppliers.length == 0) {
	                $("#supplier_search_results").append("<option value=''>No results found.</option>");
	            }
	            else {
	                for (var k = 0; k < searched_Suppliers.length; k++) {
	                    var type = '<option value="' + k + '">' + searched_Suppliers[k].Name + ' - ' + searched_Suppliers[k].Contact_Name + ' - ' + searched_Suppliers[k].Contact_Number + ' - ' + searched_Suppliers[k].Email + '</option>';
	                    $("#supplier_search_results").append(type);
	                }
	            }
	        }
	        else {
	            alertify.alert('Error', result[1], function () { });
	        }
	    }
	});
}



$(document).ready(function () {
    $("#UC3-1").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var name = $("#mat_name").val();
        var descr = $("#mat_desc").val();

        if (name.length === 0 || descr.length === 0)
        {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
        }

        if (name.length === 0) {
            $("#mat_name").addClass("empty");
        }

        if (descr.length === 0) {
            $("#mat_desc").addClass("empty");
        }

        for (var p = 0; p < suppliers.length; p++)
        {
            var ID = suppliers[p].Supplier_ID;

            var isChecked = $('#supplier_pref_' + ID).is(':checked');
            var price = $('#price_' + ID).val();

            suppliers[p].unit_price = price;
            suppliers[p].Is_Prefered = isChecked;
        }

        var rm = {Name: name, Description: descr, Minimum_Stock_Instances: 0};

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/RawMaterial",
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
    });

});
</script>
<h1 class="default-form-header">Add Raw Material</h1>
<form id="UC3-1" class="form-horizontal">
	    <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#raw" title ="Click to select raw material tab">Raw Material</a></li>
            <li><a data-toggle="tab" href="#supplier" title ="Click to select supplier tab">Supplier</a></li>
        </ul>
        <br/>
    
    <div class="tab-content">
    <div id="raw" class="tab-pane fade in active">
    <fieldset>
		<legend>Raw Material Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="mat_name" class="control-label">Material Name: </label>
				<input type="text" class="form-control" id="mat_name" title ="Enter the raw materials name" data-toggle ="tooltip" data-placement ="right">
			</div>
			<div class="col-sm-8">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<label for="mat_desc">Material Description:</label>
				<textarea class="form-control" rows="3" id="mat_desc" maxlength="250" title ="Enter the raw materials description" data-toggle ="tooltip"></textarea>
			</div>
		</div>
	</fieldset>
    
        
    <div class="row">
		<div class="col-sm-8">

		</div>	
		<div class="col-sm-4">
            <button type = "submit" class = "form-custom-button-columns" title ="Click to add raw material" data-toggle ="tooltip" data-placement ="left" ><i class="fa fa-check" aria-hidden="true"></i> Add Raw Material</button>
		</div>
	</div>
	</div>
   
         <div id="supplier" class="tab-pane fade">
	<fieldset>
		<legend>Supplier Information:</legend>
			<button type="button" class="Add_extra_things" onclick="openModal()" title ="Click to assign a supplier to the raw material" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus" aria-hidden="true"></i> Add Supplier for Raw Material</button>
		    <div id="supplierDetailsDiv"></div>
            
	</fieldset>	
    </div>
    </div>

    <br />
    <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	</div>     
    
</form>

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
					<label class="radio-inline" title ="Select search method to search by"><input type="radio" value="Exact" name="method_radio" checked>Exact</label>
					<label class="radio-inline" title ="Select search method to search by"><input type="radio" value="Contains" name="method_radio">Contains</label>

				</div>
                <div class="col-sm-4">
					<button class = "form-custom-button-modal" style="" onclick="return FilterSearch()" title ="Click to search for supplier"><i class="fa fa-check" aria-hidden="true" ></i> Filter</button>
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
            <button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close modal">Close</button>
		    <button type="button" class="btn btn-secondary modalbutton" onclick="addSupplier()" title ="Click to assign supplier to raw material">Assign Supplier to Raw Material</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

</asp:Content>
