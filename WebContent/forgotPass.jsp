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
<form name="MyForm" method=post action="findPass.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email Address:</font></div></td>
	<td><input type="email" name="email" size=10 minlength="10" maxlength="20"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Find my Password">
</form>
<%
String found = (String) session.getAttribute("pass");
if (found != null){
	%><h3>Your password is: <%=found%></h3><%
}
session.setAttribute("pass",null);
%>
</div>
<%


%>
</body>
</html>
