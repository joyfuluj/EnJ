<%@ page language="java" import="java.io.*,java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Edit page</title>

<style>
        body {
            background-image: url('./images/backcol.jpg'); /* Specify the path to your image */
            background-size: cover; /* Cover the entire background */
            background-position: bottom 0; /* Center the background image */
            background-repeat: no-repeat; /* Do not repeat the background image */
        }

        /* Add any additional styles for your content */
        .content {
            padding: 20px;
            color: #ffffff; /* Set text color to contrast with the background */
        }
    </style>
</head>
<body>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please edit your information</h3>

<br>
<form name="MyForm" method=post action="validateChange.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email Address:</font></div></td>
	<td><input type="email" name="email" size=10 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Address:</font></div></td>
	<td><input type="text" name="address" size=10 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">City:</font></div></td>
	<td><input type="text" name="city" size=10 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">State:</font></div></td>
	<td><input type="text" name="state" size=10 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Postal Code:</font></div></td>
	<td><input type="text" name="postalCode" size=10 maxlength="10"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Country:</font></div></td>
	<td><input type="text" name="country" size=10 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Edit My information">
</form>
</div>
<%


%>
</body>
</html>
