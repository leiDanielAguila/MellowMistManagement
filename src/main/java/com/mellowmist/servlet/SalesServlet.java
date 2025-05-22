package com.mellowmist.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import com.mellowmist.dao.SalesDAO;
import com.mellowmist.model.SalesReportDTO;
import com.mellowmist.model.OrderDetailDTO;
import com.mellowmist.model.SalesReportFilter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet("/SalesServlet")
public class SalesServlet extends HttpServlet {
    private SalesDAO salesDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
    	this.salesDAO = new SalesDAO();
        this.gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Build filter from request parameters
        SalesReportFilter filter = buildFilterFromRequest(request);
        
        // Get sales report data using filter
        List<SalesReportDTO> salesList = salesDAO.getSalesReport(filter);
        
        // Get sales summary
        Map<String, Object> summary = salesDAO.getSalesSummary(filter);
        
        // Get total count for pagination
        int totalCount = salesDAO.getTotalSalesCount(filter);
        int totalPages = (int) Math.ceil((double) totalCount / filter.getPageSize());
        
        // Set attributes for JSP
        request.setAttribute("salesList", salesList);
        request.setAttribute("totalSales", summary.get("totalSales"));
        request.setAttribute("orderCount", summary.get("orderCount"));
        request.setAttribute("avgOrderValue", summary.get("avgOrderValue"));
        request.setAttribute("currentPage", filter.getPage());
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("filter", filter);
        
        // Forward to JSP
        request.getRequestDispatcher("Sales.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ensure we only handle JSON
        if (!"application/json".equals(request.getContentType())) {
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE, 
                               "Content-Type must be application/json");
            return;
        }

        // Read the incoming JSON
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        // Parse JSON to find action and parameters
        JsonObject jsonReq = JsonParser.parseString(sb.toString()).getAsJsonObject();
        String action = jsonReq.has("action") ? jsonReq.get("action").getAsString() : "";
        
        if ("getOrderDetails".equals(action)) {
            int orderId = jsonReq.get("orderId").getAsInt();
            List<OrderDetailDTO> orderDetails = null;
			try {
				orderDetails = salesDAO.getOrderDetails(orderId);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

            // Serialize the list to JSON and respond
            String jsonResp = gson.toJson(orderDetails);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonResp);

        } else if ("exportReport".equals(action)) {
            // handle export…
            response.sendRedirect(request.getContextPath() + "/sales?exportSuccess=true");

        } else {
            // fallback to GET behavior if needed
            doGet(request, response);
        }
    }

    
    /**
     * Build a filter object from request parameters
     */
    private SalesReportFilter buildFilterFromRequest(HttpServletRequest request) {
        SalesReportFilter filter = new SalesReportFilter();
        
        // Get date parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                filter.setStartDate(dateFormat.parse(startDateStr));
            }
            
            if (endDateStr != null && !endDateStr.isEmpty()) {
                filter.setEndDate(dateFormat.parse(endDateStr));
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        // Get payment method filter
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            filter.setPaymentMethod(paymentMethod);
        }
        
        // Get pagination parameters
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                int page = Integer.parseInt(pageStr);
                if (page > 0) {
                    filter.setPage(page);
                }
            } catch (NumberFormatException e) {
                // Ignore and use default
            }
        }
        
        return filter;
    }
    
    /**
     * Simple method to convert a list of OrderDetailDTO to JSON
     * (In a real application, you'd use a library like Gson or Jackson)
     */
    private String convertToJson(List<OrderDetailDTO> orderDetails) {
        StringBuilder json = new StringBuilder("[");
        
        for (int i = 0; i < orderDetails.size(); i++) {
            OrderDetailDTO detail = orderDetails.get(i);
            
            if (i > 0) {
                json.append(",");
            }
            
            json.append("{");
            json.append("\"productName\":\"").append(detail.getProductName()).append("\",");
            json.append("\"size\":\"").append(detail.getSize()).append("\",");
            json.append("\"sweetness\":\"").append(detail.getSweetness()).append("\",");
            json.append("\"iceLevel\":\"").append(detail.getIceLevel()).append("\",");
            
            // Add toppings array
            json.append("\"toppings\":[");
            List<String> toppings = detail.getToppings();
            for (int j = 0; j < toppings.size(); j++) {
                if (j > 0) {
                    json.append(",");
                }
                json.append("\"").append(toppings.get(j)).append("\"");
            }
            json.append("],");
            
            json.append("\"price\":").append(detail.getPrice());
            json.append("}");
        }
        
        json.append("]");
        return json.toString();
    }
}