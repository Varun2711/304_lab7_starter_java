<html>
<head>

</head>

<body>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%@ include file="jdbc.jsp"%>

<%
// get attributes to add into the database
String name = request.getParameter("productName");
String category = request.getParameter("productCategory");
double price = Double.parseDouble(request.getParameter("productPrice"));
String desc = request.getParameter("productDesc");


// get connection
try {
    getConnection();

    String categoryId = "";
    String sql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
    String sql2 = "SELECT categoryId FROM category WHERE categoryName = ?";
    String sql3 = "INSERT INTO category(categoryName) VALUES (?)";

    // first get category id
    PreparedStatement pstmt = con.prepareStatement(sql2);
    pstmt.setString(1, category);
    ResultSet rs = pstmt.executeQuery();
    if (rs.next()) {
        categoryId = rs.getString(1);
    } else {
        pstmt = con.prepareStatement(sql3, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, category);
        pstmt.executeUpdate();
    }
    
    // then insert the new product into the product table
    pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    pstmt.setString(1, name);
    pstmt.setDouble(2, price);
    pstmt.setString(3, desc);
    pstmt.setString(4, categoryId);
    pstmt.executeUpdate();

    // print out that the product was added successfully to the database
    out.println("<h1>Product was added successfully!</h1>");
} catch (Exception e) {
    e.printStackTrace();
} finally {
    closeConnection();
}
%>
<a href="admin.jsp">Go Back</a>
</body>
</html>