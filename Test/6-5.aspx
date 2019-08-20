<%@ Page Title="Generate Delivery Note" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-5.aspx.cs" Inherits="Test._6_5" %>
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
    var client_ID;
    var contact_details = [];
    var s_parts = [];
    var s_parts2 = [];
    var client_details;
    var item_count = 0;
    var order_ID;
    var searchedOrders;
    var orderDetails;
    var vat_rate = 14;

    $(document).ready(function () {

        $.ajax({
            type: "GET",
            url: "api/CustomerOrderStatus",
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
                    var status = JSON.parse(result[1]).order_statuses;

                    $('#order_status').empty();

                    for (var k = 0; k < status.length; k++) {
                        var html = '<option value="' + status[k].Client_Order_Status_ID + '">' + status[k].Name + '</option>';

                        $("#order_status").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });

        $.ajax({
            type: "GET",
            url: "api/DeliveryMethod",
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
                    var delivery = JSON.parse(result[1]).delivery_methods;

                    $('#del_method').empty();

                    for (var k = 0; k < delivery.length; k++) {
                        var html = '<option value="' + delivery[k].Delivery_Method_ID + '">' + delivery[k].Name + '</option>';

                        $("#del_method").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });

        $.ajax({
            type: "GET",
            url: "api/CustomerOrderType",
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
                    var order = JSON.parse(result[1]).client_order_types;

                    $('#order_type').empty();

                    for (var k = 0; k < order.length; k++) {
                        var html = '<option value="' + order[k].Client_Order_Type_ID + '">' + order[k].Type + '</option>';

                        $("#order_type").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });



        //On search
        $("#search_form").submit(function (event) {
            event.preventDefault();

            var method = $('input[name=optradio]:checked', '#search_form').val();
            var criteria = $('#search_criteria').val();
            var category = $('#search_category').val();

            $.ajax({
                type: "POST",
                url: "api/SearchCustomerOrder",
                data: { data: "{'method': '" + method + "', 'criteria' : '" + criteria + "', 'category' : '" + category + "'}" },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg) {
                    var result = msg.split("|");

                    if (result[0] == "true") {
                        searchedOrders = JSON.parse(result[1]).client_orders;

                        $('#order_Search_Result').empty();
                        if (searchedOrders.length == 0) {
                            $("#order_Search_Result").append("<option value=''>No results found.</option>");
                        }
                        else {
                            for (var k = 0; k < searchedOrders.length; k++) {

                                var date = searchedOrders[k].Date.split("T");


                                var html = '<option value="' + searchedOrders[k].Client_Order_ID + '">#' + searchedOrders[k].Client_Order_ID + ' - ' + searchedOrders[k].Client_Name + ' (' +
                                    date[0] + ')</option>';

                                $("#order_Search_Result").append(html);
                            }
                        }
                    }
                    else alertify.alert("Error", result[1]);
                }
            });
            $("#ResultModal").modal('show');
        });

        //On search results click
        $('#loadOrderDetails').on('click', function () {
            order_ID = $('#order_Search_Result').val();

            if (order_ID == "" || order_ID == null)
                alertify.alert('Error', 'No Client Order has been chosen!');
            else {
                $.ajax({
                    type: "GET",
                    url: "api/CustomerOrder/"+order_ID,
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
                            orderDetails = JSON.parse(result[1]).client_orders[0];

                            $("#ord_ref_number").val(orderDetails.Reference_ID);

                            var value = orderDetails.Client_Order_Type_ID;
                            $("#order_type > option[value='" + value + "']").prop("selected", true);

                            value = orderDetails.Delivery_Method_ID;
                            $("#del_method > option[value='" + value + "']").prop("selected", true);

                            value = orderDetails.Client_Order_Status_ID;
                            $("#order_status > option[value='" + value + "']").prop("selected", true);

                            $("#order_comment").val(orderDetails.Comment);

                            if (orderDetails.VAT_Inclu == true)
                                $("#order_vat").prop("checked", true);
                            $("#ResultModal").modal('hide');

                            $("#Items").empty();

                            for (var a = 0; a < orderDetails.details.length; a++) {
                                var ID = orderDetails.details[a].Part_Type_ID;

                                item_count++;

                                var stock = orderDetails.details[a].Stock_Available;

                                if (stock > orderDetails.details[a].Quantity - orderDetails.details[a].Quantity_Delivered)
                                    stock = orderDetails.details[a].Quantity - orderDetails.details[a].Quantity_Delivered;

                                var supplier2 = { Client_Order_Detail_ID: orderDetails.details[a].Client_Order_Detail_ID,
                                    Quantity_Delivered : 0
                                };
                                s_parts.push(supplier2);

                                var ss = {
                                    Part_Type_ID: orderDetails.details[a].Part_Type_ID, Part_Type_Name: orderDetails.details[a].Part_Type_Name, Quantity: orderDetails.details[a].Quantity, Quantity_Delivered: orderDetails.details[a].Quantity_Delivered, Part_Price: orderDetails.details[a].Part_Price,
                                    Client_Discount_Rate: orderDetails.details[a].Client_Discount_Rate, Client_Order_Detail_ID: orderDetails.details[a].Client_Order_Detail_ID
                                }
                                s_parts2.push(ss);

                                var row = '<tr id="row_part_' + ID + '"><td>' + item_count + '</td><td>' + ID + '</td><td>' + orderDetails.details[a].Part_Type_Name + '</td><td>' + orderDetails.details[a].Quantity
                                    + '</td><td>' + orderDetails.details[a].Quantity_Delivered  +
                                    '</td><td>'+stock+'</td><td><input type="number" title = "Quantity delivered" value="0" id="del_'+ID+'" min="0" max="'+stock+'" /></td></tr>';

                                $("#Items").append(row);
                            }


                            $("#div_6_5").css('visibility', 'visible');
                            client_ID = orderDetails.Client_ID;
                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });

                $.ajax({
                    type: "GET",
                    url: "api/Customer/"+client_ID,
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
                            client_details = JSON.parse(result[1]).clients[0];

                            $("#client_name").val(client_details.Name);
                            $('#Contact_details').empty();

                            var c_ID_pos = 0;

                            for (var p = 0; p < client_details.contact_details.length; p++) {
                                var detail = {
                                    Contact_ID: client_details.contact_details[p].Contact_ID,
                                    Name: client_details.contact_details[p].Name, Number: client_details.contact_details[p].Number,
                                    Email_Address: client_details.contact_details[p].Email_Address
                                };

                                contact_details.push(detail);

                                if (client_details.contact_details[p].Contact_ID == orderDetails.Contact_ID) {
                                    c_ID_pos = p;
                                    $("#client_cont_num").val(contact_details[p].Number);
                                    $("#client_email").val(contact_details[p].Email_Address);
                                }

                                var html = '<option value="' + p + '">' + client_details.contact_details[p].Name + '</option>';

                                $('#Contact_details').append(html);
                            }

                            $("#Contact_details > option[value='" + c_ID_pos + "']").prop("selected", true);


                            var end = client_details.Address + ", " + client_details.City;
                            $('#Directions').html(client_details.Name + " Start: WME, End: " + end);
                            //console.log(end);
                            calcRoute(end);

                        }
                        else
                            alertify.alert('Error', result[1]);
                    }
                });
            }
        });

        $("#Contact_details").on('change', function () {
            var k = $("#Contact_details").val();
            $("#client_cont_num").val(contact_details[k].Number);
            $("#client_email").val(contact_details[k].Email_Address);
        });
    });


    function generateDeliveryNote(what)
    {
        var warnings = "";

        if (order_ID == "" || order_ID == null) {
            warnings = warnings + "No Customer Order has been specified. <br/>";
        }

        var date = (new Date()).toISOString();

        var flag = false;

        for (var a = 0; a < s_parts.length; a++) {
            var ID = s_parts2[a].Part_Type_ID;

            var delivery = $('#del_' + ID).val();
            s_parts2[a].Quantity_Delivered = delivery;

            var max = $('#del_' + ID).attr('max');

            if (delivery > max)
            {
                warnings += "Cannot deliver more than " + max + " for part type #" + ID + ". <br/>";
                $('#del_' + ID).addClass("empty");

            }

            if (delivery > 0)
                flag = true;
            
            if(delivery < 0)
            {
                warnings += "Cannot have a delivery amount of less than 0 for part type #" + ID + ". <br/>";
                $('#del_' + ID).addClass("empty");

            }
        }

        if (flag == false)
            warnings += "Cannot generate an empty delivery note. Please specify items to be delivered. <br/>";

        var client_email = $("#client_email").val();
        var delivery = { details: s_parts2, Delivery_Note_Date: date, Client_Order_ID: parseInt(order_ID), action: what, email: client_email };

        $("#w_info").html(warnings);
        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/DeliveryNote",
                data: { data: JSON.stringify(delivery) },
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
                        var d_ID = result[2];

                        if (what == 'print')
                        {
                            for (var a = 0; a < s_parts2.length; a++) {
                                var ID = s_parts2[a].Part_Type_ID;

                                var delivery = $('#del_' + ID).val();
                                s_parts2.Quantity_Delivered = delivery;

                            }

                            var c = $("#Contact_details").val();
                            var ref = $("#ord_ref_number").val();
                            var c_ID = contact_details[c].Contact_ID;
                            var name;
                            var num;

                            for (var p = 0; p < client_details.contact_details.length; p++) {

                                if (client_details.contact_details[p].Contact_ID == c_ID) {
                                    name = client_details.contact_details[p].Name;
                                    num = client_details.contact_details[p].Number;
                                }
                            }

                            var obj = { client : client_details, s_parts : s_parts2, Del_Note_ID :  d_ID, c_name : name, c_num: num};

                            var url_ = '<%=ResolveUrl("~/Delivery_Note.html") %>';
                            var w = window.open(url_);
                            w.passed_obj = obj;
                            w.print();
                        }

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
</script>

<h1 class="default-form-header">Generate Delivery Note</h1>
		
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Customer Order: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the customer order details to search for" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the customer order details to search by" data-toggle ="tooltip" data-placement ="bottom">
					<option value="All">All</option>
					<option value="ID">Reference No.</option>
					<option value="CID">Customer Order No.</option>
					<option value="CName">Customer Name</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="optradio">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="optradio">Contains</label>
					
				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
				</div>
				<div class="col-sm-4">
					<button id="submitSearch" type ="submit" class ="searchButton" title ="Click to search for customer order" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Customer Order</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="order_Search_Result" title ="Select the customer order">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadOrderDetails" title ="Click to load the order details">Load Order Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->


<br />
<div id="div_6_5" style="visibility: hidden">	
<form id="UC6-5" class="form-horizontal">
<fieldset>
	<legend>Customer Information:</legend>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_name" class="control-label">Customer Name: </label>
			<input type="text" class="form-control" id="client_name" readonly>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<label for="client_contact" class="control-label">Contact Name: </label>
			<select class="form-control" id="Contact_details" readonly>
			</select>
		</div>
        <div class="col-sm-6">
		</div>
    </div>
    <div class="row">
		<div class="col-sm-6">
			<label for="client_cont_num" class="control-label">Contact Number: </label>
			<input type="text" class="form-control" id="client_cont_num" readonly>
		</div>
		<div class="col-sm-6">
			<label for="client_email" class="control-label">Contact Email: </label>
			<input type="email" class="form-control" id="client_email" readonly>
		</div>
	</div>
</fieldset>
<br />

<style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 100%;
      }
      .direction_panel
      {
         overflow-y: auto;
         max-height: 300px;
      }
</style>
<fieldset id="Google_Maps_Div">
    <legend>Direction to <span id="Directions"></span></legend>
    <div class="row" >
        <div class="col-md-4">
            <div id="directionpanel" class="direction_panel"></div>
        </div>
            <div class="col-md-8">
                <div id="map" style="height: 300px" title ="Customer address" data-toggle ="tooltip" data-placement ="left"></div>
        </div>

    </div>
</fieldset>
<script type="text/javascript">
var calcRoute;
$(document).ready(function () {
    //my house = -25.864344, 28.182986
    var map;

    var contentString = '<div id="content">' +
        '<div id="siteNotice">' +
        '</div>' +
        '<h1 id="firstHeading" class="firstHeading">Walter Meano Engineering</h1>' +
        '<div id="bodyContent">' +
        '</div>' +
        '</div>';

    var directionsDisplay;
    var googleMapsLoaded = false;
    var directionsService = new google.maps.DirectionsService();

    function initialize() {
        directionsDisplay = new google.maps.DirectionsRenderer();
        var latlng = new google.maps.LatLng(-26.205267, 28.164622);
        var myOptions = {
            zoom: 15,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map"), myOptions);
        var marker = new google.maps.Marker
        (
            {
                position: new google.maps.LatLng(-26.205267, 28.164622),
                map: map,
                title: 'Click me'
            }
        );
        var infowindow = new google.maps.InfoWindow({
            content: contentString
        });
        google.maps.event.addListener(marker, 'click', function () {
            // Calling the open method of the infoWindow 
            infowindow.open(map, marker);
        });

        google.maps.event.addListener(map, 'tilesloaded', function () {
            googleMapsLoaded = true;
            //clear the listener, we only need it once
            google.maps.event.clearListeners(map, 'tilesloaded');
        });


        directionsDisplay.setMap(map);
        directionsDisplay.setPanel(document.getElementById('directionpanel'));
    }

    calcRoute = function(end) {

        var start = "Cnr of Acquila and Orion, Germiston";
        var request = {
            origin: start,
            destination: end,
            travelMode: google.maps.DirectionsTravelMode.DRIVING
        };
        directionsService.route(request, function (response, status) {
            if (status == google.maps.DirectionsStatus.OK) {
                directionsDisplay.setDirections(response);
            }
        });
    }

    function resizeMap() {
        google.maps.event.trigger(map, 'resize');
        map.setZoom(map.getZoom());
    }

    initialize();
    resizeMap();
    setTimeout(function () {
        if (!googleMapsLoaded) {
            //$("#Google_Maps_Div").hide();
                   
        }
    }, 7000);


});

        
        

</script>
<script type="text/javascript"
src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBtTzbdL52326fNTwIJFXhKl7Ph6LDkszw&libraries=geometry,places">
</script>



<br/>
<fieldset>
	<legend>Order Information:</legend>
				
	<div class="row">
		<div class="col-sm-6">
			<label for="ord_ref_number" class="control-label" >Reference Number: </label>
			<input type="text" class="form-control" id="ord_ref_number" readonly>
		</div>
		<div class="col-sm-6">
			<label for="order_vat" class="control-label" >VAT Included: </label><br/>
			<input type="checkbox" id="order_vat" checked disabled>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-4">
			<label for="del_method" class="control-label" >Delivery Method: </label>
			<select id="del_method" class="form-control" disabled>
				<option>Partial Delivery</option>
				<option>Full Delivery</option>
			</select>
		</div>
		<div class="col-sm-4">
			<label for="order_type" class="control-label" >Order Type: </label>
			<select id="order_type" class="form-control" disabled>
				<option>Cash Sale</option>
				<option>Contracted Sale</option>
			</select>
		</div>
        <div class="col-sm-4">
			<label for="order_status" class="control-label" >Order Type: </label>
			<select id="order_status" class="form-control" disabled>
			</select>
		</div>
	</div>
    <div class="row">
		<div class="col-sm-12">
			<label for="order_commentw" class="control-label">Order Comments: </label>
			<textarea class="form-control" id="order_comment" disabled></textarea>
		</div>
	</div>
</fieldset>
	<br />		
<fieldset id="partsFieldset">
	<legend>Order Items Information:</legend>
	<div id="parts">
        <br/>
		<div class="table-responsive makeDivScrollable">
			<table class="table table-hover" >
				<thead>
					<tr>
						<th>No.</th>
						<th>Code</th>
						<th>Name</th>
						<th>Quantity</th>
                        <th>Delivered</th>
                        <th>Stock Available</th>
                        <th>To Deliver</th>
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
	<div class="col-sm-4">

	</div>
	<div class="col-sm-4">
		<button onclick="return generateDeliveryNote('print')" class = "form-custom-button-columns" title ="Click to print the delivery note" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-print" aria-hidden="true"></i> Print Delivery Note</button>
	</div>	
	<div class="col-sm-4">
		<button onclick="return generateDeliveryNote('email')" class = "form-custom-button-columns" title ="Click to email the delivery note" data-toggle ="tooltip"><i class="fa fa-envelope-o" aria-hidden="true"></i> Email Delivery Note</button>
	</div>
</div>
</form>
</div>
</asp:Content>
