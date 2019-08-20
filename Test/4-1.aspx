<%@ Page Title="Generate Job Card" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-1.aspx.cs" Inherits="Test._4_1" %>
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
    var s_parts = [];
    var searchedItems;
    var item_count = 0;


    function searchForItem() {
        var filter_text = $("#search_criteria_1").val();
        var filter_category = $("#search_category_1").val();
        var method = $('input[name=method_radio2]:checked', '#inventory_search_Modal').val();

        $.ajax({
            type: "POST",
            url: "api/SearchPartJobCard",
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
                    searchedItems = JSON.parse(result[1]).part_types;
                    $("#item_search_results").empty();

                    for (var k = 0; k < searchedItems.length; k++) {
                        var type = '<option value="' + k + '">' + searchedItems[k].Abbreviation +' - '+ searchedItems[k].Name + '</option>';
                        $("#item_search_results").append(type);
                    }
                }
                else { alertify.alert('Error', result[1]); }
            }
        });
    }

    function addItem2() {
        var k = $("#item_search_results").val();

        if (k == "" || k == null)
            alertify.alert('Error', 'No Part has been chosen!');
        else {
            var found = false;
            var ID = searchedItems[k].Part_Type_ID;

            for (var a = 0; a < s_parts.length; a++) {
                if (s_parts[a].Part_Type_ID == ID) {

                    found = true;
                }
            }

            if (found == false) {
                var supplier2 = { Part_Type_ID: ID, Quantity: 1, Non_Manual: false };
                s_parts.push(supplier2);

                item_count++;
                var row = '<tr id="row_part_' + searchedItems[k].Part_Type_ID + '"><td>' + searchedItems[k].Part_Type_ID + '</td><td>'+item_count+'</td><td>' + searchedItems[k].Name + '</td>'
                    + '"/></td><td><input type="number" title ="Enter the quantity"id="p_q_' + searchedItems[k].Part_Type_ID + '"  min="1" value="1"/></td>' +
                    '<td><button type="button" class="Add_extra_things" title = "Click to remove the part type" onclick="return removeItem(&apos;Part Type&apos;, ' + searchedItems[k].Part_Type_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

                $("#Items").append(row);
            }
            else alertify.alert('Error', 'Part Type already in list.');
        }
    }

    function openSearchInventory() {
        $("#inventory_search_Modal").modal('show');
    }

    function removeItem(which_one, ID) {

        item_count--;
        if (which_one == "Part Type") {

            for (var a = 0; a < s_parts.length; a++) {
                if (s_parts[a].Part_Type_ID == ID) {
                    s_parts.splice(a, 1);
                    $('#row_part_' + ID).remove();
                }
            }
        }
    }

    function addJobCard()
    {
        var warnings = "";
        var date = (new Date()).toISOString();

        if (s_parts.length <= 0)
            warnings += "Job Card is empty! <br/>";

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts[a].Part_Type_ID;

            var quantity = $('#p_q_' + ID).val();
            s_parts[a].Quantity = quantity;

            if (quantity < 1)
                warnings += "No quantity specified for item ID(" + ID + "). <br/>";
        }

        var job = { Job_Card_Date: date, Job_Card_Status_ID: 1, Job_Card_Priority_ID: 1, details: s_parts };

        $("#w_info").html(warnings);

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/JobCard",
                data: { data: JSON.stringify(job) },
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
</script>




<h1 class="default-form-header">Generate Job Card</h1>
<form id="UC4-1" class="form-horizontal">		
<fieldset id="partsFieldset">
	<legend>Job Card Information:</legend>
	<div id="parts">

		<button type="button" class="Add_extra_things" onclick="return openSearchInventory()" title ="Click to add a part to a job card" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus"></i> Add Part to Job Card</button>

        <br/>
		<div class="table-responsive makeDivScrollable">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>No.</th>
						<th>Code</th>
						<th>Name</th>
						<th>Quantity</th>
                        <th>Remove</th>
					</tr>
				</thead>
				<tbody id="Items">
				</tbody>
			</table>
		</div>
	</div>

</fieldset>
<br/>
<div>
    <div class="Warning_Info" id="w_info"></div>
</div>
<div class="row">
    <div class="col-sm-8">
		
	</div>
    <div class="col-sm-4">
		<button type="button" onclick="return addJobCard()" class="form-custom-button-columns" title ="Click to add the job card" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add New Job Card</button>
	</div>
</div>
</form>
	
<!-- PART MODAL CODE -->
		
<div class="modal fade" id="inventory_search_Modal">
<div class="modal-dialog" role="document" style="width : 80%">
<div class="modal-content">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
	<h4 class="modal-title">Add Item to Job Card</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the part type details to search for">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category_1" title ="Select the part type details to search for">
					<option value="All">All</option>
                    <option value="Abb">Abbreviation</option>
                    <option value="Name">Name</option>
                    <option value="Description">Description</option>
                    <option value="Dimension">Dimensions</option>
				</select>
			</div>	
			 <div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="method_radio2">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio2">Contains</label>
				
				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">

				</div>
				<div class="col-sm-4">
					<button onclick="return searchForItem()" class ="form-custom-button-modal" title ="Click to search for the part type"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results" title ="Select the part type">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Click to add part type to the job card">Add Part to Job Card</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
