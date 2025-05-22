package com.mellowmist.servlet;

import com.mellowmist.dao.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteInventoryServlet")
public class DeleteInventoryServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get parameters
            int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
            
            // Delete inventory item
            InventoryDAO inventoryDAO = new InventoryDAO();
            boolean deleted = inventoryDAO.deleteInventory(inventoryId);
            
            if (deleted) {
                // Set success message in session
                session.setAttribute("successMessage", "Item deleted successfully!");
            } else {
                // Set error message in session
                session.setAttribute("errorMessage", "Failed to delete item. Item ID may not exist.");
            }
            
        } catch (NumberFormatException e) {
            // Set error message for invalid input
            session.setAttribute("errorMessage", "Invalid inventory ID format.");
        } catch (Exception e) {
            // Set error message for any other exception
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        // Redirect back to inventory page
        response.sendRedirect("Inventory.jsp");
    }
}

