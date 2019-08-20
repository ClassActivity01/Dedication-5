<%@ Page Title="Maintain Unique Machine" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="8-4.aspx.cs" Inherits="Test._8_4" %>
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
<h1 class="default-form-header">Maintain Unique Machine <span id="item_ID"></span></h1>
		
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search For Unique Machine: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the details to search the unique machine by" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the details to search the unique machine by" data-toggle ="tooltip" data-placement ="bottom">
                    <option value="All">All</option>
					<option value="Name">Name</option>
					<option value="Model">Model</option>
					<option value="Manufacturer">Manufacturer</option>
					<option value="Serial">Unique Machine Serial No.</option>
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
                    <button id="submitSearch" type ="submit" class ="searchButton" title ="Click to search for the unique machine" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Unique Machine</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="machine_search_results" title ="Select the unique machine">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadMachineDetails" title ="Click to load unique machine details">Load Machine Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->   
<br />
<style>
    #div_8_4{display:none;}
</style>
<div id="div_8_4">
<form id="UC8-4" class="form-horizontal">
	<fieldset>
		<legend>Select a Machine:</legend>
		<br/>
		
		<div class="table-responsive makeDivScrollable">
			<table class="sortable table table-hover">
				<thead>
					<tr>
						<th>Code</th>
						<th>Machine Name</th>
						<th>Manufacturer</th>
						<th>Model</th>
					</tr>
				</thead>
				<tbody id="listOfMachines">
				
				</tbody>
			</table>
		</div> 
	</fieldset>
	<fieldset>
		<legend>Unique Machine Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="machine_ID" class="control-label">Machine Code: </label>
				<input type="number" class="form-control" id="machine_ID" min="0" readonly>
			</div>
			<div class="col-sm-4">
				<label for="u_machine_ID" class="control-label">Unique Machine Serial No: </label>
				<input type="text" class="form-control" id="u_machine_ID" placeholder="1234-abc" maxlength="25" title ="Enter unique machine serial number" data-toggle ="tooltip" data-placement ="bottom">
			</div>	
			<div class="col-sm-4">
				<label for="u_machine_status">Unique Machine Status: </label>
				<select class="form-control" id="u_machine_status" title ="Select unique machine status" data-toggle ="tooltip" data-placement ="bottom">
					<option value="Choose">Choose an Option</option>
				</select>
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
			<button onclick="return updateUniqueMachine()" class = "form-custom-button-columns" title ="Click to update unique machine details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Update Unique Machine</button>
		</div>
        <div class="col-sm-4">
			<button onclick="return deleteUniqueMachine()" class = "form-custom-button-columns" title ="Click to remove the unique machine" data-toggle ="tooltip"><i class="fa fa-times" aria-hidden="true"></i> Delete Unique Machine</button>
		</div>
	</div>
			
</form>
</div>

<script>

//Global variables
var unique_machine_ID;

function addMachine(k) {
    $("#machine_ID").val(k);
}

function updateUniqueMachine()
{
    var warnings = "";

    var machine_ID = $("#machine_ID").val();
    var unique_machine_ID = $("#u_machine_ID").data("id");
    var unique_machine_serial = $("#u_machine_ID").val();
    var m_status = $("#u_machine_status").val();

    if (machine_ID.length == 0 || unique_machine_ID.length == 0) {
        warnings = warnings + "One ore more fields are empty. <br/>";

        if (machine_ID.trim().length <= 0)
            $("#machine_ID").addClass("empty");
        if (unique_machine_ID.trim().length <= 0)
            $("#u_machine_ID").addClass("empty");

    }

    if (m_status == "Choose") {
        warnings = warnings + "Please choose a status. <br/>";
        $("#u_machine_status").addClass("empty");

    }

    var unique_machine = { Machine_ID: machine_ID, Machine_Status_ID: m_status, Unique_Machine_Serial: unique_machine_serial };

    if (warnings == "") {
        $.ajax({
            type: "PUT",
            url: "api/UniqueMachine/" + unique_machine_ID,
            data: {data: JSON.stringify(unique_machine)},
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

function deleteUniqueMachine()
{
    unique_machine_ID = $("#u_machine_ID").data("id");

    alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Unique Machine?', function () {
        $.ajax({
            type: "DELETE",
            url: "api/UniqueMachine/" + unique_machine_ID,
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


$(document).ready(function ()
{
    //Get the machines
    $.ajax({
        type: "GET",
        url: "api/Machine",
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
                var machines = JSON.parse(result[1]).machines;

                for (var k = 0; k < machines.length; k++) {
                    var row = '<tr>' +
                            '<td>' + machines[k].Machine_ID + '</td>' +
                            '<td><button type="button" title = "Select to load machine details"class="addToList" onclick="addMachine(' + machines[k].Machine_ID + ')"><i class="fa fa-plus" aria-hidden="true"></i> ' + machines[k].Name + '</button></td>' +
                            '<td>' + machines[k].Manufacturer + '</td>' +
                            '<td>' + machines[k].Model + '</td>' +
                            '</tr>';
                    $("#listOfMachines").append(row);
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });


    //Get machine statuses;
    $.ajax({
        type: "GET",
        url: "api/MachineStatus",
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
                var status = JSON.parse(result[1]).machine_statuses;

                for (var k = 0; k < status.length; k++) {
                    var row = '<option value="' + status[k].Machine_Status_ID + '">' + status[k].Name + '</option>';
                    $("#u_machine_status").append(row);
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });


    //On search
    $("#search_form").submit(function (event) {
        event.preventDefault();

        var method = $('input[name=optradio]:checked', '#search_form').val()
        var criteria = $('#search_criteria').val();
        var category = $('#search_category').val();

        $.ajax({
            type: "POST",
            url: "api/SearchUniqueMachine",
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
                    searchedMachines = JSON.parse(result[1]).unique_machines;

                    $('#machine_search_results').empty();

                    for (var k = 0; k < searchedMachines.length; k++) {
                        var html = '<option value="' + searchedMachines[k].Unique_Machine_ID + '">' + searchedMachines[k].Name + ' - ' + searchedMachines[k].Manufacturer + ' - ' + searchedMachines[k].Model + ' - ' + searchedMachines[k].Unique_Machine_Serial + '</option>';

                        $("#machine_search_results").append(html);
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
    $('#loadMachineDetails').on('click', function () {

        unique_machine_ID = $('#machine_search_results').val();

        if (unique_machine_ID == "" || unique_machine_ID == null)
            alertify.alert('Error', 'No Machine has been chosen!');
        else
            $.ajax({
                type: "GET",
                url: "api/UniqueMachine/" + unique_machine_ID,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                },
                success: function (msg)
                {
                    var result = msg.split("|");

                    if (result[0] == "true") {
                        var u_machine_details = JSON.parse(result[1]).unique_machines;

                        $("#div_8_4").show();

                        $("#item_ID").html("#" + unique_machine_ID + " ");

                        $("#u_machine_ID").val(u_machine_details[0].Unique_Machine_Serial);
                        $("#u_machine_ID").data("id", u_machine_details[0].Unique_Machine_ID);
                        $("#machine_ID").val(u_machine_details[0].Machine_ID);
                        var value = u_machine_details[0].Machine_Status_ID;
                        $("#u_machine_status > option[value='" + value + "']").prop("selected", true);
                        $('#ResultModal').modal('hide');
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
