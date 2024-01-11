<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <title>Your Order List</title>

     <style>
        body {
            background-image: url('./images/backg.jpg'); /* Specify the path to your image */
            background-size: cover; /* Cover the entire background */
            background-position: bottom 50px; /* Center the background image */
            background-repeat: no-repeat; /* Do not repeat the background image */
        }

        /* Add any additional styles for your content */
        .content {
            padding: 20px;
            color: #ffffff; /* Set text color to contrast with the background */
        }
    </style>
</head>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}
String customer="";
String user = (String) session.getAttribute("authenticatedUser");
    if (user != null)
        customer=user;
    else{
        %>
        <h1>Please log in to see your orders.</h1>
        <h2><a href="login.jsp">Log In</a></h2>
        <%
    }

// Useful code for formatting currency values:
//out.println(currFormat.format(5.0);  // Prints $5.00
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
        String uid = "sa";
        String pw = "304#sa#pw";	
        try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();)  
            {			
                // Write query to retrieve all order summary records
                out.println("<div class=\"container-sm border border-dark\"><h1>Order List</h1><div class = \"table-responsive\">");
                out.println("<table class = \"table\">" + "<tr><th> Order Id </th> <th> Order Date </th> <th> Customer Id </th><th> Customer Name </th> <th> Total Amount </th> </tr>"); // Opening outer Table and printing header row
                String sql= "SELECT orderId,orderDate,customer.customerId,firstname,lastname,totalAmount FROM ordersummary,customer WHERE customer.customerId=ordersummary.customerId and userid=?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, customer);
                ResultSet rst = pst.executeQuery(); // Used for outer query
                ResultSet rst2;  //Used in inner loop for inner query
                
                String pquery = "SELECT productId,quantity,price FROM orderproduct WHERE orderId = ?" ;
                pst = con.prepareStatement(pquery);
                
                //For Each order in rst
               
                while (rst.next())
                {	
                out.println("<tr>"+                                 // Prints out the order summary information
                "<td>"+rst.getInt("orderId")+"</td>"+
                "<td>"+rst.getString("orderDate")+"</td>"+
                "<td>"+rst.getInt("customerId")+"</td>"+
                "<td>"+rst.getString("firstname")+' '+rst.getString("lastname")+"</td>"+
                "<td>"+currFormat.format(rst.getDouble("totalAmount"))+"</td>"+
                "</tr>");
                out.println("<tr><td colspan =\"3\"></td><td><table class= \"table\"><tr><th>Product Id</th><th> Quantity </th><th> Price </th></tr>"); //Opening inner table and printing header.
                    pst.setInt(1, rst.getInt("OrderId"));
                    rst2 = pst.executeQuery(); // Query to retrieve the products in the order
                    
                    // For each product in the order
                    while(rst2.next()){  // Write out product information 
                        out.println("<tr>"+
                        "<td>"+rst2.getInt("productId")+"</td>"+
                        "<td>"+rst2.getInt("quantity")+"</td>"+
                        "<td>"+currFormat.format(rst2.getDouble("price"))+"</td>"+
                        "<tr>");
                    }
                out.println("</td></table></tr>");
                }
                out.println("</table></div></div>");
            }
                
            catch (SQLException ex)
            {
                out.println("SQLException: " + ex);
            }
    
	



	
	
		

%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>

