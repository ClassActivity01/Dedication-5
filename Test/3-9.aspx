<%@ Page Title="Maintain Part Status" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-9.aspx.cs" Inherits="Test._3_9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
    <h1 class="default-form-header">Maintain Part Status <span id="item_ID"></span></h1>
	<script src="scripts/MyScripts/tooltip.js"></script>
    <script src="scripts/bootstrap.js"></script>
     <style>
		.tooltip-inner
		{
			 min-width:200px;
		}
    </style> 			
<form id="UC3-9" class="form-horizontal">
	<fieldset>
		<legend>Select Part Status:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="part_stat_name" class="control-label">Part Statuses on System: </label>
				<select class="form-control" id="part_statuses" title ="Select the Part status" data-toggle ="tooltip" data-placement ="right">
                    <option value="choose">Choose</option>
				</select>
			</div>
		</div>
		<div class="row">
            <div class="col-sm-8">
			</div>
			<div class="col-sm-4">
				<button onclick="return loadInfo()" class="searchButton" title ="Click to display the part status details" data-toggle ="tooltip" data-placement ="left">Load Part Status</button>
			</div>
		</div>
	</fieldset>
    <br />

    <fieldset>
		<legend>Part Status Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="part_stat_name" class="control-label">Part Status Name: </label>
				<input type="text" class="form-control" id="part_stat_name" placeholder="Part Status Name" maxlength="25" title ="Enter the part status name" data-toggle ="tooltip" data-placement ="right"/>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<label for="part_stat_desc">Part Status Description:</label>
				<textarea class="form-control" rows="3" id="part_stat_desc" maxlength="250" title ="Enter the part status description" data-toggle ="tooltip"></textarea>
			</div>
		</div>
	</fieldset>
			
	<br/>
	<div class="row">
		<div class="col-sm-4">
            <div class="Warning_Info" id="w_info"></div>
		</div>	
        <div class="col-sm-4">
            <button onclick="return deletePartStatus()" class = "form-custom-button-columns" title ="Click to remove the part status" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-minus" aria-hidden="true"></i> Remove Part Status</button>
		</div>	

		<div class="col-sm-4">
			<button onclick="return updatePartStatus()" class = "form-custom-button-columns" title ="Click to update the part status details" data-toggle ="tooltip"><i class="fa fa-wrench" aria-hidden="true"></i> Update Part Status</button>
		</div>
	</div>
</form>
<script>
    var part_statuses;
    var part_status_ID;

function loadInfo()
{
    var k = $('#part_statuses').val();

    if (k == "choose" || k == null)
        alertify.alert('Error', 'No Part has been chosen!');
    else
    {
        part_status_ID = part_statuses[k].Part_Status_ID;

        $("#item_ID").html("#" + part_status_ID + " ");

        $("#part_stat_name").val(part_statuses[k].Name);
        $("#part_stat_desc").val(part_statuses[k].Description);
    }

    return false;
}

function updatePartStatus()
{
    var warnings = "";

    var name = $("#part_stat_name").val();
    var description = $("#part_stat_desc").val();

    if (name.length == 0 || description.length == 0) {
        warnings = warnings + "One or more fields are empty. <br/>";
    }

    if (name.length == 0)
        $("#part_stat_name").addClass("empty");

    if (description.length == 0)
        $("#part_stat_desc").addClass("empty");

    if (part_status_ID == "" || part_status_ID == null)
    {
        warnings = warnings + "No Part Status has been chosen. <br/>";
    }


    var part_status = { Part_Status_ID: part_status_ID, Name: name, Description: description };


    $("#w_info").html(warnings);

    if (warnings == "") {
        $.ajax({
            type: "PUT",
            url: "api/PartStatus/" + part_status_ID,
            data: {data: JSON.stringify(part_status)},
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

function deletePartStatus()
{

    if (part_status_ID == "" || part_status_ID == null) {
        var warnings = "Cannot Delete - No Part Status has been chosen. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    $("#w_info").html("");

    alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Part Status?', function () {
        $.ajax({
            type: "DELETE",
            url: "api/PartStatus/" + part_status_ID,
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
    $.ajax({
        type: "GET",
        url: "api/PartStatus",
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
            if (result[0] == "true")
            {
                part_statuses = JSON.parse(result[1]).part_statuses;

                for (var k = 0; k < part_statuses.length; k++) {
                    var type = '<option value="' + k + '">' + part_statuses[k].Name + '</option>';
                    $("#part_statuses").append(type);
                }
            }
            else
                alertify.alert('Error', result[1]);
        }
    });

});

</script>


</asp:Content>
