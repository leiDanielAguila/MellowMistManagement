package com.mellowmist.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger logger = Logger.getLogger(DBConnection.class.getName());
    
    // Database connection parameters - update these to match your configuration
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mellowmistmanagement";
    private static final String USER = "root"; // Replace with your actual username
    private static final String PASSWORD = "1234"; // Replace with your actual password
    
    // Connection timeout in seconds
    private static final int CONNECTION_TIMEOUT = 5;
    
    static {
        try {
            // Load the JDBC driver
            Class.forName(JDBC_DRIVER);
            logger.info("JDBC Driver loaded successfully: " + JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "Failed to load JDBC driver. Database connectivity will fail.", e);
        }
    }
    
    /**
     * Get a database connection
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            logger.info("Attempting to connect to database at: " + DB_URL);
            
            // Set connection properties including timeout
            java.util.Properties connectionProps = new java.util.Properties();
            connectionProps.put("user", USER);
            connectionProps.put("password", PASSWORD);
            connectionProps.put("connectTimeout", String.valueOf(CONNECTION_TIMEOUT * 1000));
            
            conn = DriverManager.getConnection(DB_URL, connectionProps);
            
            if (conn != null) {
                logger.info("Database connection established successfully");
            } else {
                logger.severe("Failed to establish database connection - connection is null");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to connect to database", e);
            logger.severe("Connection details: URL=" + DB_URL + ", User=" + USER);
            logger.severe("Error code: " + e.getErrorCode() + ", SQL State: " + e.getSQLState());
        }
        return conn;
    }
    
    /**
     * Close the database connection
     */
    public static void closeConnection(Connection conn) throws SQLException {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                logger.info("Database connection closed successfully");
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error closing database connection", e);
            throw e;
        }
    }
    
    /**
     * Test if the database is accessible
     */
    public static boolean testDatabaseConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                logger.info("Database connection test successful");
                return true;
            } else {
                logger.severe("Database connection test failed");
                return false;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database connection test failed with exception", e);
            return false;
        } finally {
            if (conn != null) {
                try {
                    closeConnection(conn);
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error closing test connection", e);
                }
            }
        }
    }
}