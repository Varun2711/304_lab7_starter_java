<%@ page import="java.sql.*,java.util.Iterator,java.util.Map,java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
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
            pstmt = con.prepareStatement("INSERT INTO ordersummary (customerId, totalAmount) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, Integer.parseInt(custId));

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
            pstmt.setDouble(2, totalAmount);

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

            out.println("Order placed successfully!");
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



