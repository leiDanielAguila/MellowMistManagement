
public class OrderItemToppings {
	private int orderItemId, toppingId;
	
	public OrderItemToppings() {
		orderItemId = 0;
		toppingId = 0;
	}
	
	public OrderItemToppings(int orderItemId, int toppingId) {
		this.orderItemId = orderItemId;
		this.toppingId = toppingId;
	}
	
	// getters 
	
	public int getOrderItemId() {
		return orderItemId;
	}
	
	public int getToppingId() {
		return toppingId;
	}
	
	
	// setters
	
	public void setOrderItemId(int orderItemId) {
		this.orderItemId = orderItemId;
	}
	
	public void setToppingId(int toppingId) {
		this.toppingId = toppingId;
	}
	
}
