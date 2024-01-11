<%@ page import="java.text.NumberFormat" %>
<%@ include file="adminAuth.jsp"%>
    <%@ include file="jdbc.jsp"%>   
    <%@ include file="header.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>Warehouse Page</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" >
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
</head>
<%
int pid=0;
String product = (String) session.getAttribute("productId");
    if (product != null)
        pid=Integer.parseInt(product);
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
                out.println("<div class=\"container-sm border border-dark\"><h1>Inventory</h1><div class = \"table-responsive\">");
                out.println("<table class = \"table\">" + "<tr><th> Warehouse Id </th><th> Product Id </th> <th> Quantity </th> <th> Price </th></tr>"); // Opening outer Table and printing header row
                String sql= "SELECT warehouseId,productId,quantity,price FROM productinventory WHERE productId= ?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setInt(1, pid);
                ResultSet rst = pst.executeQuery(); // Used for outer query
                
                while (rst.next())
                {	
                out.println("<tr>"+               
                "<td>"+rst.getInt("warehouseId")+"</td>"+                  // Prints out the order summary information
                "<td>"+rst.getInt("productId")+"</td>"+
                "<td>"+rst.getInt("quantity")+"</td>"+
                "<td>"+currFormat.format(rst.getDouble("price"))+"</td>"+
                "</tr>");
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



    
  