<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Place Order</title>
    <style>
        body {
            background-color: #F0EAD2;
            font-family: Arial, sans-serif;
            padding: 40px;
        }
        form {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
            width: 400px;
            margin: auto;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #a98467;
            color: white;
            border: none;
            border-radius: 5px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<h2 align="center">Place New Order</h2>
<form method="post" action="OrderServlet">
    <label>Order Number:</label>
    <input type="text" name="orderNo" required>

    <label>Time:</label>
    <input type="time" name="time" required>

    <label>Total Price (₱):</label>
    <input type="number" name="totalPrice" required>

    <label>Payment Type:</label>
    <select name="paymentType">
        <option value="Cash">Cash</option>
        <option value="E-wallet">E-wallet</option>
    </select>

    <button type="submit">Submit Order</button>
</form>

</body>
</html>
