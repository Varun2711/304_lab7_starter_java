<html>
    <head>
        <title>Add warehouse</title>
    </head>
    <body>
        <%@ page import="java.sql.*,java.net.URLEncoder" %>
        <%@ page import="java.text.NumberFormat" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

        <%@ include file="jdbc.jsp"%>

        <%
        String name = request.getParameter("whName");

        try {
            getConnection();
            String sql = "INSERT INTO warehouse(warehouseName) VALUES(?)";

            PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, name);
            pstmt.executeUpdate();
            out.println("<h2>successfully added warehouse!</h2>");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        %>
        <a href="admin.jsp">Go back</a>
    </body>
</html>