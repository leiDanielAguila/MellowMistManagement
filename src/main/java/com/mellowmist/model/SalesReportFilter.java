package com.mellowmist.model;

import java.util.Date;

public class SalesReportFilter {
    private Date startDate;
    private Date endDate;
    private String paymentMethod;
    private int page;
    private int pageSize;
    
    // Constructors
    public SalesReportFilter() {
        this.page = 1;
        this.pageSize = 10;
    }
    
    // Getters and Setters
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public int getPage() {
        return page;
    }
    
    public void setPage(int page) {
        this.page = page;
    }
    
    public int getPageSize() {
        return pageSize;
    }
    
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
}