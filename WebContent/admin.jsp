<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" >
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

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
<body>

    <%@ include file="adminAuth.jsp"%>
    <%@ include file="jdbc.jsp"%>   
    <%@ include file="header.jsp"%>
  

    <container class = "container">
  
        <div class = "row">
        <div class="col">
        </div>
        <div class = "col-10">
        <h3>Administrator Sales Report by Day</h3>
        <table class="table striped" border="1"><tbody><tr><th>Order Date</th><th>Total Order Amount</th></tr>
            <%
            // TODO: Write SQL query that prints out total order amount by day
            String sql = "SELECT CAST(orderDate AS DATE) as day, SUM(totalAmount) AS total FROM ordersummary GROUP BY CAST(orderDate AS DATE)";
            try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();) 
            {			
                ResultSet rst = stmt.executeQuery(sql);
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                out.println("<tr>");
                while(rst.next()){
                    out.println("<td>"+rst.getString("day")+"</td>"+
                    "<td>"+currFormat.format(rst.getDouble("total"))+"</td>");
                    out.println("</tr>");
                }
                
            }
            catch (SQLException ex) {
                out.println("SQLException: " + ex);
            }
            %>
            </tbody></table>
        <div id="myPlot"></div>       
        <% 
            try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();) {   			
                ResultSet rst = stmt.executeQuery(sql);
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                out.println(" <script>");
                
                String xarr = "const xArray = [";
                String yarr = "const yArray = [";
                while(rst.next()){
                    xarr += "String(\""+ rst.getString("day")+"\")"+',';
                    yarr += rst.getString("total")+',';
                }
                
                xarr = xarr.substring(0,xarr.length()-1);
                xarr += ("];"); 
                
                yarr = yarr.substring(0,yarr.length()-1);
                yarr += ("];");
                
                out.println(xarr);
                out.println(yarr);
                
                out.println("const data = [{ x: xArray, y: yArray, type: \"bar\", orientation: \"v\", marker: {color:\"rgba(255,0,0,0.6)\"} }];"+
                                "const layout = {title:\"Sales by Day\"};"+
                                "Plotly.newPlot(\"myPlot\", data, layout);"+
                                "</script>");
                }
                catch (SQLException ex){
                    out.println(ex);
                }
        %>
        </div>
        <div class="col">
        </div>
        <div>
    </container>
<div>
<hr>

    <container class = "container">

        <div class = "row">
        
        <div class="col">
        </div>
        
        <div class = "col-10">
        <h3> Customer List</h3>
        <table class="table striped" border="1"><tbody><tr><th>Id</th><th>Name</th><th>Email</th><th>Phone Num</th><th>Address</th><th>Postal Code</th><th>State/Country</th></tr>

            <%
            sql = "SELECT * FROM customer";
            try(Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();){			
                ResultSet rst = stmt.executeQuery(sql);
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                while(rst.next()){
                    out.println("<tr>"+
                    "<td>"+rst.getInt("customerId")+"</td>"+
                    "<td>"+rst.getString("firstName") +' '+rst.getString("lastName")+"</td>"+
                    "<td>"+rst.getString("email")+"</td>"+
                    "<td>"+rst.getString("phonenum")+"</td>"+
                    "<td>"+rst.getString("address")+"\n,"+rst.getString("city")+"</td>"+
                    "<td>"+rst.getString("postalCode")+"</td>"+
                    "<td>"+rst.getString("state")+","+rst.getString("Country")+"</td>"+
                    "</tr>");
                }

            }
            catch (SQLException ex) {
                out.println("SQLException: " + ex);
            }
            %>
        </tbody> </table>
        </div>
        
        <div class="col">
        </div>
        
        </div>
    <hr>
    </container>
    
    <container class = "container"> <!--All Admin Tools Container-->
        <div class = row>
            <div class = "col-1"></div>
            <div class = "col-8">
                <h3> Admin Tools:</h3>
            </div>
            <div class = "col-1"></div>
        </div>
    
        <div class = "row">    <!-- Div for Product Management-->
            <div class = "col-1"></div>
            
            <div class = "col-3"> <!--Add Product Div-->
                <h5> Add New Product:</h5>
               
                <form action = "addProd.jsp">
                
                    <div class = "form-group">
                        <label for = "productName" class = "form-label">Product Name: <label>
                        <input type = "text" class = "form-control" id = "productName" name="AddProductName">
                    </div>
                    
                    <div class = "form-group">    
                        <label for = "productPrice" class = "form-label">Price: <label>
                        <input type = "number" step = "0.01" min = "0.01" class = "form-control" id = "productPrice" name="AddProductPrice">
                    </div>

                    <div class = "form-group">
                        <label for = "productDesc" class = "form-label">Product Desc: <label>
                        <input type = "textarea" rows = "3" class = "form-control" id = "productDesc" name="AddProductDesc">
                    </div>

                    <div class = "form-group">
                        <label for = "productCat" class = "form-label">Product Category: <label>
                        <select class="form-control" id="productCat" name="AddProductCategory">
                            <option value= "1" Selected>ART</option>
                            <option value= "2">Business</option>
                            <option value= "3">Communication</option>
                            <option value= "4">Education</option>
                            <option value= "5">Health Care</option>
                            <option value= "6">Hospitality</option>
                            <option value= "7">Information Technology</option>
                            <option value= "8">Science</option>
                            <option value= "9">Transportation</option>
                        </select>
                    </div>

                    <div class = "form-group">
                        <button  type ="Submit" class = "btn btn-primary" value="Submit"> Add Product</button>
                        <button  type ="Submit" class = "btn btn-secondary" value="reset"> Reset Form </button>
                    </div>
                </form>
            </div>

            <div class = "col-3"> <!-- Modify Product Div--> 
                <h5> Modify Product:</h5>
                <form action = "modProd.jsp">

                    <div class = "form-group">    
                        <label for = "productId" class = "form-label">Product Id: <label>
                        <input type = "number" step = "1" min = "1" class = "form-control" id = "productId" name="ModProductId">
                    </div>
                    
                    <div class = "form-group">
                        <label for = "productName" class = "form-label">Product Name: <label>
                        <input type = "text" class = "form-control" id = "productName" name="ModProductName">
                    </div>
                
                    <div class = "form-group">    
                        <label for = "productPrice" class = "form-label">Price: <label>
                        <input type = "number" step = "0.01" min = "0.01" class = "form-control" name="ModProductPrice">
                    </div>

                    <div class = "form-group">
                        <label for = "productDesc" class = "form-label">Product Desc: <label>
                        <input type = "textarea" rows = "3" class = "form-control" id = "productDesc" name="ModProductDesc">
                    </div>

                    <div class = "form-group">
                        <label for = "productCat" class = "form-label">Product CategoryId: <label>
                        <select class="form-control" id="productCat" name="ModProductCategory">
                            <option value= "1" Selected>ART</option>
                            <option value= "2">Business</option>
                            <option value= "3">Communication</option>
                            <option value= "4">Education</option>
                            <option value= "5">Health Care</option>
                            <option value= "6">Hospitality</option>
                            <option value= "7">Information Technology</option>
                            <option value= "8">Science</option>
                            <option value= "9">Transportation</option>
                        </select>
                    </div>

                    <div class = "form-group">
                        <button  type ="Submit" class = "btn btn-primary" value="Submit"> Modify Product</button>
                        <button  type ="Submit" class = "btn btn-secondary" value="reset"> Reset Form </button>
                    </div>
                </form>
            </div>
            
            <div class = "col-3"> <!-- Delete Product Div-->
                <h5> Delete Product:</h5>
                <form action = "delProd.jsp">

                    <div class = "form-group">    
                        <label for = "productId" class = "form-label">Product Id: <label>
                        <input type = "number" step = "1" min = "1" class = "form-control" id = "productId" name= "delProductId">
                    </div>
            

                    <div class = "form-group">
                        <button  type ="Submit" class = "btn btn-danger" value="Submit"> Delete Product</button>
                        <button  type ="Submit" class = "btn btn-secondary" value="reset"> Reset Form </button>
                    </div>
                </form>
            </div>

            <div class = "col-1"></div>
        </div>
                
        <div class = "row">     <!--Div for Ware house Management and Customer Edits-->
            <div class = "col-1"></div>
            <div class = "col-3"> <!--WareHouse Management Div-->
                <h5>Warehouse Management: </h5>    
                <form class = "form" action = "editWarehouse.jsp">
                    
                    <div class = "form-group">
                        <label for = "editWarehouseMode" class = "form-label">Edit Mode: <label>
                        <select type = select name = "editWarehouseMode" id = "editWarehouseMode" class= "form-control">
                            <option value = "Add" Selected>Add New Warehouse</option>
                            <option value = "Mod">Modify Warehouse</option>
                            <option value = "Del">Delete Warehouse</option>
                        </select>
                    </div>
                        
                    <div class = "form-group">
                        <label for = "warehouseId" class = "form-label">WarehouseId (Leave Blank for Add): <label>
                        <input type = "number" step = "1" min = "1" class="form-control" id="warehouseId" name="warehouseId">
                    </div>

                    <div class = "form-group">
                        <label for = "warehouseName" class = "form-label">WarehouseName (Leave Blank for Delete): <label>
                        <input type = "text" name = warehouseName id = "warehouseName" class= "form-control">
                    </div>

                    <div class = "form-group">
                        <button  type ="Submit" class = "btn btn-primary" value="Submit"> Confirm Change </button>
                        <button  type ="Reset" class = "btn btn-secondary" value="Reset"> Reset Form </button>
                    </div>
                    
                </form>
            </div>
        </div>

        <div class = "row">
            <div class = "col-11"></div>
            <div class = col>
                <form action = "query.jsp">
                    <button  type ="Submit" class = "btn btn-primary" value="query"> Query Runner Output </button>
                </form>
                <form action = "loaddata.jsp">
                    <button  type ="Submit" class = "btn btn-danger" value="Reset Database"> Reset Database </button>
                </form>
            </div>
        </div>  
    
    </container>

        
                

<%
%>
<h3><a href="index.jsp">Back to Main Page</a></h3>
</body>
</html>

