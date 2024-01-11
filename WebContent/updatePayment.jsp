%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("checkout.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		Boolean adminStatus = false;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			
			//TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT firstName, password, AdminStatus FROM customer WHERE userid = ? and password = ?"; //Query Executed.
			try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
        		preparedStatement.setString(1, username);
				preparedStatement.setString(2, password);
        		ResultSet rst = preparedStatement.executeQuery();
    				rst.next();
					if(rst.getString("firstName")!=null){
						retStr = username;		
					}
					if(rst.getInt("AdminStatus")==1){
						adminStatus = true;
					}	
			}
			catch (SQLException ex) {
				out.println("SQLException: " + ex);
			}
			//retStr = username;		
		}	
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
			session.setAttribute("Admin",adminStatus);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

