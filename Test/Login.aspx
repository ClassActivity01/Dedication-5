<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Test.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
	<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
	<title>Login</title>
    <script src="scripts/jquery-1.9.1.min.js"></script>
    <link rel="stylesheet" href="Content/bootstrap.min.css" />
    <script src="scripts/bootstrap.js"></script>
    <link rel="stylesheet" type="text/css" href="css/fonts.css" />
    <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="css/normalize.css" />
    <link rel="stylesheet" type="text/css" href="css/default-form.css" />
    <link rel="stylesheet" type="text/css" href="css/login.css" />
    <script src="scripts/MyScripts/generalFormValidation.js"></script>
    <script src="scripts/MyScripts/tooltip.js"></script>

    <script src="alertify/alertify.min.js"></script>
    <link rel="stylesheet" type="text/css" href="alertify/css/alertify.css" />
    <link rel="stylesheet" type="text/css" href="alertify/css/default.css" />
</head>
<body>
    <div class="container">
		<div class="login-div">
			<h1 class="login-heading">Login to System</h1>
			<p class="login-subtext">Walter Meano Engineering</p>
			<form action="" method="post" id="login-form">
				<fieldset class="form-group">
					<label for="username-input"><i class="fa fa-user" aria-hidden="true"></i> Username:</label>
					<input type="text" class="form-control" id="username-input" placeholder="Username" maxlength="20" title ="Please enter your username in the field bellow" data-toggle ="tooltip"><br/>
					<label for="password-input"><i class="fa fa-asterisk" aria-hidden="true"></i> Password:</label>
					<input type="password" class="form-control" id="password-input" placeholder="*****" maxlength="20" title ="Please enter the password associated with your username" data-toggle ="tooltip" >
				</fieldset>
				<button type="input" class="login-button" id="Login" title ="Click here to login" data-toggle ="tooltip"><i class="fa fa-sign-in" aria-hidden="true"></i> Login</button>
				
			</form>
		</div>			
	</div>
	
	<script>
	    $("#Login").click(function (e) {
	        e.preventDefault();
	        var url1 = 'Login.aspx/login';

	        var u = $("#username-input").val();
	        var p = $("#password-input").val();
	        var flag = true;

	        if (u.trim().length === 0)
	        {
	            $("#password-input").addClass("empty");
	            flag = false;
	        }

	        if (p.trim().length === 0) {
	            $("#username-input").addClass("empty");
	            flag = false;
	        }


            if(flag == true)
            $.ajax({
                type: "POST",
                url: url1,
                data: "{'username' : '"+u+"', 'password' : '"+p+"'}",
                contentType: "application/json;",
                dataType: "json",
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(xhr.responseText);
                    alert(thrownError);
                },
                success: function (msg)
                {
                    var result = msg.d.split("|");

                    if (result[0] == "true") {
                        window.location = "Home"
                    }
                    else {
                        alertify.alert('Error', result[1], function () { });
                    }
                }
	        });

	        return false;
	    });

    </script>
</body>
</html>
