package com.mellowmist.dao;

import com.mellowmist.model.Inventory;
import com.mellowmist.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Inventory operations
 */
public class InventoryDAO {
    
    /**
     * Get all inventory items with pagination
     * @param page Page number (starting from 1)
     * @param itemsPerPage Number of items per page
     * @return List of inventory items
     */
    public List<Inventory> getAllInventory(int page, int itemsPerPage) {
        List<Inventory> inventoryList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Calculate offset for pagination
            int offset = (page - 1) * itemsPerPage;
            
            // SQL query with JOIN to get category name and pagination
            String sql = "SELECT i.inventory_id, i.item_name, i.category_id, c.category_name, "
                    + "i.unit, i.quantity, i.reorder_level, i.status "
                    + "FROM inventory i "
                    + "LEFT JOIN categories c ON i.category_id = c.category_id "
                    + "ORDER BY i.inventory_id DESC "
                    + "LIMIT ? OFFSET ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, itemsPerPage);
            stmt.setInt(2, offset);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Inventory inventory = new Inventory();
                inventory.setInventoryId(rs.getInt("inventory_id"));
                inventory.setItemName(rs.getString("item_name"));
                inventory.setCategoryId(rs.getInt("category_id"));
                inventory.setCategoryName(rs.getString("category_name"));
                inventory.setUnit(rs.getString("unit"));
                inventory.setQuantity(rs.getInt("quantity"));
                inventory.setReorderLevel(rs.getInt("reorder_level"));
                inventory.setStatus(rs.getString("status"));
                
                inventoryList.add(inventory);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return inventoryList;
    }
    
    /**
     * Get total count of inventory items
     * @return Total count of inventory items
     */
    public int getTotalInventoryCount() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM inventory";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return count;
    }
    
    /**
     * Get inventory item by ID
     * @param inventoryId ID of the inventory item
     * @return Inventory object if found, null otherwise
     */
    public Inventory getInventoryById(int inventoryId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Inventory inventory = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT i.inventory_id, i.item_name, i.category_id, c.category_name, "
                    + "i.unit, i.quantity, i.reorder_level, i.status "
                    + "FROM inventory i "
                    + "LEFT JOIN categories c ON i.category_id = c.category_id "
                    + "WHERE i.inventory_id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, inventoryId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                inventory = new Inventory();
                inventory.setInventoryId(rs.getInt("inventory_id"));
                inventory.setItemName(rs.getString("item_name"));
                inventory.setCategoryId(rs.getInt("category_id"));
                inventory.setCategoryName(rs.getString("category_name"));
                inventory.setUnit(rs.getString("unit"));
                inventory.setQuantity(rs.getInt("quantity"));
                inventory.setReorderLevel(rs.getInt("reorder_level"));
                inventory.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return inventory;
    }
    
    /**
     * Add a new inventory item
     * @param inventory Inventory object to add
     * @return true if operation was successful, false otherwise
     */
    public boolean addInventory(Inventory inventory) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get next inventory ID
            int nextId = getNextInventoryId(conn);
            inventory.setInventoryId(nextId);
            
            // Prepare SQL statement
            String sql = "INSERT INTO inventory (inventory_id, item_name, category_id, unit, quantity, reorder_level, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, inventory.getInventoryId());
            stmt.setString(2, inventory.getItemName());
            stmt.setInt(3, inventory.getCategoryId());
            stmt.setString(4, inventory.getUnit());
            stmt.setInt(5, inventory.getQuantity());
            stmt.setInt(6, inventory.getReorderLevel());
            stmt.setString(7, inventory.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    /**
     * Update an existing inventory item
     * @param inventory Inventory object with updated values
     * @return true if operation was successful, false otherwise
     */
    public boolean updateInventory(Inventory inventory) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            
            // Prepare SQL statement
            String sql = "UPDATE inventory "
                    + "SET item_name = ?, category_id = ?, unit = ?, quantity = ?, reorder_level = ?, status = ? "
                    + "WHERE inventory_id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, inventory.getItemName());
            stmt.setInt(2, inventory.getCategoryId());
            stmt.setString(3, inventory.getUnit());
            stmt.setInt(4, inventory.getQuantity());
            stmt.setInt(5, inventory.getReorderLevel());
            stmt.setString(6, inventory.getStatus());
            stmt.setInt(7, inventory.getInventoryId());
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    /**
     * Delete an inventory item by ID
     * @param inventoryId ID of the inventory item to delete
     * @return true if operation was successful, false otherwise
     */
    public boolean deleteInventory(int inventoryId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            
            // Prepare SQL statement
            String sql = "DELETE FROM inventory WHERE inventory_id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, inventoryId);
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    /**
     * Get all categories for dropdown selection
     * @return List of category IDs and names
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT category_id, category_name FROM categories";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return categories;
    }
    
    /**
     * Get category ID by name
     * @param categoryName Name of the category
     * @return Category ID if found, -1 otherwise
     */
    public int getCategoryIdByName(String categoryName) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int categoryId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT category_id FROM categories WHERE category_name = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, categoryName);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                categoryId = rs.getInt("category_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return categoryId;
    }
    
    /**
     * Get the next available inventory ID
     * @param conn Database connection
     * @return Next inventory ID
     * @throws SQLException if a database error occurs
     */
    private int getNextInventoryId(Connection conn) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int nextId = 1;
        
        try {
            String sql = "SELECT MAX(inventory_id) FROM inventory";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                nextId = rs.getInt(1) + 1;
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        
        return nextId;
    }
    
    /**
     * Inner class to represent a category for dropdown
     */
    public static class Category {
        private int categoryId;
        private String categoryName;
        
        public int getCategoryId() {
            return categoryId;
        }
        
        public void setCategoryId(int categoryId) {
            this.categoryId = categoryId;
        }
        
        public String getCategoryName() {
            return categoryName;
        }
        
        public void setCategoryName(String categoryName) {
            this.categoryName = categoryName;
        }
    }
}