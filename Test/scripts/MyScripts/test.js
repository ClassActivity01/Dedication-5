var products = [{ ProductId: 1, ProductName: "Mercedes", Category: "Cars", Price: 25000 }, { ProductId: 2, ProductName: "Otobi", Category: "Furniture", Price: 20000 }];

function SendSugar() {
    $.ajax({
        type: "POST",
        url: "test1.aspx/testTheCode",
        data: "{'Products':" + JSON.stringify(products) + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(xhr.responseText);
            alert(thrownError);
        },
        success: function (msg) {
            alert(msg.d);
        }
    });
}

var pony = "{'Name': 'Ponyita','Type': 'Pokemon','Items': ['Comb','Bow','Pie'], 'Size' : 4}";

function sendPony() {
    $.ajax({
        type: "POST",
        url: "test1.aspx/FindTheSugar",
        data: "{'Pony':" + JSON.stringify(pony) + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(xhr.responseText);
            alert(thrownError);
        },
        success: function (msg) {
            alert(msg.d);
        }
    });
}

function moreComplicated()
{
    var empname = "Jane";
    var empsurname = "Shepard";

    var empmachines = new Array();
    empmachines[0] = "item1";
    empmachines[1] = "item2";
    empmachines[2] = "item3";

    var employee = "{ 'name': '" + empname + "', 'surname': '" + empsurname + "'}";
    console.log(employee);

    $.ajax({
        type: "POST",
        url: "test1.aspx/EmployeeFunction",
        data: "{'employee' : "+ JSON.stringify(employee) +", 'machines' : '"+ JSON.stringify( empmachines) +"'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(xhr.responseText);
            alert(thrownError);
        },
        success: function (msg) {
            alert(msg.d);
        }
    });

}