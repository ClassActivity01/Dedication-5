<%@ Page Title="Add Part Status" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-8.aspx.cs" Inherits="Test._3_8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<h1 class="default-form-header">Add Part Status</h1>
<script src="scripts/MyScripts/tooltip.js"></script>
<script src="scripts/bootstrap.js"></script> 
<style>
		.tooltip-inner
		{
			 min-width:200px;
		}
</style> 
<form id="UC3-8" class="form-horizontal">
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
		<div class="col-sm-8">
            <div class="Warning_Info" id="w_info"></div>
		</div>	
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" title ="Click to add the part status" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add Part Status</button>
		</div>
	</div>
</form>
<script>



$(document).ready(function () {

    $("#UC3-8").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var name = $("#part_stat_name").val();
        var description = $("#part_stat_desc").val();

        if (name.length == 0 || description.length == 0)
        {
             warnings = warnings + "One or more fields are empty. <br/>";
        }

        if (name.length == 0)
            $("#part_stat_name").addClass("empty");

        if (description.length == 0)
            $("#part_stat_desc").addClass("empty");

        var part_status = { Name : name, Description : description};
        

        $("#w_info").html(warnings);

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/PartStatus",
                data: { data: JSON.stringify(part_status) },
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
