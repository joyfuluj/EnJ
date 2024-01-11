<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<html>
<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" >


<title>EnJ Grocery Products</title>
</head>
<body>
<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");

String name = "";
double price = 0;
String image = "";
String imageURL = "";
String description = "";
String sql = "SELECT productId,productName,productDesc,productPrice,productImage,productImageURL FROM product WHERE productId = ?";
try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();)  
{			
    PreparedStatement preparedStatement = con.prepareStatement(sql);
    preparedStatement.setString(1, productId);
    ResultSet rst = preparedStatement.executeQuery();

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
               
    while (rst.next())
    {	
        name = rst.getString("productName");
        price = rst.getDouble("productPrice");
        image = rst.getString("productImage");
        imageURL = rst.getString("productImageURL");
        description = rst.getString("productDesc");
    }
    rst.close();
}  
catch (SQLException ex)
{
    out.println("SQLException: " + ex);
}

%>
<h2><% out.println(name);%><h2>
<h3><%=description%><h3>
<%
// TODO: If there is a productImageURL, display using IMG tag
if(imageURL != null)
    out.println("<img src=\"./images/"+productId+".jpg\">");
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
if(image != null)
    out.println("<img src=displayImage.jsp?id=" + productId + ">");

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
out.println("<table><td><tr>");
out.println("<th>Id: </th><td>" + productId + "</td></tr>");
out.println("<th>Price: </th><td>" + currFormat.format(price) + "</td></tr>");
out.println("</tr></td></table>");

session.setAttribute("productId", productId);
%>
<div class = "col-3">
<form action = "warehouseInv.jsp">
<button  type ="Submit" class = "btn btn-primary" value="Submit">Ckeck Inventory</button>
<%

// TODO: Add links to Add to Cart and Continue Shopping
%>
<h3><% out.println("<a href=\"/shop/addcart.jsp?id=" + productId +"&name="+ name +"&price="+ price +"\">Add to Cart</a></div></td></tr>");%><h3>
<h3><a href="listprod.jsp">Continue Shopping</a></h3>
<%
try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();)  
            {			
                // Write query to retrieve all order summary records
                out.println("<div class=\"container-sm border border-dark\"><h1>Review List</h1><div class = \"table-responsive\">");
                out.println("<table class = \"table\">" + "<tr><th> Review Id </th> <th> Review Date </th> <th> Rating </th><th> Comment </th></tr>"); // Opening outer Table and printing header row
                sql= "SELECT reviewId,reviewRating,reviewDate,reviewComment FROM review WHERE productId=?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, productId);
                ResultSet rst = pst.executeQuery(); // Used for outer query
                
                //For Each order in rst
               
                while (rst.next())
                {	
                out.println("<tr>"+                                 
                "<td>"+rst.getInt("reviewId")+"</td>"+
                "<td>"+rst.getString("reviewDate")+"</td>"+
                "<td>"+rst.getInt("reviewRating")+"</td>"+
                "<td>"+rst.getString("reviewComment")+"</td>"+
                "</tr>");
                }
            }  
            catch (SQLException ex)
            {
                out.println("SQLException: " + ex);
            }
%>
<h3><a href="addreview.jsp">Write a review</a></h3>
</body>
</html>

