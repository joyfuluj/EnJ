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
		response.sendRedirect("createAccount.jsp");		// Failed made new account - redirect back to login page with a message 
%>


<%!
	String validateNewAccount(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String fName = request.getParameter("firstname");
		String lName = request.getParameter("lastname");
        String email = request.getParameter("email");
        String phoneNum = request.getParameter("phonenum");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
		String country = request.getParameter("country");
        String userId = request.getParameter("username");
        String password = request.getParameter("password");

        boolean exist = false;
        
		if((fName.length() == 0) || (lName.length() == 0)|| (email.length() == 0) || (phoneNum.length() == 0) || (address.length() == 0) || (city.length() == 0) || (state.length() == 0) || (postalCode.length() == 0) || (country.length() == 0) )
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
			String sql = "INSERT INTO customer (firstName,lastName,email,phonenum,address,city,state,postalCode,country,userid,password) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
			try 
			{			
				PreparedStatement preparedStatement = con.prepareStatement(sql);
				preparedStatement.setString(1, fName);
				preparedStatement.setString(2, lName);
				preparedStatement.setString(3, email);
				preparedStatement.setString(4, phoneNum);
				preparedStatement.setString(5, address);
				preparedStatement.setString(6, city);
				preparedStatement.setString(7, state);
				preparedStatement.setString(8, postalCode);
				preparedStatement.setString(9, country);
				preparedStatement.setString(10, userId);
				preparedStatement.setString(11, password);
        		ResultSet rst = preparedStatement.executeQuery();

    			try (ResultSet keys = preparedStatement.getGeneratedKeys()) {
            		if (keys.next()) {
                		custoemrId = keys.getInt(1);
                		//out.println("-------ordersummary successfully Inserted-------for orderId: " + orderId);
            		} 
				}
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

