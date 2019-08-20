<%@ Page Title="Maintain Job Card" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-2.aspx.cs" Inherits="Test._4_2" %>
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
    var job_cards;
    var job_cards_statuses;
    var details = [];
    var job_card_ID;
    var index;

    $(document).ready(function () {

        $.ajax({
            type: "GET",
            url: "api/JobCard",
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
                    job_cards = JSON.parse(result[1]).job_cards;

                    for (var k = 0; k < job_cards.length; k++)
                    {
                        var date = job_cards[k].Job_Card_Date.split("T");


                        var row = '<tr>'+
						            '<td>' + job_cards[k].Job_Card_ID + '</td>' +
						            '<td>' + date[0] + '</td>'+
						            '<td>' + job_cards[k].Job_Card_Status_Name + '</td>' +
						            '<td>' + job_cards[k].Job_Card_Priority_Name + ' Order</td>' +
						            '<td><button onclick="return loadJobCard('+ k +')" class="Add_extra_things" title ="Click to load job card details"><i class="fa fa-plus"></i></button></td>'+
					            '</tr>';

						$("#listOfJobCards").append(row);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });

        $.ajax({
            type: "GET",
            url: "api/JobCardStatus",
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
                    job_cards_statuses = JSON.parse(result[1]).job_card_statuses;

                    for (var k = 0; k < job_cards_statuses.length; k++) {

                        var row = '<option value="' + job_cards_statuses[k].Job_Card_Status_ID + '">' + job_cards_statuses[k].Name + '</option>';
                        $("#jobCard_status").append(row);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });


        $("#UC4-2").submit(function (e)
        {
            e.preventDefault();

            var warnings = "";

            for (var a = 0; a < details.length; a++)
            {
                var quantity = $("#p_q_" + details[a].Part_Type_ID).val();

                details[a].Remove_Quantity = quantity;
            }

            var job = { Job_Card_Status_ID: $("#jobCard_status").val(), details : details };

            if (warnings == "")
            {
                $.ajax({
                    type: "PUT",
                    url: "api/JobCard/" + job_card_ID,
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
                    }
                });

            }

            return false;
        });


        $("#jobCardItems").on("change", ":input[type='number']", function ()
        {
            var quantity = $(this).val();
            var part_type_ID = $(this).attr("data-part_type_ID");

            $.ajax({
                type: "POST",
                url: "api/CheckPartRemove",
                data: { data: "{'part_type_ID' : '" + part_type_ID + "', 'quantity' : '" + quantity + "', 'job_card_ID' : '" + job_card_ID + "'}" },
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

                    }
                    else
                        $("#w_info").html(result[1]);
                }
            });
        });

    });

    function loadJobCard(i)
    {
        job_card_ID = job_cards[i].Job_Card_ID;
        index = i;

        $("#item_ID").html("#" + job_card_ID + " ");

        $("#jobCardItems").empty();

        for (var a = 0; a < job_cards[i].details.length; a++)
        {
            var row = '<tr>'+
                        '<td>'+job_cards[i].details[a].Part_Type_ID+'</td>'+
					    '<td>'+job_cards[i].details[a].Name+'</td>'+
					    '<td>'+job_cards[i].details[a].Quantity +'</td>'+
					    '<td><input type="number" title = "Enter the new quantity" id="p_q_' + job_cards[i].details[a].Part_Type_ID + '" min="0" value="0" max="' + job_cards[i].details[a].Quantity + '" data-part_type_ID="' + job_cards[i].details[a].Part_Type_ID + '"   /></td>' +
				    '</tr>';
                
            var j = { Part_Type_ID: job_cards[i].details[a].Part_Type_ID, Part_Type_Name: job_cards[i].details[a].Name, Quantity: job_cards[i].details[a].Quantity, Remove_Quantity : 0 };
            details.push(j);

            $("#jobCardItems").append(row);
        }

        $("#jobCard_ID").val(job_cards[i].Job_Card_ID);
        var date = job_cards[i].Job_Card_Date.split("T");

        $("#jobCard_date").val(date[0]);

        var value = job_cards[i].Job_Card_Status_ID;

        $("#jobCard_status > option[value='" + value + "']").prop("selected", true);

        return false;
    }

</script>
<h1 class="default-form-header">Maintain Job Card <span id="item_ID"></span></h1>
		
		
<form id="UC4-2" class="form-horizontal">
	<fieldset>
		<legend>Select a Job Card:</legend>
		<div class="table-responsive makeDivScrollable">
			<table class="sortable table table-hover">
				<thead>
					<tr>
						<th>Job Card No.</th>
						<th>Job Card Date Added</th>
						<th>Job Card Status</th>
						<th>Job Card Priority</th>
						<th>Select</th>
					</tr>
				</thead>
				<tbody id="listOfJobCards">
				</tbody>
			</table>
		</div> 
	</fieldset>
    <br />
	<fieldset>
	<legend>Job Card: </legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="jobCard_ID" class="control-label">Job Card ID: </label>
				<input type="text" class="form-control" id="jobCard_ID" disabled title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-4">
				<label for="jobCard_date" class="control-label">Job Card Date: </label>
				<input type="datetime" class="form-control" id="jobCard_date" disabled title ="No information can be entered into this field" data-toggle ="tooltip" data-placement ="bottom">
			</div>	
			<div class="col-sm-4">
				<label for="jobCard_status">Job Card Status: </label>
				<select class="form-control" id="jobCard_status" title ="Select the status of the job card" data-toggle ="tooltip" data-placement ="bottom">
				</select>
			</div>
		</div>
	</fieldset>
	<br/>
	<fieldset>
		<legend>Job Card Details: </legend>
		<div class="table-responsive makeDivScrollable">
		<table class="table table-hover" >
			<thead>
				<tr>
					<th>Part Type No.</th>
					<th>Part Type Name</th>
					<th>Quantity to Manufacture</th>
					<th>Decrease Quantity</th>
				</tr>
			</thead>
			<tbody id="jobCardItems">
			</tbody>
		</table>
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
		</div>
		<div class="col-sm-4">
			<button type = "submit" class = "form-custom-button-columns" title ="Click to update job card details" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-wrench" aria-hidden="true"></i> Update Job Card</button>
		</div>
	</div>
</form>
</asp:Content>
