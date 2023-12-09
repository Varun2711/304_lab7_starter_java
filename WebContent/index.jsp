<!DOCTYPE html>
<html>
<head>
        <title>UBC Hardware Galaxy</title>
		<style>
			body { 
            color: #ffffff; 
        }

        .bg {
            position: absolute;
            opacity: 0.6;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
		</style>
</head>
<body>

	<img class="bg" src="img/indexdd.jpg" alt="">
<h1 align="center">UBC Hardware Galaxy</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="reviews.jsp">Add reviews</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<h2 align="center"><a href="createAcc.jsp">Create a new account</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

</body>
</head>


