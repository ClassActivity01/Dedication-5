<%@ Page Title="Add New Employee" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="1-1.aspx.cs" Inherits="Test._1_1" %>
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
			
		h3
		{
			font-size: 14pt;
			font-weight: bold;
		}
	</style>

<h1 class="default-form-header">Add New Employee </h1>
<!-- FORM CODE -->
		
<form id="UC1-1" class="form-horizontal">
	<ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#employee" title ="Click to select the employee tab">Employee</a></li>
        <li><a data-toggle="tab" href="#machines" title ="Click to select the machine tab">Machines</a></li>
        <li><a data-toggle="tab" href="#manual" title ="Click to select the manual labour type tab">Manual Labour</a></li>
        <li><a data-toggle="tab" href="#photo" title ="Click to select the employee photo tab" >Employee Photo</a></li>
    </ul>
    <br />

    <div class="tab-content">
    <div id="employee" class="tab-pane fade in active">
    <fieldset>
		<legend>General Employee Information:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="employee_Name" class="control-label">Employee Name: </label>
				<input type="text" class="form-control" id="employee_Name" placeholder="Jane" maxlength="35" title ="Enter the employee's name" data-toggle ="tooltip" />
			</div>
			<div class="col-sm-6">
				<label for="employee_Surname" class="control-label">Employee Surname: </label>
				<input type="text" class="form-control" id="employee_Surname" placeholder="Doe" maxlength="35" title ="Enter the employee's surnname" data-toggle ="tooltip" data-placement="left" />
			</div>	
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label for="employee_ID" class="control-label">ID Number: </label>
				<input type="text" class="form-control" id="employee_ID" placeholder="0000000000000" maxlength="13" title ="Enter the employee's ID number" data-toggle ="tooltip"/>
			</div>
			<div class="col-sm-4">
				<label for="employee_no" class="control-label">Contact Number: </label>
				<input type="text" class="form-control" id="employee_no" placeholder="0000000000" maxlength="15" title ="Enter the employee's contact number" data-toggle ="tooltip" data-placement="left" />
			</div>
			<div class="col-sm-2">
				<label for="employee_gender">Gender: </label>
				<select class="form-control" id="employee_gender" title ="Select the employee's gender from the following options" data-toggle ="tooltip" data-placement="bottom">
                    <option value="Choose">Choose</option>
					<option value="M">Male</option>
					<option value="F">Female</option>
                    <option value="O">Other</option>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="employee_email" class="control-label">Email: </label>
				<input type="email" class="form-control" id="employee_email" placeholder="email@email.com" title ="Enter the employee's email address" data-toggle ="tooltip" data-placement="bottom"/>
			</div>
			<div class="col-sm-4">
				<label for="employee_type">Employee Category: </label>
				<select class="form-control" id="employee_type" title ="Select the employee category from the following options" data-toggle ="tooltip" data-placement="bottom">
					<option value="Choose">Choose an Option </option>
				</select>
			</div>
			<div class="col-sm-4">
				<br/>
				<a class="Add_extra_things_link" href="#"><i class="fa fa-plus" aria-hidden="true"></i> Add New Employee Category</a>
			</div>
		</div>
	</fieldset>	
	<br />
		
	<fieldset>
		<legend>Login Details:</legend>
		<div class="row">
			<div class="col-sm-7">
				<label for="employee_username" class="control-label">Username: </label>
				<input type="text" class="form-control" id="employee_username" maxlength="20" title ="Please enter your username details" data-toggle ="tooltip" data-placement="right"/>
						
				<label for="employee_password" class="control-label">Password: </label>
				<input type="password" class="form-control" id="employee_password" title ="Please enter a password" data-toggle ="tooltip" data-placement="right"/>
						
				<label for="employee_password_confirm" class="control-label">Confirm Password: </label>
				<input type="password" class="form-control" id="employee_password_confirm" title ="Please re-enter the same password" data-toggle ="tooltip" data-placement="right"/>
			</div>
			<div class="col-sm-5">
			</div>
		</div>
	</fieldset>

    <div class="row">
		<div class="col-sm-8">

		</div>	
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" id="submitEmployeeInformation" title ="Click here to add a new employee" data-toggle ="tooltip" ><i class="fa fa-check" aria-hidden="true"></i>Add New Employee</button>
		</div>
	</div>

	</div>
			
	<div id="machines" class="tab-pane fade">
    <fieldset id="machinefieldset">
		<legend>Assign Employee to Machines</legend>
		<div class="row">
					
			<div class="col-sm-3">
				<h3>Select Machines: </h3>
				<div class="scrollableDiv" id="listOfMachines" title ="Click to select the machine">
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
				<div class="scrollableDiv" id="listOfManualLabour" title ="Click to select the manual labour type" >
				</div>
			</div>
			<div class="col-sm-8">
				<h3>Manual Labour Information: </h3>
				<div class="displayInformationDiv scrollableDiv">
					<p>
						<span class="infoheader">Name:</span> <span id="ml_name"></span> <br/>
						<span class="infoheader">No:</span> <span id="ml_ID"></span>  <br/>
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
            <div class="col-md-6"><div id="my_camera" style="width:320px; height:240px;" title ="Don't forget to smile" data-toggle ="tooltip" data-placement ="right"></div></div>
            <div class="col-md-6"><div id="my_result"></div></div>

        </div>


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

        <br />

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

<script>
    var manual_labours;
    var image = "";

    function extract() {
        var s = "";

        if (image != "") {
            var i = image.indexOf(',');
            s = image.substr(i + 1, image.length - i);
            console.log(s);

        }

        return s;
    }

    $(document).ready(function ()
    {
        $("#UC1-1").submit(function (e)
        {
            e.preventDefault();

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

            if (emp_type == "Choose")
            {
                warnings = warnings + "No category chosen for employee type. <br/>";
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

            if (employee_ID.length < 13) {
                warnings = warnings + "ID number not 13 characters. <br/>";
                $("#employee_ID").addClass("empty");
            }

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
            var employee_username = $("#employee_username").val();
            var employee_password = $("#employee_password").val();
            var employee_password_2 = $("#employee_password_confirm").val();
            var emp_email = $("#employee_email").val();


            var res = only_nums_pattern.test(Employee_contact_number);
            if (res == false) {
                warnings = warnings + "Contact number may only contain numeric characters. <br/>";
                $("#employee_no").addClass("empty");
            }

            if (Employee_contact_number.length < 10)
            {
                warnings = warnings + "Contact number is not correct. Invalid Length <br/>";
                $("#employee_no").addClass("empty");
            }

            //TO DO. Check password length based on access level
            if(employee_password != employee_password_2)
                warnings = warnings + "Passwords do not match each other. <br/>";

            var emp_type_ar = $("#employee_type").children(":selected").data("access");

            if (emp_type_ar == "1")
            {
                if (employee_password.length < 4)
                    warnings = warnings + "Passwords too short Min of 4 Characters. <br/>";
            }
            else if (emp_type_ar == "2" || emp_type_ar == "3")
            {
                if (employee_password.length < 6)
                {
                    warnings = warnings + "Passwords too short. Min of 6 Characters. <br/>";
                }

                
                var patt = new RegExp("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{5,11}$");
                var res = patt.test(employee_password);

                if(res == false)
                    warnings = warnings + "Password must contain minimum 6 characters (max 10), upper and lower case, and a number. <br/>";
                    
            }
            else if (emp_type_ar == "4") {
                if (employee_password.length < 8)
                    warnings = warnings + "Passwords too short Min of 8 Characters. <br/>";


                var strongRegex = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
                var res = strongRegex.test(employee_password);

                if (res == false)
                    warnings = warnings + "Password must contain minimum 8 characters. At least one number, one capital letter and one special character. <br/>";

            }

            //Get Manual Labour
            var ml = getManual_Labour();

            //Get Machines
            var m = getMachines();

            //Make JSON String
            var employee = '{"name": "' + emp_name + '", "surname": "' + employee_surname +
                            '", "type" : ' + emp_type + ', "gender" : "' + emp_gender + '", "ID": "' + employee_ID +
                            '", "email" : "' + emp_email + '", "contact_number" : "' + Employee_contact_number +
                            '", "username" : "' + employee_username + '", "password" : "' + employee_password + '", "image" : "'+extract()+'"}';

            $("#w_info").html(warnings);

            if (warnings == "")
            {
                $.ajax({
                    type: "POST",
                    url: "api/Employee",
                    contentType: "application/json",
                    dataType: "json",
                    data: { data: JSON.stringify({ emp: JSON.parse(employee), machines: m, manual_labour: ml }) },
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
        });

        //Get all machines
        function getMachines()
        {
            var m = new Array();

            $('#listOfMachines :input').each(function () {
                var input = $(this); // This is the jquery object of the input, do what you will

                if (input.is(':checked')) {
                    var m_ID = parseInt(input.attr("id").replace('machine_', ''));
                    m.push(m_ID);
                }
            });

            return m;
        }

        //Get all the manual labour
        function getManual_Labour()
        {
            var ml = new Array();

            $('#listOfManualLabour :input').each(function () {
                var input = $(this); // This is the jquery object of the input, do what you will

                if (input.is(':checked')) 
                {
                    var m_ID = parseInt(input.attr("id").replace('manual_labour_', ''));
                    ml.push(m_ID);
                }
            });
       
            return ml;
        }

        //Get all the employee types.
        $.ajax({
            type: "GET",
            url: "api/EmployeeType",
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(xhr.responseText);
                alert(thrownError);
            },
            success: function (msg)
            {
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

        //Get all the manual labour
        $.ajax({
            type: "GET",
            url: "api/ManualLabour",
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(xhr.responseText);
                alert(thrownError);
            },
            success: function (msg)
            {
                var result = msg.split("|");

                if (result[0] == "true") {
                    manual_labour_types = JSON.parse(result[1]).manual_labour_types;

                    for (var k = 0; k < manual_labour_types.length; k++) {
                        var html = '<div class="checkbox checkboxCustom">' +
                        '<label class="labelCheck"><input type="checkbox" id="manual_labour_' + manual_labour_types[k].Manual_Labour_Type_ID + '" value="'
                        + k + '">' + manual_labour_types[k].Name + '</label>' +
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
            $("#ml_name").html(manual_labour_types[k].Name);
            $("#ml_ID").html(manual_labour_types[k].Manual_Labour_Type_ID);
            $("#ml_descr").html(manual_labour_types[k].Description);
        });

        $('#listOfMachines').on('mouseover', '.labelCheck', function () {
            var k = $(this).children(":first").val();
            $("#m_name").html(machines[k].Name);
            $("#m_model").html(machines[k].Model);
            $("#m_man").html(machines[k].Manufacturer);
            $("#m_ID").html(machines[k].Machine_ID);
            $("#m_no").html(machines.length);
        });
    });
</script>

</asp:Content>
