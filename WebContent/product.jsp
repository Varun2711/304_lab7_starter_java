<%@ page import="java.util.HashMap, java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>EZ Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
    // Get product name to search for
    String productId = request.getParameter("id");

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        getConnection();

        String sql = "SELECT * FROM Product WHERE productId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // Display product information
            out.println("<h2>" + rs.getString("productName") + "</h2>");
            out.println("<p>Description: " + rs.getString("description") + "</p>");
            out.println("<p>Price: " + rs.getString("price") + "</p>");

            // Display image using productImageURL field if available
            String productImageURL = rs.getString("productImageURL");
            if (productImageURL != null && !productImageURL.isEmpty()) {
                out.println("<img src='" + productImageURL + "' alt='Product Image'>");
            }

            // Display image from the binary field productImage by providing an img tag and modifying the displayImage.jsp/php file.
            out.println("<img src='displayImage.jsp?id=" + productId + "' alt='Product Image'>");

            // Add links to Add to Cart and Continue Shopping
            out.println("<a href='addToCart.jsp?id=" + productId + "'>Add to Cart</a>");
            out.println("<a href='listprod.jsp'>Continue Shopping</a>");
        } else {
            out.println("<p>Product not found!</p>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

</body>
</html>

</html>

