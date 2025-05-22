package com.mellowmist.dao;

import com.mellowmist.model.OrderQueue;
import com.mellowmist.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderQueueDAO {
    // Add a logger for better debugging
    private static final Logger logger = Logger.getLogger(OrderQueueDAO.class.getName());

    /**
     * Get all queue entries with pagination
     */
    public List<OrderQueue> getAllQueueEntries(int page, int itemsPerPage) {
        List<OrderQueue> queueList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                logger.severe("Database connection failed in getAllQueueEntries");
                return queueList;
            }
            
            int offset = (page - 1) * itemsPerPage;
            logger.info("Fetching queue entries with page=" + page + ", itemsPerPage=" + itemsPerPage + ", offset=" + offset);

            // Modified SQL to include JOIN with orders table to get total_amount
            String sql = "SELECT q.queue_id, q.order_id, q.queue_status, q.queue_number, o.total_amount " +
                         "FROM queue q " +
                         "JOIN orders o ON q.order_id = o.order_id " +
                         "ORDER BY q.queue_number ASC LIMIT ? OFFSET ?";
            logger.info("SQL Query: " + sql);
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, itemsPerPage);
            stmt.setInt(2, offset);

            rs = stmt.executeQuery();
            logger.info("Query executed successfully");

            int count = 0;
            while (rs.next()) {
                OrderQueue queue = new OrderQueue();
                queue.setQueueId(rs.getInt("queue_id"));
                queue.setOrderId(rs.getInt("order_id"));
                queue.setQueueStatus(rs.getString("queue_status"));
                queue.setQueueNumber(rs.getInt("queue_number"));
                queue.setTotalAmount(rs.getInt("total_amount")); // Get total_amount from resultset
                queueList.add(queue);
                count++;
            }
            logger.info("Retrieved " + count + " queue entries");

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "SQL Exception in getAllQueueEntries", e);
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return queueList;
    }
    
    public List<OrderQueue> getAllQueues() {
        List<OrderQueue> queueList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            logger.info("Attempting to get all queues");
            conn = DBConnection.getConnection();
            if (conn == null) {
                logger.severe("Database connection failed in getAllQueues");
                return queueList;
            }

            // Modified SQL to include JOIN with orders table to get total_amount
            String sql = "SELECT q.queue_id, q.order_id, q.queue_status, q.queue_number, o.total_amount " +
                         "FROM queue q " +
                         "JOIN orders o ON q.order_id = o.order_id " +
                         "ORDER BY q.queue_number ASC";
            logger.info("SQL Query: " + sql);
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            int count = 0;
            while (rs.next()) {
                OrderQueue queue = new OrderQueue();
                queue.setQueueId(rs.getInt("queue_id"));
                queue.setOrderId(rs.getInt("order_id"));
                queue.setQueueStatus(rs.getString("queue_status"));
                queue.setQueueNumber(rs.getInt("queue_number"));
                queue.setTotalAmount(rs.getInt("total_amount")); // Get total_amount from resultset
                queueList.add(queue);
                count++;
            }
            logger.info("Retrieved " + count + " queue entries in getAllQueues");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception in getAllQueues", e);
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return queueList;
    }
    
    public List<OrderQueue> getQueuesByPage(int currentPage, int recordsPerPage) {
        List<OrderQueue> queueList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            int start = (currentPage - 1) * recordsPerPage;
            logger.info("Fetching queues for page=" + currentPage + ", recordsPerPage=" + recordsPerPage + ", start=" + start);
            
            conn = DBConnection.getConnection();
            if (conn == null) {
                logger.severe("Database connection failed in getQueuesByPage");
                return queueList;
            }

            // Debug to check if connection is valid
            logger.info("Connection valid: " + !conn.isClosed());
            
            // Try a simple query to test if we can query the database at all
            try (Statement testStmt = conn.createStatement()) {
                ResultSet testRs = testStmt.executeQuery("SELECT 1");
                if (testRs.next()) {
                    logger.info("Basic connectivity test successful");
                }
            } catch (SQLException e) {
                logger.severe("Basic connectivity test failed: " + e.getMessage());
            }

            // Modified SQL to include JOIN with orders table to get total_amount
            String sql = "SELECT q.*, o.total_amount FROM queue q " +
                         "JOIN orders o ON q.order_id = o.order_id " +
                         "ORDER BY q.queue_number ASC LIMIT ?, ?";
            logger.info("SQL Query: " + sql);
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, start);
            stmt.setInt(2, recordsPerPage);

            rs = stmt.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                OrderQueue queue = new OrderQueue();
                queue.setQueueId(rs.getInt("queue_id"));
                queue.setOrderId(rs.getInt("order_id"));
                queue.setQueueStatus(rs.getString("queue_status"));
                queue.setQueueNumber(rs.getInt("queue_number"));
                queue.setTotalAmount(rs.getInt("total_amount")); // Get total_amount from resultset
                queueList.add(queue);
                count++;
                
                // Debug each retrieved row
                logger.info("Retrieved queue: ID=" + queue.getQueueId() + 
                           ", OrderID=" + queue.getOrderId() + 
                           ", Status=" + queue.getQueueStatus() + 
                           ", Number=" + queue.getQueueNumber() +
                           ", Total Amount=" + queue.getTotalAmount());
            }
            logger.info("Retrieved " + count + " queue entries in getQueuesByPage");
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "SQL Exception in getQueuesByPage", e);
            e.printStackTrace();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "General Exception in getQueuesByPage", e);
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return queueList;
    }
    
    /**
     * Get detailed order information including items
     */
    public Map<String, Object> getOrderDetailsById(int orderId) {
        Map<String, Object> orderDetails = new HashMap<>();
        List<Map<String, Object>> orderItems = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            logger.info("Fetching order details for Order ID: " + orderId);
            conn = DBConnection.getConnection();
            if (conn == null) {
                logger.severe("Database connection failed in getOrderDetailsById");
                return orderDetails;
            }
            
            // First get order info
            String orderSql = "SELECT o.order_id, o.total_amount, o.order_date " +
                             "FROM orders o WHERE o.order_id = ?";
            
            stmt = conn.prepareStatement(orderSql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                orderDetails.put("orderNo", String.format("%05d", rs.getInt("order_id")));
                orderDetails.put("totalAmount", rs.getInt("total_amount"));
                orderDetails.put("orderDate", rs.getDate("order_date").toString());
            } else {
                logger.warning("No order found with ID: " + orderId);
                return orderDetails;
            }
            
            // Close previous resources
            rs.close();
            stmt.close();
            
            // Now get order items
            String itemsSql = "SELECT oi.order_item_id, oi.quantity, oi.price, " +
                             "p.product_name, ps.size_name, oi.ice_level, oi.sugar_level, " +
                             "GROUP_CONCAT(t.topping_name SEPARATOR ',') as toppings " +
                             "FROM order_items oi " +
                             "JOIN products p ON oi.product_id = p.product_id " +
                             "JOIN product_size ps ON oi.product_size_id = ps.product_size_id " +
                             "LEFT JOIN order_item_toppings oit ON oi.order_item_id = oit.order_item_id " +
                             "LEFT JOIN toppings t ON oit.topping_id = t.topping_id " +
                             "WHERE oi.order_id = ? " +
                             "GROUP BY oi.order_item_id";
            
            stmt = conn.prepareStatement(itemsSql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", rs.getString("product_name"));
                item.put("price", rs.getInt("price"));
                item.put("size", rs.getString("size_name"));
                item.put("sweetness", rs.getInt("sugar_level") + "%");
                item.put("iceLevel", rs.getString("ice_level"));
                
                // Handle toppings - split the concatenated string
                String toppingsStr = rs.getString("toppings");
                List<String> toppingsList = new ArrayList<>();
                if (toppingsStr != null && !toppingsStr.isEmpty()) {
                    String[] toppingsArray = toppingsStr.split(",");
                    toppingsList = Arrays.asList(toppingsArray);
                }
                item.put("toppings", toppingsList);
                
                orderItems.add(item);
            }
            
            orderDetails.put("items", orderItems);
            logger.info("Retrieved order details for Order ID: " + orderId + " with " + orderItems.size() + " items");

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "SQL Exception in getOrderDetailsById", e);
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return orderDetails;
    }
    
    /**
     * Get a single queue entry by ID
     */
    public OrderQueue getQueueById(int queueId) {
        OrderQueue queue = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            logger.info("Fetching queue with ID: " + queueId);
            conn = DBConnection.getConnection();
            if (conn == null) {
                logger.severe("Database connection failed in getQueueById");
                return null;
            }
            
            // Modified SQL to include JOIN with orders table to get total_amount
            String sql = "SELECT q.queue_id, q.order_id, q.queue_status, q.queue_number, o.total_amount " +
                         "FROM queue q " +
                         "JOIN orders o ON q.order_id = o.order_id " +
                         "WHERE q.queue_id = ?";
            logger.info("SQL Query: " + sql);
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, queueId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                queue = new OrderQueue();
                queue.setQueueId(rs.getInt("queue_id"));
                queue.setOrderId(rs.getInt("order_id"));
                queue.setQueueStatus(rs.getString("queue_status"));
                queue.setQueueNumber(rs.getInt("queue_number"));
                queue.setTotalAmount(rs.getInt("total_amount")); // Get total_amount from resultset
                
                logger.info("Retrieved queue: ID=" + queue.getQueueId() + 
                           ", OrderID=" + queue.getOrderId() + 
                           ", Status=" + queue.getQueueStatus() + 
                           ", Number=" + queue.getQueueNumber() +
                           ", Total Amount=" + queue.getTotalAmount());
            } else {
                logger.warning("No queue found with ID: " + queueId);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "SQL Exception in getQueueById", e);
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return queue;
    }
    
    // The remaining methods can stay the same as they don't need to fetch total_amount
    
    /**
     * Update only the queue_status of a queue entry
     */
    public boolean updateQueueStatus(int queueId, String newStatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        try {
            logger.info("Updating queue status for ID " + queueId + " to: " + newStatus);
            conn = DBConnection.getConnection();
            if (conn == null) {
                logger.severe("Database connection failed in updateQueueStatus");
                return false;
            }

            // Test connection
            if (conn.isClosed()) {
                logger.severe("Connection is closed");
                return false;
            }
            
            logger.info("Connection successful, autocommit=" + conn.getAutoCommit());

            // Important: Disable auto-commit to ensure transaction integrity
            boolean originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            
            System.out.println("Update status request: Queue ID = " + queueId + ", New Status = " + newStatus);

            String sql = "UPDATE queue SET queue_status = ? WHERE queue_id = ?";
            logger.info("SQL Query: " + sql);

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setInt(2, queueId);

            int rowsAffected = stmt.executeUpdate();
            logger.info("SQL execution complete. Rows affected: " + rowsAffected);
            
            // Explicitly commit the transaction
            conn.commit();
            logger.info("Transaction committed");
            
            success = (rowsAffected > 0);

            logger.info("Update " + (success ? "successful" : "failed") +
                    ". Rows affected: " + rowsAffected);
                    
            // Restore original auto-commit setting
            conn.setAutoCommit(originalAutoCommit);

            if (!success) {
                // Debug info for when update fails but no exception is thrown
                System.out.println("WARNING: Update reported no rows affected. Verify queue_id " + queueId + " exists.");
                
                // Test if the queue exists
                PreparedStatement checkStmt = null;
                ResultSet rs = null;
                try {
                    checkStmt = conn.prepareStatement("SELECT count(*) FROM queue WHERE queue_id = ?");
                    checkStmt.setInt(1, queueId);
                    rs = checkStmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        logger.info("Queue ID " + queueId + " exists in database: " + (count > 0));
                    }
                } finally {
                    if (rs != null) rs.close();
                    if (checkStmt != null) checkStmt.close();
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "SQL Exception in updateQueueStatus", e);
            e.printStackTrace();
            
            // Attempt to rollback on error
            try {
                if (conn != null) {
                    conn.rollback();
                    logger.info("Transaction rolled back due to error");
                }
            } catch (SQLException rollbackEx) {
                logger.log(Level.SEVERE, "Error during rollback", rollbackEx);
            }
        } finally {
            closeResources(null, stmt, conn);
        }

        return success;
    }
    
    /**
     * Get total number of queue entries
     */
    public int getTotalQueueCount() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            logger.info("Getting total queue count");
            conn = DBConnection.getConnection();
            if (conn == null) {
                logger.severe("Database connection failed in getTotalQueueCount");
                return 0;
            }
            
            String sql = "SELECT COUNT(*) FROM queue";
            logger.info("SQL Query: " + sql);
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
                logger.info("Total queue count: " + count);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "SQL Exception in getTotalQueueCount", e);
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return count;
    }
    
    /**
     * Helper method to close JDBC resources
     */
    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DBConnection.closeConnection(conn);
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error closing JDBC resources", e);
        }
    }
    
    /**
     * Test method to verify database connection works
     */
    public boolean testConnection() throws SQLException {
        Connection conn = null;
        try {
            logger.info("Testing database connection");
            conn = DBConnection.getConnection();
            boolean isConnected = (conn != null && !conn.isClosed());
            logger.info("Connection test result: " + (isConnected ? "SUCCESS" : "FAILED"));
            return isConnected;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Connection test failed with exception", e);
            return false;
        } finally {
            if (conn != null) {
                DBConnection.closeConnection(conn);
            }
        }
    }
}