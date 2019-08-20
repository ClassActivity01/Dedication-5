<%@ Page Title="Search Suppliers" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-11.aspx.cs" Inherits="Test._5_11" %>
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

    var send_data = "{'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "', 'method' : '" + method +"'}";

    $.ajax({
        type: "POST",
        url: "api/SearchSupplier",
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
                searchResults = JSON.parse(result[1]).suppliers;

                if (searchResults.length == 0)
                    alertify.alert('Error', "No results found.", function () { });

                $("#div_search_results").show();
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
                        '<td>' + searchResults[k].Supplier_ID + '</td>' +
                        '<td>' + searchResults[k].Name + '</td>' +
                        '<td>' + searchResults[k].Address + '</td>' +
                        '<td>' + searchResults[k].City + '</td>' +
                        '<td>' + province + '</td>' +
                        '<td>' + searchResults[k].Zip + '</td>' +
                        '<td><button type="button" title ="Click to view suppliers details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
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

function showMoreDetails(i)
{
    //Get bank details
    var row = "Bank Account Number: " + searchResults[i].Back_Account_Number + "<br/>" +
        "Bank Name: " + searchResults[i].Bank_Name + "<br/>" +
        "Bank Branch/Swift Code: " + searchResults[i].Bank_Branch + "<br/>" +
        "Bank Reference: " + searchResults[i].Bank_Reference + "<br/>";
    $("#supplier_bank_details").html(row);

    //Get contact details
    row = "Contact Name: " + searchResults[i].Contact_Name + "<br/>" +
        "Contact Number: " + searchResults[i].Contact_Number + "<br/>" +
        "Contact Email: " + searchResults[i].Email + "<br/>";
    $("#contact_details").html(row);

    //Get inventory assigned to supplier

    for(var a = 0; a < searchResults[i].cs.length; a++)
    {
        row = "<tr><td>" + searchResults[i].cs[a].Component_ID + "</td><td>Component</td><td>" + searchResults[i].cs[a].Component_Name +
            "</td><td>"+ searchResults[i].cs[a].unit_price +"</td><td>"+ searchResults[i].cs[a].is_preferred +"</td></tr>";

        $("#items").append(row);
    }
    
    for (var a = 0; a < searchResults[i].rms.length; a++)
    {
        row = "<tr><td>" + searchResults[i].rms[a].Raw_Material_ID + "</td><td>Raw Material</td><td>" + searchResults[i].rms[a].Raw_Material_Name +
            "</td><td>" + searchResults[i].rms[a].unit_price + "</td><td>" + searchResults[i].rms[a].Is_Prefered + "</td></tr>";

        $("#items").append(row);
    }

    for(var a = 0; a < searchResults[i].ps.length; a++)
    {
        row = "<tr><td>" + searchResults[i].ps[a].Part_Type_ID + "</td><td>Part</td><td>" + searchResults[i].ps[a].Part_Type_Name +
            "</td><td>"+ searchResults[i].ps[a].unit_price +"</td><td>"+ searchResults[i].ps[a].Is_Prefered +"</td></tr>";

        $("#items").append(row);
    }

    $("#s_ID").html(searchResults[i].Supplier_ID);
    $("#detailsModal").modal('show');
}

$(document).ready(function ()
{

    $('#order_by').on('change', function () {
        var prop = $('#order_by').val();

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
                '<td>' + searchResults[k].Supplier_ID + '</td>' +
                '<td>' + searchResults[k].Name + '</td>' +
                '<td>' + searchResults[k].Address + '</td>' +
                '<td>' + searchResults[k].City + '</td>' +
                '<td>' + province + '</td>' +
                '<td>' + searchResults[k].Zip + '</td>' +
                '<td><button type="button" title ="Click to view suppliers details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                '</tr>';

            $("#search_results").append(row);
        }
    });
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
</script>

<h1 class="default-form-header">Search Suppliers</h1>
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Supplier: </legend>
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter what to search the supplier by" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select what to search the supplier by" data-toggle ="tooltip" data-placement="bottom">
                        <option value="All">All</option>
						<option value="Name">Name</option>
						<option value="Email">Email</option>
                        <option value="CName">Contact Name</option>
						<option value="Contact_Number">Contact Number</option>
					</select>
				</div>	
			</div>
			<div class="row">
				<div class="col-sm-6">
					Search Method:
					<div class="radio">
						<label title ="Select the search method"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					</div>
					<div class="radio">
						<label title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>
					</div>

				</div>
				<div class="col-sm-6">
				</div>	
			</div>
		</fieldset>
		<div class="row">
			<div class="col-sm-4">
				<button id="submitSearch" onclick="return Search()" class ="searchButton" title ="Search for the supplier" data-toggle ="tooltip" data-placement="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-4">
			</div>
			<div class="col-sm-4">
				<button id="clearSearch" onclick="return ClearCriteria()" class ="searchButton" title ="Clear search details" data-toggle ="tooltip" data-placement="left"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>

<div id="div_search_results" style="display : none">
    <fieldset>
		<legend>Search Results: </legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="order_by">Order By: </label>
				<select class="form-control" id="order_by" title ="Select how to order the search results" data-toggle ="tooltip" data-placement ="right">
                    <option value="Choose">Choose an Option</option>
					<option value="Name">Name</option>
                    <option value="Address">Address</option>
					<option value="Email">Email</option>
					<option value="Supplier_ID">ID</option>
                    <option value="City">City</option>
                    <option value="Province_ID">Province</option>
				</select>
			</div>
		</div>

        <div class="table-responsive makeDivScrollable_search results">
	    <table class="sortable table table-hover">
		    <thead id="table1_header">
			    <tr>
				    <th>Supplier ID</th>
				    <th>Name</th>
					<th>Address</th>
                    <th>City</th>
                    <th>Province</th>
                    <th>Zip</th>
                    <th>More Details</th>
			    </tr>
		    </thead>
		    <tbody id="search_results">
		    </tbody>
	    </table>
        </div> 
	</fieldset>
</div>
<div class="modal fade" id="detailsModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">Supplier #<span id="s_ID"></span> Details</h4>
		</div>
		<div class="modal-body">
            <div>
                <table class="table" style="color: white">
				    <tbody >
                        <tr>
                            <td>Bank Details: </td>
                            <td id="supplier_bank_details"></td>
                        </tr>
				    </tbody>
			    </table>
            </div>

            <div>
                <table class="table" style="color: white">
				    <tbody >
                        <tr>
                            <td>Contact Details:</td>
                            <td id="contact_details"></td>
                        </tr>
				    </tbody>
			    </table>
            </div>

            <div>
                <table class="table" style="color: white">
                    <thead>
                        <tr>
                            <th>Item ID</th>
                            <th>Item Type</th>
                            <th>Item Name</th>
                            <th>Unit Price</th>
                            <th>Prefered</th>
                        </tr>
                    </thead>

				    <tbody id="items">
				    </tbody>
			    </table>
            </div>
			
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal">Close</button>
			<button type="button" class="btn btn-secondary modalbutton" id="maintainSubContractor">Maintain this Supplier</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

</asp:Content>
