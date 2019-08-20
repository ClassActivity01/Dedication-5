<%@ Page Title="Update Part Statuses" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-15.aspx.cs" Inherits="Test._3_15" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<h1 class="default-form-header">Update Part Statuses</h1>
<script src="scripts/MyScripts/tooltip.js"></script>
<script src="scripts/bootstrap.js"></script>
<style>
		.tooltip-inner
		{
			 min-width:200px;
		}
</style> 		
<form id="UC3-15" class="form-horizontal">
	<fieldset>
		<legend>List of Uncompleted Parts:</legend>
        <div class="row">
            <div class="col-md-4">
                <label for="order_by">Order By: </label>
				<select class="form-control" id="order_by" title ="Select how to sort search results" data-toggle ="tooltip" data-placement ="right">
                    <option value="Select">Select an option</option>
					<option value="Name">Name</option>
					<option value="Part_Serial">Serial</option>
					<option value="Stage">Stage</option>
					<option value="Date_Added">Date Added</option>
                    <option value="Job_Card_ID">Job Card No.</option>
				</select>

            </div>
            <div class="col-md-8"></div>
        </div>
        <br />
		<div class="table-responsive makeDivScrollable" style="max-height : 500px;">
				<table class="table table-hover" >
					<thead>
						<tr>
							<th>Serial No.</th>
							<th>Part Type</th>
							<th>Stage in Manufacturing</th>
							<th>Date Added</th>
                            <th>Job Card #</th>
                            <th>Status</th>
						</tr>
					</thead>
					<tbody id="partItems">
                        
					</tbody>
				</table>
			</div>
	</fieldset>
			
	<br/>
	<div class="row">
        <div class="col-sm-8">
					
		</div>
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" title ="Click to update part status" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-wrench" aria-hidden="true"></i> Update Part Statusses</button>
		</div>
	</div>
</form>

<script>
    var parts = [];

    var statuses = "";
    var i = 0;
    var pp;

$(document).ready(function () {

    $("#UC3-15").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        for (var k = 0; k < parts.length; k++)
        {
            parts[k].Part_Status_ID = $("#part_status_" + k).val();
        }

        //alert(JSON.stringify(parts));

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/UpdatePartStatus",
                data: {data: JSON.stringify(parts)},
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


    //On Form Load
    $.ajax({
        type: "GET",
        url: "api/PartStatus",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async : false,
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
                    statuses = statuses + '<option value="' + part_statuses[k].Part_Status_ID + '">' + part_statuses[k].Name + '</option>';
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });


    $.ajax({
        type: "GET",
        url: "api/UpdatePartStatus",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(xhr.responseText);
            alert(thrownError);
        },
        success: function (msg) {
            var result = msg.split("|");

            if (result[0] == "true") 
            {
                pp = JSON.parse(result[1]).parts;
                
                for(var k = 0; k < pp.length; k++)
                {
                    var date = pp[k].Date_Added;
                    var res2 = date.split("T");

                    var row = '<tr>'+
                            '<td>'+ pp[k].Part_Serial +'</td>'+
                            '<td>' + pp[k].Name + '</td>' +
                            '<td>' + pp[k].Part_Stage + '</td>' +
                            '<td>' + res2[0] + '</td>' +
                            '<td>' + pp[k].Job_Card_ID + '</td>' +
                            '<td><select id="part_status_'+i+'" title ="Select the part status">'+statuses+'</select></td>'+
                            '</tr>';

                    var part = { Part_ID: pp[k].Part_ID, Part_Status_ID: pp[k].Part_Status_ID };
                    parts.push(part);

                    $("#partItems").append(row);

                    var value = pp[k].Part_Status_ID;

                    $("#part_status_" + i + " > option[value='" + value + "']").prop("selected", true);

                    i++;
                }
            }
            else
                alertify.alert('Error', result[1], function () { });
        }
    });

    $('#order_by').on('change', function () {
        var prop = $('#order_by').val();
        //console.log(prop);

        pp.sort(predicatBy(prop));

        $("#partItems").empty();

        i = 0;

        for (var k = 0; k < pp.length; k++) {
            var date = pp[k].Date_Added;
            var res2 = date.split("T");

            var row = '<tr>' +
                    '<td>' + pp[k].Part_Serial + '</td>' +
                    '<td>' + pp[k].Name + '</td>' +
                    '<td>' + pp[k].Part_Stage + '</td>' +
                    '<td>' + res2[0] + '</td>' +
                    '<td>' + pp[k].Job_Card_ID + '</td>' +
                    '<td><select id="part_status_' + i + '" title ="Select the part status">' + statuses + '</select></td>' +
                    '</tr>';

            var part = { Part_ID: pp[k].Part_ID, Part_Status_ID: pp[k].Part_Status_ID };
            parts.push(part);

            $("#partItems").append(row);

            var value = pp[k].Part_Status_ID;

            $("#part_status_" + i + " > option[value='" + value + "']").prop("selected", true);

            i++;
        }
        
    });

    function predicatBy(prop) {
        return function (a, b) {
            if (a[prop] > b[prop]) {
                return 1;
            } else if (a[prop] < b[prop]) {
                return -1;
            }
            return 0;
        }
    }


});

</script>
</asp:Content>
