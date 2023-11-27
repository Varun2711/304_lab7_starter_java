<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
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
</style>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
out.println("<h1>Admin</h1><h2>Administrator sales report by day</h2>");
// TODO: Write SQL query that prints out total order amount by day
String sql = "SELECT CONCAT(Year(orderDate), '-', Month(orderDate), '-', Day(orderDate)), SUM(totalAmount) AS total FROM ordersummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate)";
try {
    getConnection();
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rs = pstmt.executeQuery();

    out.println("<table><thead><td>Order Date</td><td>Total Order Amount</td></thead>");
    while(rs.next()) {
        out.println("<tr><td>"+ rs.getString(1) +"</td><td>$"+ rs.getString(2) +"</td></tr>");
    }
    out.println("</table>");
} catch(Exception e) {
    e.printStackTrace();
} finally {
    closeConnection();
}
%>

</body>
</html>

