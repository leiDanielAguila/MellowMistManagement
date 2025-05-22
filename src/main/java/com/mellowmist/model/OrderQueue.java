package com.mellowmist.model;

public class OrderQueue {
    private int queueId;
    private int orderId;
    private String queueStatus;
    private int queueNumber;
    private int totalAmount; // Added field for total amount
    
    public OrderQueue() {
        // Default constructor
    }
    
    // Getters and setters
    public int getQueueId() {
        return queueId;
    }
    
    public void setQueueId(int queueId) {
        this.queueId = queueId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public String getQueueStatus() {
        return queueStatus;
    }
    
    public void setQueueStatus(String queueStatus) {
        this.queueStatus = queueStatus;
    }
    
    public int getQueueNumber() {
        return queueNumber;
    }
    
    public void setQueueNumber(int queueNumber) {
        this.queueNumber = queueNumber;
    }
    
    // New getter and setter for totalAmount
    public int getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }
}