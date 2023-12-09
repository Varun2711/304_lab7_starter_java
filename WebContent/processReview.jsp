<html>
    <head>
        <title>
            UBC Hardware Galaxy
        </title>
    </head>

    <body>
        <%@ include file="jdbc.jsp" %>
        <%@ page import="java.sql.* %>

        <%
        String user = (String) session.getAttribute("authenticatedUser");
        String rating = request.getParameter("rating");
        String pid = request.getParameter("productId");
        String review = request.getParameter("review");

        try {
            getConnection();
            String sql = "SELECT customerId FROM customer WHERE userid = ?";
            PreparedStatement pstmt = con.prepareStatement(sql)
            pstmt.setString(1, user);
            ResultSet rs = pstmt.executeQuery();

            String cid = "";
            if (rs.next()) {
                cid = rs.getString(1);
            }

            String sql2 = "INSERT INTO review(reviewRating, reviewDate, productId, customerId, reviewComment) VALUES (?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, rating);
            pstmt.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
            pstmt.setString(3, pid);
            pstmt.setString(4, cid);
            pstmt.setString(5, review);

            pstmt.executeUpdate();

            out.println("<h2>Your review was successfully added</h2>");
            out.pritnln("<a href="index.jsp">Go back to main page</a>");
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        %>
    </body>
</html>