package com.mellowmist.model;

/**
 * Model class representing an inventory item
 */
public class Inventory {
    private int inventoryId;
    private String itemName;
    private int categoryId;
    private String categoryName;
    private String unit;
    private int quantity;
    private int reorderLevel;
    private String status;

    // Default constructor
    public Inventory() {
    }

    // Constructor with parameters
    public Inventory(int inventoryId, String itemName, int categoryId, String categoryName, 
                     String unit, int quantity, int reorderLevel, String status) {
        this.inventoryId = inventoryId;
        this.itemName = itemName;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.unit = unit;
        this.quantity = quantity;
        this.reorderLevel = reorderLevel;
        this.status = status;
    }

    // Getters and setters
    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        // Update status based on quantity and reorder level
        updateStatus();
    }

    public int getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = reorderLevel;
        // Update status based on quantity and reorder level
        updateStatus();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    // Method to update status based on quantity and reorder level
    private void updateStatus() {
        if (quantity <= 0) {
            this.status = "Out of Stock";
        } else if (quantity <= reorderLevel) {
            this.status = "Low Stock";
        } else {
            this.status = "In Stock";
        }
    }

    @Override
    public String toString() {
        return "Inventory{" +
                "inventoryId=" + inventoryId +
                ", itemName='" + itemName + '\'' +
                ", categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", unit='" + unit + '\'' +
                ", quantity=" + quantity +
                ", reorderLevel=" + reorderLevel +
                ", status='" + status + '\'' +
                '}';
    }
}