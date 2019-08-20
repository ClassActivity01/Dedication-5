<%@ Page Title="View Outstanding Purchase Orders" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-9.aspx.cs" Inherits="Test._5_9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<script>
    var search_results;

    $(document).ready(function () {
        var send_data = "{'criteria' : 'NotComplete', 'category' : 'NotComplete', 'method' : 'Exact'}";

        $.ajax({
            type: "POST",
            url: "api/SearchSupplierOrder",
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
                    search_results = JSON.parse(result[1]).supplier_orders;

                    for (var k = 0; k < search_results.length; k++) {
                        var date = search_results[k].Date.split("T");

                        var row = '<tr>' +
                                    '<td>' + search_results[k].Supplier_Order_ID + '</td>' +
                                    '<td>' + date + '</td>' +
                                    '<td>' + search_results[k].Status_Name + '</td>' +
                                    '<td><button type="button" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                                    '</tr>';

                        $("#Items").append(row);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });
    });


    function showMoreDetails(i) {
        $("#Quote_Items").empty();

        $("#s_ID").html("Purchase Order #" + search_results[i].Supplier_Order_ID);

        var total = 0;
        //console.log(search_results[i]);

        for (var k = 0; k < search_results[i].cs.length; k++) {

            row = '<tr><td>' + search_results[i].cs[k].Component_ID + '</td><td>Component</td><td>' + search_results[i].cs[k].Component_Name
                + '</td><td>' + search_results[i].cs[k].Quantity_Requested + '</td><td>R ' + search_results[i].cs[k].Price + '</td></tr>';

            total = total + (search_results[i].cs[k].Price * search_results[i].cs[k].Quantity_Requested);


            $("#Quote_Items").append(row);
        }

        for (var k = 0; k < search_results[i].ps.length; k++) {

            row = '<tr><td>' + search_results[i].ps[k].Part_Type_ID + '</td><td>Part Type</td><td>' + search_results[i].ps[k].Part_Type_Name
                + '</td><td>' + search_results[i].ps[k].Quantity + '</td><td>R ' + search_results[i].ps[k].Price + '</td></tr>';

            total = total + (search_results[i].ps[k].Price * search_results[i].ps[k].Quantity);


            $("#Quote_Items").append(row);
        }

        for (var k = 0; k < search_results[i].rms.length; k++) {

            var dimensions = search_results[i].rms[k].Dimensions;


            row = '<tr><td>' + search_results[i].rms[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + search_results[i].rms[k].Raw_Material_Name
                + ' (' + dimensions + ')</td><td>' + search_results[i].rms[k].Quantity + '</td><td>R ' + search_results[i].rms[k].Price + '</td></tr>';

            total = total + (search_results[i].rms[k].Price * search_results[i].rms[k].Quantity);


            $("#Quote_Items").append(row);
        }

        var vat_rate = getVATRate();

        var VAT = total * vat_rate / 100;
        var total2 = VAT + total;

        row = '<tr><td></td><td></td><td></td><td>Sub Total:</td><td>R ' + total + '</td></tr>'
        + '<tr><td></td><td></td><td></td><td>VAT:</td><td>R ' + VAT + '</td></tr>'
        + '<tr><td></td><td></td><td></td><td>Order Total:</td><td>R ' + total2 + '</td></tr>';

        $("#Quote_Items").append(row);
        $("#detailsModal").modal('show');

    }
</script>

<h1 class="default-form-header">View Outstanding Purchase Orders</h1>
<div class="table-responsive makeDivScrollable">
	<table class="sortable table table-hover">
		<thead>
			<tr>
				<th>Order No.</th>
				<th>Order Date</th>
				<th>Order Status</th>
				<th>Show Details</th>
			</tr>
		</thead>
		<tbody id="Items">
			
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
			<div id="OrderDetails">
	            <div class="table-responsive makeDivScrollable results">
			            <table class="sortable table">
				            <thead id="table2_header">
					            <tr>
						            <th>Code</th>
						            <th>Inventory Type</th>
						            <th>Name</th>
						            <th>Quantity Ordered</th>
						            <th>Price R(Vat Exlc.)</th>
					            </tr>
				            </thead>
				            <tbody id="Quote_Items">

				            </tbody>
			            </table>
		            </div> 
            </div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal">Close</button>
			<button type="button" class="btn btn-secondary modalbutton" id="maintainOrder">Maintain</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

</asp:Content>
