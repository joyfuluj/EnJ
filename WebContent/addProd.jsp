<%@ include file = "jdbc.jsp" %>

<% 

String sql = "INSERT INTO product(productName,productPrice,productDesc,categoryId) values (?,?,?,?)";

try ( Connection con = DriverManager.getConnection(url, uid, pw);
    PreparedStatement pstmt = con.prepareStatement(sql);) 
{		
    String productName = request.getParameter("AddProductName");
    String productPrice = request.getParameter("AddProductPrice");
    String productDesc = request.getParameter("AddProductDesc");
    String productCategory = request.getParameter("AddProductCategory");
    pstmt.setString(1,productName);	
    pstmt.setString(2,productPrice);	
    pstmt.setString(3,productDesc);	
    pstmt.setString(4,productCategory);	
    pstmt.executeUpdate();
    response.sendRedirect("admin.jsp");

}
catch (SQLException ex) {
        out.println("SQLException: " + ex);
}

%>