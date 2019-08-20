<%@ Page Title="View Production Schedule" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-8.aspx.cs" Inherits="Test._4_8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<style>
	table td:nth-child(1) {
		font-weight: bold;
		width: 120px;
	}
			
	table .btn {
		vertical-align: middle;
		width: 100%;
		height: 110%;
	}
</style>
		
<script>	
    
    var searchedParts;

    function generateExcel()
    {

    }

	function onMore(k)
    {
	    $("#part_details_table").empty();
	    
	    var row = "<tr><td>Part:</td><td>" + searchedParts[k].Part_Serial + "</td></tr>" +
					"<tr><td>Part Type:</td><td>" + searchedParts[k].Part_Type_Name + "</td></tr>" +
					"<tr><td>Part Dimensions:</td><td>" + searchedParts[k].Part_Type_Dimension + "</td></tr>"+
	                "<tr><td>Stages:</td><td>";

                    for(x = 1; x <= searchedParts[k].Stages_Count; x++)
                    {
                        for(y = 0; y < searchedParts[k].Stages[0].recipe.length; y++)
                        {
                            if(searchedParts[k].Stages[0].recipe[y].stage == x)
                                row += searchedParts[k].Stages[0].recipe[y].stage + " - Material - " + searchedParts[k].Stages[0].recipe[y].name + ", ";
                        }

                        for (y = 0; y < searchedParts[k].Stages[0].machines.length; y++) {
                            if (searchedParts[k].Stages[0].machines[y].stage == x)
                                row += searchedParts[k].Stages[0].machines[y].stage + " - Machine - " + searchedParts[k].Stages[0].machines[y].name + ", ";
                        }

                        for(y = 0; y < searchedParts[k].Stages[0].manual.length; y++)
                        {
                            if (searchedParts[k].Stages[0].manual[y].stage == x)
                                row += searchedParts[k].Stages[0].manual[y].stage + " - Manual Labour - " + searchedParts[k].Stages[0].manual[y].name + ", ";
                        }
                        
                        if (searchedParts[k].Stages_Count == x)
                            row = row.slice(0, -2);
                    }
                
		row +=  	"</td></tr><tr><td>Order Type:</td><td>" + searchedParts[k].Order_Type + "</td></tr>" +
					"<tr><td>Job Card ID:</td><td>"+ searchedParts[k].Job_Card_ID + "</td></tr>";

	    $("#part_details_table").append(row);

	    $("#Part_Details").modal('show');
		return false;
	}
			
	function listUnusedParts()
	{
        //Fetches all parts that have status == raw OR status == in-production //ARMAND UPDATE THIS
	    $.ajax({
	        type: "GET",
	        url: "api/PartsRawProd",
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
	                searchedParts = JSON.parse(result[1]).parts;

	                $("#Unused_Parts_table").empty();

	                for (var k = 0; k < searchedParts.length; k++) {

	                    var row = "<tr><td>" + searchedParts[k].Part_Serial + "</td><td>" + searchedParts[k].Part_Type_Abbreviation + ' - ' + searchedParts[k].Part_Type_Name + "</td><td>" +
                            "<button class='Add_extra_things' onclick='return onMore(" + k + ")'><i class='fa fa-plus' aria-hidden='true'></i></button></td></tr>";

	                    $("#Unused_Parts_table").append(row);
	                }

	                $("#UnusedPartsModal").modal('show');
	            }
	            else {
	                alertify.alert('Error', result[1], function () { });
	            }
	        }
	    });

		return false;
	}
			
	jQuery(document).ready(function ($)
	{
        //Fetches the production Schedule
	    $.ajax({
	        type: "GET",
	        url: "api/ProductionSchedule",
	        error: function (xhr, ajaxOptions, thrownError) {
	            alert(xhr.status);
	            alert(xhr.responseText);
	            alert(thrownError);
	        },
	        success: function (msg) {
	            var result = msg.split("~-~");

	            if (result[0] == "true") 
	            {
	                $("#PartTypeFieldSet").append(result[1]);
	            }
	            else {
	                alertify.alert('Error', result[1], function () { });
	            }
	        }
	    });
	});
</script>

<h1 class="default-form-header">View Production Schedule</h1>
		
<form id="UC4-8" class="form-horizontal">
	<fieldset id="PartTypeFieldSet">
		<legend>Production Schedule:</legend>

	</fieldset>
			
	<br/>
	<div class="row">
		<div class="col-sm-4">
			<button class="form-custom-button-columns"><i class="fa fa-file-excel-o" aria-hidden="true"></i> Export Schedule to Excel</button>
		</div>	
		<div class="col-sm-4">
		</div>	
		<div class="col-sm-4">
			<button type="button" onclick="return listUnusedParts()" class="form-custom-button-columns"><i class="fa fa-list" aria-hidden="true"></i> List of Unused Parts</button>
		</div>	
	</div>
</form>
		
<!-- MODAL CODE -->
		
<div class="modal fade" id="UnusedPartsModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">List of Unused Parts</h4>
		</div>
		<div class="modal-body">
			<table class="table table-hover" style="background-color:white; color: #333">
				<thead>
                    <tr>
                        <th>Part</th>
					    <th>Part Type</th>
                        <th>Show More</th>
                    </tr>
				</thead>
				<tbody id="Unused_Parts_table">
				</tbody>
			</table>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
		
<div class="modal fade" id="Part_Details">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true" style="color:white">&times;</span>
			</button>
			<h4 class="modal-title">Part Details</h4>
		</div>
		<div class="modal-body">
			<table class="table" style="color: white">
				<tbody id="part_details_table">
					<tr><td>Part:</td><td>XXX333</td></tr>
					<tr><td>Part Type:</td><td>VSE Pump</td></tr>
					<tr><td>Part Dimensions:</td><td>80x60x50mm d</td></tr>
					<tr><td>Stages Left:</td><td>2 - XX-99<br/>3 - Welding<br/>4 - XX-79<br/></td></tr>
					<tr><td>Order Type:</td><td>Client</td></tr>
					<tr><td>Job Card ID:</td><td>#123</td></tr>
				</tbody>
			</table>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</asp:Content>
