<%@ Page Title="View Job Cards in Production" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-9.aspx.cs" Inherits="Test._4_9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<script>
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
                    var job_cards = JSON.parse(result[1]).job_cards;

                    for (var k = 0; k < job_cards.length; k++) {

                        var html = '<div id="job_card_' + job_cards[k].Job_Card_ID + '"><fieldset><legend>Job Card #'+job_cards[k].Job_Card_ID+'</legend>';

                        var date = job_cards[k].Job_Card_Date.split("T");
                        var status = job_cards[k].Job_Card_Status_Name;
                        var priority;

                        if (job_cards[k].Job_Card_Priority_ID == 1)
                            priority = "Customer Order";
                        else
                            priority = "Manufacturing Order";

                        html += '<div class="row"> <div class="col-sm-2"> Date: </div> <div class="col-sm-10"><span id="job_card_date">' + date[0] + '</span></div>' +
                            '<div class="col-sm-2"> Status: </div> <div class="col-sm-10"><span id="job_card_status">' + status + '</span></div>' +
                            '<div class="col-sm-2"> Priority: </div> <div class="col-sm-10"><span id="job_card_priority">' + priority + '</span></div></div>';


                        html += '<div class="table-responsive makeDivScrollable"><table class="table table-hover" ><thead><tr><th>Part Type No.</th><th>Part Type Name</th><th>Quantity to Manufacture</th></tr></thead><tbody id="Items">';


                        for (var a = 0; a < job_cards[k].details.length; a++)
                        {
                            html += '<tr>'+
                                        '<td>'+job_cards[k].details[a].Part_Type_ID+'</td>'+
					                    '<td>'+job_cards[k].details[a].Name+'</td>'+
					                    '<td>'+job_cards[k].details[a].Quantity +'</td>'+
				                    '</tr>';

                            var ID = job_cards[k].details[a].Part_Type_ID;

                            for(var p = 0; p < job_cards[k].details[a].parts.length; p++)
                            {
                                if (job_cards[k].details[a].parts[p].Part_Type_ID == ID)
                                {
                                    html += '<tr><td></td><td>Part - ' + job_cards[k].details[a].parts[p].Part_Serial + '</td><td>' + job_cards[k].details[a].parts[p].Part_Status_Name + '</td></tr>';
                                }
                            }

                        }


                        html += '</tbody></table></div> </fieldset></div><br/>';

                        $("#wrapper").append(html);
                    }
                }
                else
                    alertify.alert('Error', result[1]);
            }
        });

    });
</script>

<h1 class="default-form-header">View Job Cards in Production</h1>
<div id="wrapper">
 
</div>
</asp:Content>
