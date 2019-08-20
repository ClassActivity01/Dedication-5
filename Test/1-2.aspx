<%@ Page Title="Maintain Employee" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="1-2.aspx.cs" Inherits="Test._1_2" %>
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
	function createAddMachineDiv()
	{
		if($("#machinefieldset").is(":visible"))
		{
			$("#machinedivbutton").html('<i class="fa fa-plus" aria-hidden="true"></i> Add Machines to Employee');
			$("#machinefieldset").hide();
		}
		else
		{
			$("#machinedivbutton").html('<i class="fa fa-minus" aria-hidden="true"></i> Do not assign Employee to Machines');
			$("#machinefieldset").show();
		}	
	}
		
	function createAddManualLabourDiv()
		{
			if($("#manuallabourfieldset").is(":visible"))
			{
				$("#manualdivbutton").html('<i class="fa fa-plus" aria-hidden="true"></i> Add Manual Labour To Employee');
				$("#manuallabourfieldset").hide();
			}
			else
			{
				$("#manualdivbutton").html('<i class="fa fa-minus" aria-hidden="true"></i> Do not assign Employee to Manual Labour');
				$("#manuallabourfieldset").show();
			}	
		}
				
		function showPassword()
		{
			if($("#passwordfieldset").is(":visible"))
			{
			    
				$("#changepasswordbutton").html('<i class="fa fa-plus" aria-hidden="true"></i> Change Password');
				$("#passwordfieldset").hide();
			}
			else
			{
			    $("#changepasswordbutton").html('<i class="fa fa-minus" aria-hidden="true"></i> Do not Change Password');
                $("#passwordfieldset").show();
			}
		}
</script>
<style>
	.scrollableDiv
	{
		max-height: 150px;
		overflow-y: auto;
	}
			
	.checkbox
	{
		padding: 1%;
		padding-bottom: 2%;
		margin: 0;
	}
			
	.checkboxCustom
	{

	}
	.checkboxCustom:hover
	{
		background: rgba(204, 204, 204, 0.2);
	}
			
	.infoheader
	{
		font-weight: bold;
	}
	#passwordfieldset
	{
		display: none;
	}
			
</style>

<h1 class="default-form-header">Maintain Employee <span id="item_ID"></span></h1>		
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Employee: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the employee's details to search by" data-toggle ="tooltip" data-placement="bottom"/>
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select what to search the employee by" data-toggle ="tooltip" data-placement="bottom" >
					<option value="All">All</option>
					<option value="Name">Name</option>
					<option value="Surname">Surname</option>
					<option value="Email">Email</option>
					<option value="IDNumber">ID Number</option>
					<option value="ContactNumber">Contact Number</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Exact" name="optradio" checked/>Exact</label>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Contains" name="optradio" />Contains</label>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					
				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
                    <button id="submitSearch" type ="submit" class ="searchButton" title ="Click here to search for the employee" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select an Employee</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="employee_search_results" title ="Select an employee">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Select to close modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadEmployeeDetails" title ="Select to load the employee's details">Load Employee Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
<!-- FORM CODE -->
<style>
    #div_1_2 {display: none;}
</style>

<br />
<div id="div_1_2">		
<form id="UC1-2" class="form-horizontal">
	<ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#employee" title ="Click to select the employee tab">Employee</a></li>
        <li><a data-toggle="tab" href="#machines" title ="Click to select the machine tab">Machines</a></li>
        <li><a data-toggle="tab" href="#manual" title ="Click to select the manual labour type tab">Manual Labour</a></li>
        <li><a data-toggle="tab" href="#photo" title ="Click to select the employee photo tab">Employee Photo</a></li>
    </ul>
    <br />

    <div class="tab-content">
    <div id="employee" class="tab-pane fade in active">
    <fieldset>
		<legend>General Employee Information:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="employee_Name" class="control-label">Employee Name: </label>
				<input type="text" class="form-control" id="employee_Name" placeholder="Jane" title ="Enter the employee's new name" data-toggle ="tooltip"/>
			</div>
			<div class="col-sm-6">
				<label for="employee_Surname" class="control-label">Employee Surname: </label>
				<input type="text" class="form-control" id="employee_Surname" placeholder="Doe" title ="Enter the employee's new surname" data-toggle ="tooltip" data-placement ="left"/>
			</div>	
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label for="employee_ID" class="control-label">ID Number: </label>
				<input type="text" class="form-control" id="employee_ID" placeholder="0000000000000" maxlength="13" title ="Enter the employee's new ID Number" data-toggle ="tooltip"/>
			</div>
			<div class="col-sm-4">
				<label for="employee_no" class="control-label">Contact Number: </label>
				<input type="text" class="form-control" id="employee_no" placeholder="0000000000" maxlength="15" title ="Enter the employee's new contact number" data-toggle ="tooltip" data-placement ="left"/>
			</div>
			<div class="col-sm-2">
				<label for="employee_gender">Gender: </label>
				<select class="form-control" id="employee_gender" title ="Select the gender for the employee" data-toggle ="tooltip" data-placement ="left">
                    <option value="Choose">Choose an Option</option>
					<option value="M">Male</option>
					<option value="F">Female</option>
                    <option value="O">Other</option>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="employee_email" class="control-label">Email: </label>
				<input type="email" class="form-control" id="employee_email" placeholder="email@email.com" title ="Enter the employee's new email" data-toggle ="tooltip"/>
			</div>
			<div class="col-sm-4">
				<label for="employee_type">Employee Category: </label>
				<select class="form-control" id="employee_type" title ="Select the employee category" data-toggle ="tooltip" data-placement ="bottom">
					<option value="Choose">Choose an Option</option>
				</select>
			</div>
			<div class="col-sm-4">
				<br/>
				<a class="Add_extra_things_link" href="#"><i class="fa fa-plus" aria-hidden="true"></i> Add New Employee Category</a>
			</div>
		</div>
	</fieldset>
    
	<br/>

	<button type="button" id="changepasswordbutton" class="Add_extra_things" onclick="showPassword()" title ="Click here to change the employee's password" data-toggle ="tooltip" data-placement ="bottom"><i class="fa fa-plus" aria-hidden="true"></i> Change Password</button>
			
	<fieldset id="passwordfieldset">
		<legend>Login Details:</legend>
		<div class="row">
			<div class="col-sm-7">
				<label for="employee_username" class="control-label">Username: </label>
				<input type="text" class="form-control" id="employee_username" title ="Please enter your new username" data-toggle ="tooltip" data-placement="right"/>
						
				<label for="employee_password" class="control-label">New Password: </label>
				<input type="password" class="form-control" id="employee_password" title ="Please enter a password" data-toggle ="tooltip" data-placement="right"/>
						
				<label for="employee_password_confirm" class="control-label">Confirm Password: </label>
				<input type="password" class="form-control" id="employee_password_confirm" title ="Please re-enter your password" data-toggle ="tooltip" data-placement="right"/>
			</div>
			<div class="col-sm-5">
			</div>
		</div>
	</fieldset>
        <br />
        <div class="row">
		<div class="col-sm-4">

		</div>	
		<div class="col-sm-4">
            <button onclick="return deleteEmployee()" class = "form-custom-button-columns" title ="Click here to remove the employee" data-toggle ="tooltip" ><i class="fa fa-times" aria-hidden="true"></i> Remove Employee</button>
		</div>
		<div class="col-sm-4">
            <button onclick="return updateEmployee()" class = "form-custom-button-columns" title ="Click here to update the employee's details" data-toggle ="tooltip" ><i class="fa fa-wrench" aria-hidden="true"></i> Update Employee</button>
		</div>
	</div>
	</div>
			
	<div id="machines" class="tab-pane fade">
	<fieldset id="machinefieldset">
		<legend>Assign Employee to Machines</legend>
		<div class="row">
					
			<div class="col-sm-3">
				<h3>Select machines: </h3>
				<div class="scrollableDiv" id="listOfMachines">
				</div>
			</div>
			<div class="col-sm-6">
				<h3>Machine Information: </h3>
				<div class="displayInformationDiv scrollableDiv">
					<p>
						<span class="infoheader">Name:</span> <span id="m_name"></span> <br/>
						<span class="infoheader">Serial No:</span> <span id="m_ID"></span> <br/>
						<span class="infoheader">Model:</span> <span id="m_model"></span> <br/>
						<span class="infoheader">Manufacturer:</span> <span id="m_man"></span> <br/>
						<span class="infoheader">No. of Machines Available:</span> <span id="m_no"></span> <br/>
					</p>
				</div>
			</div>
			<div class="col-sm-3">
				<br/>
				<a class="Add_extra_things_link" href="#"><i class="fa fa-plus" aria-hidden="true"></i> Add New Machine</a>
			</div>
		</div>
	</fieldset>
    </div>
			
	<div id="manual" class="tab-pane fade">
	<fieldset id="manuallabourfieldset">
		<legend>Assign Employee to Manual Labour</legend>
		<div class="row">
			<div class="col-sm-4">
				<h3>Select Manual Labour: </h3>
				<div class="scrollableDiv" id="listOfManualLabour">
                
				</div>
			</div>
			<div class="col-sm-8">
				<h3>Manual Labour Information: </h3>
				<div class="displayInformationDiv scrollableDiv">
					<p>
						<span class="infoheader">Name:</span> <span id="ml_name"></span> <br/>
						<span class="infoheader">ID:</span> <span id="ml_ID"></span>  <br/>
						<span class="infoheader">Description:</span> <span id="ml_descr"></span> <br/>
					</p><br/>
					<a class="Add_extra_things_link" href="#"><i class="fa fa-plus" aria-hidden="true"></i> Add New Manual Labour</a>
				</div>
			</div>
		</div>
	</fieldset>
    </div>

    <div id="photo" class="tab-pane fade">
	<fieldset id="photo_fieldset">
		<legend>Add an Employee photo</legend>
		<script src="Webcam/webcam.js"></script>
        <script>

            $(document).ready(function () {
                Webcam.set({
                    width: 320,
                    height: 240,
                    image_format: 'jpeg',
                    jpeg_quality: 90
                });

                Webcam.attach('#my_camera');
            });

            function take_snapshot() {
                Webcam.snap(function (data_uri)
                {
                    document.getElementById('my_result').innerHTML = '<img src="' + data_uri + '"/>';
                    image = data_uri;



                } );
            }
        </script>
        
        <div class="row">
            <div class="col-md-6"><div id="my_camera" style="width:320px; height:240px;" title ="Don't forget to smile" data-toggle ="tooltip" data-placement ="bottom"></div></div>
            <div class="col-md-6"><div id="my_result" title ="Employee photo" data-toggle ="tooltip" data-placement ="bottom"></div></div>

        </div>
        <br />

        <style>
            .abutton {
                background-color : #333;
                color: #ccc;
                border : 1px solid #333;
                padding : 5px;
                text-decoration : none;

            }

                .abutton:hover {
                    background-color: #444;
	                color: #ff4000;

                }
        </style>

        

        <a class="abutton"  onclick="javascript:void(take_snapshot())" title ="Click to take a snapshot" data-toggle ="tooltip" data-placement="right">Take Snapshot</a>
	
	</fieldset>
    </div>
    </div>
		
	<br/>
	<div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	</div>     
</form>
</div>

<script>
    var searchedE;
    var ID;
    var image = "";

    function extract() {
        var s = "";

        if (image != "") {
            var i = image.indexOf(',');
            s = image.substr(i + 1, image.length - i);
            //console.log(s);

        }

        return s;
    }

    function updateEmployee()
    {
       var warnings = "";

        //Check for empty inputs
        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        //Check if dropdowns have valid values
        var emp_type = $("#employee_type").val();

        if (emp_type == "Choose") {
            warnings = warnings + "No category chosen for employee category. <br/>";
            $("#employee_type").addClass("empty");
        }

        var emp_gender = $("#employee_gender").val();

        if (emp_gender == "Choose") {
            warnings = warnings + "No gender for employee gender. <br/>";
            $("#employee_gender").addClass("empty");
        }

        //Get Rest of Info
        var emp_name = $("#employee_Name").val();
        var employee_surname = $("#employee_Surname").val();
        var employee_ID = $("#employee_ID").val();

        //Check ID length to be exact
        if (employee_ID.length < 13) {
            warnings = warnings + "ID number not 13 characters. <br/>";
            $("#employee_ID").addClass("empty");
        }

        //Make sure there are no characters in it
        var only_nums_pattern = new RegExp("^[0-9]*$");
        var res = only_nums_pattern.test(employee_ID);
        if (res == false) {
            warnings = warnings + "ID number may only contain numeric characters. <br/>";
            $("#employee_ID").addClass("empty");
        }

        //Validate ID date
        var date = employee_ID.substring(0, 6);

        var y = date.substr(0, 2);
        var m = date.substr(2, 2);
        var d = date.substr(4, 2);

        y = parseInt(y);
        m = parseInt(m);
        d = parseInt(d);

        if (m < 1 || m > 12)
            warnings = warnings + "ID number month not correct. <br/>";

        if (d < 1 || d > 31)
            warnings = warnings + "ID number day not correct. <br/>";

        var Employee_contact_number = $("#employee_no").val().replace(/ /g, '');
        var emp_type_ar = emp_type.split(">");

        var res = only_nums_pattern.test(Employee_contact_number);
        if (res == false) {
            warnings = warnings + "Contact number may only contain numeric characters. <br/>";
            $("#employee_no").addClass("empty");
        }

        if (Employee_contact_number.length < 10) {
            warnings = warnings + "Contact number is not correct. Invalid Length <br/>";
            $("#employee_no").addClass("empty");
        }



        if ($("#passwordfieldset").is(":visible")) {
            var employee_username = $("#employee_username").val();
            var employee_password = $("#employee_password").val();
            var employee_password_2 = $("#employee_password_confirm").val();

            if (employee_username.length == 0 || employee_password.length == 0 || employee_password_2.length == 0)
            {
                warnings = warnings + "One or more fields are empty. <br/>";
                $("#w_info").html(warnings);
                return false;
            }

            //TO DO. Check password length based on access level
            if (employee_password != employee_password_2)
                warnings = warnings + "Passwords do not match each other. <br/>";

            if (emp_type_ar[1] == "Access-1") {
                if (employee_password.length < 4)
                    warnings = warnings + "Passwords too short Min of 4 Characters. <br/>";
            }
            else if (emp_type_ar[1] == "Access-2" || emp_type_ar[1] == "Access-3") {
                if (employee_password.length < 6) {
                    warnings = warnings + "Passwords too short Min of 6 Characters. <br/>";
                }


                var patt = new RegExp("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{5,11}$");
                var res = patt.test(employee_password);

                if (res == false)
                    warnings = warnings + "Password must contain minimum 6 characters (max 10), upper and lower case, and a number. <br/>";

            }
            else if (emp_type_ar[1] == "Access-4") {
                if (employee_password.length < 8)
                    warnings = warnings + "Passwords too short. Min of 8 Characters. <br/>";


                var strongRegex = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
                var res = patt.test(employee_password);

                if (res == false)
                    warnings = warnings + "Password must contain minimum 8 characters. At least one number, one capital letter and one special character. <br/>";
            }
        }
        else
        {
            var employee_username = $("#employee_username").val();
            var employee_password = "";
            var employee_password_2 = "";
        }

        var emp_email = $("#employee_email").val();

        //Get Manual Labour
        var ml = getManual_Labour();

        //Get Machines
        var m = getMachines();


        $("#w_info").html(warnings);

        if (warnings == "")
        {
            var employee = '{"name": "' + emp_name + '", "surname": "' + employee_surname +
                        '", "type" : "' + emp_type_ar[0] + '", "gender" : "' + emp_gender + '", "ID": "' + employee_ID +
                        '", "email" : "' + emp_email + '", "contact_number" : "' + Employee_contact_number +
                        '", "username" : "' + employee_username + '", "password" : "' + employee_password + '", "img" : "'+extract()+'"}';

            $.ajax({
                type: "PUT",
                url: "api/Employee/" + ID,
                data: { data: "{'employee' : " + employee + ", 'machines' : " + JSON.stringify(m) + ", 'manual_labour' : " + JSON.stringify(ml) + "}" },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
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
            return false;
        }
        else
            return false;
    }

    function getMachines() {
        var m = new Array();

        $('#listOfMachines :input').each(function () {
            var input = $(this); // This is the jquery object of the input, do what you will

            if (input.is(':checked')) {
                var m_ID = input.attr("id").replace('machine_', '');
                m.push(m_ID);
            }
        });

        return m;
    }

    function getManual_Labour() {
        var ml = new Array();

        $('#listOfManualLabour :input').each(function () {
            var input = $(this); // This is the jquery object of the input, do what you will

            if (input.is(':checked')) {
                var m_ID = input.attr("id").replace('manual_labour_', '');
                ml.push(m_ID);
            }
        });

        return ml;
    }

    function deleteEmployee()
    {
        alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Employee?', function () {
            $.ajax({
                type: "DELETE",
                url: "api/Employee/" + ID,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
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
        }, function () { });

        return false;
    }


    $(document).ready(function () {

        //On search
        $("#search_form").submit(function (event) {
            event.preventDefault();

            var method = $('input[name=optradio]:checked', '#search_form').val()
            var criteria = $('#search_criteria').val();
            var category = $('#search_category').val();

            $.ajax({
                type: "POST",
                url: "api/SearchEmployee",
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

                    if (result[0] == "true") {
                       
                        searchedE = JSON.parse(result[1]).employees;
                        $('#employee_search_results').empty();

                            if (searchedE.length == 0) {
                                $("#employee_search_results").append("<option value=''>No results found.</option>");
                            }
                            else {
                                

                                for (var k = 0; k < searchedE.length; k++) {
                                    var html = '<option value="' + searchedE[k].Employee_ID + '">' + searchedE[k].Name + ' ' + searchedE[k].Surname + ' - ' + searchedE[k].Contact_Number + ' - ' + searchedE[k].Email + '</option>';

                                    $("#employee_search_results").append(html);
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


        //On search results click
        $('#loadEmployeeDetails').on('click', function () {
            ID = $('#employee_search_results').val();

            if (ID == "" || ID == null)
                alertify.alert('Error', 'No Employee has been chosen!', function () { });
            else 
            $.ajax({
                type: "GET",
                url: "api/Employee/"+ID,
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg) {
                    var result = msg.split("|");

                    if (result[0] == "true") {
                        var emp_details = JSON.parse(result[1]).employees;

                        $("#div_1_2").show();

                        $("#item_ID").html("#" + ID + " ");

                        $("#employee_Name").val(emp_details[0].Name);
                        $("#employee_Surname").val(emp_details[0].Surname);
                        $("#employee_ID").val(emp_details[0].ID_Number);
                        $("#employee_no").val(emp_details[0].Contact_Number);
                        $("#employee_email").val(emp_details[0].Email);
                        $("#employee_username").val(emp_details[0].Username);

                        var value = emp_details[0].Employee_Type_ID;

                        $("#employee_type > option[value='" + value + "']").prop("selected", true);

                        value = emp_details[0].Gender_ID;
                        $('#ResultModal').modal('hide');
                        $("#employee_gender > option[value='" + value + "']").prop("selected", true);

                        if (emp_details[0].machines.length > 0) {
                            createAddMachineDiv();
                            for (var k = 0; k < emp_details[0].machines.length; k++)
                                $("#machine_" + emp_details[0].machines[k]).prop('checked', true);
                        }

                        if (emp_details[0].manual_labour.length > 0) {
                            createAddManualLabourDiv();
                            for (var k = 0; k < emp_details[0].manual_labour.length; k++)
                                $("#manual_labour_" + emp_details[0].manual_labour[k]).prop('checked', true);
                        }


                        document.getElementById('my_result').innerHTML = '<img src="images/Employees/emp_' + ID + '_image.png" alt="No emp image"/>';

                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });
        });

        //Get all the employee types.
        $.ajax({
            type: "GET",
            url: "api/EmployeeType",
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(xhr.responseText);
                alert(thrownError);
            },
            success: function (msg) {
                var result = msg.split("|");

                if (result[0] == "true") {
                    var emp_types = JSON.parse(result[1]).employee_types;

                    for (var k = 0; k < emp_types.length; k++) {
                        var type = '<option value="' + emp_types[k].Employee_Type_ID + '" data-access="' + emp_types[k].Access_Level + '">' + emp_types[k].Name + '</option>';
                        $("#employee_type").append(type);
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });

        var manual_labours;

        //Get all the manual labour
        $.ajax({
            type: "GET",
            url: "api/ManualLabour",
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(xhr.responseText);
                alert(thrownError);
            },
            success: function (msg) {
                var result = msg.split("|");

                if (result[0] == "true") {
                    manual_labours = JSON.parse(result[1]).manual_labour_types;

                    for (var k = 0; k < manual_labours.length; k++) {
                        var html = '<div class="checkbox checkboxCustom">' +
                        '<label class="labelCheck"><input type="checkbox" id="manual_labour_' + manual_labours[k].Manual_Labour_Type_ID + '" value="'
                        + k + '">' + manual_labours[k].Name + '</label>' +
                        '</div>';

                        $("#listOfManualLabour").append(html);
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });

        var machines;

        //Get all the machines
        $.ajax({
            type: "GET",
            url: "api/Machine",
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(xhr.responseText);
                alert(thrownError);
            },
            success: function (msg) {
                var result = msg.split("|");

                if (result[0] == "true") {
                    machines = JSON.parse(result[1]).machines;

                    for (var k = 0; k < machines.length; k++) {
                        var html = '<div class="checkbox checkboxCustom">' +
                        '<label class="labelCheck"><input type="checkbox" id="machine_' + machines[k].Machine_ID + '" value="' + k + '">' + machines[k].Name + '</label>' +
                        '</div>';

                        $("#listOfMachines").append(html);
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });

        $('#listOfManualLabour').on('mouseover', '.labelCheck', function () {
            var k = $(this).children(":first").val();

            

            $("#ml_name").html(manual_labours[k].Name);
            $("#ml_ID").html(manual_labours[k].ID);
            $("#ml_descr").html(manual_labours[k].Description);
        });

        $('#listOfMachines').on('mouseover', '.labelCheck', function () {
            var k = $(this).children(":first").val();

            $("#m_name").html(machines[k].Name);
            $("#m_model").html(machines[k].Model);
            $("#m_man").html(machines[k].Manufacturer);
            $("#m_ID").html(machines[k].ID);
            $("#m_no").html(machines.length);
        });
    });

</script>

</asp:Content>
