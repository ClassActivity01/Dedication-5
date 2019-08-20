<%@ Page Title="Search Inventory" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-7.aspx.cs" Inherits="Test._3_7" %>
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
//This function populates the modal
function onMore(k)
{
    $("#modalTable").empty();
    var row;

    if (inventory_type == "Raw Material") {
        
        $("#modalHeader").html("Raw Material #" + searchResults[k].Raw_Material_ID);


        row = '<tr><td>Description: </td><td>'+ searchResults[k].Description + '</td></tr>';
        $("#modalTable").append(row);

        row = '<tr><td>Suppliers: </td><td>';

        for (var j = 0; j < searchResults[k].Raw_Material_Suppliers.length; j++)
        {
            var s_name = searchResults[k].Raw_Material_Suppliers[j].Name;
            var flag = "Not Preferred";

            if (searchResults[k].Raw_Material_Suppliers[j].Is_Prefered == true)
                flag = "Preferred";

            row = row + s_name + " - " + flag + " - R" + searchResults[k].Raw_Material_Suppliers[j].unit_price + "<br/>";

        }

        row = row + '</td></tr>';
        $("#modalTable").append(row);
    }
    else if (inventory_type == "Unique Raw Material") {

        $("#modalHeader").html("Unique Raw Material #" + searchResults[k].Unique_Raw_Material_ID);

        var date = searchResults[k].Date_Used.split("T");

        row = '<tr><td>Date Used: </td><td>' + date[0] + '</td></tr>';
        $("#modalTable").append(row);

        row = '<tr><td>Purchas Order: </td><td>#' + searchResults[k].Supplier_Order_ID + '</td></tr>';
        $("#modalTable").append(row);

    }
    else if (inventory_type == "Part Type")
    {
        $("#modalHeader").html("Part Type #" + searchResults[k].Part_Type_ID);

        row = '<tr><td>Description: </td><td>' + searchResults[k].Description + '</td></tr>';
        $("#modalTable").append(row);


        row = '<tr><td>Manual Labour: </td><td>';
        row = row + "No. - Name - Stage in Manufacturing <br/>";

        for (var j = 0; j < searchResults[k].Manual_Labours.length; j++) {
            row = row + "#" + searchResults[k].Manual_Labours[j].Manual_Labour_Type_ID + " - " + searchResults[k].Manual_Labours[j].Manual_Labour_Type_Name + " - " +
                searchResults[k].Manual_Labours[j].Stage_In_Manufacturing + "<br/>";
        }

        row = row + '</td></tr>';
        $("#modalTable").append(row);


        row = '<tr><td>Machines: </td><td>';
        row = row + "No. - Name - Stage in Manufacturing <br/>";

        for (var j = 0; j < searchResults[k].Machines.length; j++) {
            row = row + "#" + searchResults[k].Machines[j].Machine_ID + " - " + searchResults[k].Machines[j].Machine_Name + " - " +
                searchResults[k].Machines[j].Stage_In_Manufacturing + "<br/>";
        }

        row = row + '</td></tr>';
        $("#modalTable").append(row);


        row = '<tr><td>Bill of Materials: </td><td>';
        row = row + "No - Type - Name - Stage in Manufacturing - Quantity Required <br/>";

        for (var j = 0; j < searchResults[k].recipe.length; j++) {
            row = row + "#" + searchResults[k].recipe[j].Item_ID + " - " + searchResults[k].recipe[j].Recipe_Type + " - " + searchResults[k].recipe[j].Item_Name + " - " +
                searchResults[k].recipe[j].Stage_in_Manufacturing + " - " + searchResults[k].recipe[j].Quantity_Required + "<br/>";
        }

        row = row + '</td></tr>';
        $("#modalTable").append(row);


        row = '<tr><td>Suppliers: </td><td>';

        for (var j = 0; j < searchResults[k].suppliers.length; j++) {
            var s_name = searchResults[k].suppliers[j].Name;
            var flag = "Not Preferred";

            if (searchResults[k].suppliers[j].Is_Prefered == true)
                flag = "Preferred";

            row = row + s_name + " - " + flag + " - R" + searchResults[k].suppliers[j].unit_price + "<br/>";

        }

        row = row + '</td></tr>';
        $("#modalTable").append(row);
    }
    else if (inventory_type == "Part") {
        row = '<tr><td>Abbreviation: </td><td>' + searchResults[k].Part_Type_Abbreviation + '</td></tr>';
        $("#modalTable").append(row);

        row = '<tr><td>Description: </td><td>' + searchResults[k].Part_Type_Description + '</td></tr>';
        $("#modalTable").append(row);

        row = '<tr><td>Dimensions: </td><td>' + searchResults[k].Part_Type_Dimension + '</td></tr>';
        $("#modalTable").append(row);

        row = '<tr><td>Sell Price: </td><td>R' + searchResults[k].Part_Type_Selling_Price + '</td></tr>';
        $("#modalTable").append(row);
    }
    else if (inventory_type == "Component") {
        row = '<tr><td>Description: </td><td>' + searchResults[k].Description + '</td></tr>';
        $("#modalTable").append(row);

        row = '<tr><td>Suppliers: </td><td>';

        for (var j = 0; j < searchResults[k].Suppliers.length; j++) {
            var s_name = searchResults[k].Suppliers[j].Name;
           

            var flag = "Not Preferred";

            if (searchResults[k].Suppliers[j].Is_Prefered == true)
                flag = "Preferred";

            row = row + s_name + " - " + flag + " - R" + searchResults[k].Suppliers[j].unit_price + "<br/>";
        }

        row = row + '</td></tr>';
        $("#modalTable").append(row);
    }

    $("#showMoreModal").modal('show');


    return false;
}

var searchResults;
var inventory_type;

function clearCriteria()
{
    $('#search_criteria_1').val("");
    $("#search_category_1 > option[value='Choose']").prop("selected", true);
    $("#what_type > option[value='Choose']").prop("selected", true);
    return false;
}

$(document).on('change', '#what_type', function () {
    var what = $("#what_type").val();

    if (what == "Part Type")
        $("#search_category_1").html('<option value="All">All</option><option value="Abb">Abbreviation</option><option value="Name">Name</option><option value="Description">Description</option><option value="Dimension">Dimensions</option>');
    else if (what == "Part")
        $("#search_category_1").html('<option value="All">All</option><option value="Serial">Serial No.</option><option value="Name">Part Type Name</option><option value="Abb">Part Type Abbreviation</option>');
    else if (what == "Component")
        $("#search_category_1").html('<option value="All">All</option><option value="ID">Component No.</option><option value="Name">Name</option><option value="Description">Description</option>');
    else if (what == "Raw Material")
        $("#search_category_1").html('<option value="All">All</option><option value="Name">Name</option><option value="ID">Raw Material No.</option><option value="Description">Description</option>');
    else if (what == "Unique Raw Material")
        $("#search_category_1").html('<option value="All">All</option><option value="ID">Unique Raw Material No.</option><option value="Name">Name</option><option value="Description">Description</option><option value="Dimension">Dimensions</option>');
});

function Search() {
    var criteria1 = $('#search_criteria_1').val();
    var cat_1 = $('#search_category_1').val();
    inventory_type = $('#what_type').val();

    if (inventory_type == "Choose")
    {
        alertify.alert('Error', "Please choose an inventory type before searching.");
        return false;
    }

    var method = $('input[name=optradio]:checked', '#search_form').val();
    var send_data = "{'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "', 'method' : '" + method + "'}";

    if (inventory_type == "Part Type")
    {
        $.ajax({
            type: "POST",
            url: "api/SearchPartType",
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
                    searchResults = JSON.parse(result[1]).part_types;

                    if (searchResults.length == 0)
                        alertify.alert('Error', "No results found.", function () { });

                    var header = '<tr><th>No.</th><th>Name</th><th>Abbreviation</th><th>Dimensions</th><th>Minimum Level</th><th>Show More</th></tr>';

                    $("#result_header").empty();
                    $("#result_header").append(header);
                    $("#search_results").empty();
                    var row;

                    for (var k = 0; k < searchResults.length; k++) {
                        var row = '<tr><td>' + searchResults[k].Part_Type_ID + '</td><td>' + searchResults[k].Name + '</td><td>' +
                                searchResults[k].Abbreviation + '</td><td>' + searchResults[k].Dimension + '</td><td>' +
                                searchResults[k].Minimum_Level + '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';;

                        $("#search_results").append(row);
                    }

                    $("#order_by").empty();
                    var options = "<option value='Select'>Select an Option</option>" +
                                    "<option value='Part_Type_ID'>Part Code</option>" +
                                    "<option value='Name'>Name</option>" +
                                    "<option value='Abbreviation'>Abbreviation</option>" +
                                    "<option value='Dimension'>Dimension</option>";
                    $("#order_by").append(options);

                }
                else { alertify.alert('Error', result[1]); }
            }
        });
    } else
    if (inventory_type == "Part")
    {
        $.ajax({
            type: "POST",
            url: "api/SearchPart",
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
                    searchResults = JSON.parse(result[1]).parts;

                    if (searchResults.length == 0)
                        alertify.alert('Error', "No results found.", function () { });

                    var header = '<tr><th>Serial No.</th><th>Part Type</th><th>Date Added</th><th>Status</th><th>Stage</th><th>Show More</th></tr>';
                    var status;
                    //On Form Load
                    $.ajax({
                        type: "GET",
                        url: "api/PartStatus",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        error: function (xhr, ajaxOptions, thrownError) {
                            alert(xhr.status);
                            alert(xhr.responseText);
                            alert(thrownError);
                        },
                        success: function (msg) {
                            var result = msg.split("|");

                            if (result[0] == "true") {
                                status = JSON.parse(result[1]).part_statuses;
                            }
                            else {
                                alertify.alert('Error', result[1], function () { });
                            }
                        }
                    });

                    $("#result_header").empty();
                    $("#result_header").append(header);
                    $("#search_results").empty();
                    var row;

                    for (var k = 0; k < searchResults.length; k++) {
                        var p_status;

                        for (var j = 0; j < status.length; j++)
                            if (status[j].Part_Status_ID == searchResults[k].Part_Status_ID)
                            {
                                p_status = status[j].Name;
                            }
                                

                        var date = searchResults[k].Date_Added.split("T");

                        row = '<tr><td>' + searchResults[k].Part_ID + '</td><td>' + searchResults[k].Part_Type_Name + '</td><td>'
                            + date[0] + '</td><td>' + p_status + '</td><td>' + searchResults[k].Part_Stage +
                            '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

                        $("#search_results").append(row);
                    }

                    $("#order_by").empty();
                    var options = "<option value='Select'>Select an Option</option>" +
                                    "<option value='Part_ID'>Part Code</option>" +
                                    "<option value='Part_Type_Name'>Name</option>" +
                                    "<option value='Part_Stage'>Part Stage</option>";
                    $("#order_by").append(options);

                }
                else { alertify.alert('Error', result[1]); }
            }
        });
    } else
    if (inventory_type == "Component")
    {
        $.ajax({
            type: "POST",
            url: "api/SearchComponent",
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
                    searchResults = JSON.parse(result[1]).components;

                    if (searchResults.length == 0)
                        alertify.alert('Error', "No results found.", function () { });

                    var header = '<tr><th>No.</th><th>Name</th><th>Quantity Available</th><th>Unit Price (R)</th><th>Dimension</th><th>Show More</th></tr>';

                    $("#result_header").empty();
                    $("#result_header").append(header);
                    $("#search_results").empty();
                    var row;

                    for (var k = 0; k < searchResults.length; k++) {
                        row = '<tr><td>' + searchResults[k].Component_ID + '</td><td>' + searchResults[k].Name + '</td><td>' +
                            searchResults[k].Quantity
                            + '</td><td>' + searchResults[k].Unit_Price + '</td><td>' + searchResults[k].Dimension +
                            '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

                        $("#search_results").append(row);
                    }

                    $("#order_by").empty();
                    var options = "<option value='Select'>Select an Option</option>" +
                                    "<option value='Component_ID'>Component Code</option>" +
                                    "<option value='Name'>Name</option>" +
                                    "<option value='Quantity'>Quantity Available</option>" +
                                    "<option value='Dimension'>Dimension</option>";
                    $("#order_by").append(options);

                }
                else { alertify.alert('Error', result[1]); }
            }
        });
    } else
        if (inventory_type == "Raw Material") {
            $.ajax({
                type: "POST",
                url: "api/SearchRawMaterial",
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
                        searchResults = JSON.parse(result[1]).raw_materials;

                        if (searchResults.length == 0)
                            alertify.alert('Error', "No results found.", function () { });

                        var header = '<tr><th>No.</th><th>Name</th><th>Show More</th></tr>';

                        $("#result_header").empty();
                        $("#result_header").append(header);
                        $("#search_results").empty();
                        var row;

                        for (var k = 0; k < searchResults.length; k++) {
                            row = '<tr><td>' + searchResults[k].Raw_Material_ID + '</td><td>' + searchResults[k].Name + '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

                            $("#search_results").append(row);
                        }

                        $("#order_by").empty();
                        var options = "<option value='Select'>Select an Option</option>" +
                                        "<option value='Raw_Material_ID'>Raw Material Code</option>" +
                                        "<option value='Name'>Name</option>";
                        $("#order_by").append(options);
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
        } else
            if (inventory_type == "Unique Raw Material") {
                $.ajax({
                    type: "POST",
                    url: "api/SearchUniqueRawMaterial",
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
                            searchResults = JSON.parse(result[1]).unique_raw_materials;

                            if (searchResults.length == 0)
                                alertify.alert('Error', "No results found.", function () { });

                            var header = '<tr><th>No.</th><th>Type</th><th>Dimensions</th><th>Quality</th><th>Date Added</th><th>Show More</th></tr>';

                            $("#result_header").empty();
                            $("#result_header").append(header);
                            $("#search_results").empty();
                            var row;

                            for (var k = 0; k < searchResults.length; k++) {
                                var date = searchResults[k].Date_Added.split("T");

                                row = '<tr><td>' + searchResults[k].Unique_Raw_Material_ID + '</td><td>' + searchResults[k].Raw_Material_Name + '</td><td>' + searchResults[k].Dimension + '</td><td>' +
                                    searchResults[k].Quality + '</td><td>' + date[0] + '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

                                $("#search_results").append(row);
                            }

                            $("#order_by").empty();
                            var options = "<option value='Select'>Select an Option</option>" +
                                            "<option value='Unique_Raw_Material_ID'>Raw Material Code</option>" +
                                            "<option value='Raw_Material_Name'>Name</option>" +
                                            "<option value='Quality'>Quality</option>" +
                                            "<option value='Dimension'>Dimension</option>";
                            $("#order_by").append(options);

                        }
                        else { alertify.alert('Error', result[1]); }
                    }
                });
            }

    $("#resultDiv").show();

    return false;
}

$(document).ready(function () {
    $('#order_by').on('change', function () {
        var prop = $('#order_by').val();

        searchResults.sort(predicatBy(prop));

        if (inventory_type == "Part Type") {
            
            $("#search_results").empty();
            var row;

            for (var k = 0; k < searchResults.length; k++) {
                var row = '<tr><td>' + searchResults[k].Part_Type_ID + '</td><td>' + searchResults[k].Name + '</td><td>' +
                        searchResults[k].Abbreviation + '</td><td>' + searchResults[k].Dimension + '</td><td>' +
                        searchResults[k].Minimum_Level + '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';;

                $("#search_results").append(row);
            }

        } else
        if (inventory_type == "Part") {

            var status;
            //On Form Load
            $.ajax({
                type: "GET",
                url: "api/PartStatus",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg) {
                    var result = msg.split("|");

                    if (result[0] == "true") {
                        status = JSON.parse(result[1]).part_statuses;
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });

            $("#search_results").empty();
            var row;

            for (var k = 0; k < searchResults.length; k++) {
                var p_status;

                for (var j = 0; j < status.length; j++)
                    if (status[j].Part_Status_ID == searchResults[k].Part_Status_ID) {
                        p_status = status[j].Name;
                    }


                var date = searchResults[k].Date_Added.split("T");

                row = '<tr><td>' + searchResults[k].Part_ID + '</td><td>' + searchResults[k].Part_Type_Name + '</td><td>'
                    + date[0] + '</td><td>' + p_status + '</td><td>' + searchResults[k].Part_Stage +
                    '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

                $("#search_results").append(row);
            }

    } else
     if (inventory_type == "Component") {
                    
        $("#search_results").empty();
        var row;

        for (var k = 0; k < searchResults.length; k++) {
            row = '<tr><td>' + searchResults[k].Component_ID + '</td><td>' + searchResults[k].Name + '</td><td>' +
                searchResults[k].Quantity
                + '</td><td>' + searchResults[k].Unit_Price + '</td><td>' + searchResults[k].Dimension +
                '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

            $("#search_results").append(row);
        }

    } else
    if (inventory_type == "Raw Material") {
                       
        $("#search_results").empty();
        var row;

        for (var k = 0; k < searchResults.length; k++) {
            row = '<tr><td>' + searchResults[k].Raw_Material_ID + '</td><td>' + searchResults[k].Name + '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

            $("#search_results").append(row);
        }

    } else
    if (inventory_type == "Unique Raw Material") {
                            
                    $("#search_results").empty();
                    var row;

                    for (var k = 0; k < searchResults.length; k++) {
                        var date = searchResults[k].Date_Added.split("T");

                        row = '<tr><td>' + searchResults[k].Unique_Raw_Material_ID + '</td><td>' + searchResults[k].Raw_Material_Name + '</td><td>' + searchResults[k].Dimension + '</td><td>' +
                            searchResults[k].Quality + '</td><td>' + date[0] + '</td><td><button class="Add_extra_things_link" onclick="return onMore(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td></tr>';

                        $("#search_results").append(row);
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
<h1 class="default-form-header">Search Inventory</h1>
		
<!-- Search Code -->
<div class="searchDiv" id="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Inventory Item: </legend>
			<div class="row">
				<div class="col-sm-6">
					<label for="what_type" class="control-label">Search Category: </label>
					<select class="form-control" id="what_type" title ="Select the inventory category" data-toggle ="tooltip" data-placement="right">
						<option value="Choose">Choose a Type</option>
						<option value="Part Type">Part Type</option>
						<option value="Part">Part</option>
						<option value="Component">Component</option>
						<option value="Raw Material">Raw Material</option>
						<option value="Unique Raw Material">Unique Raw Material</option>
					</select>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the inventory item details to search by" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select what to search the inventory item by" data-toggle ="tooltip" data-placement="bottom">
						<option value="All">All</option>
						<option value="Name">Name</option>
						<option value="ID">Item No.</option>
						<option value="Description">Description</option>
					</select>
				</div>	
			</div>
			<div class="row">
				<div class="col-sm-6">
					<label for="optradio">Search Method: </label>
					<div class="radio">
						<label title ="Select the search method"><input type="radio" value="Exact" checked name="optradio">Exact</label>
					</div>
					<div class="radio">
						<label title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>
					</div>
				</div>
			</div>
		</fieldset>
		<div class="row">
					
			<div class="col-sm-4">
				<button id="submitSearch" onclick="return Search()" class ="searchButton" title ="Click here to search for the item" data-toggle ="tooltip" data-placement ="right" ><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-offset-4 col-sm-4">
				<button id="clearSearch" onclick="return clearCriteria()" class ="searchButton" title ="Click here to clear the sreach criteria" data-toggle ="tooltip"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>
<br />
<style>    #resultDiv { display : none;
    }
</style>

<div id="resultDiv">
	<fieldset>
		<legend>Search Results: </legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="order_by">Order By: </label>
				<select class="form-control" id="order_by" title ="Select how to sort search results" data-toggle ="tooltip" data-placement ="right">
                    <option value="Select">Select an option</option>
					<option value="Name">Name</option>
					<option value="ID">ID</option>
					<option value="Dimension">Dimensions</option>
					<option value="Quantity">Quantity (Component)</option>
					<option value="Date_Added">Date Added</option>
				</select>
			</div>
		</div>
        <br />

        <div class="table-responsive makeDivScrollable_search results">
		<table class="sortable table table-hover">
			<thead id="result_header">
					
			</thead>
			<tbody id="search_results">
					
			</tbody>
		</table>
	</div>
	</fieldset>	
</div>

<div class="modal fade" id="showMoreModal">
<div class="modal-dialog" role="document">
<div class="modal-content">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true" style="color:white">&times;</span>
		</button>
		<h4 class="modal-title" id="modalHeader">More Info</h4>
	</div>
	<div class="modal-body" style="color:white" id="modalBody">
        <table class="table" style="color: white">
			<tbody id="modalTable">
				
			</tbody>
		</table>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

</asp:Content>
