<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>UBC Hardware Galaxy</title>
    <style>
        body {
            display: flex;
            flex-flow: column;
            align-items: center;
        }
        a#rtmp, a#rtmp:visited, a#rtmp:hover, a#rtmp:active {
            color: black;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <h1><a id="rtmp" href="index.jsp">UBC Hardware Galaxy</a></h1>
<h2>Search for the products you want to buy:</h2>

<form method="get" action="listprod.jsp">
    <label for="productName">Enter a product name: </label>
    <input type="text" name="productName" size="50">
    <br>
    <label for="category">Enter a category: </label>
    <input type="text" name="category" size="50">
    <br>
    <input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<%
String name = request.getParameter("productName");
String category = request.getParameter("category");
try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
Connection con = null;

try {
    con = DriverManager.getConnection(url, uid, pw);
    String sql = "";
    if (!name.isEmpty()) {
        sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ? ";
    } else if (!category.isEmpty()) {
        sql = "SELECT productId, productName, productPrice FROM product WHERE categoryId = ?";
    } else {
        sql = "SELECT productId, productName, productPrice FROM product";
    }
    PreparedStatement pstmt = con.prepareStatement(sql);

    if (!name.isEmpty()) {
        pstmt.setString(1, "%" + name + "%");
    } else if (!category.isEmpty()) {
        pstmt.setString(1, category);
    }

    ResultSet rs = pstmt.executeQuery();

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    String output = "<table><thead><tr><th></th><th>Product Name</th><th>Price</th></tr></thead><tbody>";
    while (rs.next()) {
        String id = rs.getString(1);
        String pname = rs.getString(2);
        String price = currFormat.format(rs.getDouble(3));

        String href = "addcart.jsp?id=" + URLEncoder.encode(id, "UTF-8") + "&name=" + URLEncoder.encode(pname, "UTF-8") + "&price=" + URLEncoder.encode(price.substring(1), "UTF-8");
        String hrefProd = "product.jsp?id=" + URLEncoder.encode(id, "UTF-8");
        String item = "<tr><td><a href=\"" + href + "\">add to cart</a></td><td><a href = \"" + hrefProd + "\">" + pname + "</a></td><td>" + price + "</td></tr>";
        output += item;
    }
    output += "</tbody></table>";

    if (name.isEmpty() && category.isEmpty()) {
        output = "<h2>All products</h2>" + output;
    } else if (!name.isEmpty()) {
        output = "<h2>Products containing '" + name + "'</h2>" + output;
    } else {
        output = "<h2>All products in category: " + category + "</h2>" + output;
    }
    out.println(output);

    rs.close();
    pstmt.close();
} catch (Exception e) {
    out.println("An error occurred: " + e.getMessage());
} finally {
    try {
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
