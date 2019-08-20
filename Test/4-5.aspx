<%@ Page Title="Maintain Manual Labour Type" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-5.aspx.cs" Inherits="Test._4_5" %>
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

<h1 class="default-form-header">Maintain Manual Labour Type <span id="item_ID"></span></h1>
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search For Manual Labour Type: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the manual labour type details to search by" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select what to search the manual labour type by" data-toggle ="tooltip" data-placement="bottom">
                    <option value="All">All</option>
					<option value="Name">Name</option>
					<option value="Description">Description</option>
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
                    <button id="submitSearch" type ="submit" class ="searchButton" title ="Click here to search for the manual labour type" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Manual Labour Type</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="ml_search_results" title ="Select a manual labour type">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadMLDetailsButton" title ="Click to load the manual labour type details">Load Manual Labour Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<br />
<div id="div_4_5" style="display : none">
<form id="UC4-5" class="form-horizontal">
	<fieldset>
		<legend>General Information:</legend>
		<div class="row">
			<div class="col-sm-5">
				<label for="Manual_Labour_type_name" class="control-label">Name: </label>
				<input type="text" class="form-control" id="Manual_Labour_type_name"title ="Enter the manual labour type name" data-toggle ="tooltip" data-placement ="bottom" />
			</div>
			<div class="col-sm-3">
				<label for="Manual_Labour_type_duration" class="control-label">Duration (in min): </label>
				<input type="number" class="form-control" id="Manual_Labour_type_duration" min="0" max="9999"  title ="Enter the duration of the manual labour type" data-toggle ="tooltip" data-placement ="bottom"/>
			</div>
			<div class="col-sm-4">
				<br/>
				<div class="checkbox">
					<label>
					<input type="checkbox" id="sub_contractor" title ="Select if the manual labour type is done by a sub-contractor" data-toggle ="tooltip" data-placement ="bottom"/>
					Done by sub-contractor
					</label>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<label for="Manual Labour_type_descr">Description:</label>
				<textarea class="form-control" rows="5" id="Manual_Labour_type_descr" maxlength="255" title ="Enter the manual labour type description" data-toggle ="tooltip"></textarea>
			</div>
		</div>
	</fieldset>
	<br/>
    <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	</div>     
    <div class="row">
		<div class="col-sm-4">

		</div>	
		<div class="col-sm-4">
            <button onclick="return updateML()" class = "form-custom-button-columns" title ="Click to update the manual labour type details" data-toggle ="tooltip"><i class="fa fa-wrench" aria-hidden="true"></i> Update Manual Labour Type</button>
		</div>
		<div class="col-sm-4">
			<button onclick="return deleteML()" class = "form-custom-button-columns" title ="Click to remove the manual labour type" data-toggle ="tooltip"><i class="fa fa-times" aria-hidden="true"></i> Remove Manual Labour Type</button>
		</div>
	</div>
			
</form>
</div>

<script>
//Global Variables
var ml_ID;
var ml_Details;
var searchedML;

function updateML()
{
    var warnings = "";

    var empty = checkEmpty();

    if (empty == false) {
        warnings = warnings + "One or more fields are empty. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    if (ml_ID == "" || ml_ID == null) {
        var warnings = "Cannot Delete - No Manual Labour has been chosen. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    var name = $("#Manual_Labour_type_name").val();
    var sub = $("#sub_contractor").is(":checked");
    var duration = $("#Manual_Labour_type_duration").val();
    var description = $("#Manual_Labour_type_descr").val();

    //console.log(description);

    var ml = { Name: name, Description: description, Duration: duration, Sub_Contractor: sub };

    $("#w_info").html(warnings);

    if (warnings == "") {
        $.ajax({
            type: "PUT",
            url: "api/ManualLabour/" + ml_ID,
            data: { data: JSON.stringify(ml) },
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

function deleteML()
{
    if (ml_ID == "" || ml_ID == null) {
        var warnings = "Cannot Delete - No Manual Labour has been chosen. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Manual Labour Type?', function () {
        $.ajax({
            type: "DELETE",
            url: "api/ManualLabour/" + ml_ID,
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
            url: "api/SearchManualLabour",
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
                    searchedML = JSON.parse(result[1]).manual_labour_types;

                    $('#ml_search_results').empty();

                    for (var k = 0; k < searchedML.length; k++) {
                        var html = '<option value="' + searchedML[k].Manual_Labour_Type_ID + '">' + searchedML[k].Name + '</option>';

                        $("#ml_search_results").append(html);
                    }
                }
                else { alertify.alert('Error', result[1]); }
            }
        });
        $("#ResultModal").modal('show');
    });

    //On search results click
    $('#loadMLDetailsButton').on('click', function () {
        ml_ID = $('#ml_search_results').val();

        if (ml_ID == "" || ml_ID == null)
            alertify.alert('Error', 'No Manual Labour has been chosen!');
        else
            $.ajax({
                type: "GET",
                url: "api/ManualLabour/"+ml_ID,
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
                        ml_Details = JSON.parse(result[1]).manual_labour_types[0];

                        $("#div_4_5").show();

                        $("#item_ID").html("#" + ml_ID + " ");

                        $("#Manual_Labour_type_name").val(ml_Details.Name);

                        if(ml_Details.Sub_Contractor == true)
                            $("#sub_contractor").prop('checked', true);


                        $("#sub_contractor").is(":checked");
                        $("#Manual_Labour_type_duration").val(ml_Details.Duration);
                        $("#Manual_Labour_type_descr").val(ml_Details.Description);
                        $("#ResultModal").modal('hide');
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
    });

});


</script>
</asp:Content>
