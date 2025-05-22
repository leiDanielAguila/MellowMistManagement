package com.mellowmist.servlet;

import com.google.gson.Gson;
import com.mellowmist.dao.OrderQueueDAO;
import com.mellowmist.model.OrderQueue;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/OrderQueue")
public class UpdateQueueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private OrderQueueDAO orderQueueDAO;
    
    @Override
    public void init() {
        orderQueueDAO = new OrderQueueDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int recordsPerPage = 9;
        int currentPage = 1;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        
        try {
            int totalRecords = orderQueueDAO.getTotalQueueCount();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            List<OrderQueue> queues = orderQueueDAO.getQueuesByPage(currentPage, recordsPerPage);
            
            // Debug statement to check if queues are being retrieved properly
            System.out.println("Debug in servlet: queues size = " + (queues != null ? queues.size() : "null"));
            
            request.setAttribute("queues", queues);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            
            // Forward to the JSP file - updated path to match your project structure
            request.getRequestDispatcher("/OrderQueue.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving queue: " + e.getMessage());
            request.getRequestDispatcher("/OrderQueue.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get parameters from form
            int queueId = Integer.parseInt(request.getParameter("queueId"));
            String newStatus = request.getParameter("queueStatus");
            
            // Log the received values
            System.out.println("Processing update request: queueId=" + queueId + ", newStatus=" + newStatus);
            
            // Validation
            if (newStatus == null || newStatus.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Queue status cannot be empty\"}");
                return;
            } 
            
            // DAO update
            boolean success = orderQueueDAO.updateQueueStatus(queueId, newStatus);
            
            if (success) {
            	response.sendRedirect("OrderQueue");

            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"Failed to update queue status\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid queue ID format\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
 // Add this method to your existing UpdateQueueServlet class
    @WebServlet("/OrderDetails")
    public static class OrderDetailsServlet extends HttpServlet {
        private static final long serialVersionUID = 1L;
        
        private OrderQueueDAO orderQueueDAO;
        
        @Override
        public void init() {
            orderQueueDAO = new OrderQueueDAO();
        }
        
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            try {
                String orderIdParam = request.getParameter("orderId");
                if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Order ID is required\"}");
                    return;
                }
                
                int orderId = Integer.parseInt(orderIdParam);
                Map<String, Object> orderDetails = orderQueueDAO.getOrderDetailsById(orderId);
                
                // Convert to JSON using any library (or manually like this)
                Gson gson = new Gson();
                String json = gson.toJson(orderDetails);
                
                out.print(json);
                
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Invalid order ID format\"}");
                e.printStackTrace();
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"" + e.getMessage() + "\"}");
                e.printStackTrace();
            }
        }
    }
}