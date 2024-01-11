<%@ page language="java" import="java.io.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Edit page</title>
</head>
<body>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<h2>Find your Email</h2>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please enter your information</h3>

<br>
<form name="MyForm" method=post action="findEmail.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">First Name:</font></div></td>
	<td><input type="text" name="firstname"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Last Name:</font></div></td>
	<td><input type="text" name="lastname" size=10 maxlength="10"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Phone Number:</font></div></td>
	<td><input type="text" name="phonenum" size=10 maxlength="15"></td>
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
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Find my Email">
</form>
<%
String found = (String) session.getAttribute("email");
if (found != null){
	%><h3>Your email is: <%=found%></h3><%
}
session.setAttribute("email",null);
%>
</div>
<%


%>
</body>
</html>
