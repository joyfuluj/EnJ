<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
 <style>
        body {
            background-image: url('./images/backg.jpg'); /* Specify the path to your image */
            background-size: cover; /* Cover the entire background */
            background-position: bottom -10px; /* Center the background image */
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

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System</h3>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username" autocomplete="on" size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" autocomplete="on" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<h3><a href="forgotEmail.jsp">Forgot email</a></h3>
<h3><a href="forgotPass.jsp">Forgot Password</a></h3>
<h3><a href="index.jsp">Back to Main Page</a></h3>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>

</div>

</body>
</html>

