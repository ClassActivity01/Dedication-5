<%@ Page Title="Maintain Machine" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="8-2.aspx.cs" Inherits="Test._8_2" %>
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
<h1 class="default-form-header">Maintain Machine <span id="item_ID"></span></h1>
		
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search For Machine: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the details to search the machine by" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the details to search the machine by" data-toggle ="tooltip" data-placement ="bottom">
                    <option value="All">All</option>
					<option value="Name">Name</option>
					<option value="Model">Model</option>
					<option value="Manufacturer">Manufacturer</option>
					<option value="ID">Machine No.</option>
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
                    <button id="submitSearch" type ="submit" class ="searchButton" title ="Click to search for the machine" data-toggle ="tooltip" data-placement ="right" ><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Machine</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="machine_search_results" title ="Select a machine">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadMachineDetails" title ="Click to load the machine details">Load Machine Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
<br/>
<!-- FORM CODE -->
<style>
    #div_8_2 { display:none;}
</style>
<div id="div_8_2">
<form id="UC8-2" class="form-horizontal">
	<fieldset>
		<legend>Machine Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="machine_name" class="control-label">Machine Name: </label>
				<input type="text" class="form-control" id="machine_name" placeholder="Machine A" maxlength="25" title ="Enter the machine name" data-toggle ="tooltip" data-placement ="right" >
			</div>
			<div class="col-sm-4">
				<label for="machine_model" class="control-label">Machine Model: </label>
				<input type="text" class="form-control" id="machine_model" placeholder="1234-abc" maxlength="25" title ="Enter the machine model" data-toggle ="tooltip" data-placement ="right" >
			</div>	
			<div class="col-sm-4">
				<label for="machine_manufacturer" class="control-label">Machine Manufacturer: </label>
				<input type="text" class="form-control" id="machine_manufacturer" placeholder="M2 Production" maxlength="25" title ="Enter the machine manufacturer" data-toggle ="tooltip" data-placement ="bottom">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="machine_runtime" class="control-label">Machine Runtime (in minutes): </label>
				<input type="number" class="form-control" id="machine_runtime" value="1" min="1" max="999" title ="Enter the machine runtime" data-toggle ="tooltip" data-placement ="bottom" >
			</div>
			<div class="col-sm-4">
				<label for="machine_pph" class="control-label">Machine Price per hour R: </label>
				<input type="number" class="form-control" id="machine_pph" value="1" min="1" step="0.01" title ="Enter the price per hour" data-toggle ="tooltip" data-placement ="right" >
			</div>	
			<div class="col-sm-4">
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
            <button onclick="return updateMachine()" class = "form-custom-button-columns" title ="Click to update the machine details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-wrench" aria-hidden="true"></i> Update Machine</button>
		</div>
		<div class="col-sm-4">
			<button onclick="return deleteMachine()" class = "form-custom-button-columns" title ="Click to remove the machine" data-toggle ="tooltip" ><i class="fa fa-times" aria-hidden="true"></i> Delete Machine</button>
		</div>
	</div>
</form>	
</div>

<script>
//Global Variables
var machine_ID;
var machine_details;
var searchedMachines;

function updateMachine()
{
    var warnings = "";

    var empty = checkEmpty();

    if (empty == false) {
        warnings = warnings + "One or more fields are empty. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    var negatives = checkForNegatives();

    if (negatives == true)
    {
        warnings = warnings + "One or more number fields have negative inputs. <br/>";
    }

    var name = $("#machine_name").val();
    var model = $("#machine_model").val();
    var manufacturer = $("#machine_manufacturer").val();
    var runtime = $("#machine_runtime").val();
    var ppr = $("#machine_pph").val();

    var machine = {Name: name, Model: model, Manufacturer: manufacturer,
        Run_Time: runtime, Price_Per_Hour: ppr
    };

    $("#w_info").html(warnings);

    if (warnings == "") {
        $.ajax({
            type: "PUT",
            url: "api/Machine/" + machine_ID,
            data: {data: JSON.stringify(machine)},
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

function deleteMachine()
{
    if (machine_ID == "" || machine_ID == null) {
        var warnings = "Cannot Delete - No Machine has been chosen. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Machine?', function () {
        $.ajax({
            type: "DELETE",
            url: "api/Machine/" + machine_ID,
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
            url: "api/SearchMachine",
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
                    searchedMachines = JSON.parse(result[1]).machines;

                    $('#machine_search_results').empty();

                    for (var k = 0; k < searchedMachines.length; k++) {
                        var html = '<option value="' + searchedMachines[k].Machine_ID + '">' + searchedMachines[k].Name + ' - ' + searchedMachines[k].Manufacturer + ' - ' + searchedMachines[k].Model + '</option>';

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

        machine_ID = $('#machine_search_results').val();

        if (machine_ID == "" || machine_ID == null)
            alertify.alert('Error', 'No Machine has been chosen!');
        else
            $.ajax({
                type: "GET",
                url: "api/Machine/" + machine_ID,
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
                        machine_details = JSON.parse(result[1]).machines;

                        $("#div_8_2").show();

                        $("#item_ID").html("#" + machine_ID + " ");

                        $("#machine_name").val(machine_details[0].Name);
                        $("#machine_model").val(machine_details[0].Model);
                        $("#machine_manufacturer").val(machine_details[0].Manufacturer);
                        $("#machine_runtime").val(machine_details[0].Run_Time);
                        $("#machine_pph").val(machine_details[0].Price_Per_Hour);
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
