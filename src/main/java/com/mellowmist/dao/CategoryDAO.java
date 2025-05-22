package com.mellowmist.dao;

import com.mellowmist.util.DBConnection;
import java.sql.*;

/**
 * Data Access Object for Category operations
 */
public class CategoryDAO {
    
    /**
     * Get category ID by name
     * If category doesn't exist, it will create one
     * @param categoryName Name of the category
     * @return Category ID 
     */
    public int getCategoryIdByName(String categoryName) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int categoryId = -1;
        
        try {
            conn = DBConnection.getConnection();
            
            // First check if category exists
            String sql = "SELECT category_id FROM categories WHERE category_name = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, categoryName);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                categoryId = rs.getInt("category_id");
            } else {
                // Category doesn't exist, create it
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                
                // Get next category ID
                stmt = conn.prepareStatement("SELECT MAX(category_id) FROM categories");
                rs = stmt.executeQuery();
                int nextCategoryId = 1;
                if (rs.next()) {
                    nextCategoryId = rs.getInt(1) + 1;
                }
                
                // Insert new category
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                
                sql = "INSERT INTO categories (category_id, category_name) VALUES (?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, nextCategoryId);
                stmt.setString(2, categoryName);
                int result = stmt.executeUpdate();
                
                if (result > 0) {
                    categoryId = nextCategoryId;
                }
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
}