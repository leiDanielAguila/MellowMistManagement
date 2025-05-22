package com.mellowmist.dao;

import com.mellowmist.model.SalesReportDTO;
import com.mellowmist.model.OrderDetailDTO;
import com.mellowmist.model.SalesReportFilter;
import com.mellowmist.util.DBConnection;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class SalesDAO {
    
    /**
     * Get sales report data with filtering and pagination
     */
    public List<SalesReportDTO> getSalesReport(SalesReportFilter filter) {
        List<SalesReportDTO> salesList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT order_id, order_date, order_time, total_amount, payment_method ");
            sql.append("FROM orders WHERE 1=1 ");
            
            List<Object> params = new ArrayList<>();
            
            // Add date filter conditions
            if (filter.getStartDate() != null) {
                sql.append("AND order_date >= ? ");
                params.add(new java.sql.Date(filter.getStartDate().getTime()));
            }
            
            if (filter.getEndDate() != null) {
                sql.append("AND order_date <= ? ");
                params.add(new java.sql.Date(filter.getEndDate().getTime()));
            }
            
            // Add payment method filter if specified
            if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().isEmpty()) {
                sql.append("AND payment_method = ? ");
                params.add(filter.getPaymentMethod());
            }
            
            // Order by date desc, time desc
            sql.append("ORDER BY order_date DESC, order_time DESC ");
            
            // Add pagination
            sql.append("LIMIT ? OFFSET ? ");
            params.add(filter.getPageSize());
            params.add((filter.getPage() - 1) * filter.getPageSize());
            
            pstmt = conn.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                SalesReportDTO sales = new SalesReportDTO();
                sales.setOrderId(rs.getInt("order_id"));
                sales.setOrderDate(rs.getDate("order_date"));
                sales.setOrderTime(rs.getTime("order_time"));
                sales.setTotalAmount(rs.getBigDecimal("total_amount"));
                sales.setPaymentMethod(rs.getString("payment_method"));
                
                salesList.add(sales);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException (e);
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return salesList;
    }
    
    /**
     * Get total count of sales for pagination
     */
    public int getTotalSalesCount(SalesReportFilter filter) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM orders WHERE 1=1 ");
            
            List<Object> params = new ArrayList<>();
            
            // Add date filter conditions
            if (filter.getStartDate() != null) {
                sql.append("AND order_date >= ? ");
                params.add(new java.sql.Date(filter.getStartDate().getTime()));
            }
            
            if (filter.getEndDate() != null) {
                sql.append("AND order_date <= ? ");
                params.add(new java.sql.Date(filter.getEndDate().getTime()));
            }
            
            // Add payment method filter if specified
            if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().isEmpty()) {
                sql.append("AND payment_method = ? ");
                params.add(filter.getPaymentMethod());
            }
            
            pstmt = conn.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Get sales summary data (total sales, order count, average order value)
     */
    public Map<String, Object> getSalesSummary(SalesReportFilter filter) {
        Map<String, Object> summary = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT SUM(total_amount) as total_sales, ");
            sql.append("COUNT(*) as order_count, ");
            sql.append("AVG(total_amount) as avg_order_value ");
            sql.append("FROM orders WHERE 1=1 ");
            
            List<Object> params = new ArrayList<>();
            
            // Add date filter conditions
            if (filter.getStartDate() != null) {
                sql.append("AND order_date >= ? ");
                params.add(new java.sql.Date(filter.getStartDate().getTime()));
            }
            
            if (filter.getEndDate() != null) {
                sql.append("AND order_date <= ? ");
                params.add(new java.sql.Date(filter.getEndDate().getTime()));
            }
            
            // Add payment method filter if specified
            if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().isEmpty()) {
                sql.append("AND payment_method = ? ");
                params.add(filter.getPaymentMethod());
            }
            
            pstmt = conn.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                summary.put("totalSales", rs.getBigDecimal("total_sales"));
                summary.put("orderCount", rs.getInt("order_count"));
                summary.put("avgOrderValue", rs.getBigDecimal("avg_order_value"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return summary;
    }
    
    /**
     * Get order details for a specific order ID
     */
    public List<OrderDetailDTO> getOrderDetails(int orderId) throws SQLException {
        // Map to preserve insertion order
        Map<Integer, OrderDetailDTO> orderItemMap = new LinkedHashMap<>();

        // 1️⃣ First query: fetch order items with quantity and price as BigDecimal
        String itemSql = 
            "SELECT oi.order_item_id, p.product_name, ps.product_size_name, " +
            "oi.quantity, oi.sugar_level, oi.ice_level, oi.price " +
            "FROM order_items oi " +
            "JOIN products p ON oi.product_id = p.product_id " +
            "JOIN product_size ps ON oi.product_size_id = ps.product_size_id " +
            "WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps1 = conn.prepareStatement(itemSql)) {

            ps1.setInt(1, orderId);
            try (ResultSet rs1 = ps1.executeQuery()) {
                while (rs1.next()) {
                    int orderItemId = rs1.getInt("order_item_id");
                    OrderDetailDTO detail = new OrderDetailDTO();

                    detail.setProductName(rs1.getString("product_name"));
                    detail.setSize(rs1.getString("product_size_name"));
                    detail.setQuantity(rs1.getInt("quantity"));                             // ← quantity
                    detail.setSweetness(convertSugarLevel(rs1.getInt("sugar_level")));
                    detail.setIceLevel(rs1.getString("ice_level"));
                    // price was INT in DB, convert to BigDecimal
                    detail.setPrice(BigDecimal.valueOf(rs1.getInt("price")));

                    // Initialize toppings list
                    detail.setToppings(new ArrayList<>());

                    orderItemMap.put(orderItemId, detail);
                }
            }

            // If no items, return empty list
            if (orderItemMap.isEmpty()) {
                return new ArrayList<>();
            }

            // 2️⃣ Build IN‑clause safely for toppings query
            StringBuilder inClause = new StringBuilder();
            for (Integer id : orderItemMap.keySet()) {
                if (inClause.length() > 0) inClause.append(",");
                inClause.append(id);
            }

            String toppingSql =
                "SELECT oit.order_item_id, t.topping_name " +
                "FROM order_item_toppings oit " +
                "JOIN toppings t ON oit.topping_id = t.topping_id " +
                "WHERE oit.order_item_id IN (" + inClause + ")";

            try (PreparedStatement ps2 = conn.prepareStatement(toppingSql);
                 ResultSet rs2 = ps2.executeQuery()) {
                while (rs2.next()) {
                    int orderItemId = rs2.getInt("order_item_id");
                    String toppingName = rs2.getString("topping_name");

                    OrderDetailDTO detail = orderItemMap.get(orderItemId);
                    if (detail != null) {
                        detail.getToppings().add(toppingName);
                    }
                }
            }
        }

        // 3️⃣ Return list preserving original order
        return new ArrayList<>(orderItemMap.values());
    }

    // Helper to convert sugar_level int to human‑readable form
    private String convertSugarLevel(int sugarLevel) {
        switch (sugarLevel) {
            case 0:  return "No Sugar";
            case 25: return "25%";
            case 50: return "50%";
            case 75: return "75%";
            case 100:return "100%";
            default: return sugarLevel + "%";
        }
    }
    
    /**
     * Helper method to convert sugar level integer to descriptive string
     */

    
    /**
     * Helper method to join collection of keys for SQL IN clause
     */
    private String joinKeys(Set<Integer> keys) {
        StringBuilder result = new StringBuilder();
        boolean first = true;
        
        for (Integer key : keys) {
            if (first) {
                first = false;
            } else {
                result.append(",");
            }
            result.append(key);
        }
        
        return result.toString();
    }
    
    /**
     * Close database resources
     */
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}