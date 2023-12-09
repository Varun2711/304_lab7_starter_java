<html>
<head>
<title>Ray's Grocery</title>
</head>
<body>

<!-- This is included here so that they do not checkout unless they are logged in-->
<%@ include file="auth.jsp"%>


<!-- Even after they log in, still take their customer id and pw to process checkout-->
<h1>Enter your customer id and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
<table>
<tr><td>Username:</td><td><input type="text" name="customerId" size="20"></td></tr>
<tr><td>Password:</td><td><input type="password" name="password" size="20"></td></tr>
<tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
</table>
</form>

</body>
</html>

