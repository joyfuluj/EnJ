<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" >	
	<title>EnJ Grocery Products</title>
</head>
<body>
 <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="shop.html"> <t>EnJ Grocery</a>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
             <div class="navbar-nav">
                <a class="nav-item nav-link" href="shop.html">Home</a>
                <a class="nav-item nav-link active" href="listprod.jsp">Our Products</a>
                <a class="nav-item nav-link" href="listorder.jsp">All Orders</a>
                <a class="nav-item nav-link" href="showcart.jsp">Your Cart</a>
			</div>
        </div>
    </nav>

<%
	// TODO: Get order id
String oid = request.getParameter("orderId");
          
	// TODO: Check if valid order id in database
String sql = "SELECT * FROM ordersummary WHERE orderId = ?";
try ( Connection con = DriverManager.getConnection(url, uid, pw);)
{			
    PreparedStatement preparedStatement = con.prepareStatement(sql);
    preparedStatement.setString(1, oid);
    ResultSet rst = preparedStatement.executeQuery();
    if(!rst.next()){
		%>
    	<h1>Invalid order id or password. Go back to the previous page and try again.</h1>
		<h2><a href="shop.html">Back to Main Page</a></h2>
		<%
		return;
    }
}
catch (SQLException ex) {
	out.println("SQLException: " + ex);
}

	//TODO: Start a transaction (turn-off auto-commit)
	//con.setAutoCommit(false);
String pid = "";
String ordQuan = "";
String invQuan = "";
String newInvQuan = "";
int count = 0;
// TODO: For each item verify sufficient quantity available in warehouse 1.
sql = "SELECT productinventory.productId,orderproduct.quantity AS oq ,productinventory.quantity AS iq FROM productinventory JOIN orderproduct ON productinventory.productId=orderproduct.productId JOIN warehouse ON warehouse.warehouseId = productinventory.warehouseId WHERE orderId = ? AND warehouse.warehouseId=1";
String sql2 = "UPDATE productinventory SET quantity = ? WHERE productId = ?";
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();) 
{	con.setAutoCommit(false);		
	PreparedStatement preparedStatement = con.prepareStatement(sql);
	PreparedStatement updateStatement = con.prepareStatement(sql2);
    preparedStatement.setString(1, oid);
    ResultSet rst = preparedStatement.executeQuery();
	// TODO: Retrieve all items in order with given id
	out.println("<table><tbody>");
    while(rst.next()&&count<3){
		pid = rst.getString("productId");
		ordQuan = rst.getString("oq");
		invQuan = rst.getString("iq");

		// TODO: Create a new shipment record
		String sqlShip = "INSERT INTO shipment (shipmentDate,warehouseId) VALUES (GETDATE(),1)";
		preparedStatement = con.prepareStatement(sqlShip);

		// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		if(Integer.parseInt(invQuan)==0 || Integer.parseInt(invQuan)<Integer.parseInt(ordQuan)){
			con.rollback();
			%>
    		<h1>Shipment not done. Insufficient inventory for product id: <%=pid%></h1>
			<%
		}
		else{
			newInvQuan = Integer.toString(Integer.parseInt(invQuan) - Integer.parseInt(ordQuan));
			updateStatement.setString(1, newInvQuan);
			updateStatement.setString(2, pid);
			updateStatement.executeUpdate();
			
			
			%>
			<h1>Ordered product: <%=pid%> Qty: <%=ordQuan%> Previous inventory: <%=invQuan%> New inventory: <%=newInvQuan%></h1>
			<%
		}
		count++;
    }
	con.commit();
	%>
	<h3><a href="index.jsp">Back to Main Page</a></h3>
	<%
	
	out.println("</tbody></table>");
	rst.close();
	con.setAutoCommit(true);
}
catch (SQLException ex) {
	con.rollback();
	out.println("SQLException: " + ex);
}
%>                       				

</body>
</html>
