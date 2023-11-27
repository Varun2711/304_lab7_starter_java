<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
    String orderId = request.getParameter("orderId");

	try {
		getConnection();

		// TODO: Check if valid order id in database
		String sql = "SELECT COUNT(orderId) FROM ordersummary where orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, orderId);
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		int count = rs.getInt(1);

		if (count == 1) {
			// TODO: Start a transaction (turn-off auto-commit)
			con.setAutocommit(false);

			// TODO: Retrieve all items in order with given id
			pstmt = con.prepareStatement("SELECT * from odderProduct WHERE orderId = ? LIMIT 3");
			pstmt.setString(1, orderId);
			ResultSet rs = pstmt.executeQuery();

			// TODO: Create a new shipment record.
			
			// TODO: For each item verify sufficient quantity available in warehouse 1.
			// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		
			// TODO: Auto-commit should be turned back on
		} else {

		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		closeConnection();
	}
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
