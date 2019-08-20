<%@ Page Title="Search Customer Quotes/Orders" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-9-10.aspx.cs" Inherits="Test._6_9_10" %>
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

    var search_results;
    var what;
    var vat_rate = 14;
    var obj = {};
    var extra;

    function ClearCriteria()
    {
        $('#search_criteria_1').val("");
        $("#search_category_1 > option[value='Choose']").prop("selected", true);

        return false;

    }

    function Search() {
        var criteria1 = $('#search_criteria_1').val();
        var cat_1 = $('#search_category_1').val();
        var method = $('input[name=optradio]:checked', '#search_form_Supplier_Order').val();

        what = $('#type').val();

        var send_data = "{'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "', 'method' : '" + method +"'}";

        if (what == "Client Order")
        {
            $.ajax({
                type: "POST",
                url: "api/SearchCustomerOrder",
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
                        search_results = JSON.parse(result[1]).client_orders;

                        if (search_results.length == 0)
                            alertify.alert('Error', "No results found.", function () { });

                        $("#div_search_results").show();
                        $("#search_results").empty();

                            var head = '<tr>' +
                                        '<th>Order No.</th>' +
                                        '<th>Reference</th>' +
                                        '<th>Date</th>' +
                                        '<th>Delivery Method</th>' +
                                        '<th>Order Type</th>' +
                                        '<th>Status</th>' +
                                        '<th>Show Details</th>' +
                                        '</tr>';
                            $("#table1_header").empty();
                            $("#table1_header").append(head);

                            for (var k = 0; k < search_results.length; k++) {
                                var date = search_results[k].Date.split("T");

                                var row = '<tr>' +
                                            '<td>' + search_results[k].Client_Order_ID + '</td>' +
                                            '<td>' + search_results[k].Reference_ID + '</td>' +
                                            '<td>' + date[0] + '</td>' +
                                            '<td>' + search_results[k].Delivery_Method_Name + '</td>' +
                                            '<td>' + search_results[k].Order_Type_Name + '</td>' +
                                            '<td>' + search_results[k].Client_Order_Status_Name + '</td>' +
                                            '<td><button type="button" title ="Click to view details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                                            '</tr>';

                                $("#search_results").append(row);
                            }
                        
                    }
                    else
                        alertify.alert('Error', result[1], function () { });
                }
            });
        } else
        {
            $.ajax({
                type: "POST",
                url: "api/SearchCustomerQuote",
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
                        search_results = JSON.parse(result[1]).client_quotes;

                        if (search_results.length == 0)
                            alertify.alert('Error', "No results found.", function () { });

                        $("#div_search_results").show();
                        $("#search_results").empty();

                        var head = '<tr>' +
				                    '<th>Quote No</th>' +
				                    '<th>Date</th>' +
                                    '<th>Settlement Discount Rate</th>' +
				                    '<th>Show Details</th>' +
				                    '</tr>';
                        $("#table1_header").empty();
                        $("#table1_header").append(head);

                        for (var k = 0; k < search_results.length; k++) {
                            var date = search_results[k].Date.split("T");

                            var row = '<tr>' +
                                        '<td>' + search_results[k].Client_Quote_ID + '</td>' +
                                        '<td>' + date[0] + '</td>' +
                                        '<td>' + search_results[k].details[0].Settlement_Discount_Rate + '</td>' +
                                        '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                                        '</tr>';

                            $("#search_results").append(row);
                        }
                    }
                    else
                        alertify.alert('Error', result[1], function () { });
                }
            });
        }

        return false;
    }

    function showMoreDetails(i)
    {
        $("#Items").empty();
        $("#Client_details").empty();

        var client_details;
        //GET CLIENT DETAILS
        var client_ID = search_results[i].Client_ID;
        $.ajax({
            type: "GET",
            url: "api/Customer/"+client_ID,
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
                    client_details = JSON.parse(result[1]).clients[0];
                    var row = '';
                    var province;
                    switch (client_details.Province_ID) {
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

                    row += '<tr><td>Name:</td><td>' + client_details.Name + '</td></tr>';
                    row += '<tr><td>Account Number:</td><td>' + client_details.Account_Name + '</td></tr>';
                    row += '<tr><td>Address:</td><td>' + client_details.Address + ', ' + client_details.City + ', ' + 
                        client_details.Zip + ', ' + province + '</td></tr>';

                    var contact_ID = search_results[i].Contact_ID;

                    obj.client = client_details;

                    for (var a = 0; a < client_details.contact_details.length; a++)
                    {
                        if (client_details.contact_details[a].Contact_ID == contact_ID)
                        {
                            row += '<tr><td>Contact Details: </td><td>' + client_details.contact_details[a].Name + ' (' +
                                client_details.contact_details[a].Number + ') - ' + client_details.contact_details[a].Email_Address + '</td></tr>';

                            obj.c_name = client_details.contact_details[a].Name;
                            obj.c_num = client_details.contact_details[a].Number;

                        }
                            
                    }
                    
                    $("#Client_details").append(row);
                }
                else
                    alertify.alert('Error', result[1], function () { });
            }
        });

        var total = 0;
        if (what == "Client Order")
        {
            $("#s_ID").html("Client Order #" + search_results[i].Client_Order_ID);
            var head = '<tr>' +
				        '<th>Code</th>' +
                        '<th>Name</th>' +
				        '<th>Quantity</th>' +
                        '<th>Quantity Delivered</th>' +
                        '<th>Discount</th>' +
				        '<th>Price VAT Exlc.</th>'+
				        '</tr>';
            $("#table2_header").empty();
            $("#table2_header").append(head);

            var row = '';

            row += '<h4>Order Details</h4><div class="table-responsive results"><table class="sortable table"><tbody id="order_details_more">';
            row += "<tr><td>Delivery Method: </td><td>" + search_results[i].Delivery_Method_Name + "</td></tr>";
            row += "<tr><td>Delivery Method: </td><td>" + search_results[i].Order_Type_Name + "</td></tr>";
            row += "<tr><td>Order Type Name:</td><td>" + search_results[i].Comment + "</td></tr>";
            row += '</tbody></table></div>';

            $("#order_extra").empty();
            $("#order_extra").html(row);
            $("#order_extra").show();

            $.ajax({
                type: "GET",
                url: "api/OrderExtra/"+search_results[i].Client_Order_ID,
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

                    if (result[0] == "true") {
                        extra = JSON.parse(result[1]).order[0].delivery;

                        console.log(extra);
                        
                        $("#del_notes").empty();

                        for (var a = 0; a < extra.length; a++)
                        {
                            var date = extra[a].Date.split("T");
                            row = "<tr>" +
                                "<td>" + extra[a].Delivery_Note_ID + "</td>" +
                                "<td>" + date[0] + "</td>" +
                                "<td><button type='button' class='addToList' onclick='loadDeliveryNote(" + a + ")'><i class='fa fa-plus' aria-hidden='true'></i></button></td>" +
                                "</tr>";

                            $("#del_notes").append(row);
                        }

                        $("#order_extra_del").show();

                    }
                    else {

                    }
                }
                });
            

            var names = [];

            for (var a = 0; a < search_results[i].details.length; a++)
            {
                row = '<tr>' +
				        '<td>' + search_results[i].details[a].Part_Type_ID + '</td>' +
                        '<td>' + search_results[i].details[a].Part_Type_Name + '</td>' +
				        '<td>' + search_results[i].details[a].Quantity + '</td>' +
                        '<td>' + search_results[i].details[a].Quantity_Delivered + '</td>' +
                        '<td>' + search_results[i].details[a].Client_Discount_Rate + '%</td>' +
				        '<td>' + search_results[i].details[a].Part_Price + '</td>' +
				        '</tr>';

                total += search_results[i].details[a].Part_Price * search_results[i].details[a].Quantity;
                $("#Items").append(row);
                names.push(search_results[i].details[a].Part_Type_Name);
            }

            obj.s_parts = search_results[i].details;
            obj.p_names = names;
            obj.Order_ID = search_results[i].Client_Order_ID;
            obj.VAT_Exemp = search_results[i].VAT_Inclu;
            obj.Reference = search_results[i].Reference_ID;
            obj.VAT = vat_rate;
            obj.order_type = search_results[i].Client_Order_Type_ID;

            var VAT = total * vat_rate / 100;
            var total2 = VAT + total;

            row = '<tr><td></td><td></td><td></td><td></td><td>Sub Total:</td><td>R ' + total.toFixed(2) + '</td></tr>'
            + '<tr><td></td><td></td><td></td><td></td><td>VAT:</td><td>R ' + VAT.toFixed(2) + '</td></tr>'
            + '<tr><td></td><td></td><td></td><td></td><td>Order Total :</td><td>R ' + total2.toFixed(2) + '</td></tr>';

            $("#Items").append(row);
            $("#detailsModal").modal('show');

        }
        else {
            $("#s_ID").html("Client Quote #" + search_results[i].Client_Quote_ID);

            var head = '<tr>' +
				        '<th>Code</th>' +
                        '<th>Name</th>' +
				        '<th>Quantity</th>' +
                        '<th>Discount</th>' +
				        '<th>Price VAT Excl.</th>' +
				        '</tr>';
            $("#table2_header").empty();
            $("#table2_header").append(head);

            var names = [];

            for (var a = 0; a < search_results[i].details.length; a++) {

                //console.log(search_results[i].details[a]);

                var row = '<tr>' +
				        '<td>' + search_results[i].details[a].Part_Type_ID + '</td>' +
                        '<td>' + search_results[i].details[a].Part_Type_Name + '</td>' +
				        '<td>' + search_results[i].details[a].Quantity + '</td>' +
                        '<td>' + search_results[i].details[a].Client_Discount_Rate + '%</td>' +
				        '<td>' + search_results[i].details[a].Part_Price + '</td>' +
				        '</tr>';

                total += search_results[i].details[a].Part_Price * search_results[i].details[a].Quantity;
                $("#Items").append(row);
                names.push(search_results[i].details[a].Part_Type_Name);
            }

            obj.s_parts = search_results[i].details;
            obj.p_names = names;
            obj.Quote_ID = search_results[i].Client_Quote_ID;
            obj.VAT = vat_rate;

            var VAT = total * vat_rate / 100;
            var total2 = VAT + total;

            row = '<tr><td></td><td></td><td></td><td>Sub Total:</td><td>R ' + total.toFixed(2) + '</td></tr>'
            + '<tr><td></td><td></td><td></td><td>VAT:</td><td>R ' + VAT.toFixed(2) + '</td></tr>'
            + '<tr><td></td><td></td><td></td><td>Order Total :</td><td>R ' + total2.toFixed(2) + '</td></tr>';

            $("#Items").append(row);
            $("#detailsModal").modal('show');
        }
    }

    function print()
    {
        if (what == "Client Order") {
            var url_ = '<%=ResolveUrl("~/customer_order.html") %>';
            var w = window.open(url_);
            w.passed_obj = obj;
        }
        else {

            var url_ = '<%=ResolveUrl("~/Quote.html") %>';
            var w = window.open(url_);
            w.passed_obj = obj;
        }
        

    }

    function loadDeliveryNote(i)
    {
        var thing = "<h4>Delivery #"+extra[i].Delivery_Note_ID+" Note Details</h4>" +
        "<div class='table-responsive results'>" +
            "<table class='sortable table'>" +
                "<thead>" +
                    "<tr>" +
                        "<th>Code</th>" +
                        "<th>Item Name</th>" +
                        "<th>Quantity Delivered</th>" +
                        "<th>Price VAT Excl.</th>" +
                    "</tr>" +
                "</thead>" +
                "<tbody>";

        for (var a = 0; a < extra[i].delivery_note_details.length; a++)
        {
            thing += "<td>" + extra[i].delivery_note_details[a].Part_Type_Abbreviation + "</td>" +
                "<td>" + extra[i].delivery_note_details[a].Part_Type_Name + "</td>" +
                "<td>" + extra[i].delivery_note_details[a].Quantity_Delivered + "</td>" +
                "<td>" + extra[i].delivery_note_details[a].Part_Price + "</td>";
        }

                
        thing += "</tbody>" +
            "</table>" +
        "</div>" +
        "<h4>Invoices tied to Delivery Note</h4>" +
        "<div class='table-responsive results'>" +
            "<table class='sortable table'>" +
                "<thead>" +
                    "<tr>" +
                        "<th>Invoice No.</th>" +
                        "<th>Invoice Date</th>" +
                        "<th>Sub Total</th>" +
                        "<th>VAT</th>" +
                        "<th>Total</th>" +
                    "</tr>" +
                "</thead>" +
                "<tbody>";

        for (var a = 0; a < extra[i].invoice.length; a++)
        {

            var vat = extra[i].invoice[a].Amount_Vat - extra[i].invoice[a].Amount;

            thing += "<tr>" +
                        "<td>" + extra[i].invoice[a].Invoice_ID + "</td>" +
                        "<td>" + extra[i].invoice[a].Date + "</td>" +
                        "<td>" + extra[i].invoice[a].Amount + "</td>" +
                        "<td>"+vat+"</td>" +
                        "<td>" + extra[i].invoice[a].Amount_Vat + "</td>" +
                    "</tr>";
        }

        thing += "</tbody>" +
            "</table>" +
        "</div>";

        

        $("#del_body").html(thing);
        $("#delivery_note_modal").modal('show');


    }

$(document).ready(function ()
{
    vat_rate = getVATRate();

    $('#order_by').on('change', function () {
        var prop = $('#order_by').val();
        // console.log(prop);

        search_results.sort(predicatBy(prop));
        $("#search_results").empty();

        if (what == "Client Order") {
            var head = '<tr>' +
                        '<th>Order ID</th>' +
                        '<th>Reference</th>' +
                        '<th>Date</th>' +
                        '<th>Delivery Method</th>' +
                        '<th>Order Type</th>' +
                        '<th>Status</th>' +
                        '<th>Show Details</th>' +
                        '</tr>';
            $("#table1_header").empty();
            $("#table1_header").append(head);

            for (var k = 0; k < search_results.length; k++) {
                var date = search_results[k].Date.split("T");

                var row = '<tr>' +
                            '<td>' + search_results[k].Client_Order_ID + '</td>' +
                            '<td>' + search_results[k].Reference_ID + '</td>' +
                            '<td>' + date[0] + '</td>' +
                            '<td>' + search_results[k].Delivery_Method_Name + '</td>' +
                            '<td>' + search_results[k].Order_Type_Name + '</td>' +
                            '<td>' + search_results[k].Client_Order_Status_Name + '</td>' +
                            '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                            '</tr>';

                $("#search_results").append(row);
            }
        }
        else {
            var head = '<tr>' +
                        '<th>Quote ID</th>' +
                        '<th>Date</th>' +
                        '<th>Settlement Discount Rate</th>' +
                        '<th>Show Details</th>' +
                        '</tr>';
            $("#table1_header").empty();
            $("#table1_header").append(head);

            for (var k = 0; k < search_results.length; k++) {
                var date = search_results[k].Date.split("T");

                var row = '<tr>' +
                            '<td>' + search_results[k].Client_Quote_ID + '</td>' +
                            '<td>' + date[0] + '</td>' +
                            '<td>' + search_results[k].Settlement_Discount_Rate + '</td>' +
                            '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                            '</tr>';

                $("#search_results").append(row);
            }
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

    $(document).on('change', '#type', function () {
        var what = $("#type").val();

        if (what == "Client Quote")
            $("#search_category_1").html('<option value="All">All</option><option value="ID">Customer Quote No.</option><option value="CName">Customer Name</option>');
        else if (what == "Client Order")
            $("#search_category_1").html('<option value="All">All</option><option value="ID">Reference No.</option><option value="CID">Customer Order No.</option><option value="CName">Customer Name</option>');
    });

			
</script>

<h1 class="default-form-header">Search Customer Quotes/Orders</h1>
		
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form_Supplier_Order">
		<fieldset>
		<legend>Search: </legend>
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter the customer order/quote details to search for" data-toggle ="tooltip" data-placement ="right"/>
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select the customer order/quote details to search by" data-toggle ="tooltip" data-placement ="bottom">
                        <option value="All">All</option>
                        <option value="ID">Reference No.</option>
                        <option value="CID">Customer Order No.</option>
                        <option value="CName">Customer Name</option>
					</select>
				</div>	
			</div>
			<div class="row">
                <div class="col-sm-6">
                    <label for="type">Order/Quote: </label>
					<select class="form-control" id="type"title ="Select to search order or quote" data-toggle ="tooltip" data-placement ="bottom" >
						<option value="Client Order">Customer Order</option>
						<option value="Client Quote">Customer Quote</option>
					</select>
				</div>	
				<div class="col-sm-6">
					Search Method:
					<div class="radio">
						<label title ="Select the search method" data-toggle ="tooltip" data-placement ="right"><input type="radio" value="Exact" checked name="optradio"/>Exact</label>
					</div>
					<div class="radio">
						<label title ="Select the search method" data-toggle ="tooltip" data-placement ="right"><input type="radio" value="Contains" name="optradio"/>Contains</label>
					</div>

				</div>
			</div>
		</fieldset>
		<div class="row">
			<div class="col-sm-4">
				<button id="submitSearch" type ="button" class ="searchButton" onclick="return Search()" title ="Click to search for customer order/quote" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-4">
			</div>
			<div class="col-sm-4">
				<button id="clearSearch" onclick="return ClearCriteria()" class ="searchButton" title ="Click to clear search details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>
		
<div id="div_search_results" style="display : none">
	<fieldset>
	<legend>Search Results: </legend>
	<div class="row">
		<div class="col-sm-4">
			<label for="order_by">Order by: </label>
			<select class="form-control" id="order_by" title ="Select how to sort searched results" data-toggle ="tooltip" data-placement ="right">
                <option value="OrderBY">Order By</option>
				<option value="Date">Date</option>
				<option value="Client_Order_Status_ID">Status</option>
				<option value="Reference_ID">Reference Number</option>
			</select>
		</div>
	</div>

    <div class="table-responsive makeDivScrollable_search results">
	<table class="sortable table table-hover">
		<thead id="table1_header">
			<tr>
				<th>Order ID</th>
				<th>Order Date</th>
				<th>Order Status</th>
				<th>Show Details</th>
			</tr>
		</thead>
		<tbody id="search_results">
		</tbody>
	</table>
</div> 

	</fieldset>	
</div>
		



<div class="modal fade" id="detailsModal">
	<div class="modal-dialog" role="document" style="width : 80%">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title"><span id="s_ID"></span></h4>
		</div>
		<div class="modal-body">
            <div>
                <h4>Client Details</h4>
                <div class="table-responsive results">
			            <table class="sortable table">
				            <tbody id="Client_details">

				            </tbody>
			            </table>
		            </div> 
            </div>

            <div id="order_extra" style="display : none">
                

            </div>

			<div id="OrderDetails">
                <h4>Items on Quote/Order</h4>
	            <div class="table-responsive results">
			            <table class="sortable table">
				            <thead id="table2_header">
					            <tr>
						            <th>Code</th>
						            <th>Name</th>
                                    <th>Discount</th>
						            <th>Quantity Ordered</th>
						            <th>Price</th>
					            </tr>
				            </thead>
				            <tbody id="Items">

				            </tbody>
			            </table>
		            </div> 
            </div>

            <div id="order_extra_del" style="display : none">
                <h4>Delivery Notes</h4>
                <div class="table-responsive results">
			            <table class="sortable table">
                            <thead>
                                <tr>
                                    <th>Del. Note No.</th>
                                    <th>Date</th>
                                    <th>Show More</th>
                                </tr>
                            </thead>
				            <tbody id="del_notes">

				            </tbody>
			            </table>
		            </div> 

            </div>

		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
			<button type="button" class="btn btn-secondary modalbutton" onclick="print()" title ="Click to print this">Print</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="delivery_note_modal">
	<div class="modal-dialog" role="document" style="width : 80%">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
		</div>
		<div class="modal-body" id="del_body">
            
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
