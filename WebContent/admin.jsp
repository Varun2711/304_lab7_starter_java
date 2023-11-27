<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%

// TODO: Write SQL query that prints out total order amount by day
String sql = "";

if (!isLoggedIn()) {
    response.sendRedirect("login.jsp");
    return;
}

//Write SQL query that prints out total order amount by day

Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    getConnection();

    String sql = "SELECT orderDate, SUM(totalAmount) as total FROM orders GROUP BY orderDate";
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();

    out.println("<table><thead><td>Order Date</td><td>Total Order Amount</td></thead>");

    while (rs.next()) {
        String date = rs.getString(1);
        String amount = rs.getString(2);

        out.println("<tr><td>" + date + "</td><td>" + amount + "</td></tr>");
    }

    out.println("</table>");
} catch (SQLException e) {
    e.printStackTrace();
} finally {
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

