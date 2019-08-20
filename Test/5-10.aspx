<%@ Page Title="Generate Goods Returned Note" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-10.aspx.cs" Inherits="Test._5_10" %>
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
    var return_Items = [];

    var order_ID;
    var searchedOrders;

    function submitReturnNote(what) {
        //event.preventDefault();

        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        if (order_ID == null || order_ID == "") {
            warnings += "No Purchase Order has been chosen. <br/>";
        }

        //Get the different inventory item values
        for (var a = 0; a < return_Items.length; a++)
        {
            var ID = return_Items[a].Inventory_ID;
            var type = return_Items[a].Type_of_Inventory;

            if (type == "Component")
            {
                var quantity = $('#c_return_' + ID).val();
                return_Items[a].Units_Returned = quantity;

                if (quantity < 0)
                {

                    warnings += "Quantity cannot be less than 0 for Component #" + ID + ". <br/>";
                    $('#c_return_' + ID).addClass("empty");
                }
            }
            else if (type == "Unique Raw Material")
            {
                var flag = $('#r_return_' + ID).is(":checked");

                if(flag == true)
                    return_Items[a].Units_Returned = 1;
            }
            else if (type == "Part")
            {
                var flag = $('#p_return_' + ID).is(":checked");

                if (flag == true)
                    return_Items[a].Units_Returned = 1;
            }
        }

        // console.log(return_Items);

        var invoice = $('#supplier_order_invoice').val();
        var del_note = $('#supplier_order_delivery').val();
        var comment =  $('#Return_comment').val();

        if (invoice.trim().length <= 0)
        {
            $('#supplier_order_invoice').addClass("empty");
            warnings = warnings + "No Invoice number has been specified. <br/>";
        }

        if (del_note.trim().length <= 0) {
            $('#supplier_order_delivery').addClass("empty");
            warnings = warnings + "No Delivery Note Number has been specified. <br/>";
        }

        if (comment.trim().length <= 0) {
            $('#Return_comment').addClass("empty");
            warnings = warnings + "No Comments has been specified. <br/>";
        }

        //console.log(quote);

        $("#w_info").html(warnings);

        var date = (new Date()).toISOString();

        var note = {Date_of_Return: date, Invoice_Number: invoice, Delivery_Note_Number: del_note, Comment: comment, sr : return_Items, action: what};

        //alert(JSON.stringify(note));

        if (warnings == "") {
            $.ajax({
                type: "PUT",
                url: "api/ReturnSupplier/" + order_ID,
                data: { data: JSON.stringify(note) },
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
    }

$(document).ready(function () {
    $.ajax({
        type: "GET",
        url: "api/SupplierOrderStatus",
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
                var status = JSON.parse(result[1]).supplier_order_statuses;

                //console.log(status);
                $('#order_status').empty();

                for (var k = 0; k < status.length; k++) {
                    var html = '<option value="' + status[k].Supplier_Order_Status_ID + '">' + status[k].Name + '</option>';

                    $("#order_status").append(html);
                }
            }
            else
                alertify.alert('Error', result[1], function () { });
        }
    });


    $("#search_form").submit(function (event) {
        event.preventDefault();

        var method = $('input[name=optradio]:checked', '#search_form').val()
        var criteria = $('#search_criteria').val();
        var category = $('#search_category').val();

        $.ajax({
            type: "POST",
            url: "api/SearchSupplierOrder",
            data: { data: "{'method': '" + method + "', 'criteria' : '" + criteria + "', 'category' : '" + category + "'}" },
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
                    searchedOrders = JSON.parse(result[1]).supplier_orders;
                    $('#supplier_Search_Result').empty();

                    if (searchedOrders.length == 0) {
                        $("#supplier_Search_Result").append("<option value=''>No results found.</option>");
                    }
                    else {
                        for (var k = 0; k < searchedOrders.length; k++) {
                            var date = searchedOrders[k].Date.split("T");
                            var html = '<option value="' + searchedOrders[k].Supplier_Order_ID + '">' + searchedOrders[k].Supplier_Order_ID + ' - ' + searchedOrders[k].Supplier_Name + ' (' + date[0] + ')</option>';

                            $("#supplier_Search_Result").append(html);
                        }
                    }
                }
                else
                    alertify.alert('Error', result[1], function () { });
            }
        });
        $("#ResultModal").modal('show');
    });

    //On search results click
    $('#loadSupplierDetailsButton').on('click', function () {
        order_ID = $("#supplier_Search_Result").val();

        if (order_ID == null || order_ID == "") {
            alertify.alert("No Purchase Order has been chosen.");
        }
        else {
            $.ajax({
                type: "GET",
                url: "api/SupplierOrder/" + order_ID,
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
                        var order_details = JSON.parse(result[1]).supplier_orders[0];

                        console.log(order_details);

                        var row;
                        $("#Order_Items").empty();
                        var total = 0;

                        var date = order_details.Date.split("T");

                        $("#supplier_Name").val(order_details.Supplier_Name);
                        $("#supplier_ID").val(order_details.Supplier_ID);
                        $("#Order_date").val(date[0]);
                        $("#order_ID").val(order_ID);

                        var value = order_details.Supplier_Order_Status_ID;
                        $("#order_status > option[value='" + value + "']").prop("selected", true);

                        $("#ResultModal").modal('hide');
                        //Components
                        for (var k = 0; k < order_details.cs.length; k++) {

                            row = '<tr><td>' + order_details.cs[k].Component_ID + '</td><td>Component</td><td>' + order_details.cs[k].Component_Name
                                + '</td><td>' + order_details.cs[k].Quantity_Received + '</td><td><input type="number" id="c_return_' +
                                order_details.cs[k].Component_ID + '" value="0" min="0" max="' + order_details.cs[k].Quantity_Received + '"/></td></tr>';

                            //total = total + (order_details.sqc[k].Price * order_details.sqc[k].Quantity_Requested);

                            var item = { Type_of_Inventory: "Component", Inventory_ID: order_details.cs[k].Component_ID, Units_Returned: 0, Item_Name: order_details.cs[k].Component_Name };
                            return_Items.push(item);

                            $("#Order_Items").append(row);
                        }

                        for (var k = 0; k < order_details.rms.length; k++)
                        {

                            row = '<tr><td>' + order_details.rms[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + order_details.rms[k].Raw_Material_Name
                                    + '</td><td>' + order_details.rms[k].Quantity_Received + '</td><td><input type="number" id="r_quantity_' +
                                    order_details.rms[k].Raw_Material_ID + '" disabled value="0"/></td></tr>';

                            $("#Order_Items").append(row);

                            for(var j = 0; j < order_details.rms[k].unique.length; j++)
                            {
                                row = '<tr><td></td><td>Dimensions (' + order_details.rms[k].unique[j].Dimension + ') ID: ' + order_details.rms[k].unique[j].Unique_Raw_Material_ID + '</td><td>' 
                                    + '</td><td>1</td><td><input type="checkbox" data-type="Raw" data-id="' + order_details.rms[k].Raw_Material_ID + '" id="r_return_' +
                                    order_details.rms[k].unique[j].Unique_Raw_Material_ID + '"/></td></tr>';

                                //total = total + (order_details.sqc[k].Price * order_details.sqc[k].Quantity_Requested);

                                var item = { Type_of_Inventory: "Unique Raw Material", Inventory_ID: order_details.rms[k].Raw_Material_ID, Units_Returned: 0, Item_Name: order_details.rms[k].Raw_Material_Name };
                                return_Items.push(item);

                                $("#Order_Items").append(row);
                            }
                        }

                        for (var k = 0; k < order_details.ps.length; k++)
                        {

                            row = '<tr><td>' + order_details.ps[k].Part_Type_ID + '</td><td>Part Type</td><td>' + order_details.ps[k].Part_Type_Name
                               + '</td><td>'+ order_details.ps[k].Quantity_Received + '</td><td><input type="number" id="p_quantity_' +
                               order_details.ps[k].Part_Type_ID + '" disabled value="0"/></td></tr>';

                            $("#Order_Items").append(row);

                            for (var j = 0; j < order_details.ps[k].parts.length; j++)
                            {
                                row = '<tr><td></td><td>Part</td><td> Part Serial: ' + order_details.ps[k].parts[j].Part_Serial
                                + '</td><td></td><td><input type="checkbox" data-type="Part" data-id="' + order_details.ps[k].Part_Type_ID + '" id="p_return_' +
                                order_details.ps[k].parts[j].Part_ID + '"/></td></tr>';

                                //total = total + (order_details.sqc[k].Price * order_details.sqc[k].Quantity_Requested);

                                var item = { Type_of_Inventory: "Part", Inventory_ID: order_details.ps[k].parts[j].Part_ID, Units_Returned: 0, Item_Name: order_details.ps[k].Part_Type_Name };
                                return_Items.push(item);

                                $("#Order_Items").append(row);
                            }
                        }

                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
        }

        $("#div_5_10").show();
    });

    $("#Order_Items").on('change', 'input[type=checkbox]', function(){
        var input = $(this);

        if (input.is(":checked")) {
            if (input.attr("data-type") == "Raw") {
                var ID = input.attr("data-id");
                var quantity = parseInt($("#r_quantity_" + ID).val()) + 1;
                $("#r_quantity_" + ID).val(quantity);
            }
            else {
                var ID = input.attr("data-id");
                var quantity = parseInt($("#p_quantity_" + ID).val()) + 1;
                $("#p_quantity_" + ID).val(quantity);

            }

        }
        else {
            if (input.attr("data-type") == "Raw") {
                var ID = input.attr("data-id");
                var quantity = $("#r_quantity_" + ID).val() - 1;
                $("#r_quantity_" + ID).val(quantity);
            }
            else {
                var ID = input.attr("data-id");
                var quantity = $("#p_quantity_" + ID).val() - 1;
                $("#p_quantity_" + ID).val(quantity);

            }
        }
    
    });
});
</script>

<h1 class="default-form-header">Generate Goods Returned Note</h1>

<div class="searchDiv">
<form id="search_form">
	<fieldset>
	<legend>Search for Purchase Order: </legend>
		<div class="row">
		<div class="col-sm-4">
			<label for="search_criteria" class="control-label">Search Criteria: </label>
			<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the purchase order details to seach for" data-toggle ="tooltip" data-placement ="bottom"/>
		</div>
		<div class="col-sm-4">
			<label for="search_category">Search By: </label>
			<select class="form-control" id="search_category" title ="Select the purchase order details to seach by" data-toggle ="tooltip" data-placement ="bottom">
				<option value="All">All</option>
                <option value="ID">Supplier Order No.</option>
                <option value="Date">Date</option>
			</select>
		</div>	
		<div class="col-sm-4">
				<label class="control-label">Search Method: </label><br/>
				<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio">Exact</label>
				<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>
				
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
			</div>
			<div class="col-sm-4">
			</div>
			<div class="col-sm-4">
                <button id="submitSearch" type ="submit" class ="searchButton" title ="Select to search for the purchase order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
		</div>
	</fieldset>
</form>
</div>
		
<!-- MODAL CODE -->
		
<div class="modal fade" id="ResultModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Select a Purchase Order</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="supplier_Search_Result" title ="Select a purchase order">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadSupplierDetailsButton" title ="Click to load the purchase order details">Load Order Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

    <br />
<div id="div_5_10" style="display : none">
<form id="UC5-10" class="form-horizontal">
	<fieldset>
		<legend>General Information of Order:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="supplier_Name" class="control-label">Supplier Name: </label>
				<input type="text" class="form-control" id="supplier_Name" disabled>
			</div>
			<div class="col-sm-2">
				<label for="supplier_ID" class="control-label">Supplier No: </label>
				<input type="number" class="form-control" id="supplier_ID" disabled>
			</div>	
			<div class="col-sm-3">
				<label for="Order_date_adHoc">Order Date: </label>
				<input type="date" class="form-control" id="Order_date" disabled>
			</div>
			<div class="col-sm-3">
				<label for="order_ID">Reference Number: </label>
				<input type="text" class="form-control" id="order_ID" disabled>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="order_status">Order Status: </label>
				<select class="form-control" id="order_status" disabled>

				</select>
			</div>
			<div class="col-sm-4">
				<label for="supplier_order_delivery" class="control-label">Delivery Note Number: </label>
				<input type="text" class="form-control" id="supplier_order_delivery" placeholder="0000000" maxlength="20" title ="Enter the delivery note number" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="supplier_order_invoice" class="control-label">Invoice Number: </label>
				<input type="text" class="form-control" id="supplier_order_invoice" placeholder="0000000000" maxlength="20" title ="Enter the invoice number" data-toggle ="tooltip" data-placement ="bottom">
			</div>	
		</div>
	</fieldset>
    <br />
    <fieldset>
		<legend>Items Ordered:</legend>
		<div class="table-responsive">
				<table class="sortable table table-hover">
					<thead>
						<tr>
							<th>Code</th>
							<th>Inventory Type</th>
							<th>Name</th>
                            <th>Quantity Received</th>
							<th>Return?</th>
						</tr>
					</thead>
					<tbody id="Order_Items">
					</tbody>
				</table>
			</div> 
	</fieldset>

    <div class="row">
		<div class="col-sm-12">
			<label for="Return_comment">Comment on Returns:</label>
			<textarea class="form-control" rows="5" id="Return_comment" maxlength="255" title ="Enter the reason for return" data-toggle ="tooltip" data-placement ="bottom"></textarea>
		</div>
	</div>
    <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	</div>     
    <div class="row">
		<div class="col-sm-offset-4 col-sm-4">
            <button type="button" onclick="return submitReturnNote('email');" class="form-custom-button-columns" title ="Click to generate and email return note" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-envelope-o" aria-hidden="true"></i> Generate & Email Return Note</button>
		</div>	
		<div class="col-sm-4">
			<button type="button" onclick="return submitReturnNote('process');" class="form-custom-button-columns" title ="Click to generate return note" data-toggle ="tooltip"><i class="fa fa-reply" aria-hidden="true"></i> Generate Return Note</button>
		</div>
	</div>

</form>
</div>

</asp:Content>
