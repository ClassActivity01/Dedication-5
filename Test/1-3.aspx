<%@ Page Title="Add Employee Category" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="1-3.aspx.cs" Inherits="Test._1_3" %>
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
    <h1 class="default-form-header">Add New Employee Category</h1>
		
		<form id="UC1-3" class="form-horizontal">
			<fieldset>
				<legend>Employee Category Information:</legend>
				<div class="row">
					<div class="col-sm-6">
						<label for="employee_type_name" class="control-label">Category Type: </label>
						<input type="text" class="form-control" id="employee_type_name" placeholder="General Manager" maxlength="30" title ="Enter the employee category name" data-toggle ="tooltip" data-placement ="right"/>
					</div>
					<div class="col-sm-6">
						
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<label for="employee_type_descr">Job Description:</label>
						<textarea class="form-control" rows="5" id="employee_type_descr" maxlength="255" title ="Enter the employee category job description details" data-toggle ="tooltip"></textarea>
					</div>
				</div>
                
			</fieldset>
            <fieldset>
                <legend>Assign Access to Employee Type</legend>
                <label class="checkbox-inline no_indent" title ="Click to select all checkboxes" data-toggle ="tooltip" data-placement ="right"><input type="checkbox" id="Check_All">Check All</label><br/>
                <div id="UC_Access">
                    <div class="row">
                        <div class="col-sm-4" id="ss1" title ="Click to select checkbox"><h2>Employees</h2></div>
                        <div class="col-sm-4" id="ss8" title ="Click to select checkbox"><h2>Equipment</h2></div>
                        <div class="col-sm-4" id="ss4" title ="Click to select checkbox"><h2>Manufacturing</h2></div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4" id="ss3" title ="Click to select checkbox"><h2>Inventory</h2></div>
                        <div class="col-sm-4" id="ss5" title ="Click to select checkbox"><h2>Suppliers</h2></div>
                        <div class="col-sm-4" id="ss6" title ="Click to select checkbox"><h2>Orders</h2></div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4" id="ss7" title ="Click to select checkbox"><h2>Sub-Contractors</h2></div>
                        <div class="col-sm-4" id="ss2" title ="Click to select checkbox"><h2>Clients</h2></div>
                        <div class="col-sm-4" id="ss9"title ="Click to select checkbox" ><h2>Reports</h2></div>
                    </div>

                </div>
            </fieldset>
			<br/>
			<div class="row">
				<div class="col-sm-8">
                    <div class="Warning_Info" id="w_info"></div>
		        </div>	
				<div class="col-sm-4">
					<button type = "submit" class = "form-custom-button-columns" id="submitEmployeeType" title ="Click here to add a new Employee Category" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add New Employee Category</button>
				</div>
			</div>
			
		</form>

<script>
    $(document).ready(function ()
    {

        $("#Check_All").on("click", function () {

            var flag = false;

            if ($(this).is(":checked"))
                flag = true;

            for (var k = 0; k < UC.length; k++) {

                if (flag == false)
                    $("#access_" + UC[k].ID).prop("checked", false);
                else
                    $("#access_" + UC[k].ID).prop("checked", true);
            }


        });

        $("#UC1-3").submit(function (e)
        {
            e.preventDefault();
            var warnings = "";

            var name = $("#employee_type_name").val();
            var description = $("#employee_type_descr").val();

            if (name.length === 0)
            {
                $("#employee_type_name").addClass("empty");
                warnings = warnings + "Please specify Employee Category Name. <br/>";
            }

            if (description.length === 0) {
                $("#employee_type_descr").addClass("empty");
                warnings = warnings + "Please add a Job Description. <br/>";
            }

            for (var k = 0; k < UC.length; k++)
            {
                if ($("#access_" + UC[k].ID).is(":checked"))
                {
                    UC[k].access = true;
                    //console.log("Hello");
                }
                    
            }



            $("#w_info").html(warnings);

            if (warnings == "")
            {
                var employee_type = '{"name": "' + name + '", "access": ' + JSON.stringify(UC) +
                                    ', "description" : "' + description + '"}';
                console.log(employee_type);

                $.ajax({
                    type: "POST",
                    url: "api/EmployeeType",
                    data: { data: "{'employee_type' : " + employee_type + "}" },
                    contentType: "application/json",
                    dataType: "json",
                    error: function (xhr, ajaxOptions, thrownError) {
                        alert(xhr.status);
                        alert(xhr.responseText);
                        alert(thrownError);
                    },
                    success: function (msg) {


                        console.log(msg);

                        var result = msg.split("|");
                        
                        if (result[0] == "true") {
                            alertify.alert('Successful', result[1], function () { location.reload(); });
                        }
                        else {
                            alertify.alert('Error', result[1], function () {});
                        }
                        return false;
                    }
                });
            }
            return false;
        });


        //Get all the employee types.
        $.ajax({
            type: "GET",
            url: "api/Access",
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(xhr.responseText);
                alert(thrownError);
            },
            success: function (msg) {
                var result = msg.split("|");

                if (result[0] == "true") {
                    UC = JSON.parse(result[1]).access;
                    
                    for (var k = 0; k < UC.length; k++) {
                        if (UC[k].ID < 6)
                            $("#ss1").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 6 && UC[k].ID < 9)
                            $("#ss2").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 9 && UC[k].ID < 23)
                            $("#ss3").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 23 && UC[k].ID < 30)
                            $("#ss4").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 30 && UC[k].ID < 40)
                            $("#ss5").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 40 && UC[k].ID < 51)
                            $("#ss6").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 51 && UC[k].ID < 54)
                            $("#ss7").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 54 && UC[k].ID < 60)
                            $("#ss8").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');
                        else if (UC[k].ID >= 60)
                            $("#ss9").append('<label class="checkbox-inline no_indent"><input type="checkbox" id="access_' + UC[k].ID + '"> ' + UC[k].UC_Name + '</label><br/>');

                    }
                    
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });

        
        

    });


    var UC = [];

</script>
</asp:Content>
