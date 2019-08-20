<%@ Page Title="Maintain Unique Machine Statuses" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="8-5.aspx.cs" Inherits="Test._8_5" %>
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
<h1 class="default-form-header">Maintain Unique Machine Statuses</h1>		
<form id="UC8-5" class="form-horizontal">
	<fieldset>
		<legend>Unique Machines:</legend>
        
		<div class="table-responsive makeDivScrollable">
			<table class="sortable table table-hover">
				<thead>
					<tr>
						<th>Serial No</th>
						<th>Type of Machine</th>
						<th>Manufacturer</th>
						<th>Model</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody id="listOfMachines">
					
				</tbody>
			</table>
		</div> 
	</fieldset>
			
	<br/>
	<div class="row">
		<div class="col-sm-4">
		</div>	
		<div class="col-sm-4">
		</div>
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" title ="Click to update unique machine status" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Update Unique Machine statuses</button>
		</div>
	</div>
			
</form>	

<script>
var machine_statusses = "";
var machines;

$(document).ready(function () {

    //Get the statuses
    $.ajax({
        type: "GET",
        url: "api/MachineStatus",
        contentType: "application/json; charset=utf-8",
        async: false,
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
                    machine_statusses = machine_statusses + row;
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    $.ajax({
        type: "GET",
        url: "api/UniqueMachineStatuses",
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
                machines = JSON.parse(result[1]).unique_machine_statuses;

                for (var k = 0; k < machines.length; k++) {
                    var row = '<tr><td>' + machines[k].Unique_Machine_ID + '</td><td>' + machines[k].Name + '</td><td>' +
                        machines[k].Manufacturer + '</td><td>' + machines[k].Model + '</td>' +
                    '<td><select class="form-control" title ="Select the machine status" id="u_machine_status_' + machines[k].Unique_Machine_ID + '">' + machine_statusses + '</select></td></tr>';

                    $("#listOfMachines").append(row);

                    var value = machines[k].Machine_Status_ID;
                    var ums_status = "u_machine_status_" + machines[k].Unique_Machine_ID;
                    $("#" + ums_status + " > option[value='" + value + "']").prop("selected", true);
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    $("#UC8-5").submit(function (e) {
        e.preventDefault();
        
        var ums = [];

        for (var k = 0; k < machines.length; k++)
        {

            var value = $("#u_machine_status_" + machines[k].Unique_Machine_ID).val();
            console.log(value);
            
            var um = { Unique_Machine_ID: machines[k].Unique_Machine_ID, Machine_Status_ID: value, Machine_ID: machines[k].Machine_ID };

            ums.push(um);
        }
                
        //console.log(ums);
        //alert(JSON.stringify(ums));
        $.ajax({
            type: "POST",
            url: "api/UniqueMachineStatuses",
            data: { data: JSON.stringify(ums) },
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

        return false;
    });

});
</script>
<style>
    .makeDivScrollable {
        max-height : 600px;
    }

</style>
</asp:Content>
