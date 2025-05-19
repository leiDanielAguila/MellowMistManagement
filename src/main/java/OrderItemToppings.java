
public class OrderItemToppings {
	private int orderItemId, toppingId, quantity;
	
	public OrderItemToppings() {
		orderItemId = 0;
		toppingId = 0;
		quantity = 0;
	}
	
	public OrderItemToppings(int orderItemId, int toppingId, int quantity) {
		this.orderItemId = orderItemId;
		this.toppingId = toppingId;
		this.quantity = quantity;
	}
	
	// getters 
	
	public int getOrderItemId() {
		return orderItemId;
	}
	
	public int getToppingId() {
		return toppingId;
	}
	
	public int getQuantity() {
		return quantity;
	}
	
	// setters
	
	public void setOrderItemId(int orderItemId) {
		this.orderItemId = orderItemId;
	}
	
	public void setToppingId(int toppingId) {
		this.toppingId = toppingId;
	}
	
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
}
