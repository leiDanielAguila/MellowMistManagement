package com.mellowmist.model;

import java.util.Date;
import java.math.BigDecimal;

public class SalesReportDTO {
    private int orderId;
    private Date orderDate;
    private Date orderTime;
    private String formattedOrderId;  // For displaying as 00001, 00002, etc.
    private BigDecimal totalAmount;
    private String paymentMethod;
    
    // Constructors
    public SalesReportDTO() {}
    
    public SalesReportDTO(int orderId, Date orderDate, Date orderTime, 
                         BigDecimal totalAmount, String paymentMethod) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.orderTime = orderTime;
        this.formattedOrderId = String.format("%05d", orderId);
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
    }
    
    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
        this.formattedOrderId = String.format("%05d", orderId);
    }
    
    public Date getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }
    
    public Date getOrderTime() {
        return orderTime;
    }
    
    public void setOrderTime(Date orderTime) {
        this.orderTime = orderTime;
    }
    
    public String getFormattedOrderId() {
        return formattedOrderId;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}