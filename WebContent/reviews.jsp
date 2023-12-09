<html>
    <head>
        <title>UBC Hardware Galaxy</title>
    </head>
    <body>
        <h1>Reviews</h1>
        <%@ include file="auth.jsp" %>
        <%@ include file="jdbc.jsp" %>

        <%
        try{
            String userName = (String) session.getAttribute("authenticatedUser");

            getConnection();
            String productList = "<h2>Products you can review</h2><ul>";
            String sql = "SELECT os.orderId FROM ordersummary os JOIN customer c ON os.customerId = c.customerId WHERE c.userid = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userName);
            ResultSet rs = pstmt.executeQuery();

            String sql2 = "SELECT p.productId, p.productName FROM product p JOIN orderProduct op ON p.productId = op.productId WHERE op.orderId = ?";
            pstmt = con.prepareStatement(sql2);

            while (rs.next()) {
                String oid = rs.getString(1);

                pstmt.setString(1, oid);
                ResultSet rs2 = pstmt.executeQuery();
                while (rs2.next()) {
                    productList += "<li><p>Product Id: " + rs2.getString(1) +  " Product Name: " + rs2.getString(2) + "</li>";
                }
            }
            productList += "</ul>";
            out.println(productList);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        %>

        <h2>Add Review</h2>
        <form method="post" action="processReview.jsp">
            <label for="pfr">Enter the product id for the product you wish to review</label>
            <input type="number" name="productId" id="pfr" min="1" required><br>

            <label for="r">Enter rating</label>
            <input type="number" id="r" name="rating" min="1" max="5" required><br>

            <label for="rd">Review: </label>
            <input type="text" id="rd" name="review" required><br>

            <input type="submit" value="submit Review">
        </form>
        <a href="index.jsp">Go back to main page</a>
    </body>
</html>