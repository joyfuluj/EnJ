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
		response.sendRedirect("forgotEmail.jsp");		// Successful finding email
	else
		response.sendRedirect("forgotEmail.jsp");		// Failed find email - redirect back to login page with a message 
%>
<%!
	String validateNewAccount(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String fName = request.getParameter("firstname");
		String lName = request.getParameter("lastname");
        String phoneNum = request.getParameter("phonenum");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
		String country = request.getParameter("country");


        String foundEmail= null;
		if((fName.length() == 0) || (lName.length() == 0) || (phoneNum.length() == 0) || (address.length() == 0) || (city.length() == 0) || (state.length() == 0) || (postalCode.length() == 0) || (country.length() == 0) )
			return null;

		try 
		{
			getConnection();
			//TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT email FROM customer WHERE firstName=? and lastName=? and phonenum=? and address=? and city=? and state=? and postalCode=? and country=?";
			try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
                preparedStatement.setString(1, fName);
                preparedStatement.setString(2, lName);
				preparedStatement.setString(3, phoneNum);
                preparedStatement.setString(4, address);
				preparedStatement.setString(5, city);
				preparedStatement.setString(6, state);
				preparedStatement.setString(7, postalCode);
				preparedStatement.setString(8, country);
        		ResultSet rst = preparedStatement.executeQuery();
    			while(rst.next()){
                    if(rst.getString("email")!=null)
					    foundEmail=rst.getString("email");
				}
			}
			catch (SQLException ex) {
				out.println("SQLException: " + ex);
			}	
		}	
		catch (SQLException ex) {
			out.println(ex);
		}
        if(foundEmail != null)
		{
			session.setAttribute("email",foundEmail);
		}
	
		return foundEmail;
    
	}
%>