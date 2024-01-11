<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" >


<title>EnJ Products</title>

 <style>
        body {
            background-image: url('./images/backg.jpg'); /* Specify the path to your image */
            background-size: cover; /* Cover the entire background */
            background-position: bottom; /* Center the background image */
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

<div class = "container">
	<div class= "row">
		<div class = "col"></div>
		<div class = "col-12">
		<h1>Search for the products you want to buy:</h1>
		<form method="get" action="listprod.jsp">
			<select size="1" name="categoryName">
  				<option value = "All">All</option>
				<option value= "ART">ART</option>
				<option value= "Business">Business</option>
				<option value= "Communication">Communication</option>
				<option value= "Education">Education</option>
				<option value= "Health Care">Health Care</option>
				<option value= "Hospitality">Hospitality</option>
				<option value= "Information Technology">Information Technology</option>
				<option value= "Science">Science</option>
				<option value= "Transportation">Transportation</option>
  			</select>
			<input type="text" name="productName" size="50">
			<input type="submit" value="Submit"><input type="reset" value="Reset">
		</form>
		</div>
		<div class = "col"></div>
	</div>
</div>


<%-- <h2><a href="addcart.jsp">Begin Shopping</a></h2> --%>

<% // Get product name to search for

		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


class catLookup{										//Helper function for color lookup
	public String catColorLookup(String catName){
		switch (catName){
			case "ART":
				return "BlueViolet";
			case "Business":
				return"SaddleBrown";
			case "Communication":
				return"DodgerBlue";
			case "Education":
				return"DarkGreen";
			case "Health Care":
				return"Red";
			case "Hospitality":
				return"Blue";
			case "Information technology":
				return"Orchid";
			case "Science":
				return"Chocolate";
			case "Transportation":
				return "Orange";
			default:
				return "black";
		}
	}	
}

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";


	try ( Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();)
	{	

		String proImage = "";
		String category = request.getParameter("categoryName"); // Variable category contains selected category
		String name = request.getParameter("productName");  	// Variable name now contains the search string the user entered
		String query = "SELECT productId,productName,productPrice,productImageURL,categoryId FROM product"; //query for search bar/Caregory choice
		String head = "All Products";							//Search result display header
		boolean nameFlag = false;
		catLookup catColor = new catLookup();	
		
		if((name!=null && !name.isEmpty()) || (category!=null && !category.equals("All"))){	// Complete If chain for building query
			query += " WHERE";
			if(name!=null && !name.isEmpty()){
				query +=  " productName LIKE \'%" + name+"%\'";
				head += " containing \""+name+"\"";
				nameFlag = true;
			}
			if(category!=null && !category.equals("All") && !category.isEmpty()){
				if(nameFlag) query += " AND"; 
				query += " categoryId = (SELECT categoryId from category WHERE categoryName = \'"+ category + "\')";
				head += " of category: " + category;
			}
		}
		
		PreparedStatement pstmt = con.prepareStatement(query);
		ResultSet rst = pstmt.executeQuery();
		PreparedStatement pstmt2 = con.prepareStatement("Select categoryName from category WHERE categoryId = ?");
		
		out.println("<div class = \" container\"><div class = \"row\"><div class = \"col\"></div><div class = \"col-12\">");
		out.println("<h2>"+head+"</h2>");
		out.println("<table class=\"table table-striped\"> <thead class = \"thead-dark\"> <tr><th>Product Name</th><th>Product Category</th><th>Price</th><th></th></tr> </thead> <tbody>");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		String pid = "";
		while (rst.next())
		{
			pstmt2.setInt(1,rst.getInt("categoryId"));
			ResultSet rst2 = pstmt2.executeQuery();
			rst2.next();
			pid = rst.getString("productId");
			out.println("<tr> <td style = \"color:"+catColor.catColorLookup(rst2.getString("categoryName"))+"\">"+ "<a href=product.jsp?id=" + java.net.URLEncoder.encode(pid, "UTF-8")  + ">" + rst.getString("productName") + "</a></td>"); //ColorLookup helper used to fill for HTML
			out.println("<td style = \"color:"+catColor.catColorLookup(rst2.getString("categoryName"))+"\">"+rst2.getString("categoryName") +"</td>");
			out.println("<td>" + currFormat.format(rst.getDouble("productPrice")) + "</td>");
			if(rst.getString("productImageURL")!= null){
				out.println("<td><img src=\"./images/"+pid+".jpg\"style=\"width:100px; height:100px;\"></td>");
			}
			//Next Line outputs add to cart link in button format using Bootstrap
			out.println("<td><div class=\"d-flex justify-content-center\"><a class = \"btn btn-primary\" href=\"/shop/addcart.jsp?id=" + rst.getInt("productId") +"&name="+ rst.getString("productName")+"&price="+ rst.getDouble("productPrice")+"\">Add to Cart</a></div></td></tr>");
		}
		out.println("<tbody></table></div><div class=\"col\"></div></div>");

		rst.close();
	}
	catch (SQLException ex)
	{
		out.println("SQLException: " + ex);
	}	


%>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>

