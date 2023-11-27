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
			con.setAutoCommit(false);

			// TODO: Retrieve all items in order with given id
			pstmt = con.prepareStatement("SELECT * from orderProduct WHERE orderId = ?");
			pstmt.setString(1, orderId);
			rs = pstmt.executeQuery();

			// TODO: Create a new shipment record.
			String sql2 = "INSERT INTO shipment (shipmentDate, shipmentDesc) VALUES (?, ?)";
			pstmt = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);
			pstmt.setTimestamp(1, new java.sql.Timestamp(System.currentTimeMillis()));
			pstmt.setString(2, "Shipment for order id: " + orderId);
			pstmt.executeUpdate();

			// TODO: For each item verify sufficient quantity available in warehouse 1.
			boolean sufficientInventory = true;
			while (rs.next()) {
				// get product inventory
				pstmt = con.prepareStatement("SELECT * FROM productInventory WHERE productId = ? AND warehouseId = ?");
				pstmt.setString(1, rs.getString(2));
				pstmt.setString(2, "1");
				ResultSet rs2 = pstmt.executeQuery();

				if (rs2.next()) {
					// get variables 
					int oldQty = rs2.getInt(3);
					int orderQty = rs.getInt(3);
					String pid = rs.getString(2);

					// if order quantity <= current quantity, update the product inventory
					// by substracting the order quantity to get new product inventory
					if (orderQty <= oldQty) {
						// update product inventory
						pstmt = con.prepareStatement("UPDATE productInventory SET quantity = ? WHERE productId = ?");
						pstmt.setInt(1, oldQty-orderQty);
						pstmt.setString(2, rs.getString(2));
						pstmt.executeUpdate();
						
						// select query to get the new product inventory
						PreparedStatement pstmt2 = con.prepareStatement("SELECT quantity FROM productInventory WHERE productId = ?");
						pstmt2.setString(1, rs.getString(2));
						ResultSet rs3 = pstmt2.executeQuery();
						if (rs3.next()) {
							// print out the information
							out.println("<h3>Order product:" + pid +" Qty: " +  orderQty  + 
								" Previous Inventory: " +  oldQty + " New Inventory: " + rs3.getString(1) + "</h3>");
						}
					} else {
						//if there is insufficient inventory, cancel shipment;
						sufficientInventory = false;
						out.println("<h2>Shipment not done. Insufficient inventory for product id: "+  pid +"</h2>");
						break;
					}
				}
			}
			// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
			if (sufficientInventory) {
				con.commit();
				out.println("<h2>Shipment successfully processed</h2>");
			} else {
				con.rollback();
			}

			// TODO: Auto-commit should be turned back on
			con.setAutoCommit(true);
		} else {

		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println(e);
	} finally {
		closeConnection();
	}
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
