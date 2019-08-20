<%@ Page Title="Maintain VAT" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-11.aspx.cs" Inherits="Test._6_11" %>
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
    $(document).ready(function () {
        $.ajax({
            type: "GET",
            url: "api/VAT",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(xhr.responseText);
                alert(thrownError);
            },
            success: function (msg) {
                var result = msg.split("|");

                if (result[0] == "true") {
                    var vat = JSON.parse(result[1]).vats[0];

                    var date = vat.Date.split("T");
                    var date2 = (new Date()).toISOString().split("T");


                    $('#vat').val(vat.VAT_Rate);
                    $('#vat_date').val(date[0]);
                    $('#vat_new_date').val(date2[0]);
                }
                else
                    alertify.alert('Error', result[1], function () { });
            }
        });

        $("#UC6-11").submit(function (e) {
            var warnings = "";

            var vatn = $('#vat_new').val();
            var date = (new Date()).toISOString();

            var vat = { Date: date, VAT_Rate : parseInt(vatn)};

            $("#w_info").html(warnings);

            if (warnings == "") {
                $.ajax({
                    type: "POST",
                    url: "api/VAT",
                    data: { data: JSON.stringify(vat) },
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

                        return false;
                    }
                });
            }

            return false;
        });
    });
</script>
<h1 class="default-form-header">Maintain VAT</h1>
				
<form id="UC6-11" class="form-horizontal">
	<fieldset>
		<legend>VAT Information:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="vat" class="control-label">Current VAT %: </label>
				<input type="number" class="form-control" id="vat" value="14" readonly>
			</div>
			<div class="col-sm-6">
				<label for="vat_date" class="control-label">Current VAT Date: </label>
				<input type="date" class="form-control" id="vat_date" value="2016-01-01" readonly>
			</div>
			<div class="col-sm-6">
				<label for="vat_new" class="control-label">New VAT %: </label>
				<input type="number" max="100" min="0" class="form-control" id="vat_new" value="0" title ="Enter new Vat rate" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-6">
				<label for="vat_new_date" class="control-label">New VAT Date: </label>
				<input type="date" class="form-control" id="vat_new_date" disabled>
			</div>
		</div>
	</fieldset>
	<div>
          <div class="Warning_Info" id="w_info"></div>
	</div>		
	<br/>
	<div class="row">
        <div class="col-sm-8">
			
		</div>	
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" title ="Click to update VAT" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-wrench" aria-hidden="true"></i> Update VAT</button>
		</div>	
	</div>
</form>
</asp:Content>
