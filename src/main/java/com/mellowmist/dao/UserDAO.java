package com.mellowmist.dao;

import com.mellowmist.model.User;
import com.mellowmist.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public UserDAO() {
        // Constructor
    }
    
    // Get all users
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                int id = rs.getInt("user_id");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String role = rs.getString("role");
                String email = rs.getString("email");
                String status = rs.getString("status");
                
                User user = new User(id, username, password, email, role, status);
                users.add(user);
            }
        }
        
        return users;
    }
    
    // Get user by ID
    public User getUserById(int userId) throws SQLException {
        User user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String username = rs.getString("username");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
                    String email = rs.getString("email");
                    String status = rs.getString("status");
                    
                    user = new User(userId, username, password, email, role, status);
                }
            }
        }
        
        return user;
    }
    
    // Add new user
    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO users (user_id, username, password, role, email, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, user.getId());
            pstmt.setString(2, user.getUsername());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getRole());
            pstmt.setString(5, user.getEmail());
            pstmt.setString(6, user.getStatus());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Update existing user
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET username = ?, password = ?, role = ?, email = ?, status = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getStatus());
            pstmt.setInt(6, user.getId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Delete user
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
}