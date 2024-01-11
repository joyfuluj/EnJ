<%@ include file = "jdbc.jsp" %>

<% 
String sql = "UPDATE product SET ";
try{
    
    boolean modFlag = false;
    String productId = request.getParameter("ModProductId");
    String productName = request.getParameter("ModProductName");
    String productPrice = request.getParameter("ModProductPrice");
    String productDesc = request.getParameter("ModProductDesc");
    String productCategory = request.getParameter("ModProductCategory");

    if(productName != null && !productName.isEmpty()) {
        sql += "productName = \'"+ productName + "\',";
        modFlag=true;
        }
    
    if(productPrice != null && !productPrice.isEmpty()) {
        sql += "productPrice =\'"+ productPrice +"\',";
        modFlag=true;
        }
    if(productDesc != null && !productDesc.isEmpty()) {
        sql += "productDesc = \'"+ productDesc +"\',";
        modFlag=true;
        }
    if(productCategory != null && !productCategory.isEmpty()) {
        sql += "categoryId = \'"+ productCategory +"\',";
        modFlag=true;
    }
    if (!modFlag) throw new Exception("All Null or Empty Inputs");
     
     sql = sql.substring(0,sql.length()-1);
     sql += "from product WHERE productId ="+ productId;
}
catch(Exception ex){
    out.println("Bad Form Fill:" + ex);
}

try ( Connection con = DriverManager.getConnection(url, uid, pw);
    PreparedStatement stmt = con.prepareStatement(sql);) 
{
   out.println(sql);
   stmt.executeUpdate();
   response.sendRedirect("admin.jsp");
}
catch (SQLException ex) {
        out.println("SQLException: " + ex);
}
%>