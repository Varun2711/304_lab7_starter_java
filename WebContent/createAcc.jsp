<html>
    <head>
        <title>Create Account</title>
        <style>
            body {
                display: flex;
                flex-flow: column;
                align-items: center;
            }

            form {
                border: 1px solid black;
            }

            form input {
                padding: 5px;
                margin: 1% 10px;
            }
        </style>
    </head>
    <body>
        <h1>Create a new account</h1>
        <form method="post" action="addCustomer.jsp">
            <label for="fn">First Name: </label>
            <input type="text" id="fn" name="fname" placeholder="John" size="50" required><br>

            <label for="ln">Last Name: </label>
            <input type="text" id="ln" name="lname" placeholder="Smith" size="50" required><br>

            <label for="em">Email: </label>
            <input type="email" id="em" name="email" placeholder="john123@email.com" size="30" required><br>

            <label for="un">Username: </label>
            <input type="text" id="un" name="userId" size="50" minlength="5" maxlength="20" placeholder="john123" required><br>

            <label for="pw">Password: </label>
            <input type="password" id="pw" name="password" size="50" minlength="8" maxlength="30" required><br>

            <label for="pn">Phone Number: </label>
            <input type="tel" id="pn" name="phonenum" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"  placeholder="123-456-7890" size="30" required><br>

            <label for="sa">Street Address: </label>
            <input type="text" id="sa" name="streetAddress" placeholder="123 abc street" size="50" required><br>

            <label for="cty">City: </label>
            <input type="text" id="cty" name="city" placeholder="city" size="30" required><br>

            <label for="sp">State/Provice: </label>
            <input type="text" id="sp" name="state" placeholder="state/province" size="40" required><br>

            <label for="pc">Postal Code: </label>
            <input type="text" id="pc" name="postalcode" pattern="[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}" placeholder="a1b2c3" required><br>
            
            <label for="cntry">Country</label>
            <input type="text" id="cntry" name="country" size="50" placeholder="country" required><br>
            <input type="submit" value="Create Account">
        </form>
    </body>
</html>