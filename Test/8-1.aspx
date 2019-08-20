<%@ Page Title="Add New Machine" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="8-1.aspx.cs" Inherits="Test._8_1" %>
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
<h1 class="default-form-header">Add New Machine</h1>
<form id="UC8-1" class="form-horizontal">
	<fieldset>
		<legend>Machine Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="machine_name" class="control-label">Machine Name: </label>
				<input type="text" class="form-control" id="machine_name" placeholder="Machine A" maxlength="40" title ="Enter the machine name" data-toggle ="tooltip" data-placement ="right">
			</div>
			<div class="col-sm-4">
				<label for="machine_model" class="control-label">Machine Model: </label>
				<input type="text" class="form-control" id="machine_model" placeholder="1234-abc" maxlength="40"title ="Enter the machine model" data-toggle ="tooltip" data-placement ="right" >
			</div>	
			<div class="col-sm-4">
				<label for="machine_manufacturer" class="control-label">Machine Manufacturer: </label>
				<input type="text" class="form-control" id="machine_manufacturer" placeholder="M2 Production" maxlength="40" title ="Enter the machine manufacturer" data-toggle ="tooltip" data-placement ="bottom">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="machine_runtime" class="control-label">Machine Runtime (in minutes): </label>
				<input type="number" class="form-control" id="machine_runtime" value="1" min="1" max="999" title ="Enter the machine runtime" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="machine_pph" class="control-label">Machine Price per Hour R: </label>
				<input type="number" class="form-control" id="machine_pph" value="0.00" min="1" step="0.01" title ="Enter the price per hour" data-toggle ="tooltip" data-placement ="right">
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
			<button type = "submit" class = "form-custom-button-columns" title ="Click to add new machine" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add New Machine</button>
		</div>
	</div>
		
</form>	

<script>


$(document).ready(function () {

    $("#UC8-1").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        var negatives = checkForNegatives();

        if (negatives == true) {
            warnings = warnings + "One or more number fields have negative inputs. <br/>";
        }

        var name = $("#machine_name").val();
        var model = $("#machine_model").val();
        var manufacturer = $("#machine_manufacturer").val();
        var runtime = $("#machine_runtime").val();
        var ppr = $("#machine_pph").val();

        var machine = {Name : name, Model : model, Manufacturer : manufacturer, 
            Run_Time: runtime, Price_Per_Hour: ppr
        };

        $("#w_info").html(warnings);

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/Machine",
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
    });

});
</script>
</asp:Content>
