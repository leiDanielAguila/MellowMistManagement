package com.mellowmist.servlet;

import com.mellowmist.dao.InventoryDAO;
import com.mellowmist.dao.CategoryDAO;
import com.mellowmist.model.Inventory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling inventory item addition
 */
@WebServlet("/AddInventoryServlet")
public class AddInventoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private InventoryDAO inventoryDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() {
        inventoryDAO = new InventoryDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get form parameters
            String itemName = request.getParameter("itemName");
            String categoryName = request.getParameter("category");
            String unit = request.getParameter("unit");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int reorderLevel = Integer.parseInt(request.getParameter("reorderLevel"));
            
            // Get category ID from category name (creating it if it doesn't exist)
            int categoryId = categoryDAO.getCategoryIdByName(categoryName);
            
            if (categoryId == -1) {
                session.setAttribute("errorMessage", "Failed to process category. Please try again.");
                response.sendRedirect("Inventory.jsp");
                return;
            }
            
            // Create inventory object
            Inventory inventory = new Inventory();
            inventory.setItemName(itemName);
            inventory.setCategoryId(categoryId);
            inventory.setCategoryName(categoryName);
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
            
            // Add inventory item to database
            boolean success = inventoryDAO.addInventory(inventory);
            
            if (success) {
                session.setAttribute("successMessage", "Inventory item added successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to add inventory item. Please try again.");
            }
            
            response.sendRedirect("Inventory.jsp");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid number format. Please enter valid numbers.");
            response.sendRedirect("Inventory.jsp");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect("Inventory.jsp");
            e.printStackTrace();
        }
    }
}