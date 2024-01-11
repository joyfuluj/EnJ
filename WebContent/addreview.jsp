<%@ page language="java" import="java.io.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Add review page</title>
</head>
<body>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<div style="margin:0 auto;text-align:center;display:inline">

<h2>Please write a review</h2>
<br>

<form name="MyForm" method=post action="writeReview.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">username:</font></div></td>
	<td><input type="text" name="username" size=10 maxlength="10"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Rating(1,2,3,4,5):</font></div></td>
	<td><input type="number" name="rating" min="1" max="5"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Comment:</font></div></td>
	<td><input type="text" name="comment" size=50 maxlength="1000"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Add my review">
</form>
<%
%>
</div>
<%


%>
</body>
</html>
