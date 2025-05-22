package com.mellowmist.model;

import java.math.BigDecimal;
import java.util.List;
import java.util.ArrayList;

public class OrderDetailDTO {
    private String productName;
    private String size;
    private String sweetness;
    private String iceLevel;
    private List<String> toppings;
    private BigDecimal price;
    private int quantity;
    
    // Constructors
    public OrderDetailDTO() {
        this.toppings = new ArrayList<>();
    }
    
    public OrderDetailDTO(String productName, String size, String sweetness, 
                         String iceLevel, BigDecimal price) {
        this.productName = productName;
        this.size = size;
        this.sweetness = sweetness;
        this.iceLevel = iceLevel;
        this.price = price;
        this.toppings = new ArrayList<>();
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getSize() {
        return size;
    }
    
    public void setSize(String size) {
        this.size = size;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public int getQuantity() {
        return quantity;
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
    
    public void addTopping(String topping) {
        this.toppings.add(topping);
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}