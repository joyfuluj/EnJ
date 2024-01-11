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
    <title>EnJ Grocery Order List</title>
</head>

<h2><a href="addreview.jsp">Write a review</a></h2>
<h3><a href="index.jsp">Go Back to Main Page</a></h3>

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

int pid=0;
String product = (String) session.getAttribute("productId");
    if (product != null)
        pid=Integer.parseInt(product);
// Useful code for formatting currency values:
//out.println(currFormat.format(5.0);  // Prints $5.00
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
        String uid = "sa";
        String pw = "304#sa#pw";	
        try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();)  
            {			
                // Write query to retrieve all review records
                out.println("<div class=\"container-sm border border-dark\"><h1>Review List</h1><div class = \"table-responsive\">");
                out.println("<table class = \"table\">" + "<tr><th> Review Id </th> <th> Review Date </th> <th> Rating </th><th> Comment </th></tr>"); // Opening outer Table and printing header row
                String sql= "SELECT reviewId,reviewRating,reviewDate,reviewComment FROM review";
                PreparedStatement pst = con.prepareStatement(sql);
                //pst.setInt(1, pid);
                ResultSet rst = pst.executeQuery();
               
                while (rst.next())
                {	
                    if(rst.getString("reviewComment")==null){
                        out.println("FAIL");     
                    }
                    else{
                         out.println("<tr>"+                                 
                    "<td>"+rst.getInt("reviewId")+"</td>"+
                    "<td>"+rst.getString("reviewDate")+"</td>"+
                    "<td>"+rst.getInt("reviewRating")+"</td>"+
                    "<td>"+rst.getString("reviewComment")+"</td>"+
                    "</tr>");
                    }
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

