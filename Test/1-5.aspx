<%@ Page Title="Search Employees" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="1-5.aspx.cs" Inherits="Test._1_5" %>
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
<h1 class="default-form-header">Search Employees</h1>
		
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Employee: </legend>
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the employee's details to search by" data-toggle ="tooltip" data-placement ="bottom"/>
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select what to search the employee by" data-toggle ="tooltip" data-placement="bottom">
                        <option value="All">All</option>
						<option value="Name">Name</option>
						<option value="Surname">Surname</option>
						<option value="Email">Email</option>
						<option value="IDNumber">ID Number</option>
						<option value="ContactNumber">Contact Number</option>
					</select>
				</div>	
			</div>
            <div class="row">
				<div class="col-sm-6">
					<label for="optradio">Search Method: </label>
					<div class="radio">
						<label title ="Select a search method" data-toggle ="tooltip" data-placement="right" ><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					</div>
					<div class="radio">
						<label title ="Select a search method" data-toggle ="tooltip" data-placement="right"><input type="radio" value="Contains" name="optradio">Contains</label>
					</div>
				</div>
			</div>
			
		</fieldset>
		<div class="row">
			<div class="col-sm-4">
				<button id="submitSearch" onclick=" return Search()" class ="searchButton" title ="Click here to search for the employee" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-4">
			</div>
			<div class="col-sm-4">
				<button id="clearSearch" onclick="return clearCriteria()" class ="searchButton" title ="Click here to clear the search details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>

<br />
<div id="results_Div">	
    <form id="filterby">
	    <fieldset>
		    <legend>Search Results: </legend>
		    <div class="row">
			    <div class="col-sm-4">
				    <label for="order_by">Order By: </label>
				    <select class="form-control" id="order_by" title ="Select how to sort the employee's details" data-toggle ="tooltip" data-placement ="right">
                        <option value="Select">Select an Option</option>
					    <option value="Name">Name</option>
					    <option value="Surname">Surname</option>
					    <option value="Email">Email</option>
					    <option value="ID_Number">ID Number</option>
					    <option value="Employee_Category_Name">Employee Category</option>
				    </select>
			    </div>
		    </div>
	    </fieldset>	
    </form>
    <h1>Results:</h1>
    <div class="table-responsive makeDivScrollable_search results" title ="Select to view the employee's details">
	    <table class="sortable table table-hover">
		    <thead>
			    <tr>
				    <th>Name</th>
				    <th>Surname</th>
				    <th>ID Number</th>
				    <th>Employee Category</th>
				    <th>Email</th>
				    <th>Contact Number</th>
                    <th>More</th>
			    </tr>
		    </thead>
		    <tbody id="employee_results">
		    </tbody>
	    </table>
    </div> 
</div>

<!-- MODAL CODE -->
		
<div class="modal fade" id="Emp_DetailsModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">Employee Details for <span id="emp_name"></span></h4>
		</div>
		<div class="modal-body" id="modal_body_emp">
			
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal">Close</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
    var searchResults;

    function clearCriteria()
    {
        $('#search_criteria_1').val("");
        $("#employee_results").empty();
        $("#search_category_1 > option[value='Choose']").prop("selected", true);

        return false;
    }

    function Search() {
        var criteria1 = $('#search_criteria_1').val();

        var cat_1 = $('#search_category_1').val();

        var method = $('input[name=optradio]:checked', '#search_form').val();

        var send_data = "{'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "', 'method' : '" + method +"'}";

        $.ajax({
            type: "POST",
            url: "api/SearchEmployee",
            data: { data: send_data },
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status);
                console.log(xhr.responseText);
                console.log(thrownError);
            },
            success: function (msg) {
                var result = msg.split("|");
                //alert(result[1]);
                if (result[0] == "true") {
                    searchResults = JSON.parse(result[1]).employees;

                    if (searchResults.length == 0)
                        alertify.alert('Error', "No results found.", function () { });

                    $("#results_Div").show();
                    $("#employee_results").empty();

                    for (var k = 0; k < searchResults.length; k++) {
                        var row = '<tr>' +
                            '<td>' + searchResults[k].Name + '</td>' +
                            '<td>' + searchResults[k].Surname + '</td>' +
                            '<td>' + searchResults[k].ID_Number + '</td>' +
                            '<td>' + searchResults[k].Employee_Category_Name + '</td>' +
                            '<td>' + searchResults[k].Email + '</td>' +
                            '<td>' + searchResults[k].Contact_Number + '</td>' +
                            '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                            '</tr>';

                        $("#employee_results").append(row);
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });

        return false;
    }

    function showMoreDetails(k)
    {
        var msg = '<table>' +
				'<tbody><tr><td>Manual Labour: <td/></tr>';
         
        for (var i = 0; i < searchResults[k].manual_labour.length; i++)
            msg = msg + '<tr><td style="color: #333">____</td><td>' + searchResults[k].manual_labour[i] + '</td></tr>';

        msg = msg + '<tr><td>Machines: <td/></tr>';

        for (var i = 0; i < searchResults[k].machines.length; i++)
            msg = msg + '<tr><td style="color: #333">____</td><td>' + searchResults[k].machines[i] + '</td></tr>';

        msg += '</tbody>' +
		'</table><br/>' +
        '<img class="img-responsive" style="margin: 0 auto" src="images/Employees/emp_' + searchResults[k].Employee_ID + '_image.png" alt="No Employee image found" />';

        $("#emp_name").html(searchResults[k].Name + " " + searchResults[k].Surname);
        $("#modal_body_emp").html(msg);
        $("#Emp_DetailsModal").modal('show');
    }

$(document).ready(function ()
{
    $('#order_by').on('change', function ()
    {
        var prop = $('#order_by').val();

        searchResults.sort(predicatBy(prop));

        $("#employee_results").empty();

        for (var k = 0; k < searchResults.length; k++) {
            var row = '<tr>' +
                             '<td>' + searchResults[k].Name + '</td>' +
                             '<td>' + searchResults[k].Surname + '</td>' +
                             '<td>' + searchResults[k].ID_Number + '</td>' +
                             '<td>' + searchResults[k].Employee_Category_Name + '</td>' +
                             '<td>' + searchResults[k].Email + '</td>' +
                             '<td>' + searchResults[k].Contact_Number + '</td>' +
                             '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                             '</tr>';

            $("#employee_results").append(row);
        }
    });

    function predicatBy(prop) {
        return function (a, b) {
            if (a[prop] > b[prop]) {
                return 1;
            } else if (a[prop] < b[prop]) {
                return -1;
            }
            return 0;
        }
    }
});

</script>
</asp:Content>
