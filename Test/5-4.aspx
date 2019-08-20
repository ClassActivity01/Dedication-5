<%@ Page Title="Place Supplier Order" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-4.aspx.cs" Inherits="Test._5_4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<script src="scripts/MyScripts/getterScripts.js"></script>
<script src="scripts/MyScripts/tooltip.js"></script>
<script src="scripts/bootstrap.js"></script> 
<style>
 .tooltip-inner
	{
		min-width:200px;
	}
</style>  
<style>
	#ad-hoc, #quote-based, #supplier-quote-items
	{
		display:none;
	}
</style>
<script>

    //variables for regular order
var s_components = [];
var s_parts = [];
var s_raw = [];

    //variables for quote based
var s_components2 = [];
var s_parts2 = [];
var s_raw2 = [];

var what;
var searchedItems;
var supplier_ID;
var searchedSuppliers;
var item_count = 0;
var order_type;
var searchedQuotes;
var q_ID;
var order_ID = 0;
var total = 0;
var vat_rate = 14;
var quote_exp;
var i_what;

	$(document).ready(function () 
	{
	    vat_rate = getVATRate();

		$("#search_form_Quote").submit(function(event)
		{
			event.preventDefault();
			$("#ResultModal_Quote").modal('show');
					
		});
				
		$('#loadQuoteDetails').on('click', function() 
		{
			$("#supplier-quote-items").show();
			$("#ResultModal_Quote").modal('hide');
		});
				
		$('#search_category_Quote').on('change', function() 
		{
			if(this.value == "Date Range")
			{
				var range = prompt("Please enter the date range", "yyyy/mm/dd - yyyy/mm/dd");
				if (range != null) 
				{
						console.log(range);
				}
						
			}
		});
        
		
	});

	function calculateTotal2() {
	    var total = 0;

	    //Get the different inventory item values
	    for (var a = 0; a < s_components2.length; a++) {
	        var ID = s_components2[a].Component_ID;

	        var quantity = $('#quote_c_q_' + ID).val();
	        var price = s_components2[a].Price;

	        total += quantity * price;
	    }

	    for (var a = 0; a < s_raw2.length; a++) {
	        var ID = s_raw2[a].Raw_Material_ID;

	        var quantity = $('#quote_raw_q_' + ID).val();
	        var price = s_raw2[a].Price;

	        total += quantity * price;
	    }

	    for (var a = 0; a < s_parts2.length; a++) {
	        var ID = s_parts2[a].Part_Type_ID;

	        var quantity = $('#quote_p_q_' + ID).val();
	        var price = s_parts2[a].Price;

	        total += quantity * price;
	    }

	    var vat = (total * vat_rate / 100);
	    var total2 = total + vat;

	    vat = parseFloat(vat).toFixed(2);
	    total = total.toFixed(2);
	    total2 = total2.toFixed(2);

	    $("#subtotal2").html("R " + total);
	    $("#vat2").html("R " + vat);
	    $("#total2").html("R " + total2);
	}


	function searchForItem() {
	    var filter_text = $("#search_criteria").val();
	    var filter_category = $("#search_category").val();
	    what = $("#what").val();
	    var method = $('input[name=method_radio2]:checked', '#inventory_search_Modal').val();

	    if (supplier_ID == "" || supplier_ID == undefined || supplier_ID == null) {
	        alertify.alert('Error', "Cannot search if no supplier has been specified.");
	        return false;
	    }

	    if (what == "Part Type") {
	        $.ajax({
	            type: "PUT",
	            url: "api/SearchPartType/" + supplier_ID,
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

	                    if (searchedItems.length == 0) {
	                        $("#item_search_results").append("<option value=''>No results found.</option>");
	                    }
	                    else {
	                        for (var k = 0; k < searchedItems.length; k++) {
	                            var type = '<option value="' + k + '">' + searchedItems[k].Abbreviation + ' - ' + searchedItems[k].Name + '</option>';
	                            $("#item_search_results").append(type);
	                        }
	                    }
	                }
	                else { alertify.alert('Error', result[1]); }
	            }
	        });
	    } else
	        if (what == "Component") {
	            $.ajax({
	                type: "PUT",
	                url: "api/SearchComponent/" + supplier_ID,
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

	                        searchedItems = JSON.parse(result[1]).components;
	                        $("#item_search_results").empty();

	                        if (searchedItems.length == 0) {
	                            $("#item_search_results").append("<option value=''>No results found.</option>");
	                        }
	                        else {
	                            for (var k = 0; k < searchedItems.length; k++) {
	                                var type = '<option value="' + k + '">' + searchedItems[k].Name + '</option>';
	                                $("#item_search_results").append(type);
	                            }
	                        }
	                    }
	                    else { alertify.alert('Error', result[1]); }
	                }
	            });
	        } else {
	            $.ajax({
	                type: "PUT",
	                url: "api/SearchRawMaterial/" + supplier_ID,
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
	                        searchedItems = JSON.parse(result[1]).raw_materials;
	                        $("#item_search_results").empty();

	                        if (searchedItems.length == 0) {
	                            $("#item_search_results").append("<option value=''>No results found.</option>");
	                        }
	                        else {
	                            for (var k = 0; k < searchedItems.length; k++) {
	                                var type = '<option value="' + k + '">' + searchedItems[k].Name + '</option>';
	                                $("#item_search_results").append(type);
	                            }
	                        }
	                    }
	                    else { alertify.alert('Error', result[1]); }
	                }
	            });
	        }
	}

	function addItem2() {
	    var k = $("#item_search_results").val();
	    // console.log(k);

	    var price;

	    if (k == "" || k == null)
	        alertify.alert('Error', 'No Inventory Item has been chosen!');
	    else {
	        var found = false;

	        if (what == "Raw Material") {

	            var ID = searchedItems[k].Raw_Material_ID;

	            for (var a = 0; a < s_raw.length; a++) {
	                if (s_raw[a].Raw_Material_ID == ID) {

	                    found = true;
	                }
	            }

	            if (found == false) {
	                item_count++;

	                var dimensions;

	                
	                dimensions = prompt("Please enter the dimensions for the raw material. Enter N/A if unknown.", "a x b x c");
	                if (dimensions == null || dimensions == '')
	                { }
	                else
	                {

	                    price = getPrice(searchedItems[k].Raw_Material_ID, what, supplier_ID);

	                    //var rr = '<input type="number" step="0.01" id="r_u_' + searchedItems[k].Raw_Material_ID + '" value="' + price + '" disabled/>';

	                    var min_stock = "N/A";
	                    var available = getStockAvailable(searchedItems[k].Raw_Material_ID, "Raw Material");

	                    var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

	                    var supplier2 = { Raw_Material_ID: ID, Price: parseFloat(price), Dimensions: dimensions, Quantity: 1, Quantity_Received: 0 };
	                    s_raw.push(supplier2);

	                    var row = '<tr id="row_raw_' + searchedItems[k].Raw_Material_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + searchedItems[k].Name + ' (' + dimensions + ')</td>' +
                            extra +
                            '<td><input type="number" title = "Enter the quantity" id="r_q_' + searchedItems[k].Raw_Material_ID + '" min="1" max="999" value="1"/></td>' +
                            '<td><button type="button" title = "Click to remove the raw material"  class="Add_extra_things" onclick="return removeItem(&apos;Raw Material&apos;, ' + searchedItems[k].Raw_Material_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

	                    $("#Items").append(row);
	                }
	            }
	            else alertify.alert('Error', 'Raw Material already in list.');

	        }
	        else if (what == "Part Type") {
	            var ID = searchedItems[k].Part_Type_ID;

	            for (var a = 0; a < s_parts.length; a++) {
	                if (s_parts[a].Part_Type_ID == ID) {

	                    found = true;
	                }
	            }

	            if (found == false) {

	                item_count++;

	                price = getPrice(searchedItems[k].Part_Type_ID, what, supplier_ID);
	                //var rr = '<input type="number" step="0.01" id="p_u_' + searchedItems[k].Part_Type_ID + '" value="' + price + '" disabled/>';

	                var min_stock = getMinStock(searchedItems[k].Part_Type_ID, "Part Type");
	                var available = getStockAvailable(searchedItems[k].Part_Type_ID, "Part Type");

	                var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

	                var supplier2 = { Part_Type_ID: ID, Price: parseFloat(price), Quantity: 1, Quantity_Received: 0 };
	                s_parts.push(supplier2);

	                var row = '<tr id="row_part_' + searchedItems[k].Part_Type_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Part_Type_ID + '</td><td>Part Type</td><td>' + searchedItems[k].Name + '</td>' +
                        extra + 
                        '<td><input type="number" title = "Enter the quantity" id="p_q_' + searchedItems[k].Part_Type_ID + '"  min="1" max="999" value="1"/></td>' +
                        '<td><button type="button" title = "Click to remove the part type"  class="Add_extra_things" onclick="return removeItem(&apos;Part Type&apos;, ' + searchedItems[k].Part_Type_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

	                $("#Items").append(row);

	            }
	            else alertify.alert('Error', 'Part Type already in list.');
	        }
	        else if (what == "Component") {

	            var ID = searchedItems[k].Component_ID;

	            for (var a = 0; a < s_components.length; a++) {
	                if (s_components[a].Component_ID == ID) {

	                    found = true;
	                }
	            }

	            if (found == false) {

	                item_count++;

	                price = getPrice(searchedItems[k].Component_ID, what, supplier_ID);

	                //var rr = '<input type="number" step="0.01" id="c_u_' + searchedItems[k].Component_ID + '" value="' + price + '" disabled/>';

	                var min_stock = getMinStock(searchedItems[k].Component_ID, "Component");
	                var available = getStockAvailable(searchedItems[k].Component_ID, "Component");

	                var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

	                var supplier2 = { Component_ID: ID, Price: parseFloat(price), Quantity_Requested: 1, Quantity_Received: 0 };
	                s_components.push(supplier2);

	                var row = '<tr id="row_component_' + searchedItems[k].Component_ID + '"><td>' + item_count + '</td><td>' + searchedItems[k].Component_ID + '</td><td>Component</td><td>' + searchedItems[k].Name + '</td>' +
                        extra + 
                        '<td><input type="number" title = "Enter the quantity" id="c_q_' + searchedItems[k].Component_ID + '"  min="1" max="999" value="1"/></td>' +
                        '<td><button type="button" title = "Click to remove the component" class="Add_extra_things" onclick="return removeItem(&apos;Component&apos;, ' + searchedItems[k].Component_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

	                $("#Items").append(row);
	            }
	            else alertify.alert('Error', 'Component already in list.');
	        }
	    }
	}

	function openSearchInventory() {
	    $("#inventory_search_Modal").modal('show');
	}

	function removeItem(which_one, ID) {
	    item_count--;

	    if (which_one == "Raw Material") {

	        for (var a = 0; a < s_raw.length; a++) {
	            if (s_raw[a].Raw_Material_ID == ID) {
	                s_raw.splice(a, 1);
	                $('#row_raw_' + ID).remove();
	            }
	        }
	    }
	    else if (which_one == "Part Type") {

	        for (var a = 0; a < s_parts.length; a++) {
	            if (s_parts[a].Part_Type_ID == ID) {
	                s_parts.splice(a, 1);
	                $('#row_part_' + ID).remove();
	            }
	        }
	    }
	    else if (which_one == "Component") {

	        for (var a = 0; a < s_components.length; a++) {
	            if (s_components[a].Component_ID == ID) {
	                s_components.splice(a, 1);

	                $('#row_component_' + ID).remove();
	            }
	        }
	    }
	}

	function removeQuoteItem(ID, which_one)
	{
	    if (which_one == "Raw Material") {

	        for (var a = 0; a < s_raw2.length; a++) {
	            if (s_raw2[a].Raw_Material_ID == ID) {
	                s_raw2.splice(a, 1);
	                $('#row_raw_2_' + ID).remove();
	            }
	        }
	    }
	    else if (which_one == "Part Type") {

	        for (var a = 0; a < s_parts2.length; a++) {
	            if (s_parts2[a].Part_Type_ID == ID) {
	                s_parts2.splice(a, 1);
	                $('#row_p_2_' + ID).remove();
	            }
	        }
	    }
	    else if (which_one == "Component") {

	        for (var a = 0; a < s_components2.length; a++) {
	            if (s_components2[a].Component_ID == ID) {
	                s_components2.splice(a, 1);

	                $('#row_c_2_' + ID).remove();
	            }
	        }
	    }

	    calculateTotal2();

	}

	function submitQuoteOrder(what) {

	    var warnings = "";

	    var date = (new Date()).toISOString();

	    if (q_ID == null || q_ID == "") {
	        //alertify.alert("No quote has been chosen. ");
	        warnings = "No quote has been chosen. <br/>";
	    }

	    var now = new Date();
	    now.setHours(0, 0, 0, 0);

	    //console.log(quote_exp);
	    quote_exp = new Date(quote_exp);
	    quote_exp.setHours(0, 0, 0);

	    if (quote_exp < now) {
	        warnings = "Quote expired on " + quote_exp + ". Cannot place an order based on a expired quote. <br/>";
	    }

	    var order = { Date: date, Supplier_ID: parseInt(supplier_ID), Supplier_Order_Status_ID: 1, Supplier_Quote_ID: q_ID[0] };


	    if (s_components2.length == 0 && s_parts2.length == 0 && s_raw2.length == 0)
	        warnings += "There are no items on the quote. Please reload the quote by searching for it again. <br/>";

	    //Get the different inventory item values
	    for (var a = 0; a < s_components2.length; a++) {
	        var ID = s_components2[a].Component_ID;

	        var quantity = $('#quote_c_q_' + ID).val();
	        s_components2[a].Quantity_Requested = quantity;

	        if (quantity < 1)
	            warnings += "Quantity cannot be less than 1 for Component #" + ID + ". <br/>";
	    }

	    for (var a = 0; a < s_raw2.length; a++) {
	        var ID = s_raw2[a].Raw_Material_ID;

	        var quantity = $('#quote_raw_q_' + ID).val();
	        s_raw2[a].Quantity = quantity;

	        if (quantity < 1)
	            warnings += "Quantity cannot be less than 1 for Raw Material #" + ID + ". <br/>";
	    }

	    for (var a = 0; a < s_parts2.length; a++) {
	        var ID = s_parts2[a].Part_Type_ID;

	        var quantity = $('#quote_p_q_' + ID).val();

	        s_parts2[a].Quantity = quantity;

	        if (quantity < 1)
	            warnings += "Quantity cannot be less than 1 for Part Type #" + ID + ". <br/>";
	    }


	    $("#w_info2").html(warnings);

	    //NB NB NB NB NB NB MAJOR CHANGES
	    if (warnings == "") {
	        $.ajax({
	            type: "POST",
	            url: "api/SupplierOrder",
	            data: { data: JSON.stringify({ order: order, components: s_components2, parts: s_parts2, raw: s_raw2, type: 'QuoteBased', action: what }) },
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

	function submitOrder(what) {

	    var warnings = "";

	    if (supplier_ID == null || supplier_ID == "") {
	        warnings += "No Supplier has been chosen. <br/>";
	    }

	    if (s_components.length == 0 && s_parts.length == 0 && s_raw.length == 0)
	        warnings += "There are no items on the order. Please add an item. <br/>";

	    //Get the different inventory item values
	    for (var a = 0; a < s_components.length; a++) {
	        var ID = s_components[a].Component_ID;

	        var quantity = $('#c_q_' + ID).val();
	        s_components[a].Quantity_Requested = quantity;

	        if (quantity < 1)
	            warnings += "Quantity cannot be less than 0 for Component #" + ID + ". <br/>"
	    }

	    for (var a = 0; a < s_raw.length; a++) {
	        var ID = s_raw[a].Raw_Material_ID;

	        var quantity = $('#r_q_' + ID).val();
	        s_raw[a].Quantity = quantity;

	        if (quantity < 1)
	            warnings += "Quantity cannot be less than 1 for Raw Material #" + ID + ". <br/>"
	    }

	    for (var a = 0; a < s_parts.length; a++) {
	        var ID = s_parts[a].Part_Type_ID;

	        var quantity = $('#p_q_' + ID).val();
	        s_parts[a].Quantity = quantity;

	        if (quantity < 1)
	            warnings += "Quantity cannot be less than 1 for Part Type #" + ID + ". <br/>"
	    }

	    //console.log(quote);

	    $("#w_info").html(warnings);

	    var date = (new Date()).toISOString();
	    var order = { Date: date, Supplier_ID: parseInt(supplier_ID), Supplier_Order_Status_ID: 1 };

	    if (warnings == "") {
	        $.ajax({
	            type: "POST",
	            url: "api/SupplierOrder",
	            data: { data: JSON.stringify({ order: order, components: s_components, parts: s_parts, raw: s_raw, type: 'AdHoc', action: what }) },
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
    

	$("#search_form").submit(function (event) {
	    event.preventDefault();

	    var method = $('input[name=optradio_a]:checked', '#search_form').val()
	    var criteria = $('#search_criteria_a').val();
	    var category = $('#search_category_a').val();
	    order_type = $('#type_of_order').val();

	    if (order_type == "Choose")
	    {
	        $('#type_of_order').addClass("empty");
	        alertify.alert('Error', "Please specify the type of order.", function () { });
	        return false;
	    }

	    $.ajax({
	        type: "POST",
	        url: "api/SearchSupplier",
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
	                searchedSuppliers = JSON.parse(result[1]).suppliers;

	                $('#supplier_Search_Result').empty();
	                if (searchedSuppliers.length == 0) {
	                    $("#supplier_Search_Result").append("<option value=''>No results found.</option>");
	                }
	                else {
	                    for (var k = 0; k < searchedSuppliers.length; k++) {
	                        var html = '<option value="' + k + '">' + searchedSuppliers[k].Name + ' - ' + searchedSuppliers[k].Contact_Name + ' - ' + searchedSuppliers[k].Contact_Number + ' - ' + searchedSuppliers[k].Email + '</option>';

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
	    k = $('#supplier_Search_Result').val();

	    if (k == "" || k == null)
	        alertify.alert('Error', 'No Supplier has been chosen!');
	    else {

	        if (order_type == "Ad-Hoc") {
	            $("#ad-hoc").show();
	            $("#quote-based").hide();
	            order_type = "Ad-Hoc";
	        }
	        else if (order_type == "Quote-based") {
	            $("#quote-based").show();
	            $("#ad-hoc").hide();
	            order_type = "Quote-based";
	        }

	        $("#span_supplier_name").html(searchedSuppliers[k].Name);

	        $("#supplier_Name").val(searchedSuppliers[k].Name);
	        $("#supplier_ID").val(searchedSuppliers[k].Supplier_ID);

	        $("#supplier_Name_2").val(searchedSuppliers[k].Name);
	        $("#supplier_ID_2").val(searchedSuppliers[k].Supplier_ID);

	        var date = new Date().toISOString().substring(0, 10);
	        $("#quote_date_quoteBased").val(date);
	        $("#Order_date_adHoc").val(date);

	        $("#Items").empty();
	        s_components = [];
	        s_parts = [];
	        s_raw = [];

	        supplier_ID = searchedSuppliers[k].Supplier_ID;
	        $("#ResultModal").modal('hide');
	    }
	});

	$("#search_form_Quote").submit(function (event) {
	    event.preventDefault();

	    var method = $('input[name=optradio_Quote]:checked', '#search_form_Quote').val()
	    var criteria = $('#search_criteria_Quote').val();
	    var category = $('#search_category_Quote').val();

	    $.ajax({
	        type: "PUT",
	        url: "api/SearchSupplierQuote/" + supplier_ID,
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
	                searchedQuotes = JSON.parse(result[1]).supplier_quotes;

	                $('#supplier_Quote_Search_Result').empty();
	                if (searchedQuotes.length == 0) {
	                    $("#supplier_Quote_Search_Result").append("<option value=''>No results found.</option>");
	                }
	                else {
	                    for (var k = 0; k < searchedQuotes.length; k++) {
	                        var date = searchedQuotes[k].Supplier_Quote_Date.split("T");

	                        var html = '<option value="' + searchedQuotes[k].Supplier_Quote_ID + '">ID(' + searchedQuotes[k].Supplier_Quote_ID + ') - Reference (' + searchedQuotes[k].Supplier_Quote_Serial + ') - Received on: ' + date[0] + '</option>';

	                        $("#supplier_Quote_Search_Result").append(html);
	                    }
	                }
	            }
	            else
	                alertify.alert('Error', result[1], function () { });
	        }
	    });
	    $("#ResultModal_Quote").modal('show');
	});

	//On search results click
	$('#loadQuoteDetails').on('click', function () {
	    q_ID = $("#supplier_Quote_Search_Result").val();
	    
	    if (q_ID == null || q_ID == "")
	    {
	        alertify.alert("No quote has been chosen.");
	    }
	    else
	    {
	        $.ajax({
	            type: "GET",
	            url: "api/SupplierQuote/" + q_ID,
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            async: false,
	            error: function (xhr, ajaxOptions, thrownError) {
	                console.log(xhr.status);
	                console.log(xhr.responseText);
	                console.log(thrownError);
	            },
	            success: function (msg) {
	                var result = msg.split("|");

	                if (result[0] == "true")
	                {
	                    var quote_details = JSON.parse(result[1]).supplier_quotes[0];

	                    var row;

	                    $("#supplier_Name").val(quote_details.Supplier_Name);
	                    $("#supplier_ID").val(quote_details.Supplier_ID);

	                    $("#supplier_Name_2").val(quote_details.Supplier_Name);
	                    $("#supplier_ID_2").val(quote_details.Supplier_ID);
	                    supplier_ID = quote_details.Supplier_ID;

	                    quote_exp = quote_details.Supplier_Quote_Expiry_Date;

	                    var date = new Date().toISOString().substring(0, 10);
	                    $("#quote_date_quoteBased").val(date);
	                    $("#Order_date_adHoc").val(date);

	                    $("#quote_reference").val(quote_details.Supplier_Quote_Serial);

	                    $("#Quote_Items").empty();
	                    s_components2 = [];
	                    s_parts2 = [];
	                    s_raw2 = [];

	                    for (var k = 0; k < quote_details.cs.length; k++)
	                    {

	                        var min_stock = getMinStock(quote_details.cs[k].Component_ID, "Component");
	                        var available = getStockAvailable(quote_details.cs[k].Component_ID, "Component");

	                        var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

	                        row = '<tr id="row_c_2_' + quote_details.cs[k].Component_ID + '"><td>' + quote_details.cs[k].Component_ID + '</td><td>Component</td><td>' + quote_details.cs[k].Component_Name
                                + '</td>' +
                                extra + 
                                '<td><input type="number" title = "Enter the quantity" id="quote_c_q_' + quote_details.cs[k].Component_ID + '" value="' + quote_details.cs[k].Quantity_Requested + '" min="1" max="999" /></td>' +
                                '<td><button class="Add_extra_things" title = "Click to remove the component" onclick="removeQuoteItem(' + quote_details.cs[k].Component_ID + ', &quot;Component&quot;)"><i class="fa fa-minus" aria-hidden="true"></i></button></td></tr>';

	                        $("#Quote_Items").append(row);

	                        var supplier2 = { Component_ID: quote_details.cs[k].Component_ID, Price: parseFloat(quote_details.cs[k].Price), Quantity_Requested: quote_details.cs[k].Quantity_Requested, Quantity_Received: 0 };
	                        s_components2.push(supplier2);

	                    }

	                    for (var k = 0; k < quote_details.ps.length; k++) {

	                        var min_stock = getMinStock(quote_details.ps[k].Part_Type_ID, "Part Type");
	                        var available = getStockAvailable(quote_details.ps[k].Part_Type_ID, "Part Type");

	                        var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

	                        row = '<tr id="row_p_2_' + quote_details.ps[k].Part_Type_ID + '"><td>' + quote_details.ps[k].Part_Type_ID + '</td><td>Part Type</td><td>' + quote_details.ps[k].Part_Type_Name
                                + '</td><td><input type="number" title = "Enter the quantity" id="quote_p_q_' + quote_details.ps[k].Part_Type_ID + '" value="' + quote_details.ps[k].Quantity + '" min="1" max="999" /></td>' + extra +
                                '<td><button class="Add_extra_things" title = "Click to remove the part type" onclick="removeQuoteItem(' + quote_details.ps[k].Part_Type_ID + ', &quot;Part Type&quot;)"><i class="fa fa-minus" aria-hidden="true"></i></button></td></tr>';

	                        $("#Quote_Items").append(row);

	                        var supplier2 = { Part_Type_ID: quote_details.ps[k].Part_Type_ID, Price: parseFloat(quote_details.ps[k].Price), Quantity: quote_details.ps[k].Quantity, Quantity_Received: 0 };
	                        s_parts2.push(supplier2);
	                    }

	                    for (var k = 0; k < quote_details.rms.length; k++) {


	                        var min_stock = "N/A";
	                        var available = getStockAvailable(quote_details.rms[k].Raw_Material_ID, "Raw Material");

	                        var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

	                        row = '<tr id="row_raw_2_' + quote_details.rms[k].Raw_Material_ID + '"><td>' + quote_details.rms[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + quote_details.rms[k].Raw_Material_Name
                                + ' (' + quote_details.rms[k].Dimension + ')</td><td><input type="number" id="quote_raw_q_' + quote_details.rms[k].Raw_Material_ID + '" value="' + quote_details.rms[k].Quantity + '" min="1" max="999" /></td>'+extra+'</tr>';

	                        $("#Quote_Items").append(row);

	                        var supplier2 = { Raw_Material_ID: quote_details.rms[k].Raw_Material_ID, Price: quote_details.rms[k].Price, Dimensions: quote_details.rms[k].Dimension, Quantity: quote_details.rms[k].Quantity, Quantity_Received: 0 };
	                        s_raw2.push(supplier2);
	                    }

	                   
	                }
	                else
	                    alertify.alert('Error', result[1]);
	            }
	        });
	    }
	});

}); //ENd of Doc.ready

function search_inventory_alternative()
{
    var filter_text = $("#search_criteria_i").val();
    var filter_category = $("#search_category_i").val();
    i_what = $("#item_type_search").val();
    var method = $('input[name=optradio_i]:checked', '#search_form').val();

    if (i_what == "Choose")
    {
        alertify.alert('Error', "Please choose an inventory type before searching.");
        return false;
    }

    if (i_what == "Part Type") {
        $.ajax({
            type: "POST",
            url: "api/SearchPartType",
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
                    $("#item_search_results2").empty();

                    if (searchedItems.length == 0) {
                        $("#item_search_results2").append("<option value=''>No results found.</option>");
                    }
                    else {
                        for (var k = 0; k < searchedItems.length; k++) {
                            var type = '<option value="' + searchedItems[k].Part_Type_ID + '">' + searchedItems[k].Abbreviation + ' - ' + searchedItems[k].Name + '</option>';
                            $("#item_search_results2").append(type);
                        }
                    }
                }
                else { alertify.alert('Error', result[1]); }
            }
        });
    } else
        if (i_what == "Component") {
            $.ajax({
                type: "POST",
                url: "api/SearchComponent",
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

                        searchedItems = JSON.parse(result[1]).components;
                        $("#item_search_results2").empty();

                        if (searchedItems.length == 0) {
                            $("#item_search_results2").append("<option value=''>No results found.</option>");
                        }
                        else {
                            for (var k = 0; k < searchedItems.length; k++) {
                                var type = '<option value="' + searchedItems[k].Component_ID + '">' + searchedItems[k].Name + '</option>';
                                $("#item_search_results2").append(type);
                            }
                        }
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
        } else {
            $.ajax({
                type: "POST",
                url: "api/SearchRawMaterial",
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
                        searchedItems = JSON.parse(result[1]).raw_materials;
                        $("#item_search_results2").empty();

                        if (searchedItems.length == 0) {
                            $("#item_search_results2").append("<option value=''>No results found.</option>");
                        }
                        else {
                            for (var k = 0; k < searchedItems.length; k++) {
                                var type = '<option value="' + searchedItems[k].Raw_Material_ID + '">' + searchedItems[k].Name + '</option>';
                                $("#item_search_results2").append(type);
                            }
                        }
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
        }

    $("#inventory_search_Modal2").modal('show');
}

function addItem3()
{
    var r_ID = $("#item_search_results2").val();

    if (r_ID == null || r_ID == undefined || r_ID == "") {
        alertify.alert('Error', "No Item has been chosen.");
        return false;
    }
    else {

        var supplier = {
            Resource_ID: r_ID,
            i_type : i_what
        }

        var send_data = "{'Resource_ID' : '" + r_ID + "', 'i_type' : '" + i_what + "'}";

        console.log(send_data);

        $.ajax({
            type: "POST",
            url: "api/PrefSupplier",
            data: { data: send_data },
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async : false,
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status);
                console.log(xhr.responseText);
                console.log(thrownError);
            },
            success: function (msg) {
                var result = msg.split("|");

                if (result[0] == "true")
                {
                    var supplier = JSON.parse(result[1]).suppliers;

                    console.log(supplier);
                    if (supplier.length <= 0)
                    {
                        alertify.alert('Error', "No Preffered Supplier found.");
                        return false;
                    }


                    

                    $("#ad-hoc").show();
                    $("#quote-based").hide();
                    order_type = "Ad-Hoc";

                    $("#supplier_Name_2").val(supplier[0].Name);
                    $("#supplier_ID_2").val(supplier[0].Supplier_ID);

                    var date = new Date().toISOString().substring(0, 10);
                    $("#Order_date_adHoc").val(date);

                    $("#Items").empty();
                    s_components = [];
                    s_parts = [];
                    s_raw = [];

                    supplier_ID = supplier[0].Supplier_ID;

                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });

    }

    if (i_what == "Raw Material")
    {
        var Name = "";
        for (var k = 0; k < searchedItems.length; k++)
            if (searchedItems[k].Raw_Material_ID == r_ID)
                Name = searchedItems[k].Name;

        price = getPrice(r_ID, i_what, supplier_ID);

        //var rr = '<input type="number" step="0.01" id="r_u_' + searchedItems[k].Raw_Material_ID + '" value="' + price + '" disabled/>';

        var min_stock = "N/A";
        var available = getStockAvailable(r_ID, "Raw Material");

        var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

        var dimensions = "";

        while(dimensions == "")
            dimensions = prompt("Please enter the dimensions for the raw material. Enter N/A if unknown.", "a x b x c");

        var supplier2 = { Raw_Material_ID: r_ID, Price: parseFloat(price), Dimensions: dimensions, Quantity: 1, Quantity_Received: 0 };
        s_raw.push(supplier2);

        var row = '<tr id="row_raw_' + r_ID + '"><td>' + 1 + '</td><td>' + r_ID + '</td><td>Raw Material</td><td>' + Name + ' (' + dimensions + ')</td>' +
            extra +
            '<td><input type="number" title = "Enter the quantity" id="r_q_' + r_ID + '" min="1" max="999" value="1"/></td>' +
            '<td><button type="button" title = "Click to remove the raw material"  class="Add_extra_things" onclick="return removeItem(&apos;Raw Material&apos;, ' + r_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

        $("#Items").append(row);
    }
    else if (i_what == "Part Type")
    {
        var Name = "";
        for (var k = 0; k < searchedItems.length; k++)
            if (searchedItems[k].Part_Type_ID == r_ID)
                Name = searchedItems[k].Name;


        price = getPrice(r_ID, i_what, supplier_ID);
        //var rr = '<input type="number" step="0.01" id="p_u_' + searchedItems[k].Part_Type_ID + '" value="' + price + '" disabled/>';

        var min_stock = getMinStock(r_ID, "Part Type");
        var available = getStockAvailable(r_ID, "Part Type");

        var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

        var supplier2 = { Part_Type_ID: r_ID, Price: parseFloat(price), Quantity: 1, Quantity_Received: 0 };
        s_parts.push(supplier2);

        var row = '<tr id="row_part_' + r_ID + '"><td>' + 1 + '</td><td>' + r_ID + '</td><td>Part Type</td><td>' + Name + '</td>' +
            extra +
            '<td><input type="number" title = "Enter the quantity" id="p_q_' + r_ID + '"  min="1" max="999" value="1"/></td>' +
            '<td><button type="button" title = "Click to remove the part type"  class="Add_extra_things" onclick="return removeItem(&apos;Part Type&apos;, ' + r_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

        $("#Items").append(row);
    }
    else if (i_what == "Component")
    {
        var Name = "";
        for (var k = 0; k < searchedItems.length; k++)
            if (searchedItems[k].Component_ID == r_ID)
                Name = searchedItems[k].Name;

        price = getPrice(r_ID, i_what, supplier_ID);

        //var rr = '<input type="number" step="0.01" id="c_u_' + searchedItems[k].Component_ID + '" value="' + price + '" disabled/>';

        var min_stock = getMinStock(r_ID, "Component");
        var available = getStockAvailable(r_ID, "Component");

        var extra = "<td>" + available + "</td><td>" + min_stock + "</td>";

        var supplier2 = { Component_ID: r_ID, Price: parseFloat(price), Quantity_Requested: 1, Quantity_Received: 0 };
        s_components.push(supplier2);

        var row = '<tr id="row_component_' + r_ID + '"><td>' + 1 + '</td><td>' + r_ID + '</td><td>Component</td><td>' + Name + '</td>' +
            extra +
            '<td><input type="number" title = "Enter the quantity" id="c_q_' + r_ID + '"  min="1" max="999" value="1"/></td>' +
            '<td><button type="button" title = "Click to remove the component" class="Add_extra_things" onclick="return removeItem(&apos;Component&apos;, ' + r_ID + ')"><i class="fa fa-minus"></i></button></td></tr>';

        $("#Items").append(row);
    }

    item_count++;
}

</script>

<h1 class="default-form-header">Place Purchase Order</h1>
		
<div class="searchDiv">
	<form id="search_form">

        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#supplier_search" title ="Click to select the part type tab">Find Supplier</a></li>
            <li><a data-toggle="tab" href="#inventory_search" title ="Click to select the blueprint tab">Find Inventory Item</a></li> 
        </ul>

        <div class="tab-content">
        <div id="supplier_search" class="tab-pane fade in active">
		<fieldset>
		<legend>Find Supplier: </legend>
            <div class="row">
				<div class="col-sm-4">
					<label for="type_of_order">Type of Order: </label>
					<select class="form-control" id="type_of_order" title ="Select the type of order" data-toggle ="tooltip" data-placement ="right">
						<option value="Choose">Choose an option</option>
						<option>Ad-Hoc</option>
						<option>Quote-based</option>
					</select>
				</div>
            </div>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_a" placeholder="Search Criteria" title ="Enter the suppliers details to search by" data-toggle ="tooltip" data-placement ="bottom"/>
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category_a" title ="Select the suppliers details to search by" data-toggle ="tooltip" data-placement ="bottom">
                    <option value="All">All</option>
						<option value="Name">Name</option>
						<option value="Email">Email</option>
                        <option value="CName">Contact Name</option>
						<option value="Contact_Number">Contact Number</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio_a"/>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio_a"/>Contains</label>
				
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">

				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
                    <button type ="submit" class ="searchButton" title ="Click to search for the supplier" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		</fieldset>
        </div>
        
        <div id="inventory_search" class="tab-pane fade">
		<fieldset>
		<legend>Find Inventory Item: </legend>
            <div class="row">
				<div class="col-sm-4">
					<label for="item_type_search">Type of Item: </label>
					<select class="form-control" id="item_type_search" title ="Select the type of order" data-toggle ="tooltip" data-placement ="right">
						<option value="Choose">Choose an option</option>
						<option value="Raw Material">Raw Material</option>
						<option value="Part Type">Part Type</option>
                        <option value="Component">Component</option>
					</select>
				</div>
            </div>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria_i" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_i" placeholder="Search Criteria" title ="Enter the suppliers details to search by" data-toggle ="tooltip" data-placement ="bottom"/>
			</div>
			<div class="col-sm-4">
				<label for="search_category_i">Search By: </label>
				<select class="form-control" id="search_category_i" title ="Select the suppliers details to search by" data-toggle ="tooltip" data-placement ="bottom">
                    <option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Description">Description</option>
                    <option value="Dimension">Dimension</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio_i"/>Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio_i"/>Contains</label>
				
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">

				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
                    <button type ="button" onclick="return search_inventory_alternative()" class ="searchButton" title ="Click to search for the inventory item" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		</fieldset>
        </div>


        </div>
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
		<h4 class="modal-title">Select a Supplier</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="supplier_Search_Result" title ="Select a supplier">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadSupplierDetailsButton" title ="Click to load the suppliers details">Load Supplier Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
<div class="modal fade" id="ResultModal_Quote">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Select a Supplier Quote</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="supplier_Quote_Search_Result" title ="Select a supplier quote">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadQuoteDetails" title ="Click to load the quote details">Load Quote Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
<br />
<!-- FORM CODE -->
<div id="quote-based">
	<div class="searchDiv_Quote">
	<form id="search_form_Quote">
		<fieldset>
		<legend>Find Supplier Quote for Supplier <span id="span_supplier_name"></span>: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria_Quote" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria_Quote" placeholder="Search Criteria" title ="Enter the quote details to search for" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category_Quote">Search By: </label>
				<select class="form-control" id="search_category_Quote" title ="Select the quote details to search by" data-toggle ="tooltip" data-placement ="bottom">
                    <option value="All">All</option>
                    <option value="ID">Quote No. (ID)</option>
                    <option value="Date">Date</option>
                    <option value="Serial">Quote Reference No.</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio_Quote">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio_Quote">Contains</label>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
				</div>
				<div class="col-sm-4">
                    <button id="submitSearch_Quote" type ="submit" class ="searchButton" title ="Click to search for the quote" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		</fieldset>
	</form>
	</div>
	<br />		
	<div id="supplier-quote-items">
		<form id="UC5-3-quoteBased" class="form-horizontal">
		<fieldset>
			<legend>General Information of Order:</legend>
			<div class="row">
				<div class="col-sm-4">
					<label for="supplier_Name_quoteBased" class="control-label">Supplier Name: </label>
					<input type="text" class="form-control" id="supplier_Name" value="" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
				</div>
				<div class="col-sm-2">
					<label for="supplier_ID" class="control-label">Supplier No: </label>
					<input type="number" class="form-control" id="supplier_ID" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
				</div>	
				<div class="col-sm-3">
					<label for="order_date_quoteBased">Order Date: </label>
					<input type="date" class="form-control" id="quote_date_quoteBased" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
				</div>
                <div class="col-sm-3">
					<label for="order_date_quoteBased">Quote Reference: </label>
					<input type="text" class="form-control" id="quote_reference" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
				</div>
			</div>
		</fieldset>
			<br />	
		<fieldset>
			<legend>Items on Quote</legend>
			<div class="table-responsive makeDivScrollable">
				<table class="sortable table table-hover">
					<thead>
						<tr>
							<th>Code</th>
							<th>Inventory Type</th>
							<th>Name</th>
                            <th>Stock available</th>
                            <th>Min Stock Level</th>
							<th>Quantity</th>
                            <th>Remove</th>
						</tr>
					</thead>
					<tbody id="Quote_Items">
						
					</tbody>
				</table>
			</div> 
		</fieldset>
			<br/>

        <div class="row">
	        <div class="col-sm-12">
                <div class="Warning_Info" id="w_info2"></div>
	        </div>
	    </div>    

		<div class="row">
			<div class="col-sm-4">
			</div>	
			<div class="col-sm-4">
                <button type="button" onclick="return submitQuoteOrder('email');" class="form-custom-button-columns"title ="Click to add and email purchase order" data-toggle ="tooltip" data-placement ="left" ><i class="fa fa-envelope-o" aria-hidden="true"></i> Add & Email Quote Based Purchase Order</button>
			</div>
			<div class="col-sm-4">
				<button type="button" onclick="return submitQuoteOrder('process');" class="form-custom-button-columns" title ="Click to add purchase order" data-toggle ="tooltip"><i class="fa fa-check" aria-hidden="true"></i> Add Quote Based Purchase Order</button>
			</div>
		</div>
		</form>
	</div>
			
			
</div>
		
		
		
<div id="ad-hoc">
<form id="UC5-3-adHoc" class="form-horizontal">
<fieldset>
	<legend>General Information of Order:</legend>
	<div class="row">
		<div class="col-sm-4">
			<label for="supplier_Name_2" class="control-label">Supplier Name: </label>
			<input type="text" class="form-control" id="supplier_Name_2" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
		</div>
		<div class="col-sm-2">
			<label for="supplier_ID_2" class="control-label">Supplier No: </label>
			<input type="number" class="form-control" id="supplier_ID_2" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
		</div>	
		<div class="col-sm-6">
			<label for="Order_date_adHoc">Order Date: </label>
			<input type="date" class="form-control" id="Order_date_adHoc" title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom" disabled>
		</div>
	</div>
</fieldset>
		
<br/>
<fieldset id="itemsFieldset">
	
	<legend>Add Item to Order:</legend>
    <button type="button" class="Add_extra_things" onclick="return openSearchInventory()" title ="Click to add items to purchase order" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus"></i> Add Item</button>
		<h4>Items on order:</h4>
		<div class="table-responsive makeDivScrollable">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>Item No.</th>
						<th>Item Code</th>
                        <th>Inventory Type</th>
						<th>Item Name</th>
                        
                        <th>Stock available</th>
                        <th>Min Stock Level</th>
                        <th>Quantity</th>
                        <th>Remove</th>
					</tr>
				</thead>
				<tbody id="Items">
				</tbody>
			</table>
		</div>
</fieldset>

    <br/>

    <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	</div>     

    <div class="row">
	    <div class="col-sm-offset-4 col-sm-4">
            <button type="button" onclick="return submitOrder('email');" class="form-custom-button-columns" title ="Click to add and email purchase order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-envelope-o" aria-hidden="true"></i> Add and Email Purchase Order</button>
	    </div>	
	    <div class="col-sm-4">
		    <button type="button" onclick="return submitOrder('process');" class="form-custom-button-columns" title ="Click to add purchase order" data-toggle ="tooltip"><i class="fa fa-check" aria-hidden="true"></i> Add New Purchase Order</button>
	    </div>
    </div>
</form>
</div>

<div class="modal fade" id="inventory_search_Modal">
<div class="modal-dialog" role="document" style="width : 80%">
<div class="modal-content">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
	<h4 class="modal-title">Add Item to Order</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the inventory item details to search for">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the inventory item details to search by">
					<option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Description">Description</option>
				</select>
			</div>	
			<div class="col-sm-4">
                <label for="what">Search For: </label>
				<select class="form-control" id="what" title ="Select the inventory item  type">
					<option value="Part Type">Part Type</option>
                    <option value="Component">Component</option>
                    <option value="Raw Material">Raw Material</option>
				</select>
			</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title="Select the search method"><input type="radio" value="Exact" name="method_radio2" checked>Exact</label>
					<label class="radio-inline" title="Select the search method"><input type="radio" value="Contains" name="method_radio2">Contains</label>
					
				</div>
				<div class="col-sm-4">
					<button id="submitSearch" onclick="return searchForItem()" class ="form-custom-button-modal" title ="Click to search for inventory item"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results" title ="Select the inventory item">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Click to add the inventory item">Add Inventory Item Order</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="inventory_search_Modal2">
<div class="modal-dialog" role="document" style="width : 60%">
<div class="modal-content">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
	<h4 class="modal-title">Select an item</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results2" title ="Select the inventory item">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem3()" title ="Click to add the inventory item">Add Inventory Item Order</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
