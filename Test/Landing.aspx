<%@ Page Title="Proteus" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="Landing.aspx.cs" Inherits="Test.Landing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
    <div class="row custom_Row_1">
	<div class="col-md-4">
		<div class="card card-2 row_1_card_1">
			<div class="top_text"><a href="PlaceSupplierOrder" class="custom_link_landing" id="Lan5-4" title ="Click to place a purchase order">Place Purchase Order</a></div><br/>
			<div class="bottom_text"><a href="PlaceCustomerOrder" class="custom_link_landing" id="Lan6-2" title ="Click to place a customer order">Place Customer Order</a></div>
			<img src="images/svg-basket.svg" alt="Logo" class="logo-img">
						
		</div>
	</div>
	<div class="col-md-4">
		<div class="card card-2 row_1_card_3">
			<div class="top_text"><a href="GenerateDeliveryNote" class="custom_link_landing" id="Lan6-5" title ="Click to generate delivery note">Generate Delivery Note</a></div><br/>
			<div class="bottom_text"><a href="GenerateInvoice" class="custom_link_landing" id="Lan6-6" title ="Click to generate delivery invoice">Generate Invoice</a></div>
			<img src="images/svg-delivery.svg" alt="Logo" class="logo-img">
		</div>
	</div>
	<div class="col-md-4">
		<div class="card card-2 row_1_card_2">
			<div class="top_text"><a href="GenerateJobCard" class="custom_link_landing" id="Lan4-1" title ="Click to add job card">Add Job Card</a></div><br/>
			<div class="bottom_text"><a href="ViewProductionSchedule" class="custom_link_landing" id="Lan4-8" title ="Click to view production schedule">View Production Schedule</a></div>
			<img src="images/svg-clipboard.svg" alt="Logo" class="logo-img">
		</div>
	</div>
</div>
	
    
			
<div class="row">

				
<style>
.bottom_button_card
{
	border : none;
	background-color: #36a910;
	font-size: 12pt;
	box-shadow: 0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23);
	margin: 2%;
	font-weight: unset;
}
					
.bottom_button_card:hover
{
	color: #333;
}

.todolistItems
{
	overflow-y: scroll;
	max-height: 530px;
	padding:0;
    height : 530px;
}
				
</style>
	<div class="col-md-4">
		<div class="card card-2 row_2_card_1">
			<div class="row headerRow_2">
					<div class="col-sm-10"><p style="margin:0 0 0;"><i class="fa fa-tasks" aria-hidden="true"></i> Stock Availability</p></div>
					
			</div>

            <script>
	            var url1 = '<%=ResolveUrl("~/Landing.aspx/openList") %>';
       

            //This function checks stock levels
            $(document).ready(function () {


                $.ajax({
                    type: "GET",
                    url: "api/LowStock",
                    contentType: "application/json",
                    dataType: "json",
                    error: function (xhr, ajaxOptions, thrownError) {
                        alert(xhr.status);
                        alert(xhr.responseText);
                        alert(thrownError);
                    },
                    success: function (msg) {
                        var result = msg.split("|");

                        if (result[0] == "true") {
                            
                            var ps = JSON.parse(result[1]).ps;
                            var comp = JSON.parse(result[1]).comp;


                            for (var k = 0; k < ps.length; k++)
                            {
                                var row = '<li><label class="todoChecklabel">' + ps[k].Abbreviation + ' - ' + ps[k].Name + ' is low on stock. Need (' +
                                    ps[k].Min_Stock + '), Have (' + ps[k].Quantity + ')</label></li>';
                                
                                $("#lowStock").append(row);
                            }

                            for (var k = 0; k < comp.length; k++)
                            {
                                var row = '<li><label class="todoChecklabel">' + comp[k].Name + ' is low on stock. Need (' +
                                   comp[k].Min_Stock + '), Have (' + comp[k].Quantity + ')</label></li>';

                                $("#lowStock").append(row);
                            }


                            //console.log(result[1]);
                        }
                        else {
                            alertify.alert('Error', result[1], function () { });
                        }
                        return false;
                    }
                });


            });
				
        </script>

			<div class="todolistItems">
				<ul class="list" id="lowStock">

				</ul>
			</div>			

	</div>
   </div>
				
				
	<link rel='stylesheet' href='fullcalendar/fullcalendar.css' />
	<link href="fullcalendar/fullcalendar-custom.css" rel="stylesheet">
				
	<div class="col-md-8">
		<div class="card card-2 row_2_card_2">
			<div id="calendar"></div>
		</div>
					
		<script src='fullcalendar/moment.js'></script>
		<script src='fullcalendar/fullcalendar.js'></script>
		<script>

		    //TO DO: Add functionality to add an event to the calendar.

            var Employee_ID = '<%= Session["Employee_ID"] %>';
            var Access_Level = '<%= Session["Access_Level"] %>'.split("~");

		    $(document).ready(function () {
			    $.ajax({
			        type: "GET",
			        url: "api/Employee/" + Employee_ID,
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
			                var emp = JSON.parse(result[1]).employees[0];
			                $('#Access_Level').html(Access_Level);
			                $('#Employee_Type').html(emp.Employee_Type);
			                $('#Employee_ID').html(Employee_ID);
			                $('#Username').html(emp.Name + ' (' + emp.Username + ')<br/> <img src="images/Employees/emp_' + Employee_ID + '_image.png" class="img-responsive" style="margin: 0 auto; height: 120px; width: auto;" alt="No employee image found"/>');
			            }
			            else { alertify.alert('Error', result[1]); }

			        }
			    });

				var date = new Date();
				var d = date.getDate();
				var m = date.getMonth() + 1;
				var y = date.getFullYear();
				if(m < 10)
				var complete_d = y + '-0'+ m +'-' + d;
				else 
				var complete_d = y + '-'+ m +'-' + d;

				
				var send_data = "{'criteria' : 'NotComplete', 'category' : 'NotComplete', 'method' : 'Exact'}";
				$.ajax({
				    type: "POST",
				    url: "api/SearchCustomerOrder",
				    data: { data: send_data },
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
				            orders = JSON.parse(result[1]).client_orders;
				        }
				        else
				            alertify.alert('Error', result[1], function () { });
				    }
				});

				var nevents = [];

				for (var k = 0; k < orders.length; k++)
				{
				    var id = orders[k].Client_Order_ID;
				    var title = "Order #" + orders[k].Client_Order_ID;
				    var start = orders[k].Date;



				    var event = {
				        "id": id,
				        "title": title,
				        "start": start,
				        "end": start,
				        "allDay": true,
				        editable: false,
				        backgroundColor: '#F86915',
				        borderColor: '#F86915',
				        textColor: '#333',
				        url: '/ViewOutstandingCustomerOrders'
				    };
				    nevents.push(event);
				}
				
				//var nevents = [{ "id": "2302", "title": "XXX", "start": '2016-09-23T00:00:00', "end": "2016-09-23T00:00:00", "allDay": true, "url": "xxx" }];

				$('#calendar').fullCalendar({
					defaultDate: complete_d,
					editable: false,
					eventLimit: true, // allow "more" link when too many events
					aspectRatio: 3.1,
					header: 
					{
						left: 'prev',
						center: 'title',
						right: 'next'
					},
					events: nevents
				});


			});
		</script>
					
		<br/>
		<div class="row">
		<div class="col-md-4 col-inner">
			<div class="card card-2 row_2_card_1">
				<div class="row headerRow_1">
					<div class="col-sm-10"><p style="margin:0 0 0;">Job Cards in Production</p></div>
					<div class="col-sm-2" style="text-align:right; padding-right: 2%;"><a href="#" class="icon_link" data-toggle="tooltip" title="View Client Back Orders"><i class="fa fa-book" aria-hidden="true"></i></a></div>
				</div>
						
				<div style="padding: 15px;">
					<canvas id="myChart"></canvas>

					<style>
					canvas{
						width: 100% !important;
						max-width: 200px;
						height: auto !important;
						margin: 0 auto;
					}
					</style>
					<script src="scripts/Chart.js"></script>
				<script>

				    var x = 0;
				    var y = 0;

				    var send_data = "{'criteria' : 'NotComplete', 'category' : 'NotComplete', 'method' : 'Exact'}";
				    $.ajax({
				        type: "POST",
				        url: "api/SearchCustomerOrder",
				        data: { data: send_data },
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
				                y = JSON.parse(result[1]).client_orders.length;
				            }
				            else
				                alertify.alert('Error', result[1], function () { });
				        }
				    });

				    $.ajax({
				        type: "GET",
				        url: "api/JobCardBack",
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
				                x = JSON.parse(result[1]).job_cards.length;
				            }
				            else
				                alertify.alert('Error', result[1], function () { });
				        }
				    });

				    var ctx = document.getElementById("myChart").getContext("2d");
				    ctx.canvas.width = 5;
				    ctx.canvas.height = 5;

				    var data = {
				        labels: ["Manufacuturing", "Client"],
				        datasets: [
                            {
                                label: "",
                                backgroundColor: [
									"#259094",
									"#465F61"
                                ],
                                hoverBackgroundColor: [
                                    "#259094",
                                    "#465F61"
                                ],
                                borderWidth: 1,
                                data: [x,y]
                            }
				        ]
				    };

				    var myBarChart = new Chart(ctx, {
				        type: 'bar',
				        data: data,
				        options: {
				            title: {
				                // Overrides the global setting
				                display: true
				            },
				            legend: {
				                display : false
				            },
				            scales:
                            {
                                xAxes: [{
                                    display: false
                                }]
                            }
				        }
				    });



				</script>
				</div>
			</div>
		</div> 
		<div class="col-md-8 col-outer">
		<div class="card card-2 row_2_card_3">
			<div id="exTab1" >	
			<ul  class="nav nav-pills">
				<li class="active" >
					<a  href="#1a" data-toggle="tab">My Details</a>
				</li>
				<li>
					<a href="#2a" data-toggle="tab" title ="Click to view other settings">Other Settings</a>
				</li>
			</ul>

			<div class="tab-content clearfix">
				<div class="tab-pane active" id="1a" >
					<div class="tab-pane-above" id="Username">
						
					</div>
                    <style>
                        .colrowcustom {
                            position: absolute;
                            bottom : 0px;
                            width: 97%;
                        }

                    </style>
					<div class="row colrowcustom">
						<div class="col-md-6 col1">
							Role: <br/><br/><span id="Employee_Type"></span>
						</div>
						<div class="col-md-6 col3">
							Employee ID: <br/><br/>
							<span id="Employee_ID"></span>
						</div>
					</div>
				</div>
				<div class="tab-pane" id="2a">
					<div class="row social-row">
						<button class = "form-custom-button-columns" onclick="backUp()" title ="Click to back-up the database" data-toggle ="tooltip" data-placement ="top"><i class="fa fa-cloud-download" aria-hidden="true"></i> Export the Database</button>
					</div>
					<div class="row social-row">
						<button class = "form-custom-button-columns" onclick="restore()" title ="Click to restore the database" data-toggle ="tooltip" data-placement ="top"><i class="fa fa-cloud-upload" aria-hidden="true"></i> Import a Database</button>
					</div>
				</div>
			</div>
			</div>
			</div>
		</div>
	</div>
	</div>
	
    <script>
        function backUp()
        {
            $.ajax({
                type: "POST",
                url: " api/BackUp/back_up",
                data: { },
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                },
                success: function (msg) {
                    var res = msg.split("|");

                    if (res[0] == "true")
                    {
                        alertify.alert('Success', res[1], function () { });
                    }
                    else alertify.alert('Error', res[1], function () { });

                }
            });
        }

        function restore()
        {
            $.ajax({
                type: "GET",
                url: " api/BackUp",
                data: {},
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                },
                success: function (msg) {
                    var res = msg.split("|");

                    console.log(res);

                    if (res[0] == "true") {
                        alertify.alert('Success', res[1], function () { });
                    }
                    else alertify.alert('Error', res[1], function () { });

                }
            });
        }

    </script>	
				
				
				
</div>
</asp:Content>
