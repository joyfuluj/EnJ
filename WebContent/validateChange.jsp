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
		response.sendRedirect("index.jsp");		// Successful made new account
	else
		response.sendRedirect("edit.jsp");		// Failed made new account - redirect back to login page with a message 
%>
<%!
	String validateNewAccount(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
		String country = request.getParameter("country");
        String password = request.getParameter("password");

        boolean exist = false;
        
		if((email.length() == 0) || (address.length() == 0) || (city.length() == 0) || (state.length() == 0) || (postalCode.length() == 0) || (country.length() == 0) || (password.length() == 0))
			return null;

		try 
		{
			getConnection();
			String searchEmail = "";
			//TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT email FROM customer";
			try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
        		ResultSet rst = preparedStatement.executeQuery();
    			while(rst.next()){
					if(rst.getString("email")==email){
                        exist=true;
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
        if(exist == true){ 
            return null;
        }
        else{
			int custoemrId = 0;
			String sql = "UPDATE customer SET address=?,city=?,state=?,postalCode=?,country=?,password=? WHERE email = ?";
			try 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
				preparedStatement.setString(1, address);
				preparedStatement.setString(2, city);
				preparedStatement.setString(3, state);
				preparedStatement.setString(4, postalCode);
				preparedStatement.setString(5, country);
				preparedStatement.setString(6, password);
                preparedStatement.setString(7, email);
        		ResultSet rst = preparedStatement.executeQuery();
			}
			catch (SQLException ex) {
				out.println(ex);
			}
			finally
			{
				closeConnection();
			}	
			return "OK";
		}
	}
%>