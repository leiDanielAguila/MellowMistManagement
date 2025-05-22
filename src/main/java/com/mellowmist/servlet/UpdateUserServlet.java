package com.mellowmist.servlet;
import com.mellowmist.model.User;
import com.mellowmist.dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private UserDAO userDAO;
  
   public void init() {
       userDAO = new UserDAO();
   }
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
       try {
           // Get parameters from form
           int userId = Integer.parseInt(request.getParameter("userId"));
           String username = request.getParameter("username");
           String password = request.getParameter("password");
           String email = request.getParameter("email");
           String role = request.getParameter("role");
           String status = request.getParameter("status");
          
           // Create user object with updated values
           User user = new User(userId, username, password, email, role, status);
          
           // Update user in database
           boolean success = userDAO.updateUser(user);
          
           // Store message in session instead of request
           HttpSession session = request.getSession();
           if (success) {
               session.setAttribute("message", "User updated successfully");
               session.setAttribute("messageType", "success");
           } else {
               session.setAttribute("message", "Failed to update user");
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


