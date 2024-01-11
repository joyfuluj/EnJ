
<head>
    <title>Administrator Page</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" >
    <style>
        body {
            background-image: url('./images/backg.jpg'); /* Specify the path to your image */
            background-size: cover; /* Cover the entire background */
            background-position: bottom 0; /* Center the background image */
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
<container class = "container">  
<div class = "row">
<div class="col"> </div>
<div class = "col-8"> 
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp"%>   
<%@ include file="header.jsp"%>
<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try(Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement(); ){			
        
        
        String query = "Select * from product";
        out.println(" <h3> Result of Query: "+ query+"</h3>");
       
        ResultSet rst = stmt.executeQuery(query);
        ResultSetMetaData rsmd = rst.getMetaData();
        int columnsNumber = rsmd.getColumnCount();
        
        out.println("<table class = \"table striped\" border = \"1\"><tr>");
        for(int i = 1; i <=columnsNumber;i++){
           out.println("<th>"+rsmd.getColumnName(i)+"</th>");
        }
        out.println("</tr>");        
            
        while (rst.next()) {
            out.println("<tr>");
            for(int i = 1; i <=columnsNumber;i++){
                out.println("<td>"+rst.getString(i)+"</td>");
                }
           out.println("</tr>");
        } 
        out.println("</table>"); 

    }
    catch (SQLException ex) {
        out.println("SQLException: " + ex);

    }
%>
</div>
        <div class="col">
        </div>
        <div>
    </container>
    </body>