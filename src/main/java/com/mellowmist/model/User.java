package com.mellowmist.model;

/**
 * User model class for Mellow Mist application
 * Represents a user entity with id, username, password, email, role, and status
 */
public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String role;
    private String status;
    
    /**
     * Default constructor
     */
    public User() {
        // Default constructor
    }
    
    /**
     * Full constructor with all fields
     * 
     * @param id User ID
     * @param username Username
     * @param password Password
     * @param email Email address
     * @param role User role (Admin, Manager, Staff)
     * @param status User status (Active, Inactive)
     */
    public User(int id, String username, String password, String email, String role, String status) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.status = status;
    }
    
    /**
     * Constructor without ID (for creating new users)
     * 
     * @param username Username
     * @param password Password
     * @param email Email address
     * @param role User role
     * @param status User status
     */
    public User(String username, String password, String email, String role, String status) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.status = status;
    }
    
    // Getters and Setters
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}