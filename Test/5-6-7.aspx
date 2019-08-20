<%@ Page Title="Search Supplier Quote/Order" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="5-6-7.aspx.cs" Inherits="Test._5_6_7" %>
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
    var url3 = '<%=ResolveUrl("~/Landing.aspx/search") %>';
    var search_results;
    var what;
    var vat_rate = 14;


    function clearCriteria()
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

        var send_data = "{'criteria' : '" + criteria1 + "', 'category' : '" + cat_1 + "', 'method' : '" + method + "'}";

        if (what == "Supplier Order")
        {
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

                        if (search_results.length == 0)
                            alertify.alert('Error', "No results found.", function () { });

                        $("#div_search_results").show();
                        $("#search_results").empty();

                        if (what == "Supplier Order") {
                            var head = '<tr>' +
				                        '<th>Order No.</th>' +
				                        '<th>Order Date</th>' +
				                        '<th>Order Status</th>' +
				                        '<th>Show Details</th>' +
				                        '</tr>';
                            $("#table1_header").empty();
                            $("#table1_header").append(head);

                            for (var k = 0; k < search_results.length; k++) {
                                var date = search_results[k].Date.split("T");

                                var row = '<tr>' +
                                            '<td>' + search_results[k].Supplier_Order_ID + '</td>' +
                                            '<td>' + date + '</td>' +
                                            '<td>' + search_results[k].Status_Name + '</td>' +
                                            '<td><button type="button" title = "Click to view details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                                            '</tr>';

                                $("#search_results").append(row);
                            }
                        }
                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
        } else
        {
            $.ajax({
                type: "POST",
                url: "api/SearchSupplierQuote",
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
                        search_results = JSON.parse(result[1]).supplier_quotes;

                        if (search_results.length == 0)
                            alertify.alert('Error', "No results found.", function () { });

                        $("#div_search_results").show();
                        $("#search_results").empty();

                            var head = '<tr>' +
				                        '<th>Quote No.</th>' +
				                        '<th>Quote Date</th>' +
				                        '<th>Quote Reference</th>' +
				                        '<th>Show Details</th>' +
				                        '</tr>';
                            $("#table1_header").empty();
                            $("#table1_header").append(head);

                            for (var k = 0; k < search_results.length; k++) {
                                var date = search_results[k].Supplier_Quote_Date.split("T");

                                var row = '<tr>' +
                                            '<td>' + search_results[k].Supplier_Quote_ID + '</td>' +
                                            '<td>' + date[0] + '</td>' +
                                            '<td>' + search_results[k].Supplier_Quote_Serial + '</td>' +
                                            '<td><button type="button" title = "Click to view details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                                            '</tr>';

                                $("#search_results").append(row);
                            }
                    }
                    else
                        alertify.alert('Error', result[1]);
                }
            });
        }

        return false;
    }

    function showMoreDetails(i)
    {
        $("#Quote_Items").empty();

        if (what == "Supplier Order") {
            $("#s_ID").html("Supplier Order #" + search_results[i].Supplier_Order_ID);
        }
        else {
            $("#s_ID").html("Supplier Quote #" + search_results[i].Supplier_Quote_ID);
        }
        
        var total = 0;
        //console.log(search_results[i]);

        for (var k = 0; k < search_results[i].cs.length; k++)
        {

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

            var dimensions;
            if (what == "Supplier Order") {
                dimensions = search_results[i].rms[k].Dimensions;
            }
            else {

                dimensions = search_results[i].rms[k].Dimension;
            }

            row = '<tr><td>' + search_results[i].rms[k].Raw_Material_ID + '</td><td>Raw Material</td><td>' + search_results[i].rms[k].Raw_Material_Name
                + ' (' + dimensions + ')</td><td>' + search_results[i].rms[k].Quantity + '</td><td>R ' + search_results[i].rms[k].Price + '</td></tr>';

            total = total + (search_results[i].rms[k].Price * search_results[i].rms[k].Quantity);


            $("#Quote_Items").append(row);
        }

        

        var VAT = total * vat_rate / 100;
        var total2 = VAT + total;

        row = '<tr><td></td><td></td><td></td><td>Order Total:</td><td>R ' + total + '</td></tr>'
        + '<tr><td></td><td></td><td></td><td>VAT Total:</td><td>R ' + VAT + '</td></tr>'
        + '<tr><td></td><td></td><td></td><td>Order Total with VAT:</td><td>R ' + total2 + '</td></tr>';

        $("#Quote_Items").append(row);
        $("#detailsModal").modal('show');
        
    }

$(document).ready(function ()
{
    vat_rate = getVATRate();

    $('#order_by').on('change', function () {
        var prop = $('#order_by').val();
        // console.log(prop);

        if (prop == "Date")
        {
            if (what == "Supplier Order") {
                prop = "Date"
            }
            else {
                prop = "Supplier_Quote_Date";
            }
        }
        else if (prop == "ID") {
            if (what == "Supplier Order") {
                prop = "Supplier_Order_ID"
            }
            else {
                prop = "Supplier_Quote_ID";
            }
        }

        searchResults.sort(predicatBy(prop));

        if (what == "Supplier Order") {
            for (var k = 0; k < search_results.length; k++) {
                var date = search_results[k].Date.split("T");

                var row = '<tr>' +
                            '<td>' + search_results[k].Supplier_Order_ID + '</td>' +
                            '<td>' + date + '</td>' +
                            '<td>' + search_results[k].Status_Name + '</td>' +
                            '<td><button type="button" title = "Click to view details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
                            '</tr>';

                $("#search_results").append(row);
            }
        }
        else {
            for (var k = 0; k < search_results.length; k++) {
                var date = search_results[k].Supplier_Quote_Date.split("T");

                var row = '<tr>' +
                            '<td>' + search_results[k].Supplier_Quote_ID + '</td>' +
                            '<td>' + date + '</td>' +
                            '<td>' + search_results[k].Supplier_Quote_Reference + '</td>' +
                            '<td><button type="button" title = "Click to view details" class="addToList" onclick="showMoreDetails(' + k + ')"><i class="fa fa-plus" aria-hidden="true"></i></button></td>' +
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

        if (what == "Supplier Quote")
            $("#search_category_1").html('<option value="All">All</option><option value="ID">Quote No.</option><option value="Date">Date</option><option value="Serial">Quote Serial No.</option>');
        else if (what == "Supplier Order")
            $("#search_category_1").html('<option value="All">All</option><option value="ID">Order No.</option><option value="Date">Date</option>');
    });
			
</script>

<h1 class="default-form-header">Search Purchase Order</h1>
		
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form_Supplier_Order">
		<fieldset>
		<legend>Search for Purchase Order: </legend>
			<div class="row">
				<div class="col-sm-6">
					<label for="search_criteria_1" class="control-label">Search Criteria: </label>
					<input type="text" class="form-control" id="search_criteria_1" placeholder="Search Criteria" title ="Enter what to search the purchase order by" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-6">
					<label for="search_category_1">Search By: </label>
					<select class="form-control" id="search_category_1" title ="Select what to search the purchase order by" data-toggle ="tooltip" data-placement="bottom">
						<option value="All">All</option>
                        <option value="ID">Order No.</option>
                        <option value="Date">Date</option>
					</select>
				</div>	
			</div>
			<div class="row">
                <div class="col-sm-6">
                    <label for="type">Purchase Order/Quote: </label>
					<select class="form-control" id="type" title ="Select if it's a purchase order or quote" data-toggle ="tooltip" data-placement="bottom">
						<option value="Supplier Order">Purchase Order</option>
						<option value="Supplier Quote">Supplier Quote</option>
					</select>
				</div>	
				<div class="col-sm-6">
					Search Method:
					<div class="radio">
						<label title="Select search method"><input type="radio" value="Exact" name="optradio" checked>Exact</label>
					</div>
					<div class="radio">
						<label title="Select search method"><input type="radio" value="Contains"  name="optradio">Contains</label>
					</div>

				</div>
				
			</div>
		</fieldset>
		<div class="row">
			<div class="col-sm-4">
				<button id="submitSearch" type ="button" class ="searchButton" onclick="return Search()" title ="Click to search" data-toggle ="tooltip" data-placement="right"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
			</div>
			<div class="col-sm-4">
			</div>
			<div class="col-sm-4">
				<button id="clearSearch" onclick="return ClearCriteria()" class ="searchButton" title ="Click to clear search details" data-toggle ="tooltip" data-placement="left"><i class="fa fa-refresh" aria-hidden="true"></i> Clear Criteria</button>
			</div>
		</div>
				
	</form>
</div>
		
<div id="div_search_results" style="display : none">
	<fieldset>
	<legend>Search Results: </legend>
	<div class="row">
		<div class="col-sm-4">
			<label for="order_by">Order By: </label>
			<select class="form-control" id="order_by" title ="Select how to order the search results" data-toggle ="tooltip" data-placement ="right">
				<option value="Date">Date</option>
				<option value="Supplier_Order_Status_ID">Status</option>
				<option value="ID">Reference Number</option>
			</select>
		</div>
	</div>

    <div class="table-responsive makeDivScrollable_search results">
	<table class="sortable table table-hover">
		<thead id="table1_header">
			<tr>
				<th>Order No</th>
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
			<div id="OrderDetails">
	            <div class="table-responsive results">
			            <table class="sortable table">
				            <thead id="table2_header">
					            <tr>
						            <th>Code</th>
						            <th>Inventory Type</th>
						            <th>Name</th>
						            <th>Quantity Ordered</th>
						            <th>Price</th>
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
