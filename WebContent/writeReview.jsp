<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	
	try
	{
		authenticatedUser = validateNewAccount(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("listprod.jsp");		// Successful finding email
	else
		response.sendRedirect("addreview.jsp");		// Failed find email - redirect back to login page with a message 
%>
<%!
	String validateNewAccount(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String pid = (String) session.getAttribute("productId");
        String username = request.getParameter("username");
	    String rating = request.getParameter("rating");
        String comment = request.getParameter("comment");
        
		if((username.length() == 0) || (rating.length() == 0) || (comment.length() == 0))
			return null;
        int cusId=0;
        int reviewId=0;
		try 
		{
			getConnection();
			//TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT customerId FROM customer WHERE userid=?";
			try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
                preparedStatement.setString(1, username);
        		ResultSet rst = preparedStatement.executeQuery();
    			while(rst.next()){
                    if(rst.getString("customerId")!=null)
					    cusId=rst.getInt("customerId");
					else
						return null;
						
				}
                String sql2 = "INSERT INTO review (reviewRating,reviewDate,customerId,productId,reviewComment) VALUES (?,GETDATE(),?,?,?)";

				preparedStatement = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);
                preparedStatement.setInt(1, Integer.parseInt(rating));
                preparedStatement.setInt(2, cusId);
    			preparedStatement.setInt(1, Integer.parseInt(rating));
				if (pid != null) {
    			preparedStatement.setInt(3, Integer.parseInt(pid));
				}
                preparedStatement.setString(4, comment);

				preparedStatement.executeUpdate();

                try (ResultSet keys = preparedStatement.getGeneratedKeys()) {
            		if (keys.next()) {
                		reviewId = keys.getInt(1);
            		} 
				}
			}
			catch (SQLException ex) {
				out.println("SQLException: " + ex);
			}	
		}	
		catch (SQLException ex) {
			out.println(ex);
		}
	
		return "DONE";
    
	}
%>