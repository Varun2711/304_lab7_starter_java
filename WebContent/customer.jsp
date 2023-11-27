<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        table, tr, th, td {
			border: 1px solid black;
		}
		
		td {
			text-align: center;
		}

		th {
            background-color: #f2f2f2;
            text-align: center;
        }

        .lbl {
            font-weight: bold;
        }
    </style>
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
        

        try {
            getConnection();

            // SQL query to retrieve customer information
            String sql = "SELECT * FROM Customer WHERE userid = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userName);
            ResultSet rs = pstmt.executeQuery();

            out.println("<h2>Customer Profile</h2><table>");

            while (rs.next()) {
                out.println("<tr><td class='lbl'>Id</td><td>" + rs.getString("customerId") + "</td></tr>");
                out.println("<tr><td class='lbl'>First Name</td><td>" + rs.getString("firstName") + "</td></tr>");
                out.println("<tr><td class='lbl'>Last Name</td><td>" + rs.getString("lastName") + "</td></tr>");
                out.println("<tr><td class='lbl'>Email</td><td>" + rs.getString("email") + "</td></tr>");
                out.println("<tr><td class='lbl'>Phone</td><td>" + rs.getString("phonenum") + "</td></tr>");
                out.println("<tr><td class='lbl'>Address</td><td>" + rs.getString("address") + "</td></tr>");
                out.println("<tr><td class='lbl'>City</td><td>" + rs.getString("city") + "</td></tr>");
                out.println("<tr><td class='lbl'>State</td><td>" + rs.getString("state") + "</td></tr>");
                out.println("<tr><td class='lbl'>Postal Code</td><td>" + rs.getString("postalCode") + "</td></tr>");
                out.println("<tr><td class='lbl'>Country</td><td>" + rs.getString("country") + "</td></tr>");
                out.println("<tr><td class='lbl'>User Id</td><td>" + rs.getString("userid") + "</td></tr>");
            }

            out.println("</table>");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            closeConnection();
        }
    }
%>

</body>
</html>
