<%@ Page Title="Search Customers" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="2-3.aspx.cs" Inherits="Test._2_3" %>
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

<h1 class="default-form-header">Search Customers</h1>	
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Customer: </legend>
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the customer details to search by" data-toggle ="tooltip" data-placement ="bottom">
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select what to search the customer by" data-toggle ="tooltip" data-placement="bottom">
						<option value="All">All</option>
					    <option value="Name">Name</option>
					    <option value="Vat">Vat Number</option>
					    <option value="Account">Account Number</option>
					    <option value="ID">Customer No.</option>
					</select>
				</div>	
			</div>
			<div class="row">
				<div class="col-sm-6">
					<label>Search Method:</label>
					<div class="radio">
						<label title ="Select a search method" data-toggle ="tooltip" data-placement="right"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					</div>
					<div class="radio">
						<label title ="Select a search method" data-toggle ="tooltip" data-placement="right"><input type="radio" value="Contains" name="optradio">Contains</label>
					</div>
				</div>
				<div class="col-sm-6">
				</div>	
			</div>
		</fieldset>
		<div class="row">
			<div class="col-sm-4">
				<button id="submitSearch" onclick=" return Search()" class ="searchButton" title ="Click here to search for the customer" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-offset-4 col-sm-4">
				<button id="clearSearch" onclick="return clearCriteria()" class ="searchButton" title ="Click here to clear the search details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>
		
<!-- MODAL CODE -->
		
<div class="modal fade" id="ClientDetailsModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">Customer Contact Details and Part Discounts for <span id="c_name"></span></h4>
		</div>
		<div class="modal-body">
			<h4 class="modalSecondTitle">Contact Details</h4>
			<div id="contact_detail"></div>
			<br/>
			<h4 class="modalSecondTitle">Part Discounts</h4>
			<div id="part_type_details"></div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal">Close</button>
			<button type="button" class="btn btn-secondary modalbutton">Maintain this Customer</button>
			</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
<!-- MODAL CODE -->
		
<br/>

<div id="results_Div">	
    <form id="filterby">
	    <fieldset>
		    <legend>Search Results: </legend>
		    <div class="row">
			    <div class="col-sm-4">
				    <label for="order_by">Order By: </label>
				    <select class="form-control" id="order_by" title ="Select how to sort the customers details" data-toggle ="tooltip" data-placement ="right">
                        <option value="Select">Select an option</option>
					    <option value="Name">Name</option>
					    <option value="Account_Name">Account Number</option>
					    <option value="Vat_Number">Vat Number</option>
                        <option value="Address">Address</option>
					    <option value="Overdue_Payment">Overdue Payment</option>
				    </select>
			    </div>
		    </div>
            <br />

            <div class="table-responsive makeDivScrollable_search results" title ="Select to view the customers details">
	            <table class="sortable table table-hover">
		            <thead>
			            <tr>
                            <th>Customer No.</th>
					        <th>Name</th>
					        <th>Account Number</th>
					        <th>Vat Number</th>
					        <th>Status</th>
					        <th>Address</th>
					        <th>Overdue Payments</th>
                            <th>More Info</th>
				        </tr>
		            </thead>
		            <tbody id="client_results">
					
		            </tbody>
	            </table>
             </div> 
	    </fieldset>	
    </form>
    
		
    <br/>

</div>
<script>
    var searchResults;

    function clearCriteria()
    {
        $('#search_criteria_1').val("");
        $("#search_category_1 > option[value='Choose']").prop("selected", true);
        $("#client_results").empty();
        return false;
    }

    function Search() {
        var criteria1 = $('#search_criteria_1').val();

        var cat_1 = $('#search_category_1').val();

        var method = $('input[name=optradio]:checked', '#search_form').val();

        var send_data = "{'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "', 'method' : '" + method +"'}";

        $.ajax({
            type: "POST",
            url: "api/SearchCustomer",
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

                if (result[0] == "true") {
                    searchResults = JSON.parse(result[1]).clients;

                    $("#searchDiv").hide();
                    $("#results_Div").show();
                    $("#client_results").empty();

                    if (searchResults.length == 0)
                        alertify.alert('Error', "No results found.", function () { });

                    else
                    for (var k = 0; k < searchResults.length; k++) {
                        var client_status;

                        if (searchResults[k].Client_Status == true)
                            client_status = "Active";
                        else
                            client_status = "In-Active";

                        var row = '<tr>' +
                            '<td>' + searchResults[k].Client_ID + '</td>' +
                            '<td>' + searchResults[k].Name + '</td>' +
                            '<td>' + searchResults[k].Account_Name + '</td>' +
                            '<td>' + searchResults[k].Vat_Number + '</td>' +
                            '<td>' + client_status + '</td>' +
                            '<td>' + searchResults[k].Address + ', ' + searchResults[k].City + ', ' + searchResults[k].Zip + '</td>' +
                            '<td>R ' + searchResults[k].Overdue_Payment + '</td>' +
                            '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                            '</tr>';

                        $("#client_results").append(row);
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
        var table = '<table class="table" style="color: white"><thead><tr><th>Contact Name</th><th>Number</th><th>Email</th></tr></thead><tbody>';

        for (var p = 0; p < searchResults[k].contact_details.length; p++)
        {
            table = table + '<tr>' +
						'<td>' + searchResults[k].contact_details[p].Name + '</td>' +
						'<td>' + searchResults[k].contact_details[p].Number + '</td>' +
						'<td>' + searchResults[k].contact_details[p].Email_Address + '</td></tr>';
        }

        table = table + '</tbody></table>';
				
        $("#contact_detail").html(table);
        $("#c_name").html(searchResults[k].Name + "(" + searchResults[k].Client_ID + ")");
        
        
        table = '<table class="table" style="color: white"><thead><tr><th>Part Type Abbreviation</th><th>Part Type Name</th><th>Discount</th></tr></thead><tbody>'
	    	
        for (var p = 0; p < searchResults[k].part_discounts.length; p++) {
            table = table + '<tr>' +
						'<td>' + searchResults[k].part_discounts[p].Part_Type_Abbreviation + '</td>' +
						'<td>' + searchResults[k].part_discounts[p].Part_Type_Name + '</td>' +
						'<td>' + searchResults[k].part_discounts[p].Discount_Rate + ' %</td></tr>';
        }

        table = table + '</tbody></table>';

        $("#part_type_details").html(table);

        $("#ClientDetailsModal").modal('show');
    }

$(document).ready(function ()
{
    $('#order_by').on('change', function ()
    {
        var prop = $('#order_by').val();
        console.log(prop);

        searchResults.sort(predicatBy(prop));

        $("#client_results").empty();

        for (var k = 0; k < searchResults.length; k++) {
            var client_status;

            if (searchResults[k].Client_Status == true)
                client_status = "Active";
            else
                client_status = "In-Active";

            var row = '<tr>' +
                            '<td>' + searchResults[k].Client_ID + '</td>' +
                            '<td>' + searchResults[k].Name + '</td>' +
                            '<td>' + searchResults[k].Account_Name + '</td>' +
                            '<td>' + searchResults[k].Vat_Number + '</td>' +
                            '<td>' + client_status + '</td>' +
                            '<td>' + searchResults[k].Address + ', ' + searchResults[k].City + ', ' + searchResults[k].Zip + '</td>' +
                            '<td>R ' + searchResults[k].Overdue_Payment + '</td>' +
                            '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                            '</tr>';

            $("#client_results").append(row);
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
