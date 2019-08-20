<%@ Page Title="Add Component" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-12.aspx.cs" Inherits="Test._3_12" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
    <h1 class="default-form-header">Add Component</h1>
    <script src="scripts/MyScripts/tooltip.js"></script>
    <script src="scripts/bootstrap.js"></script> 
     <style>
		.tooltip-inner
		{
			 min-width:200px;
		}
    </style> 
	
<form id="UC3-12" class="form-horizontal">
	<ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#component" title ="Click to select the component tab">Component</a></li>
            <li><a data-toggle="tab" href="#supplier" title ="Click to select the suppliers tab">Supplier</a></li>
        </ul>
        <br/>
        
    <div class="tab-content">
    <div id="component" class="tab-pane fade in active">
    <fieldset>
        
        <legend>Component Information:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="comp_name" class="control-label">Component Name: </label>
				<input type="text" class="form-control" id="comp_name" placeholder="Component Name" maxlength="25" title ="Enter the component name" data-toggle ="tooltip" data-placement ="right">
			</div>
			<div class="col-sm-4">
				<label for="comp_dim" class="control-label">Component Dimensions: </label>
				<input type="text" class="form-control" id="comp_dim" placeholder="0x0x0" maxlength="40" title ="Enter the component dimensions" data-toggle ="tooltip" data-placement ="bottom">
			</div>
        </div>
        <div class="row">
            <div class="col-sm-12">
				<label for="comp_desc" class="control-label">Component Description: </label>
				<textarea class="form-control" id="comp_desc" maxlength="250" title ="Enter the component description" data-toggle ="tooltip"></textarea>
			</div>
        </div>
        <div class="row">
            <div class="col-sm-4">
				<label for="comp_price" class="control-label">Price (Average): </label>
				<input type="number" class="form-control" id="comp_price" value="00.00" step="0.01" min="0" title ="Enter the component price that will be used if no supplier price is found." data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="comp_min" class="control-label">Min. Stock Level: </label>
				<input type="number" class="form-control" id="comp_min" value="0" min="0" title ="Enter the min stock level" data-toggle ="tooltip" data-placement ="right">
			</div>
            <div class="col-sm-4">
				<label for="comp_quantity" class="control-label">Quantity Available: </label>
				<input type="number" class="form-control" id="comp_quantity" value="0" min="0" title ="Enter the quantity available" data-toggle ="tooltip" data-placement ="right">
			</div>
		</div>
	</fieldset>
        
       
        <div class="row">
		<div class="col-sm-8">

		</div>	
		<div class="col-sm-4">
            <button type = "submit" class = "form-custom-button-columns" title ="Click to add the component" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add Component</button>
		</div>
	</div>

    </div>

    <div id="supplier" class="tab-pane fade">
    <fieldset>
		<legend>Supplier Information:</legend>
			<button type="button" class="Add_extra_things" onclick="openModal()" title ="Click to assign the component to a supplier" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus" aria-hidden="true"></i> Add Supplier for Component</button>
		    <div id="supplierDetailsDiv"></div>
            
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

<div class="modal fade" id="supplierSearchModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Add Supplier</h4>
		</div>
		<div class="modal-body">
			<div class="row">
				<div class="col-sm-6">
					<input type="text" class="form-control" id="supplier_search" placeholder="Filter Results..." title ="Enter the suppliers details to search by"/>
				</div>
				<div class="col-sm-6">
					<select class="form-control" id="filter_select" title ="Select the suppliers details to search by">
						<option value="All">All</option>
						<option value="Name">Name</option>
						<option value="Email">Email</option>
                        <option value="CName">Contact Name</option>
						<option value="Contact_Number">Contact Number</option>
					</select>
				</div>
			</div>
            <div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" name="method_radio" checked>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio">Contains</label>
			
				</div>
                <div class="col-sm-4">
					<button class = "form-custom-button-modal" style="" onclick="return FilterSearch()" title ="Click to filter the search results"><i class="fa fa-check" aria-hidden="true" ></i> Filter</button>
				</div>
            </div>
			<div class="row">
				<div class="col-sm-12">
					<select multiple class="form-control" id="supplier_search_results" title ="Select the supplier">
					</select>
				</div>
			</div>
		</div>
		<div class="modal-footer">
            <button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		    <button type="button" class="btn btn-secondary modalbutton" onclick="addNewItem('AddSupplier')">Add New Supplier</button>
		    <button type="button" class="btn btn-secondary modalbutton" onclick="addSupplier()" title ="Click to assign the supplier to the component">Assign Supplier to Component</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
var suppliers = [];
var i = 0;
var searched_Suppliers;

function addSupplier()
{
	var k = $("#supplier_search_results").val();
	// console.log(k);

	if (k == "" || k == null)
	    alertify.alert('Error', 'No Supplier has been chosen!');
	else
	{
	    i++;
	    var found = false;

	    var ID = searched_Suppliers[k].Supplier_ID;

	    for (var a = 0; a < suppliers.length; a++) {
	        if (suppliers[a].Supplier_ID == ID) {

	            found = true;
	        }
	    }

	    if (found == false)
	    {
	        var s = '<div class="row" id="supplier_'+ID+'">' +
                '<div class="col-sm-4">' +
                    '<label for="supplier_name_'+ID+'" class="control-label">Supplier Name: </label>' +
                    '<input type="text" class="form-control" id="supplier_name_' + ID + '" disabled/>' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="price_' + ID + '" class="control-label">Supplier Price: </label>' +
                    '<input type="number" class="form-control" id="price_'+ID+'" value="0.00" step="0.01" min="0" title ="Enter the suppliers price"/>' +
                '</div>' +
                '<div class="col-sm-3">' +
                    '<label class="checkbox" for="supplier_pref_' + ID + '">Preferred:</label>' +
                    '<input type="checkbox" class="checkbox" id="supplier_pref_' + ID + '" title ="Select if the supplier is preferred/>' +
                '</div>' +
                '<div class="col-sm-1">' +
                    '<br />' +
                    '<button type="button" class="Add_extra_things" style="display: block; margin: 0 auto;" onclick="removeSupplier(' + ID + ')" title ="Click to remove the supplier">Remove <i class="fa fa-minus" aria-hidden="true"></i></button>' +
                '</div>' +
            '</div>';


	        var supplier = { Supplier_ID: searched_Suppliers[k].Supplier_ID, unit_price: 0, Is_Prefered: false };
	        suppliers.push(supplier);
	        //console.log(supplier);

	        $("#supplierDetailsDiv").append(s);

	        $("#supplier_name_"+ID).val(searched_Suppliers[k].Name);
	    }
	    else
	        alertify.alert('Error', 'Supplier already in list.');
	}
}
			
function removeSupplier(i)
{
	var ID = i;
	for (var a = 0; a < suppliers.length; a++) {
	    if (suppliers[a].Supplier_ID == ID) {
	        suppliers.splice(a, 1);
	    }
	}

	console.log(suppliers);
	$('#supplier_' + i).remove();
}

function openModal()
{
	$("#supplierSearchModal").modal('show');
}

function FilterSearch() {
	var filter_text = $("#supplier_search").val();
	var filter_category = $("#filter_select").val();
	var method = $('input[name=method_radio]:checked', '#supplierSearchModal').val();

	$.ajax({
	    type: "POST",
	    url: "api/SearchSupplier",
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
	            searched_Suppliers = JSON.parse(result[1]).suppliers;
	            $("#supplier_search_results").empty();
	            //console.log(searched_Suppliers);

	            if (searched_Suppliers.length == 0) {
	                $("#supplier_search_results").append("<option value=''>No results found.</option>");
	            }
	            else {
	                for (var k = 0; k < searched_Suppliers.length; k++) {
	                    var type = '<option value="' + k + '">' + searched_Suppliers[k].Name + ' - ' + searched_Suppliers[k].Contact_Name + ' - ' + searched_Suppliers[k].Contact_Number + ' - ' + searched_Suppliers[k].Email + '</option>';
	                    $("#supplier_search_results").append(type);
	                }
	            }
	        }
	        else {
	            alertify.alert('Error', result[1], function () { });
	        }
	    }
	});
}


$(document).ready(function () {

    $("#supplierDetailsDiv").on("change", "input[type=number]", function () {
        
        var total = 0;
        var i = 0;
        $('#supplierDetailsDiv').find('input[type=number]').each(function () {
            
            
            i++;
            total += parseFloat($(this).val());


        });

        console.log("total: " + total);
        //console.log("i: " + i);
        var average = total / i;

        $("#comp_price").val(average);


    });

    $("#UC3-12").submit(function (e) {
        e.preventDefault();

        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        var name = $("#comp_name").val();
        var descr = $("#comp_desc").val();
        var dimensions = $("#comp_dim").val();
        var price = $("#comp_price").val();
        var quantity = $("#comp_quantity").val();
        var min_stock = $("#comp_min").val();

        var res = false;
        
        if (quantity < 0) {
            warnings += "Quantity must be 0 or more than 0. <br/>";
            $('#comp_quantity').addClass("empty");

        }

        for (var p = 0; p < suppliers.length; p++) {
            var ID = suppliers[p].Supplier_ID;

            var isChecked = $('#supplier_pref_' + ID).is(':checked');
            var price2 = $('#price_' + ID).val();

            if (price2 < 0)
            {
                warnings += "Price is invalid. <br/>";
                $('#price_' + ID).addClass("empty");
            }
                

            suppliers[p].unit_price = price2;
            suppliers[p].Is_Prefered = isChecked;
        }

        var comp = { Quantity: quantity, Unit_Price: price, Description: descr, Dimension: dimensions, Name : name, Min_Stock : min_stock};

        $("#w_info").html(warnings);

        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/Component",
                data: { data: JSON.stringify({ component: comp, suppliers: suppliers}) },
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
                }
            });
        }

        return false;
    });

});

</script>
</asp:Content>
