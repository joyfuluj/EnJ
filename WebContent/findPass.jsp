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
		response.sendRedirect("forgotPass.jsp");		// Successful finding email
	else
		response.sendRedirect("forgotEmail.jsp");		// Failed find email - redirect back to login page with a message 
%>
<%!
	String validateNewAccount(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String userId = request.getParameter("username");
        String email = request.getParameter("email");
	
        String pass= null;
        String firstName = "";
		if((email.length() == 0) || (userId.length() == 0))
			return null;

		try 
		{
			getConnection();
			//TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT firstName,password FROM customer WHERE userid=? and email=? ";
			try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
                preparedStatement.setString(1, userId);
                preparedStatement.setString(2, email);
				
        		ResultSet rst = preparedStatement.executeQuery();
    			while(rst.next()){
                    if(rst.getString("password")!=null)
					    pass=rst.getString("password");
                        firstName=rst.getString("firstName");
				}
			}
			catch (SQLException ex) {
				out.println("SQLException: " + ex);
			}	
		}	
		catch (SQLException ex) {
			out.println(ex);
		}
        if(pass != null)
		{
			session.setAttribute("pass",pass);
		}
	
		return pass;
    
	}
%>