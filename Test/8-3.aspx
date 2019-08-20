<%@ Page Title="Add New Unique Machine" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="8-3.aspx.cs" Inherits="Test._8_3" %>
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
<h1 class="default-form-header">Add New Unique Machine</h1>
<form id="UC8-3" class="form-horizontal">
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
    <br />

	<fieldset>
		<legend>Machine Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="machine_ID" class="control-label">Machine Code: </label>
				<input type="number" class="form-control" id="machine_ID" value="0" min="0" disabled>
			</div>
			<div class="col-sm-4">
				<label for="u_machine_ID" class="control-label">Unique Machine Serial No: </label>
				<input type="text" class="form-control" id="u_machine_ID" placeholder="1234-abc" maxlength="25" title ="Enter the unique machine serial number" data-toggle ="tooltip" data-placement ="bottom">
			</div>	
			<div class="col-sm-4">
				<label for="u_machine_status">Unique Machine Status: </label>
				<select class="form-control" id="u_machine_status" title ="Select machine status" data-toggle ="tooltip" data-placement ="bottom">
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
		<div class="col-sm-8">
            
		</div>	
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" title ="Add unique machine" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add New Unique Machine</button>
		</div>
	</div>
			
</form>
<script>

function addMachine(k)
{
    $("#machine_ID").val(k);
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
        success: function (msg)
        {
            var result = msg.split("|");

            if (result[0] == "true") {
                var machines = JSON.parse(result[1]).machines;

                for (var k = 0; k < machines.length; k++) {
                    var row = '<tr>' +
						    '<td>' + machines[k].Machine_ID + '</td>' +
						    '<td><button type="button" title = "Select the machine" class="addToList" onclick="addMachine(' + machines[k].Machine_ID + ')"><i class="fa fa-plus" aria-hidden="true"></i> ' + machines[k].Name + '</button></td>' +
						    '<td>' + machines[k].Manufacturer + '</td>' +
						    '<td>' + machines[k].Model + '</td>' +
						    '</tr>';
                    $("#listOfMachines").append(row);
                }
            }
            else
            {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    //Get the statuses
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

    $("#UC8-3").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var machine_ID = $("#machine_ID").val();
        var unique_machine_ID = $("#u_machine_ID").val();
        var m_status = $("#u_machine_status").val();

        if (machine_ID.length == 0 || unique_machine_ID.length == 0)
        {
            warnings = warnings + "One ore more fields are empty. <br/>";

            if (machine_ID.trim().length == 0)
                $("#machine_ID").addClass("empty");
            if (unique_machine_ID.trim().length == 0)
                $("#u_machine_ID").addClass("empty");

        }

        if (m_status == "Choose")
        {
            warnings = warnings + "Please choose a status. <br/>";
            $("#u_machine_status").addClass("empty");

        }

        
        var unique_machine = { Unique_Machine_ID: unique_machine_ID, Machine_ID: machine_ID, Machine_Status_ID: m_status };

        $("#w_info").html(warnings);

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/UniqueMachine",
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
    });

});

</script>
</asp:Content>
