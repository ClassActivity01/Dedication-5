<%@ Page Title="Add Sub-Contractor" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="7-1.aspx.cs" Inherits="Test._7_1" %>
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
				'<label for="sub_contact_name_' + ci + '" class="control-label">Contact Name: </label>' +
				'<input type="text" class="form-control" id="sub_contact_name_' + ci + '" placeholder="Jane Doe" maxlength="25">' +
			'</div>' +
			'<div class="col-sm-4">' +
				'<label for="sub_contact_number_' + ci + '" class="control-label">Contact Number: </label>' +
				'<input type="text" class="form-control" id="sub_contact_number_' + ci + '" placeholder="0125554444" maxlength="15">' +
			'</div>' +
			'<div class="col-sm-4">' +
				'<label for="sub_contact_email_' + ci + '" class="control-label">Contact Email: </label>' +
				'<input type="email" class="form-control" id="sub_contact_email_' + ci + '" placeholder="jane@doe.com" maxlength="254">' +
			'</div>' +
		'</div>' +
        '</div>';


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
<h1 class="default-form-header">Add Sub-Contractor</h1>
<form id="UC7-1" class="form-horizontal">
	<fieldset>
		<legend>Sub-Contractor Information:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="con_Name" class="control-label">Contractor Name: </label>
				<input type="text" class="form-control" id="con_Name" placeholder="Contractor Name" title ="Enter the sub-contractors name" data-toggle ="tooltip" data-placement="right"/>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
				<label for="con_address" class="control-label">Address: </label>
				<input type="text" class="form-control" id="con_address" placeholder="93 Example Street" title ="Enter the sub-contractors address" data-toggle ="tooltip" data-placement="bottom">
			</div>
			<div class="col-sm-3">
				<label for="con_city" class="control-label">City: </label>
				<input type="text" class="form-control" id="con_city" placeholder="Exampletopia" title ="Enter the sub-contractors city" data-toggle ="tooltip"  data-placement="bottom">
			</div>
			<div class="col-sm-3">
				<label for="province">Province: </label>
				<select class="form-control" id="province" title ="Select a province" data-toggle ="tooltip" data-placement="bottom">
                    <option value="Choose">Choose an option</option>
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
				<input type="text" class="form-control" id="zip" maxlength="4" title ="Enter the sub-contractors zip code" data-toggle ="tooltip" data-placement="bottom">
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
					<input type="text" class="form-control" id="sub_contact_name_1" placeholder="Jane Doe" maxlength="25" title ="Enter the contact name" data-toggle ="tooltip" data-placement="right"/>
				</div>
				<div class="col-sm-4">
					<label for="client_contact_number_1" class="control-label">Contact Number: </label>
					<input type="text" class="form-control" id="sub_contact_number_1" placeholder="0125554444" maxlength="15" title ="Enter the contact number ,maximum of 15 digits" data-toggle ="tooltip" data-placement="right"/>
				</div>
				<div class="col-sm-4">
					<label for="client_contact_email_1" class="control-label">Contact Email: </label>
					<input type="email" class="form-control" id="sub_contact_email_1" placeholder="jane@doe.com" maxlength="254" title ="Enter the contact persons email address" data-toggle ="tooltip" data-placement="bottom" />
				</div>
			</div>
		</div>
	</fieldset>
	<br/>
			
	<fieldset>
		<legend>Manual Labour that Sub-Contractor Provides:</legend>
		<div class="row">
			<div class="col-sm-6">
				<label for="ml_type">Manual Labour Type: </label>
				<select class="form-control" id="ml_type" title ="Select the manual labour type" data-toggle ="tooltip" data-placement="right">

				</select>
			</div>
		</div>
        <br />
	</fieldset>
			
	<br/>

    <div class="row">
	    <div class="col-sm-12">
            <div class="Warning_Info" id="w_info"></div>
	    </div>
	</div>     

	<div class="row">
			<div class="col-sm-8">

		    </div>
			<div class="col-sm-4">
                <button type = "submit" class = "form-custom-button-columns" title ="Click to add new sub-contractor" data-toggle ="tooltip" data-placement="left" ><i class="fa fa-check" aria-hidden="true"></i> Add New Sub-Contractor</button>
				
			</div>
		</div>
</form>


<script>
    var manual_labours;


    $(document).ready(function ()
    {
        $.ajax({
            type: "GET",
            url: "api/ManualLabour",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status);
                console.log(xhr.responseText);
                console.log(thrownError);
            },
            success: function (msg) {
                console.log(msg);

                var result = msg.split("|");
                if (result[0] == "true") {
                    manual_labours = JSON.parse(result[1]).manual_labour_types;

                    $("#ml_type").empty();

                    for (var k = 0; k < manual_labours.length; k++) {
                        var type = '<option value="' + k + '">' + manual_labours[k].Name + '</option>';
                        $("#ml_type").append(type);
                    }
                }
                else
                    alertify.alert('Error', result[1], function () { });

                return false;
            }
        });

        $("#UC7-1").submit(function (e) {
            e.preventDefault();
            var warnings = "";

            var empty = checkEmpty();

            if (empty == false) {
                warnings = warnings + "One or more fields are empty. <br/>";
                $("#w_info").html(warnings);
                return false;
            }

            var c_contact_details = [];

            for (var o = 0; o < contact_nums.length; o++) {
                var k = contact_nums[o];

                var c_name = $("#sub_contact_name_" + k).val();
                var c_num = $("#sub_contact_number_" + k).val().replace(/ /g, '');
                var c_email = $("#sub_contact_email_" + k).val();

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


                var detail = { Name: c_name, Number: c_num, Email: c_email};
                c_contact_details.push(detail);
            }

            var name = $("#con_Name").val();
            var address = $("#con_address").val();
            var city = $("#con_city").val();
            var province = $("#province").val();

            if (province == "Choose")
            {
                warnings = warnings + "Please choose a province. <br/>";
                $("#province").addClass("empty");
            }

            var only_nums_pattern = new RegExp("^[0-9]*$");
            var zip = $("#zip").val();

            var res = only_nums_pattern.test(zip);

			if (res == false) {
				warnings = warnings + "Zip code may only contain numbers. <br/>";
				$("#zip").addClass("empty");
			}
				
			if (zip.length < 4) {
				warnings = warnings + "Zip code must be 4 characters. <br/>";
				$("#zip").addClass("empty");
			}

            var k = $("#ml_type").val();

            var ml_ID = manual_labours[k].Manual_Labour_Type_ID;

            var sub = {
                Name: name, Address: address, Manual_Labour_Type_ID : ml_ID,
                City: city, Province_ID: province, Zip: zip, contact_details: c_contact_details,
            };


            $("#w_info").html(warnings);
            console.log(sub);

            if (warnings == "") {
                $.ajax({
                    type: "POST",
                    url: "api/SubContractor",
                    data: {data: JSON.stringify(sub)},
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

                        return false;
                    }
                });
            }

            return false;
        });
    });
</script>
</asp:Content>
