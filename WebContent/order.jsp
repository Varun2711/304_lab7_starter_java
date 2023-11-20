<%@ page import="java.sql.*,java.util.Iterator,java.util.Map,java.util.HashMap,java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <style>
		table, tr, thead, td {
			border: 1px solid black;
		}
		
		td {
			text-align: center;
		}

		th {
         background-color: #f2f2f2;
            text-align: center;
        }

        thead td {
            font-weight: bold;
        }

        #total {
            text-align: right;
            font-weight: bold;
        }

	</style>
    <title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<%
// Get customer id
String custId = request.getParameter("customerId");
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Check for a valid customer ID
if (custId == null || !custId.matches("\\d+")) {
    out.println("Invalid customer ID!");
} else {
    // Check if the shopping cart is empty
    if (productList == null || productList.isEmpty()) {
        out.println("Your shopping cart is empty!");
    } else {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // Establish database connection
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";
            con = DriverManager.getConnection(url, uid, pw);

            // Insert order information into ordersummary table
            pstmt = con.prepareStatement("INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, Integer.parseInt(custId));
            pstmt.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
            // Calculate total amount
            double totalAmount = 0.0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = entry.getValue();
                double price = Double.parseDouble((String) product.get(2));
                int quantity = (Integer) product.get(3);
                totalAmount += price * quantity;
            }
            pstmt.setDouble(3, totalAmount);

            pstmt.executeUpdate();
            ResultSet keys = pstmt.getGeneratedKeys();
            keys.next();
            int orderId = keys.getInt(1);

            // Insert each item into OrderProduct table using OrderId from previous INSERT
            pstmt = con.prepareStatement("INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");
            iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = entry.getValue();
                String productId = (String) product.get(0);
                double price = Double.parseDouble((String) product.get(2));
                int quantity = (Integer) product.get(3);
                pstmt.setInt(1, orderId);
                pstmt.setString(2, productId);
                pstmt.setInt(3, quantity);
                pstmt.setDouble(4, price);
                pstmt.executeUpdate();
            }

            // Clear shopping cart after successful order placement
            session.removeAttribute("productList");

            String sql = "SELECT op.productId, productName, quantity, op.price, (quantity * op.price) as subtotal FROM orderproduct op JOIN product p ON op.productId = p.productId WHERE op.orderId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            out.println("<h1>Order placed successfully!</h1>");
            out.println("<h2>Your order summary</h2>");
            
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            String table = "<table><thead><td>Product ID</td><td>Product Name</td><td>Quantity</td><td>Price</td><td>Subtotal</td></thead>";
            while (rs.next()) {
                String pid = rs.getString(1);
                String pname = rs.getString(2);
                String qty = rs.getString(3);
                String price = currFormat.format(rs.getDouble(4));
                String subtotal = currFormat.format(rs.getDouble(5));
                String item = "<tr>";
                item += "<td>" + pid + "</td><td>" + pname + "</td><td>" + qty + "</td><td>" + price + "</td><td>"  + subtotal + "</td>";
                item += "</tr>";
                table += item;
            }
            table += "<tr><td id='total' colspan=\"4\">Total: </td><td>" + currFormat.format(totalAmount)+ "</td></tr></table>";

            out.println(table);
            
            pstmt = con.prepareStatement("SELECT c.customerId, CONCAT(firstName, ' ', lastName) FROM customer c JOIN ordersummary os ON c.customerId = os.customerId WHERE orderId = ?");
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            rs.next();
            out.println("<h2>Your order reference number is: " + orderId + "</h2>");
            out.println("<h2>Shipping to customer: " + rs.getString(1) + ", Name: " + rs.getString(2) + "</h2>");

        } catch (Exception e) {
            out.println("An error occurred: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                out.println("Failed to close the connection: " + e.getMessage());
            }
        }
    }
}
%>

</body>
</html>



