<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
</head>
<body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <a class="navbar-brand" href="index.jsp"> <t>EnJ</a>

                <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
                  <div class="navbar-nav">
                    <%-- <a class="nav-item nav-link" href="showcart.jsp">Your Cart</a> --%>
                    <a class="nav-item nav-link" href="mypage.jsp">My page</a>
                    <a class="nav-item nav-link" href="listprod.jsp">Our Products</a>
                    <a class="nav-item nav-link" href="listorder.jsp">All Orders</a>
                    <a class="nav-item nav-link" href="showcart.jsp">Your Cart</a>
                    <div class = "d-flex justify-content-end">
                    <%
	                  String userName = (String) session.getAttribute("authenticatedUser");
	                  if (userName != null){
                      %>
                      <a class="nav-item nav-link my-2 my-sm-0">Signed in as <%= userName %></a>
                      <%
                    }%>
                    </div>
                  </div>
                </div>
              </nav>

</body>
</html>
