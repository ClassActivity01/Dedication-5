<%@ Page Title="Search Machines" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="8-8.aspx.cs" Inherits="Test._8_8" %>
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
    var what_type;
    
$(document).ready(function () 
{
    what_type = "Machine";
	$('#search_For').on('change', function() 
	{
		var newOptions;
		if(this.value == "Machine")
		{
			newOptions ={	"All": "All",
			    "Name": "Name",
			    "Model": "Model",
			    "Manufacturer": "Manufacturer",
			    "ID": "Machine No."
			};
			what_type = "Machine";
		}
		else if(this.value == "Unique Machine")
		{
			newOptions ={	"All": "All",
			    "Name": "Name",
			    "Model": "Model",
			    "Manufacturer": "Manufacturer",
			    "Serial": "Unique Machine Serial No."
			};
			what_type = "Unique Machine";
		}

			$("#search_category_1").empty(); // remove old options
			$("#order_by").empty();
				
			$.each(newOptions, function(value,key) 
			{
				$("#search_category_1").append($("<option></option>").attr("value", value).text(key));
				$("#order_by").append($("<option></option>").attr("value", value).text(key));
			});
	});
    });

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

    $("#what_type").empty();
    $("#listOfMachines").empty();

    if (what_type == "Unique Machine")
    {
        var row = '<tr><th>Serial No.</th><th>Machine Name</th><th>Manufacturer</th><th>Model</th><th>Status</th></tr>';
        $("#what_type").append(row);

            var machine_status = "";

            $.ajax({
                type: "POST",
                url: "api/SearchUniqueMachine",
                data: { data: "{'method': '" + method + "', 'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "'}" },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                },
                success: function (msg)
                {
                    var result = msg.split("|");

                    if (result[0] == "true") {
                        searchResults = JSON.parse(result[1]).unique_machines;

                        if (searchResults.length == 0)
                            alertify.alert('Error', "No results found.", function () { });

                        for (var k = 0; k < searchResults.length; k++) {

                            var row = '<tr><td>' + searchResults[k].Unique_Machine_Serial+ '</td><td>' + searchResults[k].Name + '</td><td>' +
                                searchResults[k].Manufacturer + '</td><td>' + searchResults[k].Model + '</td><td>' + searchResults[k].Status + '</td></tr>';

                            $("#listOfMachines").append(row);
                        }

                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });
    }
    else if (what_type == "Machine")
    {
        var row = '<tr><th>Machine No.</th><th>Name</th><th>Manufacturer</th><th>Model</th><th>Run Time</th><th>Price per Hour</th></tr>';
        $("#what_type").append(row);

        $.ajax({
            type: "POST",
            url: "api/SearchMachine",
            data: { data: "{'method': '" + method + "', 'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "'}" },
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status);
                console.log(xhr.responseText);
                console.log(thrownError);
            },
            success: function (msg)
            {
                var result = msg.split("|");

                if (result[0] == "true") {
                    searchResults = JSON.parse(result[1]).machines;

                    if (searchResults.length == 0)
                        alertify.alert('Error', "No results found.", function () { });

                    for (var k = 0; k < searchResults.length; k++) {
                        var row = '<tr><td>' + searchResults[k].Machine_ID + '</td><td>' + searchResults[k].Name + '</td><td>' +
                            searchResults[k].Manufacturer + '</td><td>' + searchResults[k].Model + '</td><td>' + searchResults[k].Run_Time +
                            '</td><td>R ' + searchResults[k].Price_Per_Hour + '</td></tr>';

                        $("#listOfMachines").append(row);
                    }

                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
    }

    return false;
}

$(document).ready(function () {
    $('#order_by').on('change', function () {
        var prop = $('#order_by').val();
        //console.log(prop);

        searchResults.sort(predicatBy(prop));
        $("#listOfMachines").empty();


        if (what_type == "Unique Machine") {

            for (var k = 0; k < searchResults.length; k++) {

                var row = '<tr><td>' + searchResults[k].Unique_Machine_Serial + '</td><td>' + searchResults[k].Name + '</td><td>' +
                    searchResults[k].Manufacturer + '</td><td>' + searchResults[k].Model + '</td><td>' + searchResults[k].Status + '</td></tr>';

                $("#listOfMachines").append(row);
            }


        } else if (what_type == "Machine") {
            for (var k = 0; k < searchResults.length; k++) {
                var row = '<tr><td>' + searchResults[k].Machine_ID + '</td><td>' + searchResults[k].Name + '</td><td>' +
                    searchResults[k].Manufacturer + '</td><td>' + searchResults[k].Model + '</td><td>' + searchResults[k].Run_Time +
                    '</td><td>R ' + searchResults[k].Price_Per_Hour + '</td></tr>';

                $("#listOfMachines").append(row);
            }
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
<h1 class="default-form-header">Search Machine</h1>
		
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Machine: </legend>
			<div class="row">
				<div class="col-sm-6">
					<select class="form-control" id="search_For" title ="Select the machine type" data-toggle ="tooltip" data-placement ="right">
						<option>Machine</option>
						<option>Unique Machine</option>
					</select>
				</div>
				<div class="col-sm-6">
				</div>
			</div>
				
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the details to search by" data-toggle ="tooltip" data-placement ="right">
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select the details to search by" data-toggle ="tooltip" data-placement ="bottom">
						<option value="All">All</option>
					    <option value="Name">Name</option>
					    <option value="Model">Model</option>
					    <option value="Manufacturer">Manufacturer</option>
					    <option value="ID">Machine No.</option>
					</select>
				</div>	
			</div>
			<div class="row">
				<div class="col-sm-6">
					<label>Search Method:</label>
					<div class="radio">
						<label title ="Select the search method" data-toggle ="tooltip" data-placement ="right"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					</div>
					<div class="radio">
						<label title ="Select the search method" data-toggle ="tooltip" data-placement ="right"><input type="radio" value="Contains" name="optradio">Contains</label>
					</div>

				</div>
				<div class="col-sm-6">
				</div>	
			</div>
		</fieldset>
        <br />

		<div class="row">
			<div class="col-sm-4">
				<button id="submitSearch" onclick=" return Search()" class ="searchButton" title ="Click to search for machine" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-offset-4 col-sm-4">
				<button id="clearSearch" onclick="return clearCriteria()" class ="searchButton" title ="Click to clear search details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>
		 <br />
<form id="filterby">
	<fieldset>
		<legend>Search Results: </legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="order_by">Order By: </label>
				<select class="form-control" id="order_by" title ="Select how to order the search results" data-toggle ="tooltip" data-placement ="right">
                        <option value="Select">Select an Option</option>
						<option value="Name">Name</option>
						<option value="Model">Model</option>
						<option value="Manufacturer">Manufacturer</option>
						<option value="Unique_Machine_ID">Serial No.</option>
				</select>
			</div>
		</div>

        <br/>
        <div class="table-responsive makeDivScrollable results">
        <table class="sortable table table-hover">
	        <thead id="what_type">
		        
	        </thead>
	        <tbody id="listOfMachines">
		        
	        </tbody>
        </table>
        </div> 
	</fieldset>	
</form>

</asp:Content>
