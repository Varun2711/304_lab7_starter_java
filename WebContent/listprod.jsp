<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>EZ Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
    <input type="text" name="productName" size="50">
    <input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<%
String name = request.getParameter("productName");

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
    String sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ? ";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, "%" + name + "%");
    ResultSet rs = pstmt.executeQuery();

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    String output = "<table><thead><tr><th></th><th>Product Name</th><th>Price</th></tr></thead><tbody>";
    while (rs.next()) {
        String id = rs.getString(1);
        String pname = rs.getString(2);
        String price = currFormat.format(rs.getDouble(3));

        String href = "addcart.jsp?id=" + URLEncoder.encode(id, "UTF-8") + "&name=" + URLEncoder.encode(pname, "UTF-8") + "&price=" + URLEncoder.encode(price, "UTF-8");
        String item = "<tr><td><a href=\"" + href + "\">add to cart</a></td><td>" + pname + "</td><td>" + price + "</td></tr>";
        output += item;
    }
    output += "</tbody></table>";

    if (name == null || name.equals("")) {
        output = "<h2>All products</h2>" + output;
    } else {
        output = "<h2>Products containing '" + name + "'</h2>" + output;
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
