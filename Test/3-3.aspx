<%@ Page Title="Add Part Type" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="3-3.aspx.cs" Inherits="Test._3_3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<link rel="stylesheet" href="css/treeview.css" />
<script src="scripts/MyScripts/tooltip.js"></script>
<script src="scripts/bootstrap.js"></script> 
<style>
		.tooltip-inner
		{
			 min-width:200px;
		}
</style>  
<script>
var recipe = [];
var bill = [];
var searchedItems;
var what;
var bill_index;
var node_counts = [0, 0, 0];
var suppliers = [];
var searched_Suppliers;
var num_blueprints = 0;
var m_or_ml = "Machine";
var searched_m;
var manual_labours = [];
var machines = [];

function sendFile(ID) {

    var formdata = new FormData(); //FormData object
    var fileInput = document.getElementById('fileUpload');

    //Iterating through each files selected in fileInput
    for (i = 0; i < fileInput.files.length; i++) {
        //Appending each file to FormData object
        formdata.append(fileInput.files[i].name, fileInput.files[i]);
    }

    formdata.append("Part_Type_ID", ID);

    $.ajax({
        type: "POST",
        url: " api/Blueprint/Upload",
        data: formdata,
        cache: false,
        processData: false,
        contentType: false,
        enctype: 'multipart/form-data',
        dataType: "json",
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.status);
            console.log(xhr.responseText);
            console.log(thrownError);
        },
        success: function (msg) {
            console.log(msg);

        }
    });

    return false;

}


function addItem()
{
    $("#inventory_search_Modal").modal('show');
}

function searchForItem()
{
    var filter_text = $("#search_criteria").val();
    var filter_category = $("#search_category").val();
    what = $("#what").val();
    var method = $('input[name=method_radio2]:checked', '#inventory_search_Modal').val();

    if (what == "Part Type") {
        $.ajax({
            type: "POST",
            url: "api/SearchPartType",
            data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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

                    searchedItems = JSON.parse(result[1]).part_types;
                    $("#item_search_results").empty();

                    if (searchedItems.length == 0) {
                        $("#item_search_results").append("<option value=''>No results found.</option>");
                    }
                    else {

                        for (var k = 0; k < searchedItems.length; k++) {
                            var type = '<option value="' + k + '">' + searchedItems[k].Abbreviation + ' - ' + searchedItems[k].Name + '</option>';
                            $("#item_search_results").append(type);
                        }
                    }
                }
                else { alertify.alert('Error', result[1]); }
            }
        });
    } else
        if (what == "Component") {
            $.ajax({
                type: "POST",
                url: "api/SearchComponent",
                data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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

                        searchedItems = JSON.parse(result[1]).components;
                        $("#item_search_results").empty();

                        if (searchedItems.length == 0) {
                            $("#item_search_results").append("<option value=''>No results found.</option>");
                        }
                        else {

                            for (var k = 0; k < searchedItems.length; k++) {
                                var type = '<option value="' + k + '">' + searchedItems[k].Name + '</option>';
                                $("#item_search_results").append(type);
                            }
                        }
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
        } else {
            $.ajax({
                type: "POST",
                url: "api/SearchRawMaterial",
                data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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
                        searchedItems = JSON.parse(result[1]).raw_materials;
                        $("#item_search_results").empty();

                        if (searchedItems.length == 0) {
                            $("#item_search_results").append("<option value=''>No results found.</option>");
                        }
                        else {

                            for (var k = 0; k < searchedItems.length; k++) {
                                var type = '<option value="' + k + '">' + searchedItems[k].Name + '</option>';
                                $("#item_search_results").append(type);
                            }
                        }
                    }
                    else { alertify.alert('Error', result[1]); }
                }
            });
        }
}
			
function addItem2()
{
    var k = $("#item_search_results").val();
    // console.log(k);

    if (k == "" || k == null)
        alertify.alert('Error', 'No Item has been chosen!');
    else {

        var found = false;

        //console.log(searchedItems);

        if (what == "Raw Material") {

            var ID = searchedItems[k].Raw_Material_ID;

            for (var a = 0; a < bill.length; a++) {
                if (bill[a].resouce_ID == ID && bill[a].Recipe_Type == "Raw Material") {

                    found = true;
                }
            }

            if (found == false)
            {
                var list = "<li id='rm_" + ID + "'><input type='checkbox' id='li_rm_" + ID + "' checked='checked' /><label  for='li_rm_" + ID + "'>" + searchedItems[k].Name + " <button class='Add_extra_things' title = 'Click to remove raw material from bill of material'style='font-size: 12pt;' onclick='removeNode(" + ID + ", &quot;Raw Material&quot;)'><i class='fa fa-times' aria-hidden='true'></i></button></label>" +
                            "<ul>"+
							    "<li style='margin-left: 5%'>Stages in Manufacturing: <input type='number' title = 'Enter the stage in manufacturing' value='0' min='0' id='stage_bill_rm_" + ID + "'/></li>" +
								"<li style='margin-left: 5%'>Dimensions: <input type='text' maxlength='40' title = 'Enter the raw materials dimension' id='rm_dimension_stage_" + ID + "' /></li>" +
								"<li style='margin-left: 5%'>Quantity: <input type='number' title = 'Enter the raw material quantity' value='0' id='stage_quantity_rm_" + ID + "'/></li>" +
							"</ul>"+
							"</li>";

                $("#raw_list").append(list);

                var entry = { Recipe_Type: "Raw Material", Quantity_Required: 0, Stage_in_Manufacturing: 0, resouce_ID: searchedItems[k].Raw_Material_ID, Item_Name: searchedItems[k].Name, Dimension: "", price : 0 };
                bill.push(entry);

            }
            else alertify.alert('Error', 'Raw Material already in list.');
            
        }
        else if (what == "Part Type")
        {
            var ID = searchedItems[k].Part_Type_ID;

            for (var a = 0; a < bill.length; a++) {
                if (bill[a].resouce_ID == ID && bill[a].Recipe_Type == "Part Type") {

                    found = true;
                }
            }

            if (found == false) {

                var list = "<li id='p_" + ID + "'><input type='checkbox' id='li_p_" + ID + "' checked='checked' /><label for='li_p_" + ID + "'>" + searchedItems[k].Name + " <button class='Add_extra_things' title = 'Click to remove item from bill of material' style='font-size: 12pt;' onclick='removeNode(" + ID + ", &quot;Part Type&quot;)'><i class='fa fa-times' aria-hidden='true'></i></button></label>" +
                            "<ul>" +
							    "<li style='margin-left: 5%'>Stages in Manufacturing: <input type='number' title = 'Enter the stage in manufacturing' value='0' min='0' id='stage_bill_p_" + ID + "'/></li>" +
								"<li style='margin-left: 5%'>Quantity: <input type='number' title = 'Enter the part type quantity' value='0' id='stage_quantity_p_" + ID + "'/></li>" +
							"</ul>" +
							"</li>";


                $("#part_list").append(list);

                var entry = { Recipe_Type: "Part Type", Quantity_Required: 0, Stage_in_Manufacturing: 0, resouce_ID: searchedItems[k].Part_Type_ID, Item_Name: searchedItems[k].Name, price : searchedItems[k].Selling_Price };
                bill.push(entry);

            }
            else alertify.alert('Error', 'Part Type already in list.');

            
        }
        else if (what == "Component")
        {

            var ID = searchedItems[k].Component_ID;

            for (var a = 0; a < bill.length; a++) {
                if (bill[a].resouce_ID == ID && bill[a].Recipe_Type == "Component") {

                    found = true;
                }
            }

            if (found == false) {

                var list = "<li id='c_" + ID + "'><input type='checkbox' id='li_c_" + ID + "' checked='checked' /><label for='li_c_" + ID + "' >" + searchedItems[k].Name + " <button class='Add_extra_things' title = 'Click to remove item from bill of material' style='font-size: 12pt;' onclick='removeNode(" + ID + ", &quot;Part Type&quot;)'><i class='fa fa-times' aria-hidden='true'></i></button></label>" +
                            "<ul>" +
							    "<li style='margin-left: 5%'>Stages in Manufacturing: <input type='number' title = 'Enter the stage in manufacturing' value='0' min='0' id='stage_bill_c_" + ID + "'/></li>" +
								"<li style='margin-left: 5%'>Quantity: <input type='number' title = 'Enter the component quantity' value='0' id='stage_quantity_c_" + ID + "'/></li>" +
							"</ul>" +
							"</li>";

                $("#components_list").append(list);


                var entry = { Recipe_Type: "Component", Quantity_Required: 0, Stage_in_Manufacturing: 0, resouce_ID: searchedItems[k].Component_ID, Item_Name: searchedItems[k].Name, price : searchedItems[k].Unit_Price };
                bill.push(entry);

            }
            else alertify.alert('Error', 'Component already in list.');
        }

    }
}

function removeNode(item_ID, which_one)
{
    if (which_one == "Raw Material")
    {
        var s = "#rm_" + item_ID;

        for (var a = 0; a < bill.length; a++) {
            if (bill[a].resouce_ID == item_ID && bill[a].Recipe_Type == "Raw Material") {
                bill_index = a;
                break;
            }
        }

        bill.splice(bill_index, 1);
        $(s).remove();
        
    }
    else if (which_one == "Part Type") {
        var s = "#p_" + item_ID;

        for (var a = 0; a < bill.length; a++) {
            if (bill[a].resouce_ID == item_ID && bill[a].Recipe_Type == "Part Type") {
                bill_index = a;
                break;
            }
        }

        bill.splice(bill_index, 1);
        $(s).remove();
    }
    if (which_one == "Component") {
        var s = "#c_" + item_ID;

        for (var a = 0; a < bill.length; a++) {
            if (bill[a].resouce_ID == item_ID && bill[a].Recipe_Type == "Component") {
                bill_index = a;
                break;
            }
        }

        bill.splice(bill_index, 1);
        $(s).remove();

    }

}

function openModal() {
    $("#supplierSearchModal").modal('show');
}

function FilterSearch() {
    var filter_text = $("#supplier_search").val();
    var filter_category = $("#filter_select").val();
    var method = $('input[name=method_radio]:checked', '#supplierSearchModal').val();

    $.ajax({
        type: "POST",
        url: "api/SearchSupplier",
        data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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
                searched_Suppliers = JSON.parse(result[1]).suppliers;
                $("#supplier_search_results").empty();

                if (searched_Suppliers.length == 0) {
                    $("#supplier_search_results").append("<option value=''>No results found.</option>");
                }
                else {

                    for (var k = 0; k < searched_Suppliers.length; k++) {
                        var type = '<option value="' + k + '">' + searched_Suppliers[k].Name + ' - ' + searched_Suppliers[k].Contact_Name + ' - ' + searched_Suppliers[k].Contact_Number + ' - ' + searched_Suppliers[k].Email + '</option>';
                        $("#supplier_search_results").append(type);
                    }
                }
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });
}

function addSupplier() {
    var k = $("#supplier_search_results").val();
    // console.log(k);

    if (k == "" || k == null)
        alertify.alert('Error', 'No Supplier has been chosen!');
    else {
        var found = false;

        var ID = searched_Suppliers[k].Supplier_ID;

        for (var a = 0; a < suppliers.length; a++) {
            if (suppliers[a].Supplier_ID == ID) {

                found = true;
            }
        }

        if (found == false) {
            var s = '<div class="row" id="supplier_' + ID + '">' +
                '<div class="col-sm-4">' +
                    '<label for="supplier_name_' + ID + '" class="control-label">Supplier Name: </label>' +
                    '<input type="text" class="form-control" id="supplier_name_' + ID + '" disabled maxlength="25"/>' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="price_' + ID + '" class="control-label">Supplier Price: </label>' +
                    '<input type="number" class="form-control" id="price_' + ID + '" value="0.00" step="0.01" min="0" title ="Enter the suppliers price"/>' +
                '</div>' +
                '<div class="col-sm-3">' +
                    '<label class="checkbox" for="supplier_pref_' + ID + '">Preferred:</label>' +
                    '<input type="checkbox" class="checkbox" title = "Select if the supplier is preferred" id="supplier_pref_' + ID + '"/>' +
                '</div>' +
                '<div class="col-sm-1">' +
                    '<br />' +
                    '<button type="button" class="Add_extra_things" title ="Click to remove the supplier" style="display: block; margin: 0 auto;" onclick="removeSupplier(' + ID + ') ">Remove <i class="fa fa-minus" aria-hidden="true"></i></button>' +
                '</div>' +
            '</div>';


            var supplier = { Supplier_ID: searched_Suppliers[k].Supplier_ID, unit_price: 0, Is_Prefered: false };
            suppliers.push(supplier);
            //console.log(supplier);

            $("#supplierDetailsDiv").append(s);

            $("#supplier_name_" + ID).val(searched_Suppliers[k].Name);
        }
        else
            alertify.alert('Error', 'Supplier already in list.');

    }

}

function removeSupplier(i) {
    var ID = i;
    for (var a = 0; a < suppliers.length; a++) {
        if (suppliers[a].Supplier_ID == ID) {
            suppliers.splice(a, 1);
        }
    }

    console.log(suppliers);
    $('#supplier_' + i).remove();
}

function addBlueprint() {
    var s = '<div class="row" id="blueprint_' + num_blueprints + '">' +
            '<div class="col-sm-6">' +
                '<label for="blueprint_name_' + num_blueprints + '" class="control-label">Blueprint Name: </label>' +
                '<input type="text" class="form-control" id="blueprint_name_' + num_blueprints + '" placeholder="Blueprint Name..." maxlength="25">' +
            '</div>' +
            '<div class="col-sm-4">' +
                '<label for="blueprint_file_' + num_blueprints + '" class="control-label">Blueprint File: </label>' +
                '<input type="file" class="form-control" id="blueprint_file_' + num_blueprints + '">' +
            '</div>' +
            '<div class="col-sm-2"><br/>' +
                '<button type="button" class="Add_extra_things" style="display: block; margin: 0 auto;" onclick="removeBlueprint(' + num_blueprints + ')">Remove <i class="fa fa-minus" aria-hidden="true"></i></button>' +
            '</div>' +
        '</div>' +
    '</div>';

    num_blueprints++;
    $("#blueprintField").append(s);
}

function removeBlueprint(xi)
{
    $('#blueprint_' + xi).remove();
}

function openModal2(for_what)
{
    var options;

    if (for_what == "Machine") {
        $("#m_modal_title").html("Add a Machine");

        options = '<option value="All">All</option>' +
            '<option value="Name">Name</option>' +
            '<option value="Model">Model</option>' +
            '<option value="Manufacturer">Manufacturer</option>' +
            '<option value="ID">Machine No.</option>';
					
        if (m_or_ml == "Manual Labour")
        {
            $("#m_search_results").empty();
            m_or_ml = "Machine";
        }
        
    }
    else if (for_what == "Manual Labour") {
        $("#m_modal_title").html("Add Manual Labour");

        options = '<option value="All">All</option>' +
            '<option value="Name">Name</option>' +
            '<option value="ID">Manual Labour No.</option>' +
            '<option value="Description">Description</option>';

        if (m_or_ml == "Machine") {
            $("#m_search_results").empty();
            m_or_ml = "Manual Labour";
        }
    }

    $("#m_select").empty();
    $("#m_select").append(options);
    
    $("#mSearchModal").modal('show');
}

function FilterSearch2() {
    var filter_text = $("#m_search").val();
    var filter_category = $("#m_select").val();
    var method = $('input[name=method_radio3]:checked', '#mSearchModal').val();

    $("#m_search_results").empty();

    if (m_or_ml == "Machine")
    {
        $.ajax({
            type: "POST",
            url: "api/SearchMachine",
            data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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
                    searched_m = JSON.parse(result[1]).machines;

                    if (searched_m.length == 0) {
                        $("#m_search_results").append("<option value=''>No results found.</option>");
                    }
                    else {

                        for (var k = 0; k < searched_m.length; k++) {
                            var type = '<option value="' + k + '">' + searched_m[k].Name + ' - ' + searched_m[k].Manufacturer + ' - ' + searched_m[k].Model + '</option>';
                            $("#m_search_results").append(type);
                        }
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
    } else
    {
        $.ajax({
            type: "POST",
            url: "api/SearchManualLabour",
            data: { data: "{'method' : '" + method + "', 'criteria' : '" + filter_text + "', 'category' : '" + filter_category + "'}" },
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
                    searched_m = JSON.parse(result[1]).manual_labour_types;

                    if (searched_m.length == 0) {
                        $("#m_search_results").append("<option value=''>No results found.</option>");
                    }
                    else {

                        for (var k = 0; k < searched_m.length; k++) {
                            var type = '<option value="' + k + '">' + searched_m[k].Name + '</option>';
                            $("#m_search_results").append(type);
                        }
                    }
                }
                else {
                    alertify.alert('Error', result[1], function () { });
                }
            }
        });
    }
}

function addM()
{
    var mx = $("#m_search_results").val();

    if (mx == "" || mx == null)
        alertify.alert('Error', 'No Machine/Manual Labour has been chosen!');
    else {

        var found = false;

        if (m_or_ml == "Machine") 
        {
            
            for (var a = 0; a < machines.length; a++) {
                if (machines[a].Machine_ID == searched_m[mx].Machine_ID) {

                    found = true;
                }
            }

            if (found == false)
            {
                var m_count = searched_m[mx].Machine_ID;

                var row = '<div class="row" id="m_row_' + m_count + '">' +
                '<div class="col-sm-4">' +
                    '<label for="m_name_' + m_count + '" class="control-label">Machine Name: </label>' +
                    '<input type="text" class="form-control" id="m_name_' + m_count + '" disabled />' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="m_stage_' + m_count + '" class="control-label">Stage in Manufacturing: </label>' +
                    '<input type="number" class="form-control" title = "Enter the stage in manufacturing"min="0" id="m_stage_' + m_count + '"  />' +
                '</div>' +
                '<div class="col-sm-2">' +

                '</div>' +
                '<div class="col-sm-2"><br/>' +
                    '<button type="button" class="Add_extra_things" title = "Click to remove the machine"style="display: block; margin: 0 auto;" onclick="removeMachine(' + searched_m[mx].Machine_ID + ')">Remove <i class="fa fa-minus" aria-hidden="true"></i></button>' +
                    '</div></div>';

                

                $("#m_details_div").append(row);
                $('#m_name_' + m_count).val(searched_m[mx].Name);

                //console.log(searched_m[mx]);

                var machine = { Machine_ID: searched_m[mx].Machine_ID, Stage_In_Manufacturing: 0 };
                machines.push(machine);
            } else alertify.alert('Error', 'Machine already in list.');
            
        }
        else {

           // console.log(mx);
            //console.log(manual_labours);
            
            for (var a = 0; a < manual_labours.length; a++) {
                if (manual_labours[a].Manual_Labour_Type_ID == searched_m[mx].Manual_Labour_Type_ID) {

                    found = true;
                }
            }

            if (found == false) {

                var ml_count = searched_m[mx].Manual_Labour_Type_ID;

                var row = '<div class="row" id="ml_row_' + ml_count + '">' +
                '<div class="col-sm-4">' +
                    '<label for="ml_name_' + ml_count + '" class="control-label">Manual Labour Name: </label>' +
                    '<input type="text" class="form-control" id="ml_name_' + ml_count + '" disabled />' +
                '</div>' +
                '<div class="col-sm-4">' +
                    '<label for="ml_stage_' + ml_count + '" class="control-label">Stage in Manufacturing: </label>' +
                    '<input type="number" class="form-control" title = "Enter the stage in manufacturing"min="0" id="ml_stage_' + ml_count + '"  />' +
                '</div>' +
                '<div class="col-sm-2">' +

                '</div>' +
                '<div class="col-sm-2"><br/>' +
                    '<button type="button" class="Add_extra_things" title ="Click to remove the manual labour type"style="display: block; margin: 0 auto;" onclick="removeManual(' + searched_m[mx].Manual_Labour_Type_ID + ')">Remove <i class="fa fa-minus" aria-hidden="true"></i></button>' +
                    '</div></div>';

                
                //console.log(searched_m[mx]);
                $("#ml_details_div").append(row);
                $('#ml_name_' + ml_count).val(searched_m[mx].Name);

                var manual = { Manual_Labour_Type_ID: searched_m[mx].Manual_Labour_Type_ID, Stage_In_Manufacturing: 0 };
                manual_labours.push(manual);
            } else alertify.alert('Error', 'Manual Labour already in list.');
        }
    } 

}

function removeMachine(mx)
{
    var ID = mx;
    for (var a = 0; a < machines.length; a++) {
        if (machines[a].Machine_ID == ID) {
            machines.splice(a, 1);
        }
    }

    console.log(machines);
    $('#m_row_' + mx).remove();
}

function removeManual(mx)
{
    var ID = mx;
    for (var a = 0; a < manual_labours.length; a++) {
        if (manual_labours[a].Manual_Labour_Type_ID == ID) {
            manual_labours.splice(a, 1);
        }
    }

    console.log(manual_labours);
    $('#ml_row_' + mx).remove();
}

$(document).ready(function () {

    $("#UC3-3").submit(function (e) {
        e.preventDefault();


        var warnings = "";

        var empty = checkEmpty();

        if (empty == false) {
            warnings = warnings + "One or more fields are empty. <br/>";
            $("#w_info").html(warnings);
            return false;
        }

        var name = $('#part_name').val();
        var abbr = $('#part_abbr').val();
        var dimensions = $('#dimensions').val();
        var sell = $('#part_price').val();
        var descr = $('#part_desc').val();
        var min_stock = $('#part_min_level').val();
        var max_stock = $('#part_max_level').val();
        var mdr = $('#part_max_disc').val();
        var manu_y = $('#manufactured_y').is(':checked');

        //validate the dimensions

        var res = false;
        
        for (var a = 0; a < bill.length; a++) {

            var ID = bill[a].resouce_ID;

            if (bill[a].Recipe_Type == "Raw Material") {
                var q = $("#stage_quantity_rm_" + ID).val();

                if (q < 1)
                    warnings += "Raw Material #" + ID + " has no quantity specified in bill of materials. <br/>";

                var stage = $("#stage_bill_rm_" + ID).val();

                if (stage < 1)
                    warnings += "Raw Material #" + ID + " has no stage specified in bill of materials. <br/>";

                var dimension = $("#rm_dimension_stage_" + ID).val();

                bill[a].Quantity_Required = q;
                bill[a].Stage_in_Manufacturing = stage;
                bill[a].Dimension = dimension;
            }
            if (bill[a].Recipe_Type == "Part Type") {
                var q = $("#stage_quantity_p_" + ID).val();

                if (q < 1)
                    warnings += "Part Type #" + ID + " has no quantity specified in bill of materials. <br/>";

                var stage = $("#stage_bill_p_" + ID).val();

                if (stage < 1)
                    warnings += "Part Type #" + ID + " has no stage specified in bill of materials. <br/>";

                bill[a].Quantity_Required = q;
                bill[a].Stage_in_Manufacturing = stage;

            }
            if (bill[a].Recipe_Type == "Component") {
                var q = $("#stage_quantity_c_" + ID).val();

                if (q < 1)
                    warnings += "Component #" + ID + " has no quantity specified in bill of materials. <br/>";

                var stage = $("#stage_bill_c_" + ID).val();

                if (stage < 1)
                    warnings += "Component #" + ID + " has no stage specified in bill of materials. <br/>";


                bill[a].Quantity_Required = q;
                bill[a].Stage_in_Manufacturing = stage;

            }

        }


        //Update supplier Details
        for (var p = 0; p < suppliers.length; p++) {
            var ID = suppliers[p].Supplier_ID;

            var isChecked = $('#supplier_pref_' + ID).is(':checked');
            var price = $('#price_' + ID).val();

            suppliers[p].unit_price = price;
            suppliers[p].Is_Prefered = isChecked;
        }

        var annogram = [];

        //Update Manual Labour details
        for (var p = 0; p < manual_labours.length; p++) {
            var ID = manual_labours[p].Manual_Labour_Type_ID;

            var stage = $('#ml_stage_' + ID).val();

            manual_labours[p].Stage_In_Manufacturing = stage;

            if (stage <= 0)
                warnings += "Please specify a stage for Manual Labour (" + ID + "). <br/>";

            annogram.push(stage);
        }

        //Update Machine details
        for (var p = 0; p < machines.length; p++) {
            var ID = machines[p].Machine_ID;

            var stage = $('#m_stage_' + ID).val();

            machines[p].Stage_In_Manufacturing = stage;

            if (stage <= 0)
                warnings += "Please specify a stage for Machine (" + ID + "). <br/>";

            annogram.push(stage);
        }

        var total_stages = machines.length + manual_labours.length;
        var annogram2 = [];

        for (var p = 1; p <= total_stages; p++)
            annogram2.push(p);

        annogram = customSortfunc(annogram);

        //console.log(annogram2 + " " + annogram);

        var a1 = annogram.join();
        var a2 = annogram2.join();

        if (a1 != a2)
            warnings += "Two or more stages are the same. <br/>";


        var pt = { Abbreviation: abbr, Name: name, Description: descr, Selling_Price : sell, Dimension : dimensions, Minimum_Level : min_stock,
            Maximum_Level: max_stock, Max_Discount_Rate : mdr, Manufactured : manu_y, Average_Completion_Time : 0
        };

        $("#w_info").html(warnings);


        if (warnings == "") {
            $.ajax({
                type: "POST",
                url: "api/PartType",
                data: { data: JSON.stringify({ partType: pt, supplier: suppliers, recipe: bill, manual: manual_labours, machine: machines }) },
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


                        sendFile(result[2]);

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
});

function customSortfunc(ann) {

    var temp;

    for (var k = 0; k < ann.length - 1; k++)
        for (var j = k; j < ann.length; j++) {
            if (ann[k] > ann[j]) {
                temp = ann[k];
                ann[k] = ann[j];
                ann[j] = temp;
            }
        }

    return ann;

}


</script>

<h1 class="default-form-header">Add Part Type</h1>
<form id="UC3-3" class="form-horizontal">
	<ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#parttype" title ="Click to select the part type tab">Part Type</a></li>
        <li><a data-toggle="tab" href="#blueprint" title ="Click to select the blueprint tab">Blueprint</a></li> 
        <li><a data-toggle="tab" href="#supplier" title ="Click to select the supplier tab">Supplier</a></li>
        <li><a data-toggle="tab" href="#mam" title ="Click to select the machine and manual labour type tab" >Machines and Manual Labour</a></li>
        <li><a data-toggle="tab" href="#bom" title ="Click to select the bill of materials tab">Bill of Materials</a></li>
    </ul>
    <br/>
    
    <div class="tab-content">
    <div id="parttype" class="tab-pane fade in active">
    <fieldset>
		<legend>Part Type Information:</legend>
		<div class="row">
			<div class="col-sm-4">
				<label for="part_name" class="control-label">Name: </label>
				<input type="text" class="form-control" id="part_name" placeholder="Part Type Name..." maxlength="25" title ="Enter the part type name" data-toggle ="tooltip">
			</div>
            <div class="col-sm-2">
				<label for="part_abbr" class="control-label">Abbreviation: </label>
				<input type="text" class="form-control" id="part_abbr" placeholder="VSH" maxlength="10" title ="Enter the part type abbreviation" data-toggle ="tooltip" data-placement ="bottom">
			</div>

			<div class="col-sm-4">
				<label for="dimensions" class="control-label">Dimensions: </label>
				<input type="text" class="form-control" id="dimensions" placeholder="a x b x c" maxlength="50"title ="Enter the part type dimensions" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-2">
				<label for="manufacutred_y" class="control-label">Manufactured: </label>
				<input type="checkbox" class="checkbox" id="manufacutred_y" title ="Select if part type is manufactured" data-toggle ="tooltip" data-placement ="bottom">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<label for="part_desc">Description:</label>
				<textarea class="form-control" rows="3" id="part_desc" maxlength="255" title ="Enter the part type description" data-toggle ="tooltip"></textarea>
			</div>
		</div>
		<div class="row">
            <div class="col-sm-3">
				<label for="part_price" class="control-label">Sell Price: </label>
				<input type="number" class="form-control" id="part_price" value="0.00" step="0.01" min="0" title ="Enter the selling price" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-3">
				<label for="part_min_level" class="control-label">Minimum Stock Level: </label>
				<input type="number" class="form-control" id="part_min_level" value="0" min="0"title ="Enter the minimum stock level" data-toggle ="tooltip" data-placement ="bottom">
			</div>
			<div class="col-sm-3">
				<label for="part_max_level" class="control-label">Maximum Stock Level: </label>
				<input type="number" class="form-control" id="part_max_level" value="0" min="0" title ="Enter the maximum stock level" data-toggle ="tooltip" data-placement ="right">
			</div>
			<div class="col-sm-3">
				<label for="part_max_disc" class="control-label">Maximum Discount Rate: </label>
				<input type="number" class="form-control" id="part_max_disc" value="0" max="100" step="0.01" title ="Enter the maximum discount rate" data-toggle ="tooltip" data-placement ="left">
			</div>
		</div>
	</fieldset>

    <div class="row">
		<div class="col-sm-8">

		</div>	
		<div class="col-sm-4">
            <button type = "submit" class = "form-custom-button-columns" title ="Click to add the part type" data-toggle ="tooltip" data-placement ="left"><i class="fa fa-check" aria-hidden="true"></i> Add Part Type</button>
		</div>
	</div>


	</div>
    
    <div id="blueprint" class="tab-pane fade">
	<fieldset>
	<legend>Blueprint Information:</legend>
        <div>
			<input type="file" name="fileUpload" id="fileUpload" multiple/><br />
		</div>
    </fieldset>
    </div>

    <div id="supplier" class="tab-pane fade">
	<fieldset>
	<legend>Supplier Information:</legend>
		<button type="button" class="Add_extra_things" onclick="openModal()" title ="Click to assign a supplier to the part type" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus" aria-hidden="true"></i> Add Supplier for Part Type</button>
		<div id="supplierDetailsDiv"></div>
				
	</fieldset>
    </div>
     
    <div id="mam" class="tab-pane fade">
    <fieldset>
	<legend>Machines and Manual Labour:</legend>
		<button type="button" class="Add_extra_things" onclick="openModal2('Machine')"title ="Click to assign a machine to the part type" data-toggle ="tooltip"><i class="fa fa-plus" aria-hidden="true"></i> Add Machine for Part Type</button>
        <button type="button" class="Add_extra_things" onclick="openModal2('Manual Labour')" title ="Click to assign a manual labour type to the part type" data-toggle ="tooltip"><i class="fa fa-plus" aria-hidden="true"></i> Add Manual Labour for Part Type</button>
		<div id="m_details_div">
            <h4>Machines:</h4>
		</div>

        <div id="ml_details_div">
            <h4>Manual Labour:</h4>
        </div>
	</fieldset>
	</div>

    <div id="bom" class="tab-pane fade">
	<fieldset>
        <legend>Bill of Materials:</legend>
        <div class="row">
			<div class="col-sm-6">
                <button type="button" class="Add_extra_things" onclick="addItem()" title ="Click to add an item to the bill of materials" data-toggle ="tooltip" data-placement ="right"><i class="fa fa-plus" aria-hidden="true"></i> Add Item to Bill</button>
			</div>
		</div>
        <br />

        <script type="text/javascript">
            $(document).ready(function () {

                $("#tree").on("change", "input[type=number]", function () {
                    
                    var total = 0;
                    console.log(bill);

                    for (var a = 0; a < bill.length; a++) {

                        var ID = bill[a].resouce_ID;

                        if (bill[a].Recipe_Type == "Raw Material") {
                           
                        }
                        if (bill[a].Recipe_Type == "Part Type") {
                            var q = $("#stage_quantity_p_" + ID).val();



                            total += parseInt(q) * bill[a].price;

                        }
                        if (bill[a].Recipe_Type == "Component") {
                            var q = $("#stage_quantity_c_" + ID).val();

                            //console.log("cq: " + q);

                            total += parseInt(q) * bill[a].price;

                        }

                    }
                    console.log("total: " + total);
                    
                    $("#part_price").val(total);

                });

            });
            

        </script>
       
        <div class="css-treeview" id="tree">
			<ul>
				<li><input type="checkbox" id="item-0" /><label for="item-0"><i class="fa fa-cube" aria-hidden="true"></i> Raw Materials</label>
					<ul id="raw_list">
						
					</ul>
				</li>
                <li><input type="checkbox" id="item-1" /><label for="item-1"><i class="fa fa-cog" aria-hidden="true"></i> Components</label>
					<ul id="components_list">
					</ul>
				</li>
                <li><input type="checkbox" id="item-2" /><label for="item-2"><i class="fa fa-cogs" aria-hidden="true"></i> Part Types</label>
					<ul id="part_list">
					</ul>
				</li>
				
			</ul>
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

<style>
    #inventory_search_Modal {
        width: 100%;
    }

    .form-inline .form-group{
    margin-left: 0;
    margin-right: 0;
}

</style>

<div class="modal fade" id="inventory_search_Modal">
<div class="modal-dialog" role="document">
<div class="modal-content">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
	<h4 class="modal-title">Add Item to Bill of Materials</h4>
	</div>
	<div class="modal-body">
		<div class="row">
			<div class="col-sm-4">
				<label for="search_criteria" class="control-label">Search Criteria: </label>
				<input type="text" class="form-control" id="search_criteria" placeholder="Search Criteria" title ="Enter the inventory item details to search by">
			</div>
			<div class="col-sm-4">
				<label for="search_category">Search By: </label>
				<select class="form-control" id="search_category" title ="Select the inventory item details to search by">
					<option value="All">All</option>
					<option value="Name">Name</option>
                    <option value="Description">Description</option>
				</select>
			</div>	
			<div class="col-sm-4">
                <label for="what">Search For: </label>
				<select class="form-control" id="what" title ="Select the inventory item type">
					<option value="Part Type">Part Type</option>
                    <option value="Component">Component</option>
                    <option value="Raw Material">Raw Material</option>
				</select>
			</div>
			</div>
			<div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="method_radio2">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio2">Contains</label>
		
				</div>
				<div class="col-sm-4">
					<button id="submitSearch" onclick="return searchForItem()" class ="form-custom-button-modal" title ="Search for the inventory item"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
				</div>
			</div>
		<div class="row">
			<div class="col-sm-12">
				<select multiple class="form-control" id="item_search_results" title ="Select the inventory item">
				</select>
			</div>
		</div>
	</div>
	<div class="modal-footer">
	<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Close the modal">Close</button>
	<button type="button" class="btn btn-secondary modalbutton" onclick="addItem2()" title ="Add inventory item to the bill">Add Inventory Item to Bill</button>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="supplierSearchModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title">Add Supplier</h4>
		</div>
		<div class="modal-body">
			<div class="row">
				<div class="col-sm-6">
					<input type="text" class="form-control" id="supplier_search" placeholder="Filter Results..." title ="Enter the suppliers details to search by"/>
				</div>
				<div class="col-sm-6">
					<select class="form-control" id="filter_select" title ="Select the suppliers details to search by">
						<option value="All">All</option>
						<option value="Name">Name</option>
						<option value="Email">Email</option>
                        <option value="CName">Contact Name</option>
						<option value="Contact_Number">Contact Number</option>
					</select>
				</div>
			</div>
            <div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="method_radio">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio">Contains</label>
				
				</div>
                <div class="col-sm-4">
					<button class = "form-custom-button-modal" style="" onclick="return FilterSearch()" title ="Click to filter search results"><i class="fa fa-check" aria-hidden="true" ></i> Filter</button>
				</div>
            </div>
			<div class="row">
				<div class="col-sm-12">
					<select multiple class="form-control" id="supplier_search_results" title ="Select the supplier">
					</select>
				</div>
			</div>
		</div>
		<div class="modal-footer">
            <button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Close the modal">Close</button>
		    <button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal">Add New Supplier</button>
		    <button type="button" class="btn btn-secondary modalbutton" onclick="addSupplier()" title ="Click to assign the supplier to the part type">Assign Supplier to Part Type</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div class="modal fade" id="mSearchModal">
	<div class="modal-dialog" role="document">
	<div class="modal-content">
		<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title" id="m_modal_title"></h4>
		</div>
		<div class="modal-body">
			<div class="row">
				<div class="col-sm-6">
					<input type="text" class="form-control" id="m_search" placeholder="Filter Results..." title ="Enter the details to search by"/>
				</div>
				<div class="col-sm-6">
					<select class="form-control" id="m_select" title ="Select the details to search by">
						
					</select>
				</div>
			</div>
            <div class="row">
                <div class="col-sm-8">
					<label class="control-label">Search Method: </label><br/>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Exact" checked name="method_radio3">Exact</label>
					<label class="radio-inline" title ="Select the search method"><input type="radio" value="Contains" name="method_radio3">Contains</label>
				
				</div>
                <div class="col-sm-4">
					<button class = "form-custom-button-modal" style="" onclick="return FilterSearch2()" title ="Filter the search results"><i class="fa fa-check" aria-hidden="true" ></i> Filter</button>
				</div>
            </div>
			<div class="row">
				<div class="col-sm-12">
					<select multiple class="form-control" id="m_search_results" title ="Select the item">
					</select>
				</div>
			</div>
		</div>
		<div class="modal-footer">
		<button type="button" class="btn btn-secondary modalbutton" data-dismiss="modal" title ="Click to close the moddal">Close</button>
		<button type="button" class="btn btn-secondary modalbutton" onclick="addM()" title="Click to assign to the part type">Assign to Part Type</button>
		</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->


</asp:Content>
