<%@ include file = "jdbc.jsp" %>

<% 
String sql = "DELETE From product WHERE productId = ?";

try ( Connection con = DriverManager.getConnection(url, uid, pw);
    PreparedStatement stmt = con.prepareStatement(sql);) 
{
   String productId= request.getParameter("delProductId");
   if (productId != null && !productId.isEmpty()){
   stmt.setString(1,productId);
   stmt.executeUpdate();
   response.sendRedirect("admin.jsp");
   }
   else{
    throw new Exception("Null Product Id or Empty/Invalid Input");
   }
}
catch (SQLException ex) {
        out.println("SQLException: " + ex);
}
catch(Exception ex){
    out.println("Bad Form Fill:" + ex);
}
%>