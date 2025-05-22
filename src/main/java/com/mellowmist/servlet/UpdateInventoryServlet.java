package com.mellowmist.servlet;

import com.mellowmist.dao.InventoryDAO;
import com.mellowmist.model.Inventory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet for handling inventory item update
 */
@WebServlet("/UpdateInventoryServlet")
public class UpdateInventoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private InventoryDAO inventoryDAO;
    
    @Override
    public void init() {
        inventoryDAO = new InventoryDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get form parameters
            int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
            String itemName = request.getParameter("itemName");
            String categoryName = request.getParameter("category");
            String unit = request.getParameter("unit");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int reorderLevel = Integer.parseInt(request.getParameter("reorderLevel"));
            
            // Get the existing inventory item
            Inventory inventory = inventoryDAO.getInventoryById(inventoryId);
            
            if (inventory != null) {
                // Update inventory object with new values
                inventory.setItemName(itemName);
                // Keep existing category ID and name
                // inventory.setCategoryId(categoryId); - removed
                // inventory.setCategoryName(categoryName); - removed
                inventory.setUnit(unit);
                inventory.setQuantity(quantity);
                inventory.setReorderLevel(reorderLevel);
                
                // Set status based on quantity and reorder level
                if (quantity <= 0) {
                    inventory.setStatus("Out of Stock");
                } else if (quantity <= reorderLevel) {
                    inventory.setStatus("Low Stock");
                } else {
                    inventory.setStatus("In Stock");
                }
                
                // Update inventory item in database
                boolean success = inventoryDAO.updateInventory(inventory);
                
                if (success) {
                    session.setAttribute("successMessage", "Inventory item updated successfully!");
                    response.sendRedirect("Inventory.jsp");
                } else {
                    session.setAttribute("errorMessage", "Failed to update inventory item.");
                    response.sendRedirect("Inventory.jsp");
                }
            } else {
                session.setAttribute("errorMessage", "Inventory item not found.");
                response.sendRedirect("Inventory.jsp");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            response.sendRedirect("Inventory.jsp");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect("Inventory.jsp");
        }
    }
}

