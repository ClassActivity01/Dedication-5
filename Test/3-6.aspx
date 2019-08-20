<%@ Page Title="Maintain Part" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-6.aspx.cs" Inherits="Test._3_6" %>
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
<h1 class="default-form-header">Maintain Part <span id="item_ID"></span></h1>

<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Part: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the part details to search by" data-toggle ="tooltip" data-placement="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select what to search the part by" data-toggle ="tooltip" data-placement="bottom">
					<option value="All">All</option>
                    <option value="Serial">Serial No.</option>
					<option value="Name">Part Type Name</option>
					<option value="Abb">Part Type Abbreviation</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>
				
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					
				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
                    <button id="submitSearch" onclick="return partSearch('Part')" class ="searchButton" title ="Click here to search for a part" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		</fieldset>
	</form>
</div>

<style>
    #div_3_6 { display: none;
    }

</style>
<br />
<div id="div_3_6">
<form id="UC3-6" class="form-horizontal">
	<fieldset>
		<legend>Search for Part Type: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="part_type_filter_search" placeholder="Search Criteria" title ="Enter the part type details to search by" data-toggle ="tooltip" data-placement="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="part_type_filter_select" title ="Select what to search the part type by" data-toggle ="tooltip" data-placement="bottom">
					<option value="All">All</option>
                    <option value="Abb">Abbreviation</option>
					<option value="Name">Name</option>
					<option value="Description">Description</option>
                    <option value="Dimension">Dimensions</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" name="method_radio" checked>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio">Contains</label>
				
				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
					
				</div>
                <div class="col-sm-8">
					
				</div>
				<div class="col-sm-4">
					<button id="submitSearchPartType" onclick="return partSearch('Part Type')" class ="searchButton" title ="Click here to search for a part type" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
	</fieldset>
	<br/>
		
		<fieldset>
			<legend>Part Type Information:</legend>
			<div class="row">
				<div class="col-sm-4">
					<label for="part_abbreviation" class="control-label">Part Type Abbreviation: </label>
					<input type="text" class="form-control" id="part_abbreviation" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" readonly>
				</div>
                <div class="col-sm-4">
					<label for="part_name" class="control-label">Part Type Name: </label>
					<input type="text" class="form-control" id="part_name"  title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" readonly>
				</div>
            </div>
            <div class="row">
				<div class="col-sm-4">
					<label for="part_dim" class="control-label">Part Type Dimensions: </label>
					<input type="text" class="form-control" id="part_dim" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" readonly>
				</div>
				<div class="col-sm-4">
					<label for="part_price" class="control-label">Part Type Sell Price: </label>
					<input type="number" class="form-control" id="part_price" value="0" step="0.01" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" readonly>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<label for="part_desc">Part Type Description:</label>
					<textarea class="form-control" rows="3" id="part_desc" maxlength="255" title ="No information can be entered into this field" data-toggle ="tooltip" readonly>
					</textarea>
				</div>
			</div>
		</fieldset>
	<br/>
			
	<fieldset>
		<legend>Part Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="part_id" class="control-label">Part Serial No: </label>
				<input type="text" class="form-control" id="part_id" placeholder="ISO-9001" title ="Enter the part serial number" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="part_cost" class="control-label">Part Cost Price: </label>
				<input type="number" class="form-control" id="part_cost" step="0.01" min="0" value="0" title ="Enter the part cost price" data-toggle ="tooltip" data-placement ="bottom">
			</div>
            <div class="col-sm-4">
				<label for="part_status" class="control-label">Part Status: </label>
				<select class="form-control" id="part_status" title ="Select the part status" data-toggle ="tooltip" data-placement ="bottom">
				</select>
			</div>
		</div>
	</fieldset>
	<br/>
	<div class="row">
		<div class="col-sm-4">
            <div class="Warning_Info" id="w_info"></div>
		</div>	
        <div class="col-sm-4">
            <button onclick="return removePart()" class = "form-custom-button-columns" title ="Click to remove the part" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-times" aria-hidden="true"></i> Remove Part</button>
		</div>	
		<div class="col-sm-4">
            <button onclick="return updatePart()" class = "form-custom-button-columns" title ="Click to update the part details" data-toggle ="tooltip"><i class="fa fa-wrench" aria-hidden="true"></i> Update Part</button>
		</div>
	</div>
</form>
</div>

<div class="modal fade" id="ResultModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Select a Part</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="part_search_results" title ="Select a part">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadPartDetails" title ="Click to load the part details">Load Part Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="partTypeSearchModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true" style="color:white">&times;</span>
		</button>
		<h4 class="modal-title">Select a Part Type</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="part_type_search_result" title ="Select a part type">
			</select>
		</div>
		<div class="modal-footer">
            <button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		    <button type="button" class="btn btn-secondary modalbutton" onclick="OpenLink()">Add New Part Type</button>
		    <button type="button" class="btn btn-secondary modalbutton" id="loadPartTypeDetails" title ="CLick to load part type details">Load Part Type Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
    var searchedPartTypes;
    var searchedParts;
    var pt_ID;
    var part_type_details;
    var serial_no;
    var part_details;

    function OpenLink() {
        var url = "/AddPartType";
        window.open(url, '_blank');
    }
function updatePart()
{
    var warnings = "";

    var status = $("#part_status").val();
    var p_ID = $("#part_id").val();
    var price = $("#part_cost").val();

    if (status == "All") {
        $("#part_status").addClass("empty");
        warnings = warnings + "No status for part has been chosen. <br/>";
    }
    else status = parseInt(status);

    if (p_ID.length == 0) {
        $("#part_id").addClass("empty");
        warnings = warnings + "No serial number has been specified. <br/>";
    }

    if (pt_ID == "" || pt_ID == null) {
        warnings = warnings + "No Part Type has been specified.. <br/>";
    }
    else pt_ID = parseInt(pt_ID);

    var today = (new Date()).toISOString();
    var p_stage = 0;

    if (part_type_details != undefined)
        if (part_details.Manufactured == true)
            p_stage = 1;

    var part = { Part_Serial: p_ID, Part_Status_ID: status, Cost_Price: price, Part_Type_ID: pt_ID };

    $("#w_info").html(warnings);

    if (warnings == "") {
        $.ajax({
            type: "PUT",
            url: "api/Part/" + serial_no,
            data: { data: JSON.stringify(part) },
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

                return false;
            }
        });
    }

    return false;
}

function partSearch(which_type)
{
    if (which_type == "Part Type")
    {
        var filter_text = $("#part_type_filter_search").val();
        var filter_category = $("#part_type_filter_select").val();
        var method = $('input[name=method_radio]:checked', '#UC3-6').val();

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
                    searchedPartTypes = JSON.parse(result[1]).part_types;
                    $("#part_type_search_result").empty();

                    for (var k = 0; k < searchedPartTypes.length; k++) {
                        var type = '<option value="' + searchedPartTypes[k].Part_Type_ID + '">' + searchedPartTypes[k].Abbreviation + ' - ' + searchedPartTypes[k].Name + ' - ' + searchedPartTypes[k].Dimension + '</option>';
                        $("#part_type_search_result").append(type);
                    }

                    $("#partTypeSearchModal").modal('show');
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
    }
    else if (which_type == "Part")
    {
        var filter_text = $("#search_criteria").val();
        var filter_category = $("#search_category").val();
        var method = $('input[name=optradio]:checked', '#search_form').val();

        $.ajax({
            type: "POST",
            url: "api/SearchPart",
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
                    searchedParts = JSON.parse(result[1]).parts;

                    $("#part_search_results").empty();
                    
                    for (var k = 0; k < searchedParts.length; k++) {
                        var type = '<option value="' + searchedParts[k].Part_ID + '">' + searchedParts[k].Part_Serial + ' - ' + searchedParts[k].Part_Type_Abbreviation + ' - ' + searchedParts[k].Part_Type_Name + '</option>';
                        $("#part_search_results").append(type);
                    }

                    $("#ResultModal").modal('show');
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
    }

    return false;
}

function removePart() {
    if (serial_no == "" || serial_no == null) {
        var warnings = "Cannot Delete - No part has been chosen. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Part?', function () {
        $.ajax({
            type: "DELETE",
            url: "api/Part/" + serial_no,
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
    //On Form Load
    $.ajax({
        type: "GET",
        url: "api/PartStatus",
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
                var part_statuses = JSON.parse(result[1]).part_statuses;

                for (var k = 0; k < part_statuses.length; k++) {
                    var type = '<option value="' + part_statuses[k].Part_Status_ID + '">' + part_statuses[k].Name + '</option>';
                    $("#part_status").append(type);
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    //On search results click
    $('#loadPartDetails').on('click', function () {
        serial_no = $('#part_search_results').val();

        if (serial_no == "" || serial_no == null)
            alertify.alert('Error', 'No Part has been chosen!');
        else
            $.ajax({
                type: "GET",
                url: "api/Part/" + serial_no,
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
                        $("#div_3_6").show();

                        part_details = JSON.parse(result[1]).parts[0];

                        $("#item_ID").html("#" + serial_no + " ");

                        $("#part_name").val(part_details.Name);
                        $("#part_dim").val(part_details.Dimension);
                        $("#part_price").val(part_details.Selling_Price);
                        $("#part_desc").val(part_details.Description);

                        serial_no = part_details.Part_ID;
                        pt_ID = part_details.Part_Type_ID;

                        var value = part_details.Part_Status_ID;
                        $("#part_status > option[value='" + value + "']").prop("selected", true);

                        $("#part_id").val(part_details.Part_Serial);
                        $("#part_cost").val(part_details.Cost_Price);

                        $("#part_abbreviation").val(part_details.Part_Type_Abbreviation);
                        $("#part_name").val(part_details.Part_Type_Name);
                        $("#part_dim").val(part_details.Part_Type_Dimension);
                        $("#part_price").val(part_details.Part_Type_Selling_Price);
                        $("#part_desc").val(part_details.Part_Type_Description);
                        $("#part_cost").val(part_type_details.Selling_Price);
                        $('#ResultModal').modal('hide');
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });
    });


    //On search results click
    $('#loadPartTypeDetails').on('click', function () {

        pt_ID = $('#part_type_search_result').val();

        if (pt_ID == "" || pt_ID == null)
            alertify.alert('Error', 'No Part Type has been chosen!');
        else
            $.ajax({
                type: "GET",
                url: "api/PartType/"+pt_ID,
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
                        part_type_details = JSON.parse(result[1]).part_types[0];

                        $("#part_abbreviation").val(part_type_details.Abbreviation);
                        $("#part_name").val(part_type_details.Name);
                        $("#part_dim").val(part_type_details.Dimension);
                        $("#part_price").val(part_type_details.Selling_Price);
                        $("#part_desc").val(part_type_details.Description);
                        $('#partTypeSearchModal').modal('hide');
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
