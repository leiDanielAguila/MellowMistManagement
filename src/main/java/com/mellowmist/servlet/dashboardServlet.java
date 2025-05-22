package com.mellowmist.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

import com.google.gson.Gson;
import com.mellowmist.dao.DashboardDAO;

/**
 * Servlet implementation class dashboardServlet
 */
@WebServlet("/dashboard")
public class dashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public dashboardServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // For AJAX requests to get chart data
        if ("getHourlySales".equals(action)) {
            String dateFilter = request.getParameter("date");
            DashboardDAO dao = new DashboardDAO();
            Map<String, Object> salesData = dao.getHourlySalesData(dateFilter);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(salesData));
            return;
        } 
        // For AJAX requests to get weekly data
        else if ("getWeeklySales".equals(action)) {
            DashboardDAO dao = new DashboardDAO();
            Map<String, Object> weeklyData = dao.getWeeklySalesData();
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(weeklyData));
            return;
        }
        // Regular page load
        else {
            DashboardDAO dao = new DashboardDAO();
            String salesToday = dao.getTotalSalesToday();
            int pendingOrders = dao.getPendingOrdersCount();
            int totalOrders = dao.getTotalOrdersCount();
            
            // Get initial chart data
            Map<String, Object> initialSalesData = dao.getHourlySalesData(null);
            
            request.setAttribute("salesToday", salesToday);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("initialHours", gson.toJson(initialSalesData.get("hours")));
            request.setAttribute("initialSalesData", gson.toJson(initialSalesData.get("salesData")));
            
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}