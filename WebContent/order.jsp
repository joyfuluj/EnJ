<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Joy's Grocery Order Processing</title>
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

<% 
// Get customer id
String custId = request.getParameter("customerId");
String custPwd= request.getParameter("customerPwd");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

// If either are not true, display an error message
// Determine if valid customer id was entered
boolean customerExists = false;
boolean validPassword = false;
if (custId != null && !custId.isEmpty() && custPwd != null && !custPwd.isEmpty()) {
	try(Connection con = DriverManager.getConnection(url, uid, pw)) {
        Integer.parseInt(custId);
        String sql = "SELECT * FROM customer WHERE customerId = ?";
        PreparedStatement preparedStatement = con.prepareStatement(sql);
        preparedStatement.setString(1, custId);
        ResultSet resultSet = preparedStatement.executeQuery();
		customerExists = resultSet.next();
		if(custPwd.equals(resultSet.getString("password"))) validPassword = true;
	}
	catch (SQLException ex) {
		out.println("SQLException: " + ex);
	}
	if(!customerExists || !validPassword){
    	// No customer ID was entered or it is empty
    	%>
    	<h1>Invalid customer id or password. Go back to the previous page and try again.</h1>
		<%
		return;
	}
} 
else{
	// No customer ID was entered or it is empty
	%>
    <h1>Empty customer id or password. Go back to the previous page and try again.</h1>
	<%
	return;
}

String address = "";
String city = "";
String state = "";
String postalCode = "";
String country = "";

int orderId = 0;
String first="";
String last="";
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	    Statement stmt = con.createStatement();) 
	{			
		String sql = "SELECT firstName,lastName,address,city,state,postalCode,country FROM customer WHERE customerId=?";
		String sql2 = "INSERT INTO ordersummary (orderdate,shiptoAddress,shiptoCity,shiptoState,shiptoPostalCode,shiptoCountry,customerId) VALUES (GETDATE(),?,?,?,?,?,?)";
		
		try{
			PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);	
			pstmt.setString(1,custId);
			ResultSet rst= pstmt.executeQuery();

			while (rst.next()){
				address = rst.getString("address");
				city = rst.getString("city");
				state = rst.getString("state");
				postalCode = rst.getString("postalCode");
				country = rst.getString("country");
				first=rst.getString("firstName");
				last=rst.getString("lastName");
			}
			
		
			pstmt = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);			
			pstmt.setString(1,address);
			pstmt.setString(2,city);		
			pstmt.setString(3,state);
			pstmt.setString(4,postalCode);
			pstmt.setString(5,country);
			pstmt.setString(6,custId);

			pstmt.executeUpdate();

			try (ResultSet keys = pstmt.getGeneratedKeys()) {
            	if (keys.next()) {
                	orderId = keys.getInt(1);
                	//out.println("-------ordersummary successfully Inserted-------for orderId: " + orderId);
            	} 
			}
		}
		catch(SQLException ex){
			out.println("SQLException: " + ex);
		}
		con.close();
	}
catch (SQLException ex)
{
	out.println("SQLException: " + ex);
}
String lastName=" "+last;



// Insert each item into OrderProduct table using OrderId from previous INSERT
int countPrice=0;
Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
while (iterator.hasNext())
{ 
    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
    ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
    String productId = (String) product.get(0);
    String price = (String) product.get(2);
    double pr = Double.parseDouble(price);
    int qty = ( (Integer)product.get(3)).intValue();

	countPrice+=pr;

	
    try ( Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement();) 
    {       
        try{
            PreparedStatement pstmt = con.prepareStatement("INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?,?,?,?)");          
            pstmt.setInt(1,orderId);
            pstmt.setString(2,productId);
            pstmt.setInt(3,qty);
            pstmt.setDouble(4,pr);

            pstmt.executeUpdate();

    	}
		catch (SQLException ex)
		{
 			out.println("SQLException: " + ex);
		}
		con.close();
	}
	catch (SQLException ex)
	{
 		out.println("SQLException: " + ex);
	}
}

//out.println("\n-------productsummary successfully Inserted-------for orderId: " + orderId);

// Update total amount for order record
try ( Connection con = DriverManager.getConnection(url, uid, pw);
    Statement stmt = con.createStatement();) 
{       
    try{
        PreparedStatement pstmt = con.prepareStatement("UPDATE ordersummary SET totalAmount = ? WHERE orderId=?");
			pstmt.setDouble(1,countPrice);
			pstmt.setInt(2,orderId);
            pstmt.executeUpdate();
			//out.println("\n-------Quantity Updated Successfully-------for orderId: " + orderId);

    	}
		catch (SQLException ex)
		{
 			out.println("SQLException: " + ex);
		}
		con.close();
	}
catch (SQLException ex)
{
 	out.println("SQLException: " + ex);
}

String name = "";
if (productList != null && !productList.isEmpty()) {
	%>
	<h1>Your Order Summary</h1>
	<%
	double orderTotal=0;
    // There are products in the shopping cart
    try ( Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement();) 
    {           
        // Write query to retrieve all order summary records
        PreparedStatement pstmt = con.prepareStatement("SELECT orderproduct.productId,productName,quantity,productPrice,quantity*productPrice AS subTotal, SUM(productPrice) AS total FROM product JOIN orderproduct ON product.productId=orderproduct.productId JOIN ordersummary ON orderproduct.orderId=ordersummary.orderId WHERE orderproduct.orderId=? GROUP BY orderproduct.productId,productName,quantity,productPrice");
        pstmt.setInt(1,orderId);
        ResultSet rst= pstmt.executeQuery();
        
		out.println("<div class=\"container-sm border border-dark\"><div class = \"table-responsive\">");
        out.println("<table class = \"table\">" + "<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th><tr>"); // Opening outer Table and printing header row
        String sql= "SELECT orderId,orderDate,customer.customerId,firstname,lastname,totalAmount FROM ordersummary,customer WHERE customer.customerId=ordersummary.customerId and userid=?";
        //out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th><tr>");
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        while (rst.next())
        {
			name=rst.getString("productName");
            out.println("<tr><td>"+rst.getString("productId")+"</td>"+"<td>"+rst.getString("productName")+"</td>"+"<td align=\"center\">"+rst.getString("quantity")+"</td>"+"<td align=\"right\">"+currFormat.format(rst.getDouble("productPrice"))+"</td>"+"<td align=\"right\">"+currFormat.format(rst.getDouble("subTotal"))+"</td></tr>");
			orderTotal+=rst.getDouble("subTotal");
        }
        out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></th><td align=\"right\">"+currFormat.format(orderTotal)+"</td></tr>");
		//out.println("</table>");
		out.println("</table></div></div>");
		con.close();
    }
    catch (SQLException ex)
    {
        out.println("SQLException: " + ex);
    }  
	%>
    <h1>Congratulation, you're now a <%=name%> !</h1>
    <h1>Your order reference number is: <%=orderId%></h1>
    <h1>Thank you for shopping and have a great day!!</h1>
	<% 

	// Clean shopping cart in database
}
else {
    // The shopping cart is empty
	%>
    <h1>Your shopping cart is empty!<h1>
	<%
}
%>
<h1><a href="index.jsp">Go Back to Main Page</a></h1>
<%









// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/


// Clear cart if order placed successfully
productList.clear();
%>
</BODY>
</HTML>

