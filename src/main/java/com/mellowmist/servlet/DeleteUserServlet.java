package com.mellowmist.servlet;
import com.mellowmist.dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    public void init() {
        userDAO = new UserDAO();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get user ID from request parameter
            int userId = Integer.parseInt(request.getParameter("userId"));
            
            // Delete user from database
            boolean success = userDAO.deleteUser(userId);
            
            // Store message in session instead of request
            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("message", "User deleted successfully");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to delete user");
                session.setAttribute("messageType", "error");
            }
            
            // Redirect back to user management page
            response.sendRedirect("Users.jsp");
            
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("message", "Invalid user ID format");
            session.setAttribute("messageType", "error");
            response.sendRedirect("Users.jsp");
        } catch (SQLException e) {
            HttpSession session = request.getSession();
            session.setAttribute("message", "Database error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("Users.jsp");
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("Users.jsp");
        }
    }
}


