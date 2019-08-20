<%@ Page Title="Maintain Employee Category" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="1-4.aspx.cs" Inherits="Test._1_4" %>
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
    <h1 class="default-form-header">Maintain Employee Category <span id="item_ID"></span></h1>
		<!-- Search Code -->
		<div class="searchDiv">
			<form id="search_form">
				<fieldset>
				<legend>Search for Employee Category: </legend>
					<div class="row">
					<div class="col-sm-4">
						<label for="search_criteria" class="control-label">Search Criteria: </label>
						<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the employee category details to search by" data-toggle ="tooltip" data-placement ="bottom"/>
					</div>
					<div class="col-sm-4">
						<label for="search_category">Search By: </label>
						<select class="form-control" id="search_category"  title ="Select what to search the employee category by" data-toggle ="tooltip" data-placement="bottom">
                            <option value="All">All</option>
                            <option value="Name">Name</option>
						    <option value="Description">Description</option>
						</select>
					</div>	
					<div class="col-sm-4">
							<label class="control-label">Search Method: </label><br/>
							<label class="radio-inline" title ="Select a search method"><input type="radio" name="optradio" value="Exact" checked/>Exact</label>
							<label class="radio-inline" title ="Select a search method"><input type="radio" name="optradio" value="Contains"/>Contains</label>

						</div>
					</div>
					<div class="row">
						<div class="col-sm-4">
							
						</div>
						<div class="col-sm-4">
						</div>
						<div class="col-sm-4">
                            <button id="submitSearch" type ="submit" class ="searchButton" runat="server" title ="Click here to search for the employee category" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
				<h4 class="modal-title">Select an Employee Category</h4>
			  </div>
			  <div class="modal-body">
					<select multiple class="form-control" id="supplier_Search_Result" title ="Select an employee category">
					</select>
				</div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Select to close the modal">Close</button>
				<button type="button" class="btn btn-secondary modalbutton" id="loadSupplierDetailsButton" title ="Select to load the employee category details">Load Employee Category Details</button>
			  </div>
			</div><!-- /.modal-content -->
		  </div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
		
		
		<!-- FORM CODE -->
        <style>
            #div-1-4 {
            display: none;
            
            }

        </style>
        <br />
        <div id="div-1-4">
		<form id="UC1-4" class="form-horizontal">
			<fieldset>
				<legend>Employee Category Information:</legend>
				<div class="row">
					<div class="col-sm-6">
						<label for="employee_type_name" class="control-label">Category Type: </label>
						<input type="text" class="form-control" id="employee_type_name" placeholder="General Manager" maxlength="30" title ="Enter the employee category name" data-toggle ="tooltip" data-placement="right"/>
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
                        <div class="col-sm-4" id="ss8" title ="Click to select checkbox" ><h2>Equipment</h2></div>
                        <div class="col-sm-4" id="ss4"><h2>Manufacturing</h2></div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4" id="ss3" title ="Click to select checkbox" ><h2>Inventory</h2></div>
                        <div class="col-sm-4" id="ss5" title ="Click to select checkbox"><h2>Suppliers</h2></div>
                        <div class="col-sm-4" id="ss6" title ="Click to select checkbox"><h2>Orders</h2></div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4" id="ss7" title ="Click to select checkbox"><h2>Sub-Contractors</h2></div>
                        <div class="col-sm-4" id="ss2" title ="Click to select checkbox"><h2>Clients</h2></div>
                        <div class="col-sm-4" id="ss9" title ="Click to select checkbox"><h2>Reports</h2></div>
                    </div>

                </div>
            </fieldset>


			<br/>
			<div class="row">
				<div class="col-sm-4">
					<div class="Warning_Info" id="w_info"></div>
				</div>	
				<div class="col-sm-4">
                    <button onclick="return update_Emp_Type()" class = "form-custom-button-columns" title ="Click here to update the Employee Category details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-wrench" aria-hidden="true" ></i> Update Employee Category</button>
				</div>
				<div class="col-sm-4">
					<button onclick="return delete_Emp_Type()" class = "form-custom-button-columns" title ="Click here to remove the Employee's" data-toggle ="tooltip"><i class="fa fa-times" aria-hidden="true" ></i> Delete Employee Category</button>
				</div>
			</div>
		</form>
        </div>
<script>
    var searchedET;
    var ID;

    function update_Emp_Type()
    {
        var warnings = "";

        var name = $("#employee_type_name").val();
        var access = $("#employee_type_access").val();
        var description = $("#employee_type_descr").val();

        if (name.length === 0) {
            $("#employee_type_name").addClass("empty");
            warnings = warnings + "Please specify Employee Category Type. <br/>";
        }

        if (description.length === 0) {
            $("#employee_type_descr").addClass("empty");
            warnings = warnings + "Please add a Job Description. <br/>";
        }

        for (var k = 0; k < UC.length; k++) {
            if ($("#access_" + UC[k].ID).is(":checked")) {
                UC[k].access = true;
                //console.log("Hello");
            }
            else UC[k].access = false;

        }

        $("#w_info").html(warnings);

        if (warnings == "") {
            var employee_type = '{"name": "' + name + '", "access": ' + JSON.stringify(UC) +
                                ', "description" : "' + description + '"}';

            $.ajax({
                type: "PUT",
                url: "api/EmployeeType/" + ID,
                data: { data: "{'employee_type' : " + employee_type + "}" },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg)
                {
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
    }

    function delete_Emp_Type()
    {
        alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Employee Category?', function () {
            $.ajax({
                type: "DELETE",
                url: "api/EmployeeType/" + ID,
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
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
        }, function () {});

         return false;
    }

    var UC = [];

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




        $("#search_form").submit(function (event) {
            event.preventDefault();

            var method = $('input[name=optradio]:checked', '#search_form').val();
            var criteria = $('#search_criteria').val();
            var category = $('#search_category').val();

            $.ajax({
                type: "POST",
                url: "api/SearchEmployeeType",
                data: { data: "{'method': '" + method + "', 'criteria' : '" + criteria + "', 'category' : '" + category + "'}" },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg) {
                    var result = msg.split("|");
                    $("#supplier_Search_Result").empty();

                    if (result[0] == "true") {
                        searchedET = JSON.parse(result[1]).employee_types;
                        if (searchedET.length == 0) {

                            $("#supplier_Search_Result").append("<option value=''>No results found.</option>");
                        }
                        else {
                            $("#supplier_Search_Result").empty();

                            for (var k = 0; k < searchedET.length; k++) {
                                var html = '<option value="' + searchedET[k].Employee_Type_ID + '">' + searchedET[k].Name + '</option>';
                                
                                $("#supplier_Search_Result").append(html);
                            }
                        }
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });

            $("#ResultModal").modal('show');
        });

        $('#loadSupplierDetailsButton').on('click', function () {
            ID = $('#supplier_Search_Result').val();

            if (ID == "" || ID == null)
                alertify.alert('Error', 'No Employee Category has been chosen!', function () {});
            else
            $.ajax({
                type: "GET",
                url: "api/EmployeeType/"+ID,
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg)
                {
                    var result = msg.split("|");
                    
                    if (result[0] == "true") {
                        var emp_details = JSON.parse(result[1]).employee_types;

                        $("#div-1-4").show();

                        $("#item_ID").html("#" + ID + " ");

                        $("#employee_type_name").val(emp_details[0].Name);

                        $("#employee_type_descr").val(emp_details[0].Description);

                        for (var k = 0; k < emp_details[0].access.length; k++)
                        {
                            if (emp_details[0].access[k].access == true)
                            {
                                for (var i = 0; i < UC.length; i++)
                                    if (UC[i].ID == emp_details[0].access[k].Access_ID)
                                        UC[i].access = true;

                                $("#access_" + emp_details[0].access[k].Access_ID).prop('checked', true);
                            }
                                
                        }


                        //console.log(UC);





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
