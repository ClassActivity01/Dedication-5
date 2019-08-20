<%@ Page Title="Add Part" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-5.aspx.cs" Inherits="Test._3_5" %>
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
<h1 class="default-form-header">Add Part</h1>
<form id="UC3-5" class="form-horizontal">
	<fieldset>
		<legend>Search for Part Type: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="filter_search" placeholder="Search Criteria" title ="Enter the part type details to search by" data-toggle ="tooltip" data-placement="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="filter_select" title ="Select what to search the part type by" data-toggle ="tooltip" data-placement="bottom">
					<option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Abb">Abbreviation</option>
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
				<div class="col-sm-4">
					<button id="submitSearchPartType" onclick="return partSearch()" class ="searchButton" title ="Click here to search for a part type" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
					<input type="text" class="form-control" id="part_name" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" readonly>
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
					<textarea class="form-control" rows="3" id="part_desc" maxlength="255" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" readonly>
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
				<input type="text" class="form-control" id="part_id" placeholder="ISO-9001 ID" title ="Enter the part serial number" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="part_cost" class="control-label">Part Cost Price: </label>
				<input type="number" class="form-control" id="part_cost" step="0.01" min="0" value="0" title ="Enter the part cost price" data-toggle ="tooltip" data-placement ="bottom">
			</div>
            <div class="col-sm-4">
				<label for="part_status" class="control-label">Part Status: </label>
				<select class="form-control" id="part_status" title ="Select the part status" data-toggle ="tooltip" data-placement ="bottom" >
				</select>
			</div>
		</div>
	</fieldset>
	<br/>
	<div class="row">
		<div class="col-sm-8">
            <div class="Warning_Info" id="w_info"></div>
		</div>	
		<div class="col-sm-4">
            <button type = "submit" class = "form-custom-button-columns" title ="Click to add part" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add Part</button>
		</div>
	</div>
</form>


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
		    <button type="button" class="btn btn-secondary modalbutton" id="loadPartTypeDetails" title ="Click to load the part type details">Load Part Type Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
    var searchedPartTypes;
    var pt_ID;
    var part_type_details;

    function OpenLink()
    {
        var url = "/AddPartType";
        window.open(url, '_blank');
    }

function partSearch()
{
    var filter_text = $("#filter_search").val();
    var filter_category = $("#filter_select").val();
    var method = $('input[name=method_radio]:checked', '#UC3-5').val();

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

                if (searchedPartTypes.length == 0) {
                    $("#part_type_search_result").append("<option value=''>No results found.</option>");
                }
                else {

                    for (var k = 0; k < searchedPartTypes.length; k++) {
                        var type = '<option value="' + searchedPartTypes[k].Part_Type_ID + '">' + searchedPartTypes[k].Abbreviation + ' - ' + searchedPartTypes[k].Name + ' - ' + searchedPartTypes[k].Dimension + '</option>';
                        $("#part_type_search_result").append(type);
                    }
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    $("#partTypeSearchModal").modal('show');

    return false;
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
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

    $("#UC3-5").submit(function (e) {
        e.preventDefault();

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
        /*var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!

        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd
        }
        if (mm < 10) {
            mm = '0' + mm
        }
        var today = dd + '/' + mm + '/' + yyyy;*/
        var p_stage = 0;

        if(part_type_details != undefined)
            if(part_type_details.Manufactured == true)
                p_stage = 1;
        
        var part = { Part_Serial: p_ID, Part_Status_ID: status, Date_Added: today, Cost_Price: price, Part_Stage: p_stage, Parent_ID: 0, Part_Type_ID: pt_ID };

        $("#w_info").html(warnings);

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/Part",
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
                }
            });
        }

        return false;
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
                        $("#part_cost").val(part_type_details.Selling_Price);
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
