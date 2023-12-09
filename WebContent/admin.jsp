<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<style>
    body {
        display: flex;
        flex-flow: column;
        align-items: center;
        justify-content: center;
    }

    table, tr, th, td {
	    border: 1px solid black;
	}	
	
    td {
		text-align: center;
	}

    th {
        background-color: #f2f2f2;
        text-align: center;
    }
    
    #productForm input {
        margin-top: 5px;
    }
</style>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
out.println("<h1>Admin</h1><a href=\"index.jsp\">Return to main page</a><h2>Administrator sales report by day</h2>");
// TODO: Write SQL query that prints out total order amount by day
String sql = "SELECT CONCAT(Year(orderDate), '-', Month(orderDate), '-', Day(orderDate)), SUM(totalAmount) AS total FROM ordersummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate)";
try {
    getConnection();
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rs = pstmt.executeQuery();

    out.println("<table><thead><td>Order Date</td><td>Total Order Amount</td></thead>");
    while(rs.next()) {
        out.println("<tr><td>"+ rs.getString(1) +"</td><td>$"+ rs.getString(2) +"</td></tr>");
    }
    out.println("</table>");
    out.println("<hr width=\"40%\" height=\"10px\" color=\"black\">");
    // list all customers
    out.println("<h2>Customer List</h2>");
    
    String sql2 = "SELECT CONCAT(firstName, ' ', lastName) AS customerName, customerId FROM customer";
    PreparedStatement pstmt2 = con.prepareStatement(sql2);
    ResultSet rs2 = pstmt2.executeQuery();

    out.println("<table><thead><td>Name</td><td>Customer ID</td></thead>");

    while (rs2.next()) {
        out.println("<tr><td>"+ rs2.getString(1) +"</td><td>"+ rs2.getString(2) +"</td></tr>");
    }
    out.println("</table>");

} catch(Exception e) {
    e.printStackTrace();
} finally {
    closeConnection();
}
%>
<hr width="40%" height="10px" color="black">
    <h2>Add a product</h2>
    <form method="post" enctype="multipart/form-data" action="addProduct.jsp">
        <input type="text" name="productName" placeholder="product name" size="50" required><br>
        <input type="number" name="productPrice" placeholder="0.00" step="0.01" min="0.00" size="20" required><br>
        <input type="text" name="productDesc" placeholder="product description" size="50" required><br>
        <input type="text" name="productCategory" placeholder="product category" size="50" required><br>
        <input type="file" name="productImage" accept="image/png, image/jpeg" required><br>
        <input type="submit" value="Add Product"><br>
    </form>

<hr width="40%" height="10px" color="black">

<h2>Ship Order</h2>

<form method="post" action="ship.jsp">
    <label for="orderId">Order to ship: </label>
    <input type="text" name="orderId" size="20" required>
    <input type="submit" value="Ship">
</form>

<hr width="40%" height="10px" color="black">

<h2>Add Customer</h2>

<form method="post" action="addCustomer.jsp">
    <input type="text" name="fname" placeholder="John" size="50" required><br>
    <input type="text" name="lname" placeholder="Smith" size="50" required><br>
    <input type="email" name="email" placeholder="john123@email.com" size="30" required><br>
    <input type="tel" name="phonenum" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"  placeholder="123-456-7890" size="30" required><br>
    <input type="text" name="streetAddress" placeholder="123 abc street" size="50" required><br>
    <input type="text" name="city" placeholder="city" size="30" required><br>
    <input type="text" name="state" placeholder="state/province" size="40" required><br>
    <input type="text" name="postalcode" pattern="[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}" placeholder="a1b2c3" required><br>
    <input type="text" name="country" size="50" required><br>
    <input type="text" name="userId" size="50" required><br>
    <input type="text" name="password" size="50" required><br>
</form>

<hr width="40%" height="10px" color="black">

<h2>Add warehouse</h2>

<form method="post" action="addWarehouse.jsp">
    <label for="whName">Warehouse Name: </label>
    <input type="text" name="whName" size="50" required>
    <input type="submit" value="Add warehouse">
</form>

</body>
</html>

