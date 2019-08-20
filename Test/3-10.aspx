<%@ Page Title="Add Unique Raw Material" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-10.aspx.cs" Inherits="Test._3_10" %>
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
<h1 class="default-form-header">Add Unique Raw Material</h1>
<form id="UC3-10" class="form-horizontal">
	<fieldset>
		
        <legend>Search for Raw Material: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the raw materials details to search by" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select what to search the raw material by" data-toggle ="tooltip" data-placement="bottom">
					<option value="All">All</option>
				    <option value="Name">Name</option>
					<option value="ID">Raw Material Code</option>
					<option value="Description">Description</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>

				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
                </div>
				<div class="col-sm-4">
					<button id="submitSearch" onclick="return rawSearch()" class ="searchButton" title ="Click here to search for a raw material" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		</fieldset>
		<br/>
			
	<fieldset>
		<legend>Raw Material Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="mat_name" class="control-label">Material Name: </label>
				<input type="text" class="form-control" id="mat_name" value="" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="right" readonly>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<label for="mat_desc">Material Description:</label>
				<textarea class="form-control" rows="3" id="mat_desc" maxlength="250" title ="No information can be entered into this field" data-toggle ="tooltip" readonly></textarea>
			</div>
		</div>
	</fieldset>
	<br/>
				
	<fieldset>
		<legend>Unique Raw Material Information:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="mat_dim" class="control-label">Material Dimensions: </label>
				<input type="text" class="form-control" id="mat_dim" placeholder="0x0x0mm" title ="Enter the raw material dimensions" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-6">
				<label for="mat_quality" class="control-label">Material Quality: </label>
				<input type="text" class="form-control" id="mat_quality" placeholder="A" title ="Enter the raw material quality" data-toggle ="tooltip">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label for="mat_cost_price" class="control-label">Cost Price: </label>
				<input type="number" class="form-control" id="mat_cost_price" step="0.01" value="00.00" min="0" title ="Enter the cost price" data-toggle ="tooltip">
			</div>
			<div class="col-sm-6">

                <script>
                  $( function() {
                      $("#rm_date").datepicker();
                  } );
              </script>
            <label for="rm_date" class="control-label">Date Used: </label>
			<input type="text" class="form-control" id="rm_date" title ="Enter the date used" data-toggle ="tooltip" data-placement ="bottom">
			</div>
		</div>
	</fieldset>
    <br />

	<br/>
	<div class="row">
		<div class="col-sm-8">
            <div class="Warning_Info" id="w_info"></div>
		</div>	
		<div class="col-sm-4">
            <button type = "submit" class = "form-custom-button-columns" title ="Click to add unique raw material" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add Unique Raw Material</button>
		</div>
	</div>
</form>

<div class="modal fade" id="rawMaterialModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true" style="color:white">&times;</span>
		</button>
		<h4 class="modal-title">Select a Raw Material</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="raw_material_search_result" title ="Select a raw material">
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
    .custom {
     width: 60%;
}
</style>


<script>
var supplier_Orders;
var raw_materials;
var raw_material_ID;
var order_ID;


function rawSearch()
{
    var filter_text = $("#search_criteria").val();
    var filter_category = $("#search_category").val();
    var method = $('input[name=optradio]:checked', '#UC3-10').val();

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
                raw_materials = JSON.parse(result[1]).raw_materials;
                $("#raw_material_search_result").empty();

                if (raw_materials.length == 0) {
                    $("#raw_material_search_result").append("<option value=''>No results found.</option>");
                }
                else {

                    for (var k = 0; k < raw_materials.length; k++) {
                        var type = '<option value="' + raw_materials[k].Raw_Material_ID + '">' + raw_materials[k].Raw_Material_ID + ' - ' + raw_materials[k].Name + '</option>';
                        $("#raw_material_search_result").append(type);
                    }
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    $("#rawMaterialModal").modal('show');

    return false;
}

$(document).ready(function () {
    $("#UC3-10").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        var dimensions = $("#mat_dim").val();
        var cost = $("#mat_cost_price").val();
        var quality = $("#mat_quality").val();
        
        var date_used;

        var correct = $("#rm_date").val();

        if (correct.trim().length == 0) {
            date_used = undefined;
        }
        else {

            //console.log("Correct: " + correct);
            var res3 = correct.split("/");
            var d = parseInt(res3[1]);
            var n = res3[2] + "-" + res3[0] + "-" + d + "T00:00:00Z";
            //console.log("N: " + n);
            var new_date = new Date(n);

            //console.log(new_date);

            date_used = new_date.toISOString();
            //console.log(date_used);
        }
        


        var date_added = (new Date()).toISOString();

        if (raw_material_ID == "" || raw_material_ID == null)
        {
            warnings = warnings + "No Raw Material Type has been chosen. <br/>";
        }
        else raw_material_ID = parseInt(raw_material_ID);
        
        $("#w_info").html(warnings);

        var rm = { Raw_Material_ID: raw_material_ID, Dimension: dimensions, Quality: quality, Date_Added: date_added, Date_Used: date_used, Cost_Price: cost, Supplier_Order_ID : 0 };
        console.log(rm);
        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/UniqueRawMaterial",
                data: {data: JSON.stringify(rm)},
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


    $('#loadRawMaterialDetails').on('click', function () {
        raw_material_ID = $('#raw_material_search_result').val();

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
                        $('#rawMaterialModal').modal('hide');
                        $("#mat_name").val(rm_Details.Name);
                        $("#mat_desc").val(rm_Details.Description);
                        order_ID = 0;
                        $("#supplier_order_1").val(0);
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });
    });

});

</script>
</asp:Content>
