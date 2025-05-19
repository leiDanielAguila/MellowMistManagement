
public class OrderItems {
	private int orderItemId, orderId, productId, quantity, sugarLevel, price, productSizeId;
	private String iceLevel;
	
	public OrderItems() {
		this.orderItemId = 0;
		this.orderId = 0;
		this.productId = 0;
		this.quantity = 0;
		this.sugarLevel = 0;
		this.price = 0;
		this.productSizeId = 0;
		this.iceLevel = "";
	}
	
	public OrderItems(int orderItemId, int orderId, int productId, int quantity, int sugarLevel, int price, int productSizeId, String iceLevel) {
		this.orderItemId = orderItemId;
		this.orderId = orderId;
		this.productId = productId;
		this.quantity = quantity;
		this.sugarLevel = sugarLevel;
		this.price = price;
		this.productSizeId = productSizeId;
		this.iceLevel = iceLevel;
	}
	
	// getters
	
	public int getOrderItemId() {
		return orderItemId;
	}
	
	public int getOrderId() {
		return orderId;
	}
	
	public int getProductId() {
		return productId; 
	}
	
	public int getQuantity() {
		return quantity;
	}
	
	public int getSugarLevel() {
		return sugarLevel;
	}
	
	public int getPrice() {
		return price;
	}
	
	public int getProductSizeId() {
		return productSizeId;
	}
	
	public String getIceLevel() {
		return iceLevel;
	}
	
	// setters
	
	public void setOrderItemId(int orderItemId) {
		this.orderItemId = orderItemId;
	}
	
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	
	public void setProductId(int productId) {
		this.productId = productId;
	}
	
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public void setSugarLevel(int sugarLevel) {
		this.sugarLevel = sugarLevel;
	}
	
	public void setPrice(int price) {
		this.price = price;
	}
	
	public void setProductSizeId(int productSizeId) {
		this.productSizeId = productSizeId;
	}
	
	public void setIceLevel(String iceLevel) {
		this.iceLevel = iceLevel;
	}
	
}
