package com.mellowmist.model;

import java.util.Date;
import java.util.List;

public class Sales {
    private int orderId;
    private Date orderDate;
    private String orderTime;
    private String orderNo;
    private int totalPrice;
    private String paymentType;
    private List<OrderItem> items;

    // Inner class for order items
    public static class OrderItem {
        private String name;
        private String size;
        private String sweetness;
        private String iceLevel;
        private List<String> toppings;
        private int price;

        public OrderItem() {
        }

        public OrderItem(String name, String size, String sweetness, String iceLevel, List<String> toppings, int price) {
            this.name = name;
            this.size = size;
            this.sweetness = sweetness;
            this.iceLevel = iceLevel;
            this.toppings = toppings;
            this.price = price;
        }

        // Getters and setters
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getSize() {
            return size;
        }

        public void setSize(String size) {
            this.size = size;
        }

        public String getSweetness() {
            return sweetness;
        }

        public void setSweetness(String sweetness) {
            this.sweetness = sweetness;
        }

        public String getIceLevel() {
            return iceLevel;
        }

        public void setIceLevel(String iceLevel) {
            this.iceLevel = iceLevel;
        }

        public List<String> getToppings() {
            return toppings;
        }

        public void setToppings(List<String> toppings) {
            this.toppings = toppings;
        }

        public int getPrice() {
            return price;
        }

        public void setPrice(int price) {
            this.price = price;
        }
    }

    // Constructors
    public Sales() {
    }

    public Sales(int orderId, Date orderDate, String orderTime, String orderNo, int totalPrice, String paymentType) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.orderTime = orderTime;
        this.orderNo = orderNo;
        this.totalPrice = totalPrice;
        this.paymentType = paymentType;
    }

    // Getters and setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(String orderTime) {
        this.orderTime = orderTime;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
}