<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<style>
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

	</style>
<title>EZ Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

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

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
	// Write out product information 

	String sql = "SELECT orderId, orderDate, c.customerId, CONCAT(c.firstName, ' ' , c.lastName), totalAmount FROM ordersummary os JOIN customer c ON os.customerId = c.customerId";
	Statement stmt = con.createStatement();
	ResultSet rs = stmt.executeQuery(sql);

	String sql2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderid = ?";
	PreparedStatement pstmt = con.prepareStatement(sql2);

	NumberFormat currFormat = NumberFormat.getCurrencyInstance();


	String output = "<table><thead><td><b>Order Id</b></td><td><b>Order Date</b></td><td><b>Customer Id</b></td><td><b>Customer Name</b></td><td><b>Total Amount</b></td></thead>";


		while (rs.next()) {
		String oid = rs.getString(1);
		String odate = rs.getString(2);
		String cid = rs.getString(3);
		String cname = rs.getString(4);
		String total = currFormat.format(rs.getDouble(5));
		
		pstmt.setString(1, oid);
		ResultSet rs2 = pstmt.executeQuery();
		String order = "<tr>";
		order += "<tr><td>"+oid+"</td><td>"+odate+"</td><td>"+cid+"</td><td>"+cname+"</td><td>"+total+"</td></tr>";
		order += "<tr>";
		order += "<td colspan=\"2\"></td>";
		order += "<td colspan=\"2\"><table><thead><td><b>Product Id</b></td><td><b>Quantity</b></td><td><b>Price</b></td></thead>";
		while (rs2.next()) {
			String pid = rs2.getString(1);
			String qty = rs2.getString(2);
			String price = currFormat.format(rs2.getDouble(3));
			order += "<tr>";
			order += "<td>"+pid+"</td><td>"+qty+"</td><td>"+price+"</td>";
			order += "</tr>";
		}
		order += "</table></td><td></td>";
		order += "</tr>";
		order = order + "</tr>";
		output += order;
	}

	out.println(output);


// Close connection
try {
	if (con != null)
		con.close();
	con = null;
}
catch (Exception e)
{ }

%>



</body>
</html>
