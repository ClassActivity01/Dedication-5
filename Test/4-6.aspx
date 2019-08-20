<%@ Page Title="Generate Production Schedule" Language="C#" MasterPageFile="~/navigation.Master" AutoEventWireup="true" CodeBehind="4-6.aspx.cs" Inherits="Test._4_6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="maincontent" runat="server">
<script>				
	jQuery(document).ready(function ($)
	{
        //Fetches the production Schedule
	    $.ajax({
	        type: "POST",
	        url: "api/ProductionSchedule",
	        data: {data: JSON.stringify({date: new Date()})},
	        error: function (xhr, ajaxOptions, thrownError) {
	            alert(xhr.status);
	            alert(xhr.responseText);
	            alert(thrownError);
	        },
	        success: function (msg) {
	            var result = msg.split("|");

	            if (result[0] == "true") 
	            {
	                alertify.alert('Successful', result[1], function () { location.href = "ViewProductionSchedule"; });
	            }
	            else {
	                alertify.alert('Error', result[1], function () { });
	            }
	            }
	        });
	});
</script>
</asp:Content>
