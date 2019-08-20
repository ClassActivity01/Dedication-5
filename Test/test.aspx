<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="Test.test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script src="scripts/jquery-1.9.1.min.js"></script>
	<link rel="stylesheet" href="Content/bootstrap.min.css"/>
	<script src="scripts/bootstrap.js"></script>
	<!--<link rel="stylesheet" type="text/css" href="css/fonts.css" />-->
	<link rel="stylesheet" href="font-awesome/css/font-awesome.min.css" />
	
    <!-- Custom -->
    <link rel="stylesheet" type="text/css" href="css/normalize.css" />
	<link rel="stylesheet" type="text/css" href="css/general_and_landing.css" />
    <link rel="stylesheet" type="text/css" href="css/default-form.css" />
    <script src="scripts/MyScripts/generalFormValidation.js"></script>
    <script src="scripts/MyScripts/orders_script.js"></script>
    <script src="scripts/MyScripts/timer.js"></script>
    <script src="scripts/MyScripts/getterScripts.js"></script>
    
    <!-- Alertify -->
    <script src="alertify/alertify.min.js"></script>
    <link rel="stylesheet" type="text/css" href="alertify/css/alertify.css" />
    <link rel="stylesheet" type="text/css" href="alertify/css/default.css" />
   
    <!-- Jquery UI -->
    <link rel="stylesheet" href="css/jquery-ui.css">
    <script src="scripts/jquery-ui.min.js"></script>
</head>
<body>
<style>
	/*
		* CSS3 Treeview. No JavaScript
	    * @version 1.0
		* @author Martin Ivanov
		* @url developer's website: http://wemakesites.net/
	    * @url developer's twitter: https://twitter.com/#!/wemakesitesnet
		* @url developer's blog http://acidmartin.wordpress.com/
		**/
		 
	/*
		* This solution works with all modern browsers and Internet Explorer 9+. 
		* If you are interested in purchasing a JavaScript enabler for IE8 
		* for the CSS3 Treeview, please, check this link:
		* http://experiments.wemakesites.net/miscellaneous/acidjs-css3-treeview/
		**/
		 
	.css-treeview ul,
	.css-treeview li
	{
		padding: 0;
		margin: 0;
		list-style: none;
	}

	.css-treeview input[type='checkbox']
	{
		position: absolute;
		opacity: 0;
	}

    .css-treeview input[type='text'] {
        margin-bottom : 1%;
    }

	.css-treeview
	{
		-moz-user-select: none;
		-webkit-user-select: none;
		user-select: none;
	}

	.css-treeview a
	{
		color: #00f;
		text-decoration: none;
	}

	.css-treeview a:hover
	{
		text-decoration: underline;
	}

	.css-treeview input + label + ul
	{
		margin: 0 0 0 22px;
	}

	.css-treeview input ~ ul
	{
		display: none;
	}

	.css-treeview label,
	.css-treeview label::before
	{
		cursor: pointer;
	}

	.css-treeview input:disabled + label
	{
		cursor: default;
		opacity: .6;
	}

	.css-treeview input:checked:not(:disabled) ~ ul
	{
		display: block;
	}

	.css-treeview label,
	.css-treeview label::before
	{
			
	}

	.css-treeview label,
	.css-treeview a,
	.css-treeview label::before
	{
		display: inline-block;
		height: 16px;
		line-height: 16px;
		vertical-align: middle;
	}

	.css-treeview label
	{
		background-position: 18px 0;
	}

	.css-treeview label::before
	{
		content: "";
		width: 16px;
		margin: 0 22px 0 0;
		vertical-align: middle;
		background-position: 0 -32px;
	}

	.css-treeview input:checked + label::before
	{
		background-position: 0 -16px;
	}

    .indent {
        margin-left : 3%;
    }

	/* webkit adjacent element selector bugfix */
	@media screen and (-webkit-min-device-pixel-ratio:0)
	{
		.css-treeview 
		{
			-webkit-animation: webkit-adjacent-element-selector-bugfix infinite 1s;
		}
			
		@-webkit-keyframes webkit-adjacent-element-selector-bugfix 
		{
			from 
			{ 
				padding: 0;
			} 
			to 
			{ 
				padding: 0;
			}
		}
	}
	</style>

    <div class="css-treeview" id="tree">
			<ul>
				<li><input type="checkbox" id="item-0" /><label for="item-0"><i class="fa fa-cube" aria-hidden="true"></i> Raw Materials</label>
					<ul id="raw_list">
						<li><input type="checkbox" id="item-0-0" /><label for="item-0-0">Copper</label>
							<ul>
								<li style="margin-left: 3%">Stages in Manufacturing: <input type="text" /></li>
								<li style="margin-left: 3%">Dimensions: <input type="text" /></li>
								<li style="margin-left: 3%">Quantity: <input type="number" value='0'/></li>
							</ul>
						</li>
					</ul>
				</li>
                <li><input type="checkbox" id="item-1" /><label for="item-0"><i class="fa fa-cog" aria-hidden="true"></i> Components</label>
					<ul id="components_list">
						<li><input type="checkbox" id="item-1-0" /><label for="item-0-0">Bolts</label>
							<ul>
								<li style="margin-left: 3%">Stages in Manufacturing: <input type="text" /></li>
								<li style="margin-left: 3%">Dimensions: <input type="text" /></li>
								<li style="margin-left: 3%">Quantity: <input type="number" value='0'/></li>
							</ul>
						</li>
					</ul>
				</li>
                <li><input type="checkbox" id="item-2" /><label for="item-0"><i class="fa fa-cogs" aria-hidden="true"></i> Part Types</label>
					<ul id="part_list">
					</ul>
				</li>
				
			</ul>
		</div>
      
</body>
</html>

