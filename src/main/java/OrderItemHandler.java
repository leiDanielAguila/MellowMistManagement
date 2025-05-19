import java.util.ArrayList;
import java.util.List;

public class OrderItemHandler {
	public int mapFlavor(String flavor) {
		int x = 0;
		
		if (flavor.equals("classic")) {
			x = 1;
		}
		if (flavor.equals("taro")) {
			x = 2;
		}
		if (flavor.equals("matcha")) {
			x = 3;
		}
		if (flavor.equals("strawberry")) {
			x = 4;
		}
		if (flavor.equals("wintermelon")) {
			x = 5;
		}
	
		return x;
	}
	
	public int mapProductSize(String size, int productId) {
		int x = 0;
		
		if (size.equals("regular") && productId == 1) {
			x = 1;
		}
		if (size.equals("medium") && productId == 1) {
			x = 2;
		}
		if (size.equals("large") && productId == 1) {
			x = 3;
		}
		
		if (size.equals("regular") && (productId >= 2 && productId <= 5)) {
			x = 4;
		}
		
		if (size.equals("medium") && (productId >= 2 && productId <= 5)) {
			x = 5;
		}
		
		if (size.equals("large") && (productId >= 2 && productId <= 5)) {
			x = 6;
		}
				
		return x;
	}
	
//	public List<Integer> mapToppings(String[] toppings) {
//		List<Integer> toppingsId = new ArrayList<>();
//		
//		for (String topping : toppings) {
//			if (topping.equals("black-tapioca")) {
//				toppingsId.add(1);
//			} else if (topping.equals("cheesecake")) {
//				toppingsId.add(2);
//			} else if (topping.equals("grass-jelly")) {
//				toppingsId.add(3);
//			} else if (topping.equals("pudding")) {
//				toppingsId.add(4);
//			} else if (topping.equals("oreo")) {
//				toppingsId.add(5);
//			}
//		}		
//		return toppingsId;
//	}
	
	public List<Integer> mapToppings(String[] toppings) {
	    List<Integer> toppingIds = new ArrayList<>();
	    
	    // Handle null toppings array - return empty list if toppings is null
	    if (toppings == null || toppings.length == 0) {
	        return toppingIds; // Return empty list
	    }
	    
	    // Continue with your existing mapping logic
	    for (String topping : toppings) {
	        // Example mapping - replace with your actual mapping logic
	        switch (topping.toLowerCase()) {
	            case "black-tapioca":
	                toppingIds.add(1);
	                break;
	            case "cheesecake":
	                toppingIds.add(2);
	                break;
	            case "grass-jelly":
	                toppingIds.add(3);
	                break;
	            case "pudding":
	                toppingIds.add(4);
	                break;
	            case "oreo":
	                toppingIds.add(5);
	                break;
	            // Add more cases as needed
	            default:
	                // Handle unknown topping or use a default
	                break;
	        }
	    }
	    
	    return toppingIds;
	}
		
}
