<%@ page import="java.util.HashMap, java.sql.*, java.net.URLEncoder" %>
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
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    // Get product name to search for
    String productId = request.getParameter("id");

    //Connection con = null;
    //PreparedStatement pstmt = null;
    //ResultSet rs = null;

    try {
        getConnection();

        String sql = "SELECT * FROM Product WHERE productId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            // Display product information
            String pname = rs.getString("productName");
            String desc = rs.getString("productDesc");
            String price = currFormat.format(rs.getDouble("productPrice"));

            out.println("<h2>" + pname + "</h2>");

            // Display image using productImageURL field if available
            String productImageURL = rs.getString("productImageURL");
            if (productImageURL != null && !productImageURL.isEmpty()) {
                out.println("<img src='" + productImageURL + "' alt='Product Image'>");
            }

            // Display image from the binary field productImage by providing an img tag and modifying the displayImage.jsp/php file.
            out.println("<img src='displayImage.jsp?id=" + productId + "' alt='Product Image'><br>");

            // display price and description
            out.println("<p>Description: " + desc + "</p>");
            out.println("<p>Price: " + price + "</p>");

            // Add links to Add to Cart and Continue Shopping
            String href = "addcart.jsp?id=" + URLEncoder.encode(productId, "UTF-8") + "&name=" + URLEncoder.encode(pname, "UTF-8") + "&price=" + URLEncoder.encode(price.substring(1), "UTF-8");
            out.println("<a href=\"" + href + "\">add to cart</a><br>");
            out.println("<a href='listprod.jsp'>Continue Shopping</a>");
        } else {
            out.println("<p>Product not found!</p>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        //try {
        //    if (rs != null) rs.close();
        //    if (pstmt != null) pstmt.close();
        //    if (con != null) con.close();
        //} catch (SQLException e) {
        //    e.printStackTrace();
        //}

        closeConnection();
    }
%>

</body>
</html>

</html>

