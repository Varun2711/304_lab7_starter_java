<html>
    <head>
        <title>Add customer</title>
    </head>
    <body>
        <%@ page import="java.sql.*,java.net.URLEncoder" %>
        <%@ page import="java.text.NumberFormat" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

        <%@ include file="jdbc.jsp"%>

        <%
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("email");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("streetAddress");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalcode");
        String country = request.getParameter("country");
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");

        try {
            getConnection();
            String sql = "INSERT INTO customer(firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES(?,?,?,?,?,?,?,?,?,?,?)";

            PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, fname);
            pstmt.setString(2, lname);
            pstmt.setString(3, email);
            pstmt.setString(4, phonenum);
            pstmt.setString(5, address);
            pstmt.setString(6, city);
            pstmt.setString(7, state);
            pstmt.setString(8, postalCode);
            pstmt.setString(9, country);
            pstmt.setString(10, userId);
            pstmt.setString(11, password);
            pstmt.executeUpdate();
            out.println("<h2>successfully added customer!</h2>");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        %>
        <a href="index.jsp">Go back</a>
    </body>
</html>