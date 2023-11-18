# 304_lab7_starter_java

lines 68 onwards that were removed from listorder

// Get customer ID
String customerId = request.getParameter("customerId");

// Validate if customer ID is a number
if (customerId != null && !customerId.matches("\\d+")) {
    out.println("Invalid customer ID!");
    return; // End execution or display error message
}

// Check if this customer ID exists in the database
// You should query the database and validate if the ID is valid

// Assuming the shopping cart is stored in a session variable
//if (session.getAttribute("cart") == null || ((Map<String, Integer>) session.getAttribute("cart")).isEmpty()) {
//    out.println("Your shopping cart is empty!");
//    return; // End execution or display error message
//}

// Calculate total amount
//double totalAmount = ...; // Calculate total amount based on products in the cart

// Update total amount in OrderSummary table
// Should use PreparedStatement to perform the update

// Clear the cart after a successful order placement
session.removeAttribute("cart");

### These I believe are supposed to be in order.jsp, since all that listOrder.jsp does, is take entries is ordersummary table and print them out.

