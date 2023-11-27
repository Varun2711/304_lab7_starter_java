<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");

    if (userName == null) {
        out.println("<p>Error: Please log in to access this page.</p>");
    } else {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            getConnection();

            // SQL query to retrieve customer information
            String sql = "SELECT * FROM Customer WHERE username = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userName);
            rs = pstmt.executeQuery();

            out.println("<h2>Customer Profile</h2><table>");

            while (rs.next()) {
                out.println("<tr><td>id</td><td>" + rs.getString("id") + "</td></tr>");
                out.println("<tr><td>First Name</td><td>" + rs.getString("firstName") + "</td></tr>");
                out.println("<tr><td>Last Name</td><td>" + rs.getString("lastName") + "</td></tr>");
                out.println("<tr><td>Email</td><td>" + rs.getString("email") + "</td></tr>");
                out.println("<tr><td>Phone</td><td>" + rs.getString("phone") + "</td></tr>");
                out.println("<tr><td>Address</td><td>" + rs.getString("address") + "</td></tr>");
                out.println("<tr><td>City</td><td>" + rs.getString("city") + "</td></tr>");
                out.println("<tr><td>State</td><td>" + rs.getString("state") + "</td></tr>");
                out.println("<tr><td>Postal Code</td><td>" + rs.getString("postalCode") + "</td></tr>");
                out.println("<tr><td>Country</td><td>" + rs.getString("country") + "</td></tr>");
                out.println("<tr><td>User Id</td><td>" + rs.getString("username") + "</td></tr>");
            }

            out.println("</table>");
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
    }
%>

</body>
</html>
