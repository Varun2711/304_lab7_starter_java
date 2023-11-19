<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>EZ Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection
Connection con = null;
PreparedStatement pstmt = null;

try {
    // Validating customer ID
    if (custId == null || !custId.matches("\\d+")) {
        out.println("Invalid customer ID!");
    } else {
        // Checking if shopping cart is empty
        if (productList == null || productList.isEmpty()) {
            out.println("Your shopping cart is empty!");
        } else {
            // Create database connection
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";
            con = DriverManager.getConnection(url, uid, pw);

            // Save order information to database
            // Insert into ordersummary table

            // pstmt = con.prepareStatement("INSERT INTO ordersummary (customerId, totalAmount) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
            // pstmt.setInt(1, Integer.parseInt(custId));
            // pstmt.setDouble(2, totalAmount);
            // pstmt.executeUpdate();
            // ResultSet keys = pstmt.getGeneratedKeys();
            // int orderId = keys.getInt(1);

            // Insert each item into OrderProduct table using OrderId from previous INSERT

            /*
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = entry.getValue();
                String productId = (String) product.get(0);
                String price = (String) product.get(2);
                double pr = Double.parseDouble(price);
                int qty = ((Integer) product.get(3)).intValue();
                // Insert into orderproduct table
                // pstmt = con.prepareStatement("INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");
                // pstmt.setInt(1, orderId);
                // pstmt.setString(2, productId);
                // pstmt.setInt(3, qty);
                // pstmt.setDouble(4, pr);
                // pstmt.executeUpdate();
            }
            */

            // Update total amount for order record in OrderSummary table

            // Clear shopping cart after successful order placement
            session.removeAttribute("productList");

            out.println("Order placed successfully!");
        }
    }
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
%>
</body>
</html>

