<!DOCTYPE html>
<%@ include file="header.jsp" %>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
 <style>
        body {
            background-image: url('./images/backg.jpg'); /* Specify the path to your image */
            background-size: cover; /* Cover the entire background */
            background-position: bottom -10px; /* Center the background image */
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


<h1>Enter your customer id and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
<p>Customer ID:</p>
<input type="text" name="customerId" size="50">
<br><p>Password:</p>
<input type="password" name="customerPwd" size =50>
<br>
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</body>
</html>

