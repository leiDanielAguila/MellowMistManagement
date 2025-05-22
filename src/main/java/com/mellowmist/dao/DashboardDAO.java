package com.mellowmist.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mellowmist.util.DBConnection;

public class DashboardDAO {
    public String getTotalSalesToday() {
        String sql = "SELECT SUM(total_amount) AS sales_today FROM orders WHERE order_date = ?";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int total = rs.getInt("sales_today");
                return "P" + total;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "P0";
    }

    public int getPendingOrdersCount() {
        String sql = "SELECT COUNT(*) AS pending_orders FROM queue WHERE queue_status = 'pending'";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("pending_orders");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) AS total_orders FROM orders";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_orders");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // New method to get hourly sales data for chart
    public Map<String, Object> getHourlySalesData(String dateFilter) {
        Map<String, Object> result = new HashMap<>();
        List<String> hours = new ArrayList<>();
        List<Integer> salesData = new ArrayList<>();
        
        // Default to today if no filter provided
        LocalDate filterDate = (dateFilter != null && !dateFilter.isEmpty()) 
            ? LocalDate.parse(dateFilter) 
            : LocalDate.now();
            
        String sql = "SELECT HOUR(order_time) as hour, SUM(total_amount) as hourly_sales " +
                    "FROM orders " +
                    "WHERE order_date = ? " +
                    "GROUP BY HOUR(order_time) " +
                    "ORDER BY hour";
                    
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, java.sql.Date.valueOf(filterDate));
            ResultSet rs = stmt.executeQuery();
            
            // Process the result set
            while (rs.next()) {
                int hour = rs.getInt("hour");
                int sales = rs.getInt("hourly_sales");
                
                // Format hour for display (e.g., "11 AM", "1 PM")
                String formattedHour = formatHour(hour);
                hours.add(formattedHour);
                salesData.add(sales);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        result.put("hours", hours);
        result.put("salesData", salesData);
        return result;
    }
    
    // Helper method to format hour values for display
    private String formatHour(int hour) {
        if (hour == 0) return "12 AM";
        if (hour < 12) return hour + " AM";
        if (hour == 12) return "12 PM";
        return (hour - 12) + " PM";
    }
    
    // Get daily sales data for the past week
    public Map<String, Object> getWeeklySalesData() {
        Map<String, Object> result = new HashMap<>();
        List<String> dates = new ArrayList<>();
        List<Integer> salesData = new ArrayList<>();
        
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(6);
        
        String sql = "SELECT order_date, SUM(total_amount) as daily_sales " +
                    "FROM orders " +
                    "WHERE order_date BETWEEN ? AND ? " +
                    "GROUP BY order_date " +
                    "ORDER BY order_date";
                    
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, java.sql.Date.valueOf(startDate));
            stmt.setDate(2, java.sql.Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            // Create a map to hold the results
            Map<LocalDate, Integer> salesByDate = new HashMap<>();
            
            // Initialize with all dates in range (including those with zero sales)
            for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                salesByDate.put(date, 0);
            }
            
            // Fill in actual sales data
            while (rs.next()) {
                LocalDate date = rs.getDate("order_date").toLocalDate();
                int sales = rs.getInt("daily_sales");
                salesByDate.put(date, sales);
            }
            
            // Convert map to lists for the result
            for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                dates.add(date.toString());
                salesData.add(salesByDate.get(date));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        result.put("dates", dates);
        result.put("salesData", salesData);
        return result;
    }
}