<%@ Page Title="Add New Manual Labour Type" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-4.aspx.cs" Inherits="Test._4_4" %>
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
<script>
//Resolve ALL urls

$(document).ready(function () {
    $("#UC4-4").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        var name = $("#Manual_Labour_type_name").val();
        var sub = $("#sub_contractor").is(":checked");
        var duration = $("#Manual_Labour_type_duration").val();
        var description = $("#Manual_Labour_type_descr").val();

        //console.log(description);

        var ml = {
            Name: name, Description: description, Duration: duration,
            Sub_Contractor: sub
        };

        $("#w_info").html(warnings);
        //alert(JSON.stringify(ml));
        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/ManualLabour",
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
    });

});

</script>

<h1 class="default-form-header">Add New Manual Labour Type</h1>
		
<form id="UC4-4" class="form-horizontal">
	<fieldset>
		<legend>General Information:</legend>
		<div class="row">
			<div class="col-sm-5">
				<label for="Manual_Labour_type_name" class="control-label">Name: </label>
				<input type="text" class="form-control" id="Manual_Labour_type_name" title ="Enter the manual labour type name" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-3">
				<label for="Manual_Labour_type_duration" class="control-label">Duration (in min): </label>
				<input type="number" class="form-control" id="Manual_Labour_type_duration" min="0" max="9999" title ="Enter the duration of the manual labour type" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<br/>
				<div class="checkbox">
					<label>
					<input type="checkbox" id="sub_contractor" value="" title ="Select if the manual labour type is done by a sub-contractor" data-toggle ="tooltip" data-placement ="bottom">
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
		<div class="col-sm-8">
           
		</div>	
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" id="submitManualLabourType" title ="Click to add a new manual labour type" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add New Manual Labour Type</button>
					
		</div>
	</div>
</form>
</asp:Content>
