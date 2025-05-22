import java.time.LocalTime;
import java.time.LocalDate;

public class Order {
    private int orderId, userId, totalAmount;
    private LocalTime orderTime;
    private String paymentMethod, orderStatus;
    private LocalDate orderDate;

    public Order() {
        this.orderId = 0;
        this.userId = 0;
        this.totalAmount = 0;
        this.orderTime = LocalTime.now();
        this.paymentMethod = "";
        this.orderStatus = "";
        this.orderDate = LocalDate.now();
    }

    public Order(int orderId, int userId, int totalAmount, LocalTime orderTime, String paymentMethod, String orderStatus, LocalDate orderDate) {
        this.orderId = orderId;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.orderTime = orderTime;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
        this.orderDate = orderDate;
    }

    // Getters
    public int getOrderId() {
        return orderId;
    }

    public int getUserId() {
        return userId;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public LocalTime getOrderTime() {
        return orderTime;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getOrderStatus() {
        return orderStatus;
    }
    
    public LocalDate getOrderDate() {
    	return orderDate;
    }

    // Setters
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setOrderTime(LocalTime orderTime) {
        this.orderTime = orderTime;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }
    
    public void setLocalDate(LocalDate orderDate) {
    	this.orderDate = orderDate;
    }
}

