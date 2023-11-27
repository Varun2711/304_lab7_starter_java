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
getConnection();

String sql = "SELECT orderDate, SUM(totalAmount) as total FROM order GROUP BY orderDate";
PreparedStatement ptstmt = con.prepareStatement(sql);
ResultSet rs = pstmt.executeQuery();

String output = "<table><thead><td>Order Date</td><td>Total Order Amount</td></thead>";

while (rs.next()) {
    String date = rs.getString(1);
    String amount = rs.getString(2);

    String entry = "<tr><td>" + date + "</td><td>" + amount + "</td></tr>";
    output += entry;
}

out.println(output);

%>

</body>
</html>

