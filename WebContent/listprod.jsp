<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>EZ Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection

// User id, password, and server information
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
	
// Do not modify this url
String urlForLoadData = "jdbc:sqlserver://cosc304_sqlserver:1433;TrustServerCertificate=True";
	
// Connection
Connection con = null;

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	throw new SQLException("ClassNotFoundException: " +e);
}

con = DriverManager.getConnection(url, uid, pw);

// query

String sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ? ";

PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, "%" + name + "%");
ResultSet rs = pstmt.executeQuery();




// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0));	// Prints $5.00

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

String output = "<table><thead><td></td><td>Product Name</td><td>Price</td></thead>";
while(rs.next()) {
	String id = rs.getString(1);
	String pname = rs.getString(2);
	String price = currFormat.format(rs.getDouble(3));
	
	String href = "addcart.jsp?id=" + id + "&name=" + pname + "&price=" + price;
	String item = "<tr><td><a href=\"" + URLEncoder.encode(href) +
		 "\">add to cart</a></td>"+
		 "<td>" + pname + "</td><td>" + price + "</td></tr>";
	output += item;
}
output += "</table>";

if (name.equals("")){
	output = "<h2>All products</h2>" + output;
} else {
	output = "<h2>Products containing '" + name + "'</h2>" + output;
}
out.println(output);
%>

</body>
</html>
