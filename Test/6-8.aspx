<%@ Page Title="View Outstanding Customer Orders" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="6-8.aspx.cs" Inherits="Test._6_8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
    <script>

    var search_results;
    var vat_rate = 14;

    $(document).ready(function () {

        vat_rate = getVATRate();


        var send_data = "{'criteria' : 'NotComplete', 'category' : 'NotComplete', 'method' : 'Exact'}";

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

                    var prop = "Client_Order_ID";
                    search_results.sort(predicatBy(prop));

                    for (var k = 0; k < search_results.length; k++) {
                        var date = search_results[k].Date.split("T");

                        var row = '<tr>' +
                                    '<td>' + search_results[k].Client_Order_ID + '</td>' +
                                    '<td>' + search_results[k].Reference_ID + '</td>' +
                                    '<td>' + date[0] + '</td>' +
                                    '<td>' + search_results[k].Client_Order_Status_Name + '</td>' +
                                    '<td><button type="button" title ="Click to view order details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                                    '</tr>';

                        $("#Order_Items").append(row);
                    }
                }
                else
                    alertify.alert('Error', result[1], function () { });
            }
        });
    });


    function showMoreDetails(i) {

        $("#Items").empty();
        $("#Client_details").empty();
        $("#order_details_more").empty();
        

        var row = '';

        //row += "<tr><td></td><td></td></tr>";
        row += "<tr><td>Delivery Method: </td><td>" + search_results[i].Delivery_Method_Name + "</td></tr>";
        row += "<tr><td>Delivery Method: </td><td>" + search_results[i].Order_Type_Name + "</td></tr>";
        row += "<tr><td>Order Type Name:</td><td>" + search_results[i].Comment + "</td></tr>";

        $("#order_details_more").append(row);

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
                row = '';
                if (result[0] == "true") {
                    var client_details = JSON.parse(result[1]).clients[0];
                    
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
                    row += '<tr><td>Address</td><td>' + client_details.Address + ', ' + client_details.City + ', ' +
                        client_details.Zip + ', ' + province + '</td></tr>';

                    var contact_ID = search_results[i].Contact_ID;

                    for (var a = 0; a < client_details.contact_details.length; a++) {
                        if (client_details.contact_details[a].Contact_ID == contact_ID)
                            row += '<tr><td>Contact Details: </td><td>' + client_details.contact_details[a].Name + ' (' +
                                client_details.contact_details[a].Number + ') - ' + client_details.contact_details[a].Email_Address + '</td></tr>';
                    }

                    $("#Client_details").append(row);
                }
                else
                    alertify.alert('Error', result[1], function () { });
            }
        });

        

        var total = 0;

            $("#s_ID").html("Client Order #" + search_results[i].Client_Order_ID);
            var head = '<tr>' +
				        '<th>Code</th>' +
                        '<th>Name</th>' +
				        '<th>Quantity</th>' +
                        '<th>Quantity Delivered</th>' +
                        '<th>Discount</th>' +
				        '<th>Price</th>' +
				        '</tr>';
            $("#table2_header").empty();
            $("#table2_header").append(head);
            
            

            for (var a = 0; a < search_results[i].details.length; a++) {
                var row = '<tr>' +
				        '<td>' + search_results[i].details[a].Part_Type_ID + '</td>' +
                        '<td>' + search_results[i].details[a].Part_Type_Name + '</td>' +
				        '<td>' + search_results[i].details[a].Quantity + '</td>' +
                        '<td>' + search_results[i].details[a].Quantity_Delivered + '</td>' +
                        '<td>' + search_results[i].details[a].Client_Discount_Rate + '%</td>' +
				        '<td>' + search_results[i].details[a].Part_Price + '</td>' +
				        '</tr>';

                total += search_results[i].details[a].Part_Price * search_results[i].details[a].Quantity;
                $("#Items").append(row);
            }

            var VAT = total * vat_rate / 100;
            var total2 = VAT + total;

            row = '<tr><td></td><td></td><td></td><td></td><td>Order Total:</td><td>R ' + total.toFixed(2) + '</td></tr>'
            + '<tr><td></td><td></td><td></td><td></td><td>VAT Total:</td><td>R ' + VAT.toFixed(2) + '</td></tr>'
            + '<tr><td></td><td></td><td></td><td></td><td>Order Total with VAT:</td><td>R ' + total2.toFixed(2) + '</td></tr>';

            $("#Items").append(row);
            $("#detailsModal").modal('show');


    }

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

    <style>
        .makeDivScrollable {
            max-height: 500px;
            width: 95%;
        }

    </style>

<h1 class="default-form-header">View Outstanding Customer Orders</h1>
<div class="table-responsive makeDivScrollable">
	<table class="sortable table table-hover">
		<thead>
			<tr>
				<th>Order No</th>
                <th>Order Reference</th>
				<th>Order Date</th>
				<th>Order Status</th>
				<th>Show Details</th>
			</tr>
		</thead>
		<tbody id="Order_Items">
			
		</tbody>
	</table>
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

            <div>
                <h4>Order Details</h4>
                <div class="table-responsive results">
			            <table class="sortable table">
				            <tbody id="order_details_more">

				            </tbody>
			            </table>
		            </div> 

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
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
			<button type="button" class="btn btn-secondary modalbutton" id="maintainOrder">Maintain</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
