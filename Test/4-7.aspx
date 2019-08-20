<%@ Page Title="Maintain Production Schedule" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-7.aspx.cs" Inherits="Test._4_7" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<style>
	table td:nth-child(1) {
		font-weight: bold;
		width: 120px;
	}
			
	table .btn {
		vertical-align: middle;
		width: 100%;
		height: 105%;
	}
</style>
		
<script>	
    
    var searchedParts;

    function onMore(k) {
        $("#part_details_table").empty();

        var row = "<tr><td>Part:</td><td>" + searchedParts[k].Part_Serial + "</td></tr>" +
					"<tr><td>Part Type:</td><td>" + searchedParts[k].Part_Type_Name + "</td></tr>" +
					"<tr><td>Part Dimensions:</td><td>" + searchedParts[k].Part_Type_Dimension + "</td></tr>" +
	                "<tr><td>Stages:</td><td>";

        for (x = 1; x <= searchedParts[k].Stages_Count; x++) {
            for (y = 0; y < searchedParts[k].Stages[0].recipe.length; y++) {
                if (searchedParts[k].Stages[0].recipe[y].stage == x)
                    row += searchedParts[k].Stages[0].recipe[y].stage + " - Material - " + searchedParts[k].Stages[0].recipe[y].name + ", ";
            }

            for (y = 0; y < searchedParts[k].Stages[0].machines.length; y++) {
                if (searchedParts[k].Stages[0].machines[y].stage == x)
                    row += searchedParts[k].Stages[0].machines[y].stage + " - Machine - " + searchedParts[k].Stages[0].machines[y].name + ", ";
            }

            for (y = 0; y < searchedParts[k].Stages[0].manual.length; y++) {
                if (searchedParts[k].Stages[0].manual[y].stage == x)
                    row += searchedParts[k].Stages[0].manual[y].stage + " - Manual Labour - " + searchedParts[k].Stages[0].manual[y].name + ", ";
            }

            if (searchedParts[k].Stages_Count == x)
                row = row.slice(0, -2);
        }

        row += "</td></tr><tr><td>Order Type:</td><td>" + searchedParts[k].Order_Type + "</td></tr>" +
					"<tr><td>Job Card ID:</td><td>" + searchedParts[k].Job_Card_ID + "</td></tr>";

        $("#part_details_table").append(row);

        $("#Part_Details").modal('show');
        return false;
    }
			
	function listUnusedParts() {
	    //Fetches all parts that have status == raw OR status == in-production //ARMAND UPDATE THIS
	    $.ajax({
	        type: "GET",
	        url: "api/PartsRawProd",
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
	                searchedParts = JSON.parse(result[1]).parts;

	                $("#Unused_Parts_table").empty();

	                for (var k = 0; k < searchedParts.length; k++) {

	                    var row = "<tr><td>" + searchedParts[k].Part_Serial + "</td><td>" + searchedParts[k].Part_Type_Abbreviation + ' - ' + searchedParts[k].Part_Type_Name + "</td><td>" +
                            "<button class='Add_extra_things' onclick='return onMore(" + k + ")'><i class='fa fa-plus' aria-hidden='true'></i></button></td></tr>";

	                    $("#Unused_Parts_table").append(row);
	                }

	                $("#UnusedPartsModal").modal('show');
	            }
	            else {
	                alertify.alert('Error', result[1], function () { });
	            }
	        }
	    });

		return false;
	}

	var searchedML;
	var searchedMachines;
			
	jQuery(document).ready(function ($)
	{
	    //Fetches the production Schedule
	    $.ajax({
	        type: "GET",
	        url: "api/ProductionSchedule",
	        error: function (xhr, ajaxOptions, thrownError) {
	            alert(xhr.status);
	            alert(xhr.responseText);
	            alert(thrownError);
	        },
	        success: function (msg) {
	            var result = msg.split("~-~");

	            if (result[0] == "true") {
	                $("#PartTypeFieldSet").append(result[1]);
	            }
	            else {
	                alertify.alert('Error', result[1], function () { });
	            }
	        }
	    });

	    //Get all the unique machines
	    $.ajax({
	        type: "POST",
	        url: "api/SearchUniqueMachine",
	        data: { data: "{'method': 'Contains', 'criteria' : '', 'category' : 'All'}" },
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
	                searchedMachines = JSON.parse(result[1]).unique_machines;

	                $('#add_machine_id').empty();
	                $('#add_machine_id').append("<option value='Select'>Select a Machine</option>");

	                for (var k = 0; k < searchedMachines.length; k++) {
	                    var html = '<option value="' + searchedMachines[k].Unique_Machine_ID + '">' + searchedMachines[k].Name + ' - ' + searchedMachines[k].Manufacturer + ' - ' + searchedMachines[k].Model + ' - ' + searchedMachines[k].Unique_Machine_Serial + '</option>';

	                    $("#add_machine_id").append(html);
	                }
	            }
	            else {
	                alertify.alert('Error', result[1], function () { });
	            }
	        }
	    });

	    //Get all the manual labour
	    $.ajax({
	        type: "POST",
	        url: "api/SearchManualLabour",
	        data: { data: "{'method': 'Contains', 'criteria' : '', 'category' : 'All'}" },
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
	                searchedML = JSON.parse(result[1]).manual_labour_types;

	                $('#add_labour_id').empty();
	                $('#add_labour_id').append("<option value='Select'>Select a Manual Labour</option>");

	                for (var k = 0; k < searchedML.length; k++) {
	                    var html = '<option value="' + searchedML[k].Manual_Labour_Type_ID + '">' + searchedML[k].Name + '</option>';

	                    $("#add_labour_id").append(html);
	                }
	            }
	            else { alertify.alert('Error', result[1]); }
	        }
	    });


	});

	function addTask()
	{
	    $("#AddTaskModal").modal('show');
	    return false;
	}
</script>

<h1 class="default-form-header">View Production Schedule</h1>
		
<form id="UC4-8" class="form-horizontal">
	<fieldset id="PartTypeFieldSet">
		<legend>Production Schedule:</legend>

	</fieldset>
			
	<br/>

    <div class="row">
		<div class="col-sm-4">
			<button onclick="return addTask()" class="form-custom-button-columns"><i class="fa fa-plus" aria-hidden="true"></i> Add Task to Production Schedule</button>
		</div>	
		<div class="col-sm-4">
			<button type="submit" class="form-custom-button-columns"><i class="fa fa-wrench" aria-hidden="true"></i> Update Production Schedule</button>
		</div>	
		<div class="col-sm-4">
			<button onclick="return listUnusedParts()" class="form-custom-button-columns"><i class="fa fa-list" aria-hidden="true"></i> List of Schedulable Parts</button>
		</div>	
    </div>
</form>
		
<!-- MODAL CODE -->
		
<div class="modal fade" id="UnusedPartsModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">List of Unused Parts</h4>
		</div>
		<div class="modal-body">
			<table class="table table-hover" style="background-color:white; color: #333">
				<thead>
                    <tr>
                        <th>Part</th>
					    <th>Part Type</th>
                        <th>Show More</th>
                    </tr>
				</thead>
				<tbody id="Unused_Parts_table">
				</tbody>
			</table>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
<div class="modal fade" id="Part_Details">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">Part Details</h4>
		</div>
		<div class="modal-body">
			<table class="table" style="color: white">
				<tbody id="part_details_table">
					<tr><td>Part:</td><td>XXX333</td></tr>
					<tr><td>Part Type:</td><td>VSE Pump</td></tr>
					<tr><td>Part Dimensions:</td><td>80x60x50mm d</td></tr>
					<tr><td>Stages Left:</td><td>2 - XX-99<br/>3 - Welding<br/>4 - XX-79<br/></td></tr>
					<tr><td>Order Type:</td><td>Client</td></tr>
					<tr><td>Job Card ID:</td><td>#123</td></tr>
				</tbody>
			</table>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal --> 

<style>
	#AddTaskModal > div
	{
		width: 70%;
		height: 92%;
		padding: 0;
	}
</style>
<div class="modal fade" id="AddTaskModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">Add Task to Schedule</h4>
		</div>
		<div class="modal-body">
			<form id="search_part_form">
			<fieldset>
				<legend style="color:white;">Search for Part</legend>
				<div class="row">
					<div class="col-sm-4">
						<label for="search_for_part_criteria" class="control-label">Criteria: </label>
						<input type="text" class="form-control" id="search_for_part_criteria" placeholder="Criteria"/>
					</div>					
					<div class="col-sm-4">
						<label for="narrow_by">Search By: </label>
						<select class="form-control" id="narrow_by_part">
							<option value="All">All</option>
                            <option value="Serial">Serial No.</option>
					        <option value="Name">Part Type Name</option>
					        <option value="Abb">Part Type Abbreviation</option>
                            <option value="Job Card ID">Job Card ID</option>
						</select>
					</div>
					<div class="col-sm-4">
						<label class="control-label">Search method: </label><br/>
						<label class="radio-inline"><input type="radio" value="Exact" name="optradio">Exact</label>
						<label class="radio-inline"><input type="radio" value="Contains" name="optradio">Contains</label>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-8">
						
					</div>					
					<div class="col-sm-4">
						<br/>
						<button type ="button" class ="modalSearchButton" onclick="return searchPart()"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
					</div>
				</div>
			</fieldset>
            </form>
			<br/>

            <script>
                var searchedParts2;

                function searchPart()
                {
                    var filter_text = $("#search_for_part_criteria").val();
                    var filter_category = $("#narrow_by_part").val();
                    var method = $('input[name=optradio]:checked', '#search_part_form').val();

                    //console.log(filter_category + " " + filter_text + " " + method);

                    $.ajax({
                        type: "POST",
                        url: "api/SearchPart",
                        data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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
                                searchedParts2 = JSON.parse(result[1]).parts;

                                $("#partItems").empty();

                                for (var k = 0; k < searchedParts2.length; k++)
                                {
                                    
                                    var row = "<tr>"+
						                        "<td><button type='button' class='addToList' onclick='choosePartForTask(" + searchedParts2[k].Part_ID + ", " + searchedParts2[k].Part_Stage + ")'><i class='fa fa-plus' aria-hidden='true'> " + searchedParts2[k].Part_Serial + "</button></td>" +
						                        "<td>"+searchedParts2[k].Part_Type_Name+"</td>"+
						                        "<td>"+searchedParts2[k].Date_Added+"</td>"+
						                        "<td>"+"N/A"+"</td>"+
						                        "<td>" + searchedParts2[k].Part_Stage + "</td>" +
						                        "<td>"+"N/A"+"</td>"+
						                        "<td>" + "N/A" + "</td>" +
					                        "</tr>";



                                    $("#partItems").append(row);
                                }

                            }
                            else {
                                alertify.alert('Error', result[1], function () { });
                            }
                        }
                    });

                    return false;
                }

                function choosePartForTask(p_ID, stage)
                {
                    $("#newtask_form").show();
                    $("#chosen_part_ID").val(p_ID);
                    $("#add_part_stage_manual").val(stage + 1);
                    $("#add_part_stage_machine").val(stage + 1);

                }

            </script>
            
            <fieldset>
                <legend style="color: white">Results:</legend>
                <label for="narrow_by">Order By: </label>
				<select class="form-control" id="order_by">
                    <option value="Select">Select an Option</option>
					<option value="JC_ID">Job Card ID</option>
					<option value="Part_ID">Part ID</option>
					<option value="Part_Type_Name">Part Type Name</option>
					<option value="Date_Added">Part Date added</option>
				</select>

                <div  class="table-responsive makeDivScrollable">
			    <table class="table" style="color:white;">
				<thead>
					<tr>
						<th>Part Serial No</th>
						<th>Part Type Name</th>
						<th>Date Added</th>
						<th>Job Card ID</th>
						<th>Current Stage</th>
						<th>Resouce Needed</th>
						<th>Has dependencies</th>
					</tr>
				</thead>
				<tbody id="partItems">
					
				</tbody>
			</table>
			</div>

            </fieldset>
			
			<br />
            <form id="newtask_form" style="display: none"> 
            <fieldset>
                <legend style="color: white">New Task Info</legend>
                <div class="row">
				<div class="col-sm-4">
					<label  for="chosen_part_ID" class="control-label">Chosen Part Serial No: </label>
					<input type="text" class="form-control" id="chosen_part_ID" placeholder="AAA-000" disabled/>
				</div>					
				<div class="col-sm-8">
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<label for="add_task_type" class="control-label">Task Type: </label>
					<select class="form-control" id="add_task_type">
						<option>Choose a Type</option>
						<option value="machine">Machine</option>
						<option value="manual">Manual Labour</option>
					</select>
                    <script>
                        var type = "";

                        $("#add_task_type").on("change", function () {
                            type = $(this).val();

                            if (type == "machine")
                            {
                                $("#machineTask").show();
                                $("#manualTask").hide();
                            }
                            else if (type == "manual")
                            {
                                $("#machineTask").hide();
                                $("#manualTask").show();
                            }

                        });

                    </script>
				</div>
			</div>
			<div id="machineTask" style="display: none">
				<div class="row">
					<div class="col-sm-4">
						<label for="add_machine_id" class="control-label">Machine Serial No: </label>
						<select class="form-control" id="add_machine_id">
							<option>XX89</option>
							<option>XX99</option>
						</select>
					</div>
					<div class="col-sm-4">
						<label for="employee_name_id" class="control-label">Employee: </label>
						<select class="form-control" id="employee_name_id_machine">
						</select>
					</div>
					<div class="col-sm-2">
						<label for="add_part_stage" class="control-label">Part Stage: </label>
						<input type="number" class="form-control" id="add_part_stage_machine" value="0" min="0">
					</div>
					<div class="col-sm-2">
						<label for="add_part_start_time" class="control-label">Start Time: </label>
						<input type="time" class="form-control" id="add_part_start_time_machine" value="08:00:00" min="08:00:00" max="17:00:00">
					</div>
				</div>
			</div>	
			<div id="manualTask" style="display: none">
				<div class="row">
					<div class="col-sm-4">
						<label for="add_labour_id" class="control-label">Manual Labour Type: </label>
						<select class="form-control" id="add_labour_id">
							<option>Welding</option>
							<option>Sand Blasting</option>
						</select>
					</div>
					<div class="col-sm-4">
						<label for="employee_name_id" class="control-label">Employee: </label>
						<select class="form-control" id="employee_name_id_manual">
						</select>
					</div>
					<div class="col-sm-2">
						<label for="add_part_stage" class="control-label">Part Stage: </label>
						<input type="number" class="form-control" id="add_part_stage_manual" value="0">
					</div>
					<div class="col-sm-2">
						<label for="add_part_start_time" class="control-label">Start Time: </label>
						<input type="time" class="form-control" id="add_part_start_time_manual" value="08:00:00" min="08:00:00" max="17:00:00">
					</div>
				</div>
			</div>

            <div class="row">
	            <div class="col-sm-12">
                    <div class="Warning_Info" id="w_info"></div>
	            </div>
	        </div>        


            </fieldset>
			
			</form>			
		</div>
			
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal">Close</button>
			<button type="button" class="btn btn-secondary modalbutton" id="taskButton" onclick="return addNewTask()">Add Task to Schedule</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->

    <script>
        function addNewTask()
        {
            var p_ID = $("#chosen_part_ID").val();
            var new_task = {};
            var warnings = "";

            if (type == "machine")
            {
                var um_ID = $("#add_machine_id").val();
                var emp_ID = $("#employee_name_id_machine").val();
                var stage = $("#add_part_stage_machine").val();
                var time = $("#add_part_start_time_machine").val();

                if (stage < 0)
                {
                    warnings += "Stage must be more than 0. <br/>";
                    $("#add_part_stage_machine").addClass("empty");
                }
                    

                if (stage.trim().length == 0)
                {
                    warnings += "Stage has no value. <br/>";
                    $("#add_part_stage_machine").addClass("empty");
                }

                if(emp_ID == "Select")
                {
                    warnings += "No employee has been chosen. <br/>";
                    $("#employee_name_id_machine").addClass("empty");
                }

                if (um_ID == "Select") {
                    warnings += "No Machine has been chosen. <br/>";
                    $("#add_machine_id").addClass("empty");
                }

                if(time.trim().length == 0)
                {
                    warnings += "Please specify a start time. <br/>";
                    $("#add_part_start_time_machine").addClass("empty");
                }

                
                var patt = new RegExp("(?:[01]\d|2[0123]):(?:[012345]\d):(?:[012345]\d)");
                var res = patt.test(time);

                if (res == false)
                {
                    warnings += "Please enter a valid time. <br/>";
                    $("#add_part_start_time_machine").addClass("empty");
                }

                new_task = { Part_ID: p_ID, Start_Time: time, Resouce_ID: um_ID, Employee_ID: emp_ID, Stage: stage };
                    

            }
            else if (type == "manual")
            {
                var um_ID = $("#add_manual_id").val();
                var emp_ID = $("#employee_name_id_manual").val();
                var stage = $("#add_part_stage_manual").val();
                var time = $("#add_part_start_time_manual").val();

                if (stage < 0) {
                    warnings += "Stage must be more than 0. <br/>";
                    $("#add_part_stage_manual").addClass("empty");
                }


                if (stage.trim().length == 0) {
                    warnings += "Stage has no value. <br/>";
                    $("#add_part_stage_manual").addClass("empty");
                }

                if (emp_ID == "Select") {
                    warnings += "No employee has been chosen. <br/>";
                    $("#employee_name_id_manual").addClass("empty");
                }

                if (um_ID == "Select") {
                    warnings += "No Manual Labour has been chosen. <br/>";
                    $("#add_manual_id").addClass("empty");
                }

                if (time.trim().length == 0) {
                    warnings += "Please specify a start time. <br/>";
                    $("#add_part_start_time_manual").addClass("empty");
                }


                var patt = new RegExp("/^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/i");
                var res = patt.test(time);

                if (res == false) {
                    warnings += "Please enter a valid time. <br/>";
                    $("#add_part_start_time_manual").addClass("empty");
                }

                new_task = { Part_ID: p_ID, Start_Time: time, Resouce_ID: um_ID, Employee_ID: emp_ID, Stage: stage };
            }

            $("#w_info").html(warnings);
            if (warnings == "")
            {
                /*$.ajax({
                    type: "Post",
                    url: "",
                    data: {},
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
                            alertify.alert('Successful', result[1]);
                        }
                        else {
                            alertify.alert('Error', result[1], function () { });
                        }
                    }
                });*/
                return false;
            }
            else
                return false;
        }

        function removeTask(t_ID)
        {
            /*$.ajax({
                    type: "Post",
                    url: "",
                    data: {},
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
                            alertify.alert('Successful', result[1]);
                        }
                        else {
                            alertify.alert('Error', result[1], function () { });
                        }
                    }
                });*/
            return false;
        }

        $(document).ready(function () {

            var employees;

            //Get all the employees
            $.ajax({
                type: "POST",
                url: "api/SearchEmployee",
                data: { data: "{'method': 'PS', 'criteria' : '', 'category' : 'All'}" },
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

                        employees = JSON.parse(result[1]).employees;
                        //console.log(employees);
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });


            $("#add_labour_id").on("change", function () {
                var ml_ID = $(this).val();

                $("#employee_name_id_manual").empty();
                $("#employee_name_id_manual").append("<option value='Select'>Select an Employee</option>");

                for (var k = 0; k < employees.length; k++)
                {

                    for(var i = 0; i < employees[k].manual_labour.length; i++)
                        if (ml_ID == employees[k].manual_labour[i])
                        {
                            var option = '<option value="' + employees[k].Employee_ID + '">' + employees[k].Name + ' ' + employees[k].Surname + '</option>';
                            
                            $("#employee_name_id_manual").append(option);
                        }
                }

            });

            $("#add_machine_id").on("change", function () {
                //Get machine ID
                var m_ID = 0;
                var um_ID = $(this).val();

                $("#employee_name_id_machine").empty();
                $("#employee_name_id_machine").append("<option value='Select'>Select an Employee</option>");

                for (var k = 0; k < searchedMachines.length; k++)
                    if (um_ID == searchedMachines[k].Unique_Machine_ID)
                    {
                        m_ID = searchedMachines[k].Machine_ID;
                        console.log(m_ID);
                    }
                        

                

                for (var k = 0; k < employees.length; k++) {

                    for (var i = 0; i < employees[k].machines.length; i++)
                        if (m_ID == employees[k].machines[i]) {
                            var option = '<option value="' + employees[k].Employee_ID + '">' + employees[k].Name + ' ' + employees[k].Surname + '</option>';

                            $("#employee_name_id_machine").append(option);
                        }
                }

            });


        });

    </script>

</asp:Content>
