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

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CustomerOrder")
public class CustomerOrder extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database connection parameters
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/mellowmistmanagement";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "1234"; // Set your database password here
    
    // Pricing maps
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
    
    public CustomerOrder() {
        super();
    }

 // Updated doGet method in CustomerOrder.java
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Handle item removal from cart
        String removeItemIndex = request.getParameter("removeItem");
        if (removeItemIndex != null && session != null) {
            try {
                int index = Integer.parseInt(removeItemIndex);
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");
                
                if (cartItems != null && index >= 0 && index < cartItems.size()) {
                    // Get the price of the item to be removed
                    int itemPrice = (int) cartItems.get(index).get("price");
                    
                    // Remove the item from the cart
                    cartItems.remove(index);
                    
                    // Update the cart total
                    int cartTotal = (int) session.getAttribute("cartTotal");
                    cartTotal -= itemPrice;
                    session.setAttribute("cartTotal", cartTotal);
                    
                    // Update the cart items in session
                    session.setAttribute("cartItems", cartItems);
                }
            } catch (NumberFormatException | IndexOutOfBoundsException e) {
                // Log the error but continue processing
                System.err.println("Error removing item from cart: " + e.getMessage());
            }
            
            // Redirect back to the same page to avoid form resubmission
            response.sendRedirect("CustomerOrder");
            return; // Important to return here to prevent further processing
        }
        
        // Check if "confirmOrder" parameter exists (this means we're finalizing the order)
        String confirmOrder = request.getParameter("confirmOrder");
        if (confirmOrder != null && confirmOrder.equals("true")) {
            // Save the entire cart to database
            if (session != null) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");
                if (cartItems != null && !cartItems.isEmpty()) {
                    // Process the entire cart and save to database
                    saveOrderToDatabase(cartItems);
                    
                    // Clear the cart
                    cartItems.clear();
                    session.setAttribute("cartItems", cartItems);
                    session.setAttribute("cartTotal", 0);
                    
                    // Set a success message
                    request.setAttribute("orderCompleted", true);
                }
            }
        } else if (request.getParameter("clearCart") != null) {
            // Clear the cart
            if (session != null) {
                session.removeAttribute("cartItems");
                session.setAttribute("cartTotal", 0);
            }
        }
        
        request.getRequestDispatcher("CustomerOrder.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session or create if it doesn't exist
        HttpSession session = request.getSession(true);
        
        // Get form parameters
        String flavor = request.getParameter("flavor");

        String size = request.getParameter("size");
        String ice = request.getParameter("ice");
        String sugar = request.getParameter("sugar");
        String[] toppingsArray = request.getParameterValues("toppings");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        // Handle case when no toppings are selected
        if (toppingsArray == null) {
            toppingsArray = new String[0];
        }
        
        // Calculate item price based on flavor, size, and toppings
        int basePrice = getBasePrice(flavor, size);
        int toppingsPrice = getToppingsPrice(toppingsArray);
        int itemPrice = (basePrice + toppingsPrice) * quantity;
        
        // Create a list of order items if it doesn't exist in session
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new ArrayList<>();
            session.setAttribute("cartItems", cartItems);
        }
        
        // Format toppings for display
        String formattedToppings = formatToppings(toppingsArray);
        
        // Create a map to hold the current order item details
        Map<String, Object> orderItem = new HashMap<>();
        String flavorKey = flavor.toLowerCase(); // "Classic" -> "classic"
        String imagePath = "img/flavor-" + flavorKey + ".png"; // "img/flavor-classic.png"
        
        orderItem.put("flavor", capitalizeFirstLetter(flavor) + " Milk Tea");
        orderItem.put("size", capitalizeFirstLetter(size));
        orderItem.put("ice", formatIceLevel(ice));
        orderItem.put("sugar", sugar);
        orderItem.put("toppings", formattedToppings.isEmpty() ? "" : formattedToppings);
        orderItem.put("quantity", quantity);
        orderItem.put("price", itemPrice);
        orderItem.put("image", imagePath);
        
        // Add to cart
        cartItems.add(orderItem);
        
        // Calculate total cart amount
        int totalCartAmount = 0;
        for (Map<String, Object> item : cartItems) {
            totalCartAmount += (int) item.get("price");
        }
        session.setAttribute("cartTotal", totalCartAmount);
        
        // Set attributes for the JSP
        request.setAttribute("selectedFlavor", capitalizeFirstLetter(flavor) + " Milk Tea");
        request.setAttribute("drinkSize", capitalizeFirstLetter(size));
        request.setAttribute("iceLevel", formatIceLevel(ice));
        request.setAttribute("sugarLevel", sugar + "%");
        request.setAttribute("drinkToppings", formattedToppings.isEmpty() ? "No toppings" : formattedToppings);
        request.setAttribute("drinkQuantity", quantity);
        request.setAttribute("orderItemPrice", itemPrice);
        
        // Forward back to the JSP
        request.getRequestDispatcher("CustomerOrder.jsp").forward(request, response);
    }
    
    // Helper methods
    private int getBasePrice(String flavor, String size) {
        Map<String, Integer> prices = FLAVOR_PRICES.get(flavor);
        if (prices != null) {
            Integer price = prices.get(size);
            if (price != null) {
                return price;
            }
        }
        // Default price if not found
        return 100;
    }
    
    private int getToppingsPrice(String[] toppings) {
        int total = 0;
        if (toppings != null) {
            for (String topping : toppings) {
                Integer price = TOPPING_PRICES.get(topping);
                if (price != null) {
                    total += price;
                }
            }
        }
        return total;
    }
    
    private String formatToppings(String[] toppings) {
        if (toppings == null || toppings.length == 0) {
            return "";
        }
        
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < toppings.length; i++) {
            String formattedTopping = toppings[i].replace("-", " ");
            sb.append(capitalizeFirstLetter(formattedTopping));
            if (i < toppings.length - 1) {
                sb.append(", ");
            }
        }
        return sb.toString();
    }
    
    private String formatIceLevel(String ice) {
        if (ice == null) return "";
        return capitalizeFirstLetter(ice);
    }
    
    private String capitalizeFirstLetter(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }
        return input.substring(0, 1).toUpperCase() + input.substring(1);
    }
    
    // Database operations
    private void saveOrderToDatabase(List<Map<String, Object>> cartItems) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

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
            int userId = 1; // Assuming admin user for now
            LocalDate orderDate = LocalDate.now(); // Current date for the new order_date column
            LocalTime orderTime = LocalTime.now();
            String paymentMethod = "Cash"; // Default payment method
            String orderStatus = "Preparing"; // Default order status

            String orderSql = "INSERT INTO orders (user_id, order_date, order_time, total_amount, payment_method, order_status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

            System.out.println("Preparing SQL: " + orderSql);
            pstmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, userId);
            pstmt.setObject(2, orderDate); // Add the order_date parameter
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
