<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <title>EnJ Cart</title>
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
<script>
function update(newid, newqty)
{
	window.location="showcart.jsp?update="+newid+"&newqty="+newqty;
}
</script>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<div class =\"container-sm\"><h1>Your Shopping Cart</h1>");
	out.print("<table class=\"table\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");

	// Handle new quantity
	String id = request.getParameter("update");
	String newqty = request.getParameter("newqty");
	int newQuantity = 0;
	if (id != null && newqty != null) {
		try {
			newQuantity = Integer.parseInt(newqty);
		} catch (Exception e) {
			out.println("Invalid quantity for product: " + id + " quantity: " + newqty);
		}
		ArrayList<Object> newProduct = (ArrayList<Object>) productList.get(id);
		newProduct.set(3, new Integer(newQuantity));
		productList.put(id, newProduct);
	}


	double total = 0;
	int count = 1;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		Object pid = product.get(0);
		String newId = pid.toString();
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<form name=form1>");
		out.print("<td align=center><input type=text name=newqty" + count + "1 size=3 value=" + qty + "></td>");
		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		out.print("<td>&nbsp;&nbsp;&nbsp;&nbsp;<a href=remove.jsp?param1=" + java.net.URLEncoder.encode(newId, "UTF-8") + "> Remove Item from Cart</a></td>");
		out.print("<td>&nbsp;&nbsp;&nbsp;&nbsp;<input type=button onclick=\"update(" + pid + ",document.form1.newqty" + count + "1.value)\" value=\"Update Quantity\"></tr>");
		out.println("</tr>");
		total = total +pr*qty;
		count++;

	}

	out.println("</table><div>");
	out.println("<h2>Order Total:<h2>"+currFormat.format(total));

	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");

	
}
%>

<h2><a href="listprod.jsp">Continue Shopping</a></h2>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html> 

