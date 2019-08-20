

function addRawMaterial_order(i)
{
	var ID = i;
	var raw_material_name = "Tester";
	var s = '<tr id="rm_ID_'+ID+'">'+
		'<td>'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeRawMaterial('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+raw_material_name+'</button></td>'+
		'<td><input type="text" class="form-control" id="rm_'+ID+'_dimensions" placeholder="a X b X c"/></td>'+
		'<td><input type="number" class="form-control" id="rm_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td>R 0.00</td>' +
	'</tr>';
	$("#rawMaterialItems").append(s);
}

function addRawMaterial_Supplier(i)
{
	var ID = i;
	var raw_material_name = "Tester";
	var s = '<tr id="rm_ID_'+ID+'">'+
		'<td>'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeRawMaterial('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+raw_material_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="rm_'+ID+'_price"/></td>' +
	'</tr>';
	$("#rawMaterialItems").append(s);
}

function removeRawMaterial(i)
{
	$('#rm_ID_' + i).remove();
}

function addComponents(i)
{
	var ID = i;
	var set_part_name = "Tester";
	var s = 	'<tr id="sp_ID_'+ID+'">'+
		'<td >'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeComponent('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+set_part_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_price"/></td>'+
	'</tr>';
	$("#ComponentItems").append(s);
}

function addComponents_order(i)
{
	var ID = i;
	var set_part_name = "Tester";
	var s = 	'<tr id="sp_ID_'+ID+'">'+
		'<td >'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeComponent('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+set_part_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td>R 0.00</td>'+
	'</tr>';
	$("#ComponentItems").append(s);
}

function addComponents_supplier(i)
{
	var ID = i;
	var set_part_name = "Tester";
	var s = 	'<tr id="sp_ID_'+ID+'">'+
		'<td >'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeComponent('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+set_part_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_price"/></td>'+
	'</tr>';
	$("#ComponentItems").append(s);
	
}


function removeComponent(i)
{
	$('#sp_ID_' + i).remove();
}

function addPart(i)
{
	var ID = i;
	var part_name = "Tester";
	var s = 	'<tr id="p_ID_'+ID+'">'+
		'<td >'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removePart('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+part_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="p_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td><input type="number" class="form-control" id="p_'+ID+'_price"/></td>'+
	'</tr>';
	$("#PartItems").append(s);
}

function addPart_order(i)
{
	var ID = i;
	var part_name = "Tester";
	var s = 	'<tr id="p_ID_'+ID+'">'+
		'<td >'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removePart('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+part_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="p_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td>R 0.00</td>'+
	'</tr>';
	$("#PartItems").append(s);
}

function addPart_Supplier(i)
{
	var ID = i;
	var part_name = "Tester";
	var s = 	'<tr id="p_ID_'+ID+'">'+
		'<td >'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removePart('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>'+part_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="p_'+ID+'_price"/></td>'+
	'</tr>';
	$("#PartItems").append(s);
	
}

function removePart(i)
{
	$('#p_ID_' + i).remove();
}


/*function show(what)
{
	if(what == "component")
	{
		if($("#ComponentsFieldset").is(":visible"))
		{
			$("#showComponentButton").html('<i class="fa fa-plus" aria-hidden="true"></i> Add Components');
			$("#ComponentsFieldset").hide();
		}
		else
		{
			$("#showComponentButton").html('<i class="fa fa-minus" aria-hidden="true"></i> Do not add Components');
			$("#ComponentsFieldset").show();
		}	
	}
	else if(what =="parts")
	{
		if($("#partsFieldset").is(":visible"))
		{
			$("#showPartButton").html('<i class="fa fa-plus" aria-hidden="true"></i> Add Parts');
			$("#partsFieldset").hide();
		}
		else
		{
			$("#showPartButton").html('<i class="fa fa-minus" aria-hidden="true"></i> Do not add Parts');
			$("#partsFieldset").show();
		}	
	}
	else if (what == "raw")
	{
		if($("#RawMaterialsFieldset").is(":visible"))
		{
			$("#showRawButton").html('<i class="fa fa-plus" aria-hidden="true"></i> Add Raw Materials');
			$("#RawMaterialsFieldset").hide();
		}
		else
		{
			$("#showRawButton").html('<i class="fa fa-minus" aria-hidden="true"></i> Do not add Raw Materials');
			$("#RawMaterialsFieldset").show();
		}	
	}
}*/

function dosomething()
{
	
	console.log($("#rm_1_quantity").val());
}

function addToJobCard(i)
{
	var ID = i;
	var part_name = "Tester";
	var s = 	'<tr id="part_'+ID+'">'+
		'<td>'+ID+'</td>'+
		'<td>VSH</td>'+
		'<td><button type="button" class="addToList" onclick="removeFromJobCard('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i> '+part_name+'</button></td>'+
		'<td><input type="number" class="form-control" id="p_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
	'</tr>';
	$("#jobCardItems").append(s);
	
}

function removeFromJobCard(i)
{
	var ID = i;
	$('#part_' + i).remove();
}

$(document).ready(function($) {
	$(".collapsible").click(function() {
		var original = $(this).children("i").attr("class");
		$(this).children("i").attr("class", original == 'fa fa-chevron-down' ? 'fa fa-chevron-up' : 'fa fa-chevron-down');
	});
});

function addPartSearch()
{
	$("#partSearchModal").modal('show');
}

function addComponentSearch()
{
	$("#componentSearchModal").modal('show');
}

function addRawSearch()
{
	$("#rawSearchModal").modal('show');
}

var ID = 0;

function addItemToQuote(what)
{
	ID++;
	if(what == "part")
	{
		var s = '<tr id="item_'+ID+'">'+
		'<td>'+ID+'</td>'+
		'<td>Component</td>'+
		'<td id="p_'+ID+'">'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeItem('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>Tester</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_price"/></td>'+
		'</tr>';
		$("#QuoteItems").append(s);
	}
	else if(what == "component")
	{
		
		var s = '<tr id="item_'+ID+'">'+
		'<td>'+ID+'</td>'+
		'<td>Component</td>'+
		'<td id="c_'+ID+'">'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeItem('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>Tester</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_price"/></td>'+
		'</tr>';
		$("#QuoteItems").append(s);
		
	}
	else if(what == "raw")
	{
		var dimensions = prompt("Please enter the preffered dimensions for [raw material]", "a X b X c");
		var s = '<tr id="item_'+ID+'">'+
		'<td>'+ID+'</td>'+
		'<td>Raw Material</td>'+
		'<td id="c_'+ID+'">'+ID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeItem('+ID+')"><i class="fa fa-minus" aria-hidden="true"></i>Tester - '+dimensions+'</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td><input type="number" class="form-control" id="sp_'+ID+'_price"/></td>'+
		'</tr>';
		$("#QuoteItems").append(s);
		
	}
}

function removeItem(i)
{
	ID--;
	$('#item_' + i).remove();

}

var orderID = 0;
function addItemTo_order(what)
{
	orderID++;
	if(what == "part")
	{
		var s = '<tr id="item_'+ID+'">'+
		'<td>'+orderID+'</td>'+
		'<td>Component</td>'+
		'<td id="p_'+orderID+'">'+orderID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeOrderItem('+orderID+')"><i class="fa fa-minus" aria-hidden="true"></i>Tester</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+orderID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td>R 0.00</td>'+
		'</tr>';
		$("#orderItems").append(s);
	}
	else if(what == "component")
	{
		
		var s = '<tr id="item_'+orderID+'">'+
		'<td>'+orderID+'</td>'+
		'<td>Component</td>'+
		'<td id="c_'+orderID+'">'+orderID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeOrderItem('+orderID+')"><i class="fa fa-minus" aria-hidden="true"></i>Tester</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+orderID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td>R 0.00</td>'+
		'</tr>';
		$("#orderItems").append(s);
		
	}
	else if(what == "raw")
	{
		var dimensions = prompt("Please enter the preffered dimensions for [raw material]", "a X b X c");
		var s = '<tr id="item_'+orderID+'">'+
		'<td>'+orderID+'</td>'+
		'<td>Raw Material</td>'+
		'<td id="c_'+orderID+'">'+orderID+'</td>'+
		'<td><button type="button" class="addToList" onclick="removeOrderItem('+orderID+')"><i class="fa fa-minus" aria-hidden="true"></i>Tester - '+dimensions+'</button></td>'+
		'<td><input type="number" class="form-control" id="sp_'+orderID+'_quantity" value="1" min="1" max="999"/></td>'+
		'<td>R 0.00</td>'+
		'</tr>';
		$("#orderItems").append(s);
		
	}
}

function removeOrderItem(i)
{
	orderID--;
	$('#item_' + i).remove();

}

function choosePartForTask(i)
{
	
	
}