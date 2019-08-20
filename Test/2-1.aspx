<%@ Page Title="Add New Customer" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="2-1.aspx.cs" Inherits="Test._2_1" %>
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

    function addContact()
	{
	    ci++;
	    var s = '<div id="contact_details_' + ci + '"><h3>Contact Details <button type="button" class="Add_extra_things" onclick="removeContact(' + ci + ')" title ="Click to remove contact" data-toggle ="tooltip" data-placement="bottom"><i class="fa fa-minus" aria-hidden="true"></i></button></h3>' +
		'<div class="row">' +
			'<div class="col-sm-4">' +
				'<label for="client_contact_name_'+ci+'" class="control-label">Contact Name: </label>' +
				'<input type="text" class="form-control" id="client_contact_name_' + ci + '" placeholder="Jane Doe" maxlength="25">' +
			'</div>' +
			'<div class="col-sm-4">' +
				'<label for="client_contact_number_'+ci+'" class="control-label">Contact Number: </label>' +
				'<input type="text" class="form-control" id="client_contact_number_' + ci + '" placeholder="0125554444" maxlength="15">' +
			'</div>'+
			'<div class="col-sm-4">' +
				'<label for="client_contact_email_'+ci+'" class="control-label">Contact Email: </label>' +
				'<input type="email" class="form-control" id="client_contact_email_'+ci+'" placeholder="jane@doe.com" maxlength="254">' +
			'</div>' +
		'</div>' +
		'<div class="row">' +
			'<div class="col-sm-12">' +
				'<label for="client_contact_job_'+ci+'">Job Description:</label>' +
				'<textarea class="form-control" rows="3" id="client_contact_job_'+ci+'" maxlength="255"></textarea>' +
			'</div>' +
		'</div></div>';
		

	    if ($('#contactDetailsField').children().length < 10) {
	        $("#contactDetailsField").append(s);
	        contact_nums.push(ci);
	    }
	    else 
	        alertify.alert('Error', "No more than 10 contacts.", function () { });
	    
	}
			
function removeContact(co)
{
	if ($('#contactDetailsField').children().length > 1)
	{
	    $("#contact_details_" + co).remove();

	    for(var k = 0; k < contact_nums.length; k++)
	        if(contact_nums[k] == co)
	            contact_nums.splice(k, 1);
	}
	else
	    alertify.alert('Error', "At least one contact must be added.", function () {});
}
</script>


    <style>
        .active > a{
            background-color : #333;
        }

    </style>
<h1 class="default-form-header">Add New Customer</h1>
	<form id="UC2-1" class="form-horizontal">
        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#customer" title ="Click to select the customer tab">Customer</a></li>
            <li><a data-toggle="tab" href="#discounts" title ="Click to select the discount tab">Discounts</a></li>
        </ul>
        <br/>

        <div class="tab-content">
        <div id="customer" class="tab-pane fade in active">
		<fieldset>
			<legend>Customer Information:</legend>
			<div class="row">
				<div class="col-sm-4">
					<label for="client_Name" class="control-label">Customer Name: </label>
					<input type="text" class="form-control" id="client_Name" placeholder="Customer Name" maxlength="35" title ="Enter the customers name" data-toggle ="tooltip" data-placement="right"/>
				</div>	
				<div class="col-sm-4">
					<label for="client_acc" class="control-label">Account Name: </label>
					<input type="text" class="form-control" id="client_acc" placeholder="Account Name" maxlength="20" title ="Enter the customers account name" data-toggle ="tooltip" data-placement="right"/>
				</div>
            </div>
            <div class="row">
				<div class="col-sm-4">
					<label for="client_vat" class="control-label">VAT Number: </label>
					<input type="text" class="form-control" id="client_vat" placeholder="0000000000000" maxlength="10" title ="Enter the VAT Number" data-toggle ="tooltip" data-placement="bottom"/>
				</div>
				<div class="col-sm-2">
					<label for="client_Status">Status: </label>
					<select class="form-control" id="client_Status" title ="Select the status of the customer" data-toggle ="tooltip" data-placement="right">
						<option value="1">Active</option>
						<option value="0">In-Active</option>
					</select>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					<label for="client_Address" class="control-label">Address: </label>
					<input type="text" class="form-control" id="client_Address" placeholder="93 Example Street" maxlength="95" title ="Enter the customers address" data-toggle ="tooltip" data-placement ="bottom"/>
				</div>
				<div class="col-sm-3">
					<label for="client_City" class="control-label">City: </label>
					<input type="text" class="form-control" id="client_City" placeholder="Exampletopia" maxlength="35" title ="Enter the customers city" data-toggle ="tooltip" data-placement ="bottom"/>
				</div>
				<div class="col-sm-3">
					<label for="province">Province: </label>
					<select class="form-control" id="province" title ="Select a province" data-toggle ="tooltip" data-placement="bottom" >
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
					<input type="text" class="form-control" id="zip" maxlength="4" placeholder="0000" title ="Enter the customers zip code" data-toggle ="tooltip" data-placement="bottom" >
				</div>
			</div>
		</fieldset>
		<br/>
			
		<fieldset id="contactDetailsField">
			<legend>Contact Details:</legend>
			<button type="button" class="Add_extra_things" onclick="addContact()" title ="Click to add contact" data-toggle ="tooltip" data-placement="right" ><i class="fa fa-plus" aria-hidden="true"></i> Add Contact</button>
			
			<div id="contact_details_1">
				<h3>Contact Details</h3>
				<div class="row">
					<div class="col-sm-4">
						<label for="client_contact_name_1" class="control-label">Contact Name: </label> 
						<input type="text" class="form-control" id="client_contact_name_1" placeholder="Jane Doe" maxlength="25" title ="Enter the contact name" data-toggle ="tooltip" data-placement="bottom"/>
					</div>
					<div class="col-sm-4">
						<label for="client_contact_number_1" class="control-label">Contact Number: </label>
						<input type="text" class="form-control" id="client_contact_number_1" placeholder="0125554444" maxlength="15" title ="Enter the contact number ,maximum of 15 digits" data-toggle ="tooltip" data-placement="bottom"/>
					</div>
					<div class="col-sm-4">
						<label for="client_contact_email_1" class="control-label">Contact Email: </label>
						<input type="email" class="form-control" id="client_contact_email_1" placeholder="jane@doe.com" maxlength="254" title ="Enter the contact persons email address" data-toggle ="tooltip" data-placement="bottom" />
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<label for="client_contact_job_1">Job Description:</label>
						<textarea class="form-control" rows="3" id="client_contact_job_1" maxlength="255" title ="Enter the contact persons job description" data-toggle ="tooltip" > </textarea>
					</div>
				</div>
			</div>
		</fieldset>
        

       <div class="row">
	        <div class="col-sm-8">
	        </div>
	        <div class="col-sm-4">
                <button type = "submit" class = "form-custom-button-columns" title ="Click to add new customer" data-toggle ="tooltip" data-placement="left"><i class="fa fa-check" aria-hidden="true"></i> Add New Customer</button>
	        </div>
		</div>

		</div>
        
        <div id="discounts" class="tab-pane fade">
		<fieldset>
			<legend>Discounts:</legend>
			<div class="row">
				<div class="col-sm-3">
					<label for="contract_discount_rate" class="control-label">Contract Discount Rate: </label>
					<input type="number" class="form-control" id="contract_discount_rate" value="0" min="0" max="100" title ="Enter the contract discount rate" data-toggle ="tooltip" data-placement="bottom" />
				</div>
				<div class="col-sm-3">
					<label for="settle_discount_rate" class="control-label">Settlement Discount Rate: </label>
					<input type="number" class="form-control" id="settle_discount_rate" value="0" min="0" max="100" title ="Enter the customers settlement discount rate" data-toggle ="tooltip" data-placement="bottom" />
				</div>
			</div>
			<br/>

			<div id="parts">
				<div class="row">
					<div class="col-sm-4">
						<button type="button" class="Add_extra_things" onclick="addPartSearch()" title ="Click to add discount to part type" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus" aria-hidden="true"></i> Add Discount to Part Type</button>
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
								<th title ="Enter the part type discount">Discount %</th>
							</tr>
						</thead>
						<tbody id="PartItems" title ="Enter part type discount details" data-toggle ="tooltip" data-placement ="bottom" >
						</tbody>
					</table>
				</div>
			</div>
		</fieldset>
		<br/>
        </div>
        </div>
        
        
        
        <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	    </div>     
        
	</form>
	
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
					<select class="form-control" id="filter_select" title ="Select what to search the part type details to search by">
						<option value="All">All</option>
                        <option value="Abb">Abbreviation</option>
						<option value="Name">Name</option>
						<option value="Description">Description</option>
                        <option value="Dimension">Dimensions</option>
					</select>
				</div>
                <div class="col-sm-4">
					<button class = "form-custom-button-modal" style="" onclick="return FilterSearch()" title ="Click to search for the part type"><i class="fa fa-check" aria-hidden="true"></i> Filter</button>
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

$(document).ready(function ()
{
    $("#UC2-1").submit(function (e)
    {
        e.preventDefault();
        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        var c_contact_details = [];
        

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

            if (c_num.length < 10)
            {
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

        var res = only_nums_pattern.test(zip);

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
                $("#w_info").append(warnings);

                
            }

            if (discount < 0 || discount > 100)
                warnings = warnings + "Part discount rate for part type # " + ID + " is not correct. <br/>";

            part_discounts[k].Discount_Rate = discount;
        }

        var client = {
            Name: name, Account_Name: acc_name, Vat_Number: vat_num, Client_Status: status, Address: address,
            City: city, Province_ID: province, Zip: zip, Contract_Discount_Rate: cdr, Settlement_Discount_Rate: sdr
        };

        if (warnings == "") {
            console.log(c_contact_details);
            $.ajax({
                type: "POST",
                url: "api/Customer",
                contentType: "application/json",
                dataType: "json",
                data: { data: JSON.stringify({client: client, contacts: c_contact_details, discounts: part_discounts})},
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

                    return false;
                }
            });
        }

        return false;
    });
});

var part_types;
var part_discounts = [];

function addPart_A()
{
    var found = false;
    var k = $("#part_Search_Result").val();
    
    if (k == "" || k == null)
        alertify.alert('Error', 'No Part Type has been chosen!', function () { });
    else
    {
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
                '<td><button type="button" class="addToList" onclick="removePart_A(' + ID + ')"><i class="fa fa-minus" aria-hidden="true"></i>' + name + '</button></td>' +
                '<td><input type="number" class="form-control" id="p_' + ID + '_discount" value="0" min="0" max="100"/></td>' +
            '</tr>';
            $("#PartItems").append(s);

            var i = { Part_Type_ID: ID, Name: name, Discount_Rate: 0, Abbreviation: abbreviation };

            part_discounts.push(i);
        }
        else
            alertify.alert("Part already on list.");
    }
}

function removePart_A(i)
{
    var ID = i;

    for (var a = 0; a < part_discounts.length; a++)
    {
        if (part_discounts[a].Part_Type_ID == ID)
        {
            part_discounts.splice(a, 1);
        }
    }

    //console.log(part_discounts);
    $('#p_ID_' + i).remove();
}

function FilterSearch()
{
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
        success: function (msg)
        {
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
