//returns the price of an invetory item for the given supplier
function getPrice(ID, inventory_type, s_ID) {
    var price;

    $.ajax({
        type: "POST",
        url: "api/PartSupplierPrice",
        data: { data: "{'Supplier_ID' : '" + s_ID + "', 'Inventory_Type' : '" + inventory_type + "', 'Item_ID': '" + ID + "', 'What' : 'Price'}" },
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.status);
            console.log(xhr.responseText);
            console.log(thrownError);
        },
        success: function (msg) {
            var result = msg.split("|");

            if (result[0] == "true") {
                price = result[1];
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    return price;
}

function getSellingPrice(inventory_type, ID)
{
    var price;

    $.ajax({
        type: "POST",
        url: "api/PartSupplierPrice",
        data: { data: "{'Supplier_ID' : '" + 0 + "', 'Inventory_Type' : '" + inventory_type + "', 'Item_ID': '" + ID + "', 'What' : 'SellingPrice'}" },
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.status);
            console.log(xhr.responseText);
            console.log(thrownError);
        },
        success: function (msg) {
            var result = msg.split("|");

            if (result[0] == "true") {
                price = result[1];
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    return price;
}

//Returns the total stock available for the given inventory item
function getStockAvailable(ID, inventory_type) {
    var stock;

    $.ajax({
        type: "POST",
        url: "api/PartSupplierPrice",
        data: { data: "{'Supplier_ID' : '" + 0 + "','Inventory_Type' : '" + inventory_type + "', 'Item_ID': '" + ID + "', 'What' : 'Stock_Available'}" },
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.status);
            console.log(xhr.responseText);
            console.log(thrownError);
        },
        success: function (msg) {
            var result = msg.split("|");

            if (result[0] == "true") {
                stock = result[1];
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    return stock;
}

//returns the value of the min_stock field of the given inventory item
function getMinStock(ID, inventory_type) {
    var stock;

    $.ajax({
        type: "POST",
        url: "api/PartSupplierPrice",
        async : false,
        data: { data: "{'Supplier_ID' : '" + 0 + "','Inventory_Type' : '" + inventory_type + "', 'Item_ID': '" + ID + "', 'What' : 'Min_Stock'}" },
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.status);
            console.log(xhr.responseText);
            console.log(thrownError);
        },
        success: function (msg) {
            var result = msg.split("|");

            if (result[0] == "true") {
                stock = result[1];
            }
            else {
                alertify.alert('Error', result[1], function () { });
            }
        }
    });

    return stock;
}

function getVATRate()
{
    var vat = 14;

    $.ajax({
        type: "GET",
        url: "api/VAT",
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
                var vat = JSON.parse(result[1]).vats[0];

                vat = vat.VAT_Rate * 100;

            }
            else
                alertify.alert('Error', result[1], function () { });
        }
    });

    return parseInt(vat);
}