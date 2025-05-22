package com.mellowmist.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Just call doPost to reuse the same logic
        doPost(request, response);
    }
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the session
        HttpSession session = request.getSession(false);
        
        // Invalidate the session if it exists
        if (session != null) {
            session.invalidate();
        }
        
        // Redirect to login page
        response.sendRedirect("login.jsp");
    }
}

