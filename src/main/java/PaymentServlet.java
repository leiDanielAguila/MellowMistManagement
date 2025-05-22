import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Payment")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database connection parameters
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/mellowmistmanagement";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "1234"; // Set your database password here
    
    // Pricing maps (copied from CustomerOrder to ensure consistency)
    private static final Map<String, Map<String, Integer>> FLAVOR_PRICES = new HashMap<>();
    private static final Map<String, Integer> TOPPING_PRICES = new HashMap<>();
    
    // Initialize price maps
    static {
        // Classic milk tea prices
        Map<String, Integer> classicPrices = new HashMap<>();
        classicPrices.put("regular", 100);
        classicPrices.put("medium", 110);
        classicPrices.put("large", 120);
        FLAVOR_PRICES.put("classic", classicPrices);
        
        // Other flavored milk tea prices
        Map<String, Integer> flavoredPrices = new HashMap<>();
        flavoredPrices.put("regular", 110);
        flavoredPrices.put("medium", 120);
        flavoredPrices.put("large", 130);
        
        FLAVOR_PRICES.put("taro", flavoredPrices);
        FLAVOR_PRICES.put("matcha", flavoredPrices);
        FLAVOR_PRICES.put("strawberry", flavoredPrices);
        FLAVOR_PRICES.put("wintermelon", flavoredPrices);
        
        // Topping prices
        TOPPING_PRICES.put("black-tapioca", 20);
        TOPPING_PRICES.put("cheesecake", 20);
        TOPPING_PRICES.put("grass-jelly", 20);
        TOPPING_PRICES.put("pudding", 20);
        TOPPING_PRICES.put("oreo", 20);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Just forward to Payment.jsp
        request.getRequestDispatcher("Payment.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("cartItems") == null) {
            response.sendRedirect("CustomerOrder.jsp"); // redirect if no order
            return;
        }
        
        // Get payment method from form
        String paymentMethod = request.getParameter("payment");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "Cash"; // Default payment method
        }
        
        // Check if we're processing a payment
        String processPayment = request.getParameter("processPayment");
        if (processPayment != null && processPayment.equals("true")) {
            // Process payment and save order to database
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");
            
            if (cartItems != null && !cartItems.isEmpty()) {
                // Save the order to database with payment method
                boolean orderSaved = saveOrderToDatabase(cartItems, paymentMethod);
                
                if (orderSaved) {
                    // Clear the cart after successful payment
                    cartItems.clear();
                    session.setAttribute("cartItems", cartItems);
                    session.setAttribute("cartTotal", 0);
                    
                    // Set a success message
                    request.setAttribute("paymentCompleted", true);
                    
                    // Forward to a success page or back to payment page with success message
                    request.getRequestDispatcher("PaymentSuccess.jsp").forward(request, response);
                    return;
                } else {
                    // Payment processing failed
                    request.setAttribute("paymentError", "There was an error processing your payment. Please try again.");
                }
            }
        }
        
        // If we get here, either we're showing the payment form or there was an error
        request.getRequestDispatcher("Payment.jsp").forward(request, response);
    }
    
    // Database operations
    private boolean saveOrderToDatabase(List<Map<String, Object>> cartItems, String paymentMethod) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("JDBC Driver loaded successfully");

            // Establish connection
            System.out.println("Attempting to connect to database: " + JDBC_URL);
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            System.out.println("Database connection established successfully");

            // Begin transaction
            conn.setAutoCommit(false);
            System.out.println("Transaction begun");

            // Calculate total order amount
            int totalOrderAmount = 0;
            for (Map<String, Object> item : cartItems) {
                totalOrderAmount += (int) item.get("price");
            }

            // 1. Insert into orders table
            int userId = 1; // Assuming admin user for now - could be taken from session
            LocalDate orderDate = LocalDate.now();
            LocalTime orderTime = LocalTime.now();
            String orderStatus = "Paid"; // Set to paid since this is coming from payment process

            String orderSql = "INSERT INTO orders (user_id, order_date, order_time, total_amount, payment_method, order_status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

            System.out.println("Preparing SQL: " + orderSql);
            pstmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, userId);
            pstmt.setObject(2, orderDate);
            pstmt.setObject(3, orderTime);
            pstmt.setInt(4, totalOrderAmount);
            pstmt.setString(5, paymentMethod);
            pstmt.setString(6, orderStatus);
            int orderRowsAffected = pstmt.executeUpdate();
            System.out.println("Order insert rows affected: " + orderRowsAffected);

            // Get the auto-generated order ID
            rs = pstmt.getGeneratedKeys();
            int orderId = -1;
            if (rs.next()) {
                orderId = rs.getInt(1);
                System.out.println("Generated order ID: " + orderId);
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }
            rs.close();

            // Process each item in the cart
            for (Map<String, Object> item : cartItems) {
                String flavorWithSuffix = (String) item.get("flavor");
                String flavor = flavorWithSuffix.replace(" Milk Tea", "").toLowerCase();
                String size = ((String) item.get("size")).toLowerCase();
                String ice = (String) item.get("ice");
                String sugar = (String) item.get("sugar");
                String toppingsString = (String) item.get("toppings");
                String[] toppings = toppingsString.isEmpty() ? new String[0] : toppingsString.split(", ");
                int quantity = (int) item.get("quantity");
                int itemPrice = (int) item.get("price");

                // 2. Map flavor name to product_id
                int productId = mapFlavorToProductId(flavor);
                System.out.println("Mapped flavor " + flavor + " to product ID: " + productId);

                // 3. Map size to product_size_id
                int productSizeId = mapSizeToProductSizeId(flavor, size);
                System.out.println("Mapped size " + size + " to product size ID: " + productSizeId);

                // 4. Insert into order_items table
                int nextOrderItemId = getNextOrderItemId(conn);
                
                String orderItemSql = "INSERT INTO order_items (order_item_id, order_id, product_id, quantity, product_size_id, ice_level, sugar_level, price) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                System.out.println("Preparing SQL: " + orderItemSql);
                pstmt = conn.prepareStatement(orderItemSql, Statement.RETURN_GENERATED_KEYS);
                pstmt.setInt(1, nextOrderItemId);
                pstmt.setInt(2, orderId);
                pstmt.setInt(3, productId);
                pstmt.setInt(4, quantity);
                pstmt.setInt(5, productSizeId);
                pstmt.setString(6, ice.toLowerCase());
                pstmt.setInt(7, Integer.parseInt(sugar));
                pstmt.setInt(8, itemPrice);
                int itemRowsAffected = pstmt.executeUpdate();
                System.out.println("Order item insert rows affected: " + itemRowsAffected);

                // Get the auto-generated order item ID (in case there's AUTO_INCREMENT)
                rs = pstmt.getGeneratedKeys();
                int orderItemId = nextOrderItemId; // Default to our manual ID
                if (rs.next()) {
                    orderItemId = rs.getInt(1);
                    System.out.println("Generated order item ID: " + orderItemId);
                } else {
                    System.out.println("Using manually generated order item ID: " + orderItemId);
                }
                rs.close();

                // 5. Insert toppings into order_item_toppings table
                if (toppings != null && toppings.length > 0) {
                    System.out.println("Processing " + toppings.length + " toppings");
                    for (String topping : toppings) {
                        // Convert from display format (e.g., "Black Tapioca") to database format (e.g., "black-tapioca")
                        String dbTopping = topping.toLowerCase().replace(" ", "-");
                        int toppingId = mapToppingNameToId(dbTopping);
                        System.out.println("Mapped topping " + dbTopping + " to topping ID: " + toppingId);

                        String toppingSql = "INSERT INTO order_item_toppings (order_item_id, topping_id) VALUES (?, ?)";
                        pstmt = conn.prepareStatement(toppingSql);
                        pstmt.setInt(1, orderItemId);
                        pstmt.setInt(2, toppingId);
                        int toppingRowsAffected = pstmt.executeUpdate();
                        System.out.println("Topping insert rows affected: " + toppingRowsAffected);
                    }
                }
            }

            // 6. Insert into queue table
            String queueSql = "INSERT INTO queue (queue_id, order_id, queue_status, queue_number) VALUES (?, ?, ?, ?)";
            System.out.println("Preparing SQL: " + queueSql);
            pstmt = conn.prepareStatement(queueSql);
            pstmt.setInt(1, orderId); // Using order ID as queue ID for simplicity
            pstmt.setInt(2, orderId);
            pstmt.setString(3, "pending");
            int queueNumber = getNextQueueNumber();
            System.out.println("Next queue number: " + queueNumber);
            pstmt.setInt(4, queueNumber);
            int queueRowsAffected = pstmt.executeUpdate();
            System.out.println("Queue insert rows affected: " + queueRowsAffected);

            // Commit transaction
            conn.commit();
            System.out.println("Transaction committed successfully");
            success = true;

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                    System.err.println("Transaction rolled back due to JDBC driver error");
                }
            } catch (SQLException ex) {
                System.err.println("Failed to roll back transaction: " + ex.getMessage());
                ex.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                    System.err.println("Transaction rolled back due to SQL error");
                }
            } catch (SQLException ex) {
                System.err.println("Failed to roll back transaction: " + ex.getMessage());
                ex.printStackTrace();
            }
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                    System.err.println("Transaction rolled back due to unexpected error");
                }
            } catch (SQLException ex) {
                System.err.println("Failed to roll back transaction: " + ex.getMessage());
                ex.printStackTrace();
            }
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit mode
                    conn.close();
                    System.out.println("Database connection closed");
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    // Helper method to get the next order_item_id
    private int getNextOrderItemId(Connection conn) throws SQLException {
        int nextId = 1;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT MAX(order_item_id) FROM order_items";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                nextId = rs.getInt(1) + 1;
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        
        return nextId;
    }
    
    private int mapFlavorToProductId(String flavor) {
        switch (flavor.toLowerCase()) {
            case "classic": return 1;
            case "taro": return 2;
            case "matcha": return 3;
            case "strawberry": return 4;
            case "wintermelon": return 5;
            default: return 1;
        }
    }
    
    private int mapSizeToProductSizeId(String flavor, String size) {
        if ("classic".equals(flavor.toLowerCase())) {
            switch (size.toLowerCase()) {
                case "regular": return 1;
                case "medium": return 2;
                case "large": return 3;
                default: return 1;
            }
        } else {
            switch (size.toLowerCase()) {
                case "regular": return 4;
                case "medium": return 5;
                case "large": return 6;
                default: return 4;
            }
        }
    }
    
    private int mapToppingNameToId(String toppingName) {
        switch (toppingName.toLowerCase()) {
            case "black-tapioca": return 1;
            case "cheesecake": return 2;
            case "grass-jelly": return 3;
            case "pudding": return 4;
            case "oreo": return 5;
            default: return 1;
        }
    }
    
    private int getNextQueueNumber() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int nextQueueNumber = 1;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            
            String sql = "SELECT MAX(queue_number) FROM queue";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                nextQueueNumber = rs.getInt(1) + 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return nextQueueNumber;
    }
}