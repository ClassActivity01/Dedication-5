<%@ Page Title="Search Sub-Contractors" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="7-3.aspx.cs" Inherits="Test._7_3" %>
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
    var searchResults;

    function clearCriteria()
    {
        $('#search_criteria_1').val("");
        $("#search_category_1 > option[value='Choose']").prop("selected", true);

        return false;
    }

    function Search() {
        var criteria1 = $('#search_criteria_1').val();
        var cat_1 = $('#search_category_1').val();
        var method = $('input[name=optradio]:checked', '#search_form').val();

        var send_data = "{'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "', 'method' : '" + method + "'}";

        $.ajax({
            type: "POST",
            url: "api/SearchSubContractor",
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
                    var json = JSON.parse(result[1]).sub_contractors;

                    if (json.length == 0)
                        alertify.alert('Error', "No results found.", function () { });

                    $("#div_search_results").show();
                    $("#search_results").empty();
                    
                    searchResults = [];
                    var arr = [];

                    $.each(json, function (index, value) {
                        if ($.inArray(value.Sub_Contractor_ID, arr) == -1) { //check if id value not exits than add it
                            arr.push(value.Sub_Contractor_ID);//push id value in arr
                            searchResults.push(value); //put object in collection to access it's all values
                        }
                    });

                    //console.log(searchResults);

                    for (var k = 0; k < searchResults.length; k++) {

                        var province;

                        switch (searchResults[k].Province_ID) {
                            case 1:
                                province = "Eastern Cape";
                                break;
                            case 2:
                                province = "Free State";
                                break;
                            case 3:
                                province = "Gauteng";
                                break;
                            case 4:
                                province = "KwaZulu-Natal";
                                break;
                            case 5:
                                province = "Limpopo";
                                break;
                            case 6:
                                province = "Mpumulanga";
                                break;
                            case 7:
                                province = "North West";
                                break;
                            case 8:
                                province = "Northern Cape";
                                break;
                            case 9:
                                province = "Western Cape";
                        }


                        var row = '<tr>' +
                            '<td>' + searchResults[k].Name + '</td>' +
                            '<td>' + searchResults[k].Address + '</td>' +
                            '<td>' + searchResults[k].City + '</td>' +
                            '<td>' + province + '</td>' +
                            '<td>' + searchResults[k].Zip + '</td>' +
                            '<td>' + searchResults[k].Manual_Labour_Name + '</td>' +
                            '<td><button type="button" title ="Click to view the sub-contractor details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                            '</tr>';

                        $("#search_results").append(row);
                    }
                }
                else
                    alertify.alert('Error', result[1], function () { });
            }
        });

        return false;
    }

    function showMoreDetails(k)
    {

        $("#sub_contact_details").empty();

        for (var p = 0; p < searchResults[k].contact_details.length; p++) {

            var row = '<tr><td>' + searchResults[k].contact_details[p].Name + '</td><td>' + searchResults[k].contact_details[p].Number
                + '</td><td>' + searchResults[k].contact_details[p].Email + '</td></tr>';

            $("#sub_contact_details").append(row);
        }

        $("#s_ID").html(searchResults[k].Sub_Contractor_ID + " (" + searchResults[k].Name + ") ");
        $("#detailsModal").modal('show');
    }

$(document).ready(function ()
{

    $('#order_by').on('change', function ()
    {
        var prop = $('#order_by').val();
        console.log(prop);

        searchResults.sort(predicatBy(prop));

        $("#search_results").empty();

        for (var k = 0; k < searchResults.length; k++) {

            var province;

            switch (searchResults[k].Province_ID) {
                case 1:
                    province = "Eastern Cape";
                    break;
                case 2:
                    province = "Free State";
                    break;
                case 3:
                    province = "Gauteng";
                    break;
                case 4:
                    province = "KwaZulu-Natal";
                    break;
                case 5:
                    province = "Limpopo";
                    break;
                case 6:
                    province = "Mpumulanga";
                    break;
                case 7:
                    province = "North West";
                    break;
                case 8:
                    province = "Northern Cape";
                    break;
                case 9:
                    province = "Western Cape";
            }


            var row = '<tr>' +
                '<td>' + searchResults[k].Name + '</td>' +
                '<td>' + searchResults[k].Address + '</td>' +
                '<td>' + searchResults[k].City + '</td>' +
                '<td>' + province + '</td>' +
                '<td>' + searchResults[k].Zip + '</td>' +
                '<td>' + searchResults[k].Manual_Labour_Name + '</td>' +
                '<td><button type="button" title ="Click to view the sub-contractor details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                '</tr>';

            $("#search_results").append(row);
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


<h1 class="default-form-header">Search Sub-Contractor</h1>
		
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Sub-Contractor: </legend>
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the sub-contractors details to search by" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select what to search the sub-contractor by" data-toggle ="tooltip" data-placement="bottom">
						<option value="All">All</option>
						<option value="Name">Name</option>
						<option value="Address">Physical Address</option>
						<option value="ContactName">Contact Person Name</option>
						<option value="Number">Contact Number</option>
						<option value="Email">Email Address</option>
					</select>
				</div>	
			</div>
			<div class="row">
				<div class="col-sm-6">
					<label for="optradio">Search Method: </label>
					<div class="radio">
						<label title ="Select the search method" data-toggle ="tooltip" data-placement="right"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					</div>
					<div class="radio">
						<label title ="Select the search method" data-toggle ="tooltip" data-placement="right"><input type="radio" value="Contains" name="optradio">Contains</label>
					</div>

				</div>	
			</div>
		</fieldset>
		<div class="row">
			<div class="col-sm-4">
				<button id="submitSearch" onclick="return Search()" class="searchButton" title ="Click here to search for the sub-contractor" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-offset-4 col-sm-4">
				<button id="clearSearch" onclick="return clearCriteria()" class="searchButton" title ="Click here to clear the search details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>
<br/>

<div id="div_search_results" style="display : none">
<fieldset>
	<legend>Search Results:</legend>
    <div class="row">
		<div class="col-sm-4">
			<label for="order_by">Order By: </label>
			<select class="form-control" id="order_by" title ="Select how to sort the search results" data-toggle ="tooltip" data-placement="right">
                <option value="Select">Select an option</option>
				<option value="Name">Name</option>
				<option value="Address">Address</option>
				<option value="City">City</option>
				<option value="Province_ID">Province</option>
				<option value="Manual_Labour_Name">Manual Labour</option>
			</select>
		</div>
	</div>
    <br />
	<div class="table-responsive makeDivScrollable results">
			<table class="sortable table table-hover">
				<thead>
					<tr>
						<th>Name</th>
						<th>Address</th>
                        <th>City</th>
                        <th>Province</th>
                        <th>Zip</th>
                        <th>Manual Labour Provided</th>
                        <th>Contact Details</th>
					</tr>
				</thead>
				<tbody id="search_results">
					
				</tbody>
			</table>
		</div>
</fieldset>
</div>

<!-- MODAL CODE -->
		
<div class="modal fade" id="detailsModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">Sub-Contractor #<span id="s_ID"></span> Contact Details</h4>
		</div>
		<div class="modal-body">
			<table class="table" style="color: white">
				<thead>
                    <tr>
                        <th>Name</th>
					    <th>Number</th>
					    <th>Email</th>
                    </tr>
				</thead>
				<tbody id="sub_contact_details">
				</tbody>
			</table>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal">Close</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
