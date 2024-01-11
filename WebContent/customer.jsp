<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Customers Page</title>
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

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<h1>Customers Profile</h1>
<%

// TODO: Print Customer information
String sql = "SELECT firstName,lastName,email,phonenum,address,city,state,postalCode,country,userid,password FROM customer WHERE userid=?";
			try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
        			preparedStatement.setString(1, userName);
        		ResultSet rst = preparedStatement.executeQuery();
				out.println("<table class=\"table\" border=\"1\"><tbody>");
    			while(rst.next()){
					out.println("<table class=\"table\" border=\"1\"><tbody>");
					out.println("<tr><th>First Name</th><td>" + rst.getString("firstName") + "</td></tr>");
					out.println("<tr><th>Last Name</th><td>" + rst.getString("lastName") + "</td></tr>");
					out.println("<tr><th>Email</th><td>" + rst.getString("email") + "</td></tr>");
					out.println("<tr><th>Phone</th><td>" + rst.getString("phonenum") + "</td></tr>");
					out.println("<tr><th>Address</th><td>" + rst.getString("address") + "</td></tr>");
					out.println("<tr><th>City</th><td>" + rst.getString("city") + "</td></tr>");
					out.println("<tr><th>State</th><td>" + rst.getString("state") + "</td></tr>");
					out.println("<tr><th>Postal Code</th><td>" + rst.getString("postalCode") + "</td></tr>");
					out.println("<tr><th>Country</th><td>" + rst.getString("country") + "</td></tr>");
					out.println("<tr><th>User id</th><td>" + rst.getString("userid") + "</td></tr>");
					out.println("</tbody></table>");
					out.println("<br>");
				}
				out.println("</tbody></table>");
				out.println("<br>");
			}
			catch (SQLException ex) {
				out.println("SQLException: " + ex);
			}

// Make sure to close connection
%>
<h3><a href="edit.jsp">Change Account Information</a></h3>
<h3><a href="index.jsp">Back to Main Page</a></h3>
</body>
</html>

