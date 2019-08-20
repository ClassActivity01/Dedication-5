<%@ Page Title="Maintain Customer" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="2-2.aspx.cs" Inherits="Test._2_2" %>
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
        var ci = 1;
        var contact_nums = [1];

        function addContact() {
            ci++;
            var s = '<div id="contact_details_' + ci + '"><h3>Contact Details <button type="button" class="Add_extra_things" onclick="removeContact(' + ci + ')" title ="Click to remove contact" data-toggle ="tooltip" data-placement="bottom"><i class="fa fa-minus" aria-hidden="true"></i></button></h3>' +
            '<div class="row">' +
                '<div class="col-sm-4">' +
                    '<label for="client_contact_name_' + ci + '" class="control-label">Contact Name: </label>' +
                    '<input type="text" class="form-control" id="client_contact_name_' + ci + '" placeholder="Jane Doe" maxlength="25">' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="client_contact_number_' + ci + '" class="control-label">Contact Number: </label>' +
                    '<input type="text" class="form-control" id="client_contact_number_' + ci + '" placeholder="0125554444" maxlength="15">' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="client_contact_email_' + ci + '" class="control-label">Contact Email: </label>' +
                    '<input type="email" class="form-control" id="client_contact_email_' + ci + '" placeholder="jane@doe.com" maxlength="254">' +
                '</div>' +
            '</div>' +
            '<div class="row">' +
                '<div class="col-sm-12">' +
                    '<label for="client_contact_job_' + ci + '">Job Description:</label>' +
                    '<textarea class="form-control" rows="3" id="client_contact_job_' + ci + '" maxlength="255"></textarea>' +
                '</div>' +
            '</div></div>';

            if ($('#contactDetailsField').children().length < 10) {
                $("#contactDetailsField").append(s);
                contact_nums.push(ci);
            }
            else
                alertify.alert('Error', "No more than 10 contacts.", function () { });
        }

        function removeContact(co) {
            if ($('#contactDetailsField').children().length > 1) {
                $("#contact_details_" + co).remove();

                for (var k = 0; k < contact_nums.length; k++)
                    if (contact_nums[k] == co)
                        contact_nums.splice(k, 1);
            }
            else
                alertify.alert('Error', "At least one contact must be added.", function () { });
        }
</script>
<h1 class="default-form-header">Maintain Customer <span id="item_ID"></span></h1>
<!-- Search Code -->
<div class="searchDiv">
	<form id="search_form">
		<fieldset>
		<legend>Search for Customer: </legend>
			<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the customer details to search by" data-toggle ="tooltip" data-placement="bottom"/>
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select what to search the customer by" data-toggle ="tooltip" data-placement="bottom">
					<option value="All">All</option>
					<option value="Name">Name</option>
					<option value="Vat">Vat Number</option>
					<option value="Account">Account Number</option>
					<option value="ID">Customer No.</option>
				</select>
			</div>	
			<div class="col-sm-4">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Exact" name="optradio" checked/>Exact</label>
					<label class="radio-inline" title ="Select a search method"><input type="radio" value="Contains" name="optradio"/>Contains</label>
				</div>
			</div>
			<div class="row">
                <div class="col-sm-8">

				</div>
				<div class="col-sm-4">
					<button id="submitSearch" class ="searchButton" title ="Click here to search for the customer" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
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
		<h4 class="modal-title">Select a Customer</h4>
		</div>
		<div class="modal-body">
			<select multiple class="form-control" id="client_search_results" title ="Select a customer">
			</select>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Select to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" id="loadClientDetails" title ="Select to load the customers details">Load Customer Details</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
	
<style>
    #div_2_2 {display: none;}
</style>
<br />
<div id="div_2_2">
    <form id="UC2-1" class="form-horizontal">
		<ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#customer" title ="Click to select the customer tab">Customer</a></li>
            <li><a data-toggle="tab" href="#discounts"title ="Click to select the discount tab" >Discounts</a></li>
        </ul>
        <br/>

        <div class="tab-content">
        <div id="customer" class="tab-pane fade in active">
        <fieldset>
			<legend>Client Information:</legend>
			<div class="row">
				<div class="col-sm-4">
					<label for="client_Name" class="control-label">Customer Name: </label>
					<input type="text" class="form-control" id="client_Name" placeholder="Example clients" maxlength="35" title ="Enter the customers name" data-toggle ="tooltip" data-placement="bottom">
				</div>	
				<div class="col-sm-4">
					<label for="client_acc" class="control-label">Account Name: </label>
					<input type="text" class="form-control" id="client_acc" placeholder="CC - something" maxlength="20" title ="Enter the customers account name" data-toggle ="tooltip" data-placement="bottom">
				</div>	
				<div class="col-sm-2">
					<label for="client_vat" class="control-label">VAT Number: </label>
					<input type="text" class="form-control" id="client_vat" placeholder="0000" maxlength="10" title ="Enter the VAT Number" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-2">
					<label for="client_Status">Status: </label>
					<select class="form-control" id="client_Status" title ="Select the status of the customer" data-toggle ="tooltip" data-placement="bottom">
						<option value="1">Active</option>
						<option value="0">In-Active</option>
					</select>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					<label for="client_Address" class="control-label">Address: </label>
					<input type="text" class="form-control" id="client_Address" placeholder="93 Example Street" maxlength="95" title ="Enter the customers address" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-3">
					<label for="client_City" class="control-label">City: </label>
					<input type="text" class="form-control" id="client_City" placeholder="Exampletopia" maxlength="35" title ="Enter the customers city" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-3">
					<label for="province">Province: </label>
					<select class="form-control" id="province" title ="Select a province" data-toggle ="tooltip" data-placement="bottom">
                        <option value="3">Gauteng</option>
                        <option value="5">Limpopo</option>
                        <option value="6">Mpumulanga</option>
                        <option value="2">Free State</option>
                        <option value="4">KwaZulu-Natal</option>
                        <option value="7">North West</option>
                        <option value="1">Eastern Cape</option>
                        <option value="8">Northern Cape</option>
                        <option value="9">Western Cape</option>
					</select>
				</div>
				<div class="col-sm-2">
					<label for="zip" class="control-label">Zip Code: </label>
					<input type="text" class="form-control" id="zip" maxlength="4" placeholder="0000" title ="Enter the customers zip code" data-toggle ="tooltip" data-placement="bottom">
				</div>
			</div>
		</fieldset>
		<br/>
			
		<fieldset id="contactDetailsField">
			<legend>Contact Details:</legend>
			<button type="button" class="Add_extra_things" onclick="addContact()"title ="Click to add contact" data-toggle ="tooltip" data-placement="bottom"><i class="fa fa-plus" aria-hidden="true"></i> Add contact</button>
			
			<div id="contact_details_1">
				<h3>Contact Details 1</h3>
				<div class="row">
					<div class="col-sm-4">
						<label for="client_contact_name_1" class="control-label">Contact Name: </label> 
						<input type="text" class="form-control" id="client_contact_name_1" placeholder="Jane Doe" maxlength="25" title ="Enter the contact name" data-toggle ="tooltip" data-placement="bottom">
					</div>
					<div class="col-sm-4">
						<label for="client_contact_number_1" class="control-label">Contact Number: </label>
						<input type="text" class="form-control" id="client_contact_number_1" placeholder="0125554444" maxlength="15" title ="Enter the contact number ,maximum of 15 digits" data-toggle ="tooltip" data-placement="bottom">
					</div>
					<div class="col-sm-4">
						<label for="client_contact_email_1" class="control-label">Contact Email: </label>
						<input type="email" class="form-control" id="client_contact_email_1" placeholder="jane@doe.com" title ="Enter the contact persons email address" data-toggle ="tooltip" data-placement="bottom">
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<label for="client_contact_job_1">Job Description:</label>
						<textarea class="form-control" rows="3" id="client_contact_job_1" maxlength="255" title ="Enter the contact persons job description" data-toggle ="tooltip"></textarea>
					</div>
				</div>
			</div>
		</fieldset>
 
        <div class="row">
			<div class="col-sm-4">

		    </div>
			<div class="col-sm-4">
				<button onclick="return updateClient()" class = "form-custom-button-columns" title ="Click to update the customers details" data-toggle ="tooltip"><i class="fa fa-wrench" aria-hidden="true"></i> Update Customer</button>
			</div>
			<div class="col-sm-4">
				<button onclick="return deleteClient()" class = "form-custom-button-columns" title ="Click to remove the customer" data-toggle ="tooltip"><i class="fa fa-times" aria-hidden="true"></i> Remove Customer</button>
			</div>
		</div>

		</div>
        
        <div id="discounts" class="tab-pane fade">
		<fieldset>
			<legend>Discounts:</legend>
			<div class="row">
				<div class="col-sm-3">
					<label for="contract_discount_rate" class="control-label">Contract Discount Rate: </label>
					<input type="number" class="form-control" id="contract_discount_rate" value="0" min="0" max="100" title ="Enter the contract discount rate" data-toggle ="tooltip" data-placement="bottom">
				</div>
				<div class="col-sm-3">
					<label for="settle_discount_rate" class="control-label">Settlement Discount Rate: </label>
					<input type="number" class="form-control" id="settle_discount_rate" value="0" min="0" max="100" title ="Enter the customerss settlement discount rate" data-toggle ="tooltip" data-placement="bottom">
				</div>
			</div>
			<br/>
			<div id="parts">
				<div class="row">
					<div class="col-sm-4">
						<button type="button" class="Add_extra_things" onclick="addPartSearch()" title ="Click to add a discount to part type" data-toggle ="tooltip" data-placement="right"><i class="fa fa-plus" aria-hidden="true"></i> Add Discount to Part Type</button>
					</div>
				</div><br/>
				<h4>Parts with Discounts</h4>
				<div class="table-responsive makeDivScrollable">
					<table class="table table-hover" >
						<thead>
							<tr>
								<th>Code.</th>
								<th>Abbreviation</th>
								<th title ="Click to remove part type from discounts">Name</th>
								<th title ="Enter part type discount">Discount %</th>
							</tr>
						</thead>
						<tbody id="PartItems" title ="Enter part type discount details" data-toggle ="tooltip" data-placement ="bottom" >
						</tbody>
					</table>
				</div>
			</div>

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
</div>

<!-- PART MODAL CODE -->
		
<div class="modal fade" id="partSearchModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Add Part Type</h4>
		</div>
		<div class="modal-body">
			<div class="row">
				<div class="col-sm-4">
					<input type="text" class="form-control" id="part_search" placeholder="Filter Results..." title ="Enter the part type details to search by"/>
				</div>
				<div class="col-sm-4">
					<select class="form-control" id="filter_select" title ="Select what to search the part type details to search by" >
						<option value="All">All</option>
                        <option value="Abb">Abbreviation</option>
						<option value="Name">Name</option>
						<option value="Description">Description</option>
                        <option value="Dimension">Dimensions</option>
					</select>
				</div>
                <div class="col-sm-4">
					<button class = "form-custom-button-modal" onclick="return FilterSearch()" title ="Click to search for the part type"><i class="fa fa-check" aria-hidden="true" ></i> Filter</button>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<select multiple class="form-control" id="part_Search_Result" title ="Select the part type to assign a discount to">
					</select>
				</div>
			</div>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the modal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" onclick="addPart_A()" title ="Click to add to part type discounts">Add Part Type to Discounts</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<script>
//Global Variables
    var searchedClients;
    var client_ID = 0;
    var part_discounts = [];
    var part_types;

//Resolve ALL urls
function updateClient()
{
    var warnings = "";

    var empty = checkEmpty();

    if (empty == false) {
        warnings = warnings + "One or more fields are empty. <br/>";
        $("#w_info").html(warnings);
        return false;
    }

    var c_contact_details = [];
        
    console.log(contact_nums);
    for (var o = 0; o < contact_nums.length; o++)
    {
        var k = contact_nums[o];
        
        var c_name = $("#client_contact_name_" + k).val();
        var c_num = $("#client_contact_number_" + k).val().replace(/ /g, '');
        var c_email = $("#client_contact_email_"+k).val();
        var c_jobDescr = $("#client_contact_job_" + k).val();

        var only_nums_pattern = new RegExp("^[0-9]*$");
        var res = only_nums_pattern.test(c_num);
        if (res == false) {
            warnings = warnings + "Contact number may only contain numeric characters. <br/>";
            $("#client_contact_number_" + k).addClass("empty");
        }

        if (c_num.length < 10) {
            warnings = warnings + "Contact number is too short. <br/>";
            $("#client_contact_number_" + k).addClass("empty");
        }

        var detail = { Name: c_name, Number: c_num, Email_Address: c_email, Job_Description: c_jobDescr };
        c_contact_details.push(detail);
    }

    var name = $("#client_Name").val();
    var acc_name = $("#client_acc").val();
    var vat_num = $("#client_vat").val();
    var status = $("#client_Status").val();
    var address = $("#client_Address").val();
    var city = $("#client_City").val();
    var province = $("#province").val();
    var zip = $("#zip").val();
    var cdr = $("#contract_discount_rate").val();
    var sdr = $("#settle_discount_rate").val();

    if (sdr < 0 || sdr > 100)
        warnings += "Settlement Discount Rate is out of range.<br/>";

    if (cdr < 0 || cdr > 100)
        warnings += "Contract Discount Rate is out of range.<br/>";

    var only_nums_pattern = new RegExp("^[0-9]*$");
    var res = only_nums_pattern.test(vat_num);
    if (res == false) {
        warnings = warnings + "VAT Number may only contain numeric characters. <br/>";
        $("#client_vat").addClass("empty");
    }

    var patt = new RegExp("^[0-9]*$");
    var res = patt.test(zip);

    if (res == false) {
        warnings = warnings + "Zip code may only contain numbers. <br/>";
        $("#zip").addClass("empty");
    }

    if (zip.length < 4) {
        warnings = warnings + "Zip code must be 4 characters. <br/>";
        $("#zip").addClass("empty");
    }


    for (var k = 0; k < part_discounts.length; k++)
    {
        var ID = part_discounts[k].Part_Type_ID;
        var discount = $("#p_" + ID + "_discount").val();
        if (discount == 0)
        {
            $("#p_" + ID + "_discount").addClass("empty");
            warnings = warnings + "One or more part discounts are empty. <br/>";
            $("#w_info").html(warnings);
        }

        if (discount < 0 || discount > 100)
            warnings = warnings + "Part discount rate for part type # " + ID + " is not correct. <br/>";

        part_discounts[k].Discount_Rate = discount;
    }


    var client = {
        Name: name, Account_Name: acc_name, Vat_Number: vat_num, Client_Status: status, Address: address,
        City: city, Province_ID: province, Zip: zip, Contract_Discount_Rate: cdr, Settlement_Discount_Rate: sdr
    };

    $("#w_info").html(warnings);
    //alert(JSON.stringify(c_contact_details));

    console.log(c_contact_details);

    if (warnings == "") {
        $.ajax({
            type: "PUT",
            url: "api/Customer/" + client_ID,
            data: { data: JSON.stringify({ client: client, contacts: c_contact_details, discounts: part_discounts }) },
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
        return false;
    }
    else
        return false;

}

function deleteClient()
{
   alertify.confirm('Removal Confirmation', 'Are you sure you want to delete this Customer?', function () {
        $.ajax({
            type: "DELETE",
            url: "api/Customer/" + client_ID,
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
                    alertify.alert('Successful', result[1], function () { location.reload(); });
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
    }, function () { });

    return false;
}

$(document).ready(function () {

    //On search
    $("#search_form").submit(function (event) {
        event.preventDefault();

        var method = $('input[name=optradio]:checked', '#search_form').val()
        var criteria = $('#search_criteria').val();
        var category = $('#search_category').val();

        $.ajax({
            type: "POST",
            url: "api/SearchCustomer",
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
                    searchedClients = JSON.parse(result[1]).clients;

                    $('#client_search_results').empty();
                    if (searchedClients.length == 0) {
                        $("#client_search_results").append("<option value=''>No results found.</option>");
                    }
                    else {
                        for (var k = 0; k < searchedClients.length; k++) {
                            var html = '<option value="' + searchedClients[k].Client_ID + '">' + searchedClients[k].Client_ID + ' - ' + searchedClients[k].Name + '</option>';

                            $("#client_search_results").append(html);
                        }
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
        $("#ResultModal").modal('show');
    });

    //On search results click
    $('#loadClientDetails').on('click', function () {

        client_ID = $('#client_search_results').val();

        if (client_ID == "" || client_ID == null)
            alertify.alert('Error', 'No Customer has been chosen!', function () { alertify.success('Ok'); });
        else
            $.ajax({
                type: "GET",
                url: "api/Customer/"+client_ID,
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
                        var client_details = JSON.parse(result[1]).clients;

                        $("#div_2_2").show();

                        $("#item_ID").html("#" + client_ID + " ");

                        $("#client_Name").val(client_details[0].Name);
                        $("#client_acc").val(client_details[0].Account_Name);
                        $("#client_vat").val(client_details[0].Vat_Number);
                        $("#client_Address").val(client_details[0].Address);
                        $("#client_City").val(client_details[0].City);

                        var value = client_details[0].Province_ID;

                        $("#province > option[value='" + value + "']").prop("selected", true);

                        value = client_details[0].c_status;

                        $("#client_Status > option[value='" + value + "']").prop("selected", true);

                        $("#zip").val(client_details[0].Zip);
                        $("#contract_discount_rate").val(client_details[0].Contract_Discount_Rate);
                        $("#settle_discount_rate").val(client_details[0].Settlement_Discount_Rate);

                        $('#ResultModal').modal('hide');

                        console.log(client_details[0].contact_details);

                        for (var p = 0; p < client_details[0].contact_details.length; p++) {
                            if (p > 0) {
                                addContact();
                            }
                            var k = p + 1;

                            $("#client_contact_name_" + k).val(client_details[0].contact_details[p].Name);
                            $("#client_contact_number_" + k).val(client_details[0].contact_details[p].Number);
                            $("#client_contact_email_" + k).val(client_details[0].contact_details[p].Email_Address);
                            $("#client_contact_job_" + k).val(client_details[0].contact_details[p].Job_Description);
                        }


                        for (var p = 0; p < client_details[0].part_discounts.length; p++) {
                            part_discounts.push(client_details[0].part_discounts[p]);
                            var ID = client_details[0].part_discounts[p].Part_Type_ID;

                            var s = '<tr id="p_ID_' + ID + '">' +
                                    '<td >' + ID + '</td>' +
                                    '<td>' + part_discounts[p].Part_Type_Abbreviation + '</td>' +
                                    '<td><button type="button" class="addToList" onclick="removePart_A(' + ID + ')"><i class="fa fa-minus" aria-hidden="true"></i>' + part_discounts[p].Part_Type_Name + '</button></td>' +
                                    '<td><input type="number" class="form-control" id="p_' + ID + '_discount" value="' + part_discounts[p].Discount_Rate + '" min="0" max="100"/></td>' +
                                '</tr>';
                            $("#PartItems").append(s);
                        }
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
            });
    });
});

function addPart_A() {
    var found = false;
    var k = $("#part_Search_Result").val();

    if (k == "" || k == null)
        alertify.alert('Error', 'No Part Type has been chosen!', function () { alertify.success('Ok'); });
    else {
        var ID = part_types[k].Part_Type_ID;

        for (var a = 0; a < part_discounts.length; a++) {
            if (part_discounts[a].Part_Type_ID == ID) {
                found = true;
            }
        }

        if (found == false) {
            var name = part_types[k].Name;
            var abbreviation = part_types[k].Abbreviation;

            var s = '<tr id="p_ID_' + ID + '">' +
                '<td >' + ID + '</td>' +
                '<td>' + abbreviation + '</td>' +
                '<td><button type="button" class="addToList" onclick="removePart_A(' + ID + ')"><i class="fa fa-minus" aria-hidden="true"></i> ' + name + '</button></td>' +
                '<td><input type="number" class="form-control" id="p_' + ID + '_discount" value="0" min="0" max="100"/></td>' +
            '</tr>';
            $("#PartItems").append(s);

            var i = { Part_Type_ID: ID, Name: name, Discount_Rate: 0, Abbreviation: abbreviation };

            part_discounts.push(i);
            //console.log(part_discounts);
        }
        else
            alertify.alert("Part already on list.");
    }
}

function removePart_A(i) {
    var ID = i;

    for (var a = 0; a < part_discounts.length; a++) {
        if (part_discounts[a].Part_Type_ID == ID) {
            part_discounts.splice(a, 1);
        }
    }

    //console.log(part_discounts);
    $('#p_ID_' + i).remove();
}

function FilterSearch() {
    var filter_text = $("#part_search").val();
    var filter_category = $("#filter_select").val();

    $.ajax({
        type: "POST",
        url: "api/SearchPartType",
        data: { data: "{'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "', 'method': 'Contains'}" },
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
                part_types = JSON.parse(result[1]).part_types;
                $("#part_Search_Result").empty();

                if (part_types.length == 0) {
                    $("#part_Search_Result").append("<option value=''>No results found.</option>");
                }
                else {
                    for (var k = 0; k < part_types.length; k++) {
                        var type = '<option value="' + k + '">' + part_types[k].Abbreviation + ' - ' + part_types[k].Name + ' - ' + part_types[k].Dimension + '</option>';
                        $("#part_Search_Result").append(type);
                    }
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });
}
</script>
</asp:Content>
