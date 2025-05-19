
public class User {
	private int id;
    private String username, email, role, password, status;

    // Constructors
    public User() {
    	this.id = 0;
    	this.username = "";
    	this.email = "";
    	this.role = "";
    	this.password = "";
    	this.status = "";
    }

    public User(int id, String username, String password, String email, String role, String status) {
        this.id = id;
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
    	return this.status;
    }
    
    public void setStatus(String status) {
    	this.status = status;
    }

    // Optional: Override toString for debugging
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
