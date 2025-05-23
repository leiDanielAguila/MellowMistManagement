<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
  <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@300;400&display=swap" rel="stylesheet">
    <script
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js">
	</script>
	
    <style>
        #sidenav {
            background-color: #bd9b61;
        }
        #topnav {
            background-color: #efe5bd;
        }
        #dashboardcontentcards {
            background-color: #efe5bd;
        }
        body {
            background-color: #f0ead2;
        }
         /* Using Bricolage Grotesque as the main font */
    body {
      font-family: 'Bricolage Grotesque', sans-serif;
    }
    
    h1, h2, h3 {
      font-family: 'Bricolage Grotesque', sans-serif;
    }
    
    /* Example usage with different weights */
    .light-text {
      font-weight: 300;
    }
    
    .regular-text {
      font-weight: 400;
    }
      /* Hide number input arrows */
  input[type=number]::-webkit-inner-spin-button,
  input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
  input[type=number] {
    -moz-appearance: textfield;
  }
    </style>
    <title>Customer Order</title>
</head>
<body class="overflow-hidden">
    <div class="flex h-screen">
        <!-- Sidenav -->
        <div id="sidenav" class="w-80 h-screen flex-shrink-0 px-6 text-white p-4">
            <!-- Sidenav content here -->
            <div class="flex justify-start space-x-4 w-full items-start px-8 py-5">
            	<img src="img/logo.png" class="w-15 h-15">
            	<h5 class="text-lg text-black text-center mt-2">Mellow Mist <br> Management</h5>
            </div>
            <hr class="border-t-1 border-black mb-4 mt-3">
            <ul class="space-y-4">
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="dashboard" class="flex items-center">
                		<img src="img/speedometer.png" class="w-7 h-7 mr-3"><span>Dashboard</span>
                	</a>
                </li>
                <li class="p-2 bg-[#efe5bd] text-black rounded-xl flex items-center">
                	<a href="CustomerOrder.jsp" class="flex items-center">
                		<img src="img/shopping-basket.png" class="w-7 h-7 mr-3"><span>Orders</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="OrderQueue" class="flex items-center">
                		<img src="img/document.png" class="w-7 h-7 mr-3"><span>Queue</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="Inventory.jsp" class="flex items-center">
                		<img src="img/delivery-box.png" class="w-7 h-7 mr-3"><span>Inventory</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="SalesServlet" class="flex items-center">
                		<img src="img/increase.png" class="w-7 h-7 mr-3"><span>Sales</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="Users.jsp" class="flex items-center">
                		<img src="img/search-profile.png" class="w-7 h-7 mr-3"><span>Manage Users</span>
                	</a>
                </li>
                <div class="mt-50 pt-8">
                   <hr class="border-t-1 border-black mb-4">
                   <button id="logoutBtn" class="w-full p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded-xl flex cursor-pointer items-center justify-center">
                       <img src="img/logout.png" class="w-7 h-7 mr-3">
                       <span>Logout</span>
                   </button>
               </div>
            </ul>
        </div>
        
         <%
	    String username = (String) session.getAttribute("username");
	    if (username == null) {
	        username = "none";
	        return;
	    }
	%>
        
        <!-- Main content area -->
        <div class="flex flex-col flex-grow">
            <!-- Topnav -->
            <div id="topnav" class="w-full h-32 shadow-md flex items-center p-6">
                <!-- Topnav content here -->
                <div class=" flex items-center ml-auto">                	
                	<div class="w-[2px] h-22 bg-black rounded-xl mr-6"></div>
                	<h1 class="text-l font-bold mr-3">Welcome, <%= username %>!</h1> 
                	<img src="img/admin.png" class="w-10 h-10 ml-3 mr-3">
                </div>            
            </div>
            
            <!-- Dashboard content -->
            <div id="dashboardcontent" class="p-6 overflow-auto h-full">
                <!-- Dashboard content here -->
                <div>
                    <h2 class="text-[30px] mb-4">Orders</h2>               
                </div>
                 <!-- Flavor Section -->
                <div>
                    <h2 class="text-[24px] mb-4">Choose Flavor</h2>
                    <hr class="border-t border-black-300 mb-4" />               
                </div>
             
                
			<!-- Single Form for All Selections -->
			<form id="orderForm" class="flex flex-wrap gap-6" action="CustomerOrder" method="post">
			  <!-- Flavor Section -->
			  <div class="w-full">
			    <div class="flex flex-wrap gap-6">
			      <!-- Classic Milk Tea -->
			      <div class="relative group">
			        <input type="radio" id="classic" name="flavor" value="classic" class="peer hidden"/>
			        <label for="classic" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/flavor-classic.png" alt="Classic Milk Tea" class="w-30 h-30 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[16px] mb-1">Classic Milk Tea</span>
			          <span class="text-gray-600 mb-5">R ₱100 M ₱110 L ₱120</span>
			        </label>
			      </div>
			      
			      <!-- Other flavors... same pattern -->
			      <div class="relative group">
			        <input type="radio" id="taro" name="flavor" value="taro" class="peer hidden" />
			        <label for="taro" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/flavor-taro.png" alt="Taro Milk Tea" class="w-30 h-30 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[16px] mb-1">Taro Milk Tea</span>
			          <span class="text-gray-600 mb-5">R ₱110 M ₱120 L ₱130</span>
			        </label>
			      </div>
			      
			      <!-- Matcha Milk Tea -->
			      <div class="relative group">
			        <input type="radio" id="matcha" name="flavor" value="matcha" class="peer hidden" />
			        <label for="matcha" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/flavor-matcha.png" alt="Matcha Milk Tea" class="w-30 h-30 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[16px] mb-1">Matcha Milk Tea</span>
			          <span class="text-gray-600 mb-5">R ₱110 M ₱120 L ₱130</span>
			        </label>
			      </div>
			      
			      <!-- Strawberry Milk Tea -->
			      <div class="relative group">
			        <input type="radio" id="strawberry" name="flavor" value="strawberry" class="peer hidden" />
			        <label for="strawberry" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/flavor-strawberry.png" alt="Strawberry Milk Tea" class="w-30 h-30 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[16px] mb-1">Strawberry Milk Tea</span>
			          <span class="text-gray-600 mb-5">R ₱110 M ₱120 L ₱130</span>
			        </label>
			      </div>
			      
			      <!-- Wintermelon Milk Tea -->
			      <div class="relative group">
			        <input type="radio" id="wintermelon" name="flavor" value="wintermelon" class="peer hidden" />
			        <label for="wintermelon" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/flavor-wintermelon.png" alt="Wintermelon Milk Tea" class="w-30 h-30 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[16px] mb-1">Wintermelon Milk Tea</span>
			          <span class="text-gray-600 mb-5">R ₱110 M ₱120 L ₱130</span>
			        </label>
			      </div>
			    </div>
			  </div>
			  			
			  <!-- Size Section -->
			  <div class="w-full">
			    <h2 class="text-[24px] mt-10 mb-4">Choose Size</h2>
			    <hr class="border-t border-black-300 mb-4" />
			    <div class="flex flex-wrap gap-6">
			      <!-- Regular Size -->
			      <div class="relative group">
			        <input type="radio" id="regular" name="size" value="regular" class="peer hidden" />
			        <label for="regular" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/size-regular.png" alt="Regular Size" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mb-1">Regular</span>
			          <span class="text-gray-600 mb-5">16 oz.</span>
			        </label>
			      </div>
			      
			      <!-- Medium Size -->
			      <div class="relative group">
			        <input type="radio" id="medium" name="size" value="medium" class="peer hidden" />
			        <label for="medium" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/size-medium.png" alt="Medium Size" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mb-1">Medium</span>
			          <span class="text-gray-600 mb-5">20 oz.</span>
			        </label>
			      </div>
			      
			      <!-- Large Size -->
			      <div class="relative group">
			        <input type="radio" id="large" name="size" value="large" class="peer hidden" />
			        <label for="large" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/size-large.png" alt="Large Size" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mb-1">Large</span>
			          <span class="text-gray-600 mb-5">22 oz.</span>
			        </label>
			      </div>
			    </div>
			  </div>
			
			  <!-- Ice Level Section -->
			  <div class="w-full">
			    <h2 class="text-[24px] mt-10 mb-4">Choose Ice Level</h2>
			    <hr class="border-t border-black-300 mb-4" />
			    <div class="flex flex-wrap gap-6">
			      <!-- Normal Ice -->
			      <div class="relative group">
			        <input type="radio" id="ice-normal" name="ice" value="normal" class="peer hidden" />
			        <label for="ice-normal" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/ice-normal.png" alt="Normal Ice" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Normal Ice</span>
			        </label>
			      </div>
			      
			      <!-- Less Ice -->
			      <div class="relative group">
			        <input type="radio" id="ice-less" name="ice" value="less" class="peer hidden" />
			        <label for="ice-less" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/ice-less.png" alt="Less Ice" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Less Ice</span>
			        </label>
			      </div>
			      
			      <!-- Little Ice -->
			      <div class="relative group">
			        <input type="radio" id="ice-little" name="ice" value="little" class="peer hidden" />
			        <label for="ice-little" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/ice-little.png" alt="Little Ice" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Little Ice</span>
			        </label>
			      </div>
			      
			      <!-- No Ice -->
			      <div class="relative group">
			        <input type="radio" id="ice-no" name="ice" value="no" class="peer hidden" />
			        <label for="ice-no" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/ice-no.png" alt="No Ice" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">No Ice</span>
			        </label>
			      </div>
			    </div>
			  </div>
			  
			  <!-- Sweetness Level Section -->
			  <div class="w-full">
			    <h2 class="text-[24px] mt-10 mb-4">Choose Sweetness Level</h2>
			    <hr class="border-t border-black-300 mb-4" />
			    <div class="flex flex-wrap gap-6">
			      <!-- 100% Sugar -->
			      <div class="relative group">
			        <input type="radio" id="sugar-100" name="sugar" value="100" class="peer hidden" />
			        <label for="sugar-100" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/sugar-100.png" alt="100% Sugar" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-2">100%</span>
			        </label>
			      </div>
			      
			      <!-- 75% Sugar -->
			      <div class="relative group">
			        <input type="radio" id="sugar-75" name="sugar" value="75" class="peer hidden" />
			        <label for="sugar-75" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/sugar-75.png" alt="75% Sugar" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-2">75%</span>
			        </label>
			      </div>
			      
			      <!-- 50% Sugar -->
			      <div class="relative group">
			        <input type="radio" id="sugar-50" name="sugar" value="50" class="peer hidden" />
			        <label for="sugar-50" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/sugar-50.png" alt="50% Sugar" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-2">50%</span>
			        </label>
			      </div>
			      
			      <!-- 25% Sugar -->
			      <div class="relative group">
			        <input type="radio" id="sugar-25" name="sugar" value="25" class="peer hidden" />
			        <label for="sugar-25" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/sugar-25.png" alt="25% Sugar" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-2">25%</span>
			        </label>
			      </div>
			    </div>
			  </div>
			  
			  <!-- Toppings Section -->
			  <div class="w-full">
			    <h2 class="text-[24px] mt-10 mb-4">Choose Toppings</h2>
			    <hr class="border-t border-black-300 mb-4" />
			    <div class="flex flex-wrap gap-6">
			      <!-- Black Tapioca -->
			      <div class="relative group">
			        <input type="checkbox" id="topping-tapioca" name="toppings" value="black-tapioca" class="peer hidden" />
			        <label for="topping-tapioca" class="cursor-pointer rounded-2xl p-4 hover:bg-[#efe5bd] pb-8 bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/topping-tapioca.png" alt="Black Tapioca" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Black Tapioca</span>
			          <span class="text-gray-600 mb-5">₱20</span>
			        </label>
			      </div>
			      
			      <!-- Cheesecake -->
			      <div class="relative group">
			        <input type="checkbox" id="topping-cheesecake" name="toppings" value="cheesecake" class="peer hidden" />
			        <label for="topping-cheesecake" class="cursor-pointer rounded-2xl p-4 hover:bg-[#efe5bd] pb-8 bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/topping-cheesecake.png" alt="Cheesecake" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Cheesecake</span>
			          <span class="text-gray-600 mb-5">₱20</span>
			        </label>
			      </div>
			      
			      <!-- Grass Jelly -->
			      <div class="relative group">
			        <input type="checkbox" id="topping-grass-jelly" name="toppings" value="grass-jelly" class="peer hidden" />
			        <label for="topping-grass-jelly" class="cursor-pointer rounded-2xl p-4 hover:bg-[#efe5bd] pb-8 bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/topping-grassjelly.png" alt="Grass Jelly" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Grass Jelly</span>
			          <span class="text-gray-600 mb-5">₱20</span>
			        </label>
			      </div>
			      
			      <!-- Pudding -->
			      <div class="relative group">
			        <input type="checkbox" id="topping-pudding" name="toppings" value="pudding" class="peer hidden" />
			        <label for="topping-pudding" class="cursor-pointer rounded-2xl p-4 hover:bg-[#efe5bd] pb-8 bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/topping-pudding.png" alt="Pudding" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Pudding</span>
			          <span class="text-gray-600 mb-5">₱20</span>
			        </label>
			      </div>
			      
			      <!-- Oreo -->
			      <div class="relative group">
			        <input type="checkbox" id="topping-oreo" name="toppings" value="oreo" class="peer hidden" />
			        <label for="topping-oreo" class="cursor-pointer rounded-2xl p-4 hover:bg-[#efe5bd] pb-8 bg-[#e4dbc6] flex flex-col items-center w-55 h-55 peer-checked:bg-[#efe5bd] transition-all hover:scale-[1.02] active:scale-[0.98] duration-200">
			          <img src="img/topping-oreo.png" alt="Oreo" class="w-27 h-27 mb-2 transition-transform duration-200 group-hover:scale-110" />
			          <span class="text-[20px] mt-5">Oreo</span>
			          <span class="text-gray-600 mb-5">₱20</span>
			        </label>
			      </div>
			    </div>
			  </div>
			  
			  <!-- Quantity Section -->
			  <div class="w-full">
			    <h2 class="text-[24px] mt-10 mb-4">Quantity</h2>
			    <hr class="border-t border-black-300 mb-4" />
			    <div class="mb-6">
			      <div class="flex items-center bg-[#e4dbc6] rounded-full w-fit px-4 py-2">
			        <button type="button" onclick="decreaseQuantity()" class="text-2xl px-3 font-bold hover:bg-[#efe5bd] rounded-full cursor-pointer transition-colors">−</button>
			        <input type="number" name="quantity" id="quantity" min="1" value="1" 
			               class="w-12 rounded-2xl text-center bg-transparent focus:outline-none text-[24px] font-medium appearance-none transition-colors focus:bg-[#efe5bd] hover:bg-[#efe5bd]" />
			        <button type="button" onclick="increaseQuantity()" class="text-2xl px-3 font-bold hover:bg-[#efe5bd] rounded-full cursor-pointer transition-colors">+</button>
			      </div>
			    </div>
			  </div>
			  
			  <!-- Total and Submit Section -->
			  <div class="w-full">			
			    <button type="submit" 
			            class="flex items-center justify-center gap-2 bg-[#e4dbc6] hover:bg-[#f3e8c8] rounded-full px-6 py-3 w-full sm:w-fit transition-colors duration-200 cursor-pointer group">
			      <!-- Shopping Cart Icon (using Heroicons) -->
			      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" 
			           class="w-6 h-6 group-hover:scale-130 transition-transform">
			        <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" />
			      </svg>
			      <span class="text-[20px] font-medium">Add to Cart</span>
			    </button>
			  </div>
			</form>
			
			
			<!-- Add this near the top of your form, perhaps after the "Orders" title -->
			<div class="flex justify-between items-center mb-4">
			  <h2 class="text-[30px]">Orders</h2>
			  <button onclick="showCartModal()" class="flex items-center justify-center gap-2 bg-[#e4dbc6] hover:bg-[#f3e8c8] rounded-full px-4 py-2 transition-colors duration-200 cursor-pointer">
			    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
			      <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" />
			    </svg>
			    <span class="font-medium">View Cart</span>
			    <span class="bg-[#bd9b61] text-white rounded-full w-6 h-6 flex items-center justify-center ml-1">
			      <%= session.getAttribute("cartItems") != null ? ((List)session.getAttribute("cartItems")).size() : "0" %>
			    </span>
			  </button>
			</div>     
            </div>
        </div>
    </div>
		<!-- Updated Cart Modal HTML with Remove Buttons -->
<div id="cartModal" class="fixed inset-0 flex items-center justify-center p-4 invisible opacity-0 transition-all duration-300 ease-out"
    style="background-color: rgba(0, 0, 0, 0.15)">
    <div class="bg-[#f0ead2] rounded-2xl p-8 max-w-md w-full mx-4 shadow-lg relative z-50 transform transition-all duration-300 scale-95 opacity-0">
        <h2 class="text-[24px] font-bold mb-6 text-center">Shopping Cart</h2>

        <div id="cartItems" class="max-h-64 overflow-y-auto mb-4">
            <!-- This is where cart items will be displayed -->
            <%
            if(session.getAttribute("cartItems") != null) {
                java.util.List<java.util.Map<String, Object>> cartItems = 
                    (java.util.List<java.util.Map<String, Object>>) session.getAttribute("cartItems");

                for(int i = 0; i < cartItems.size(); i++) {
                    java.util.Map<String, Object> item = cartItems.get(i);
            %>
            <div class="p-3 mb-3 bg-[#e4dbc6] rounded-lg relative">
                <div class="flex justify-between mb-1">
                    <span class="font-medium"><%= item.get("flavor") %> - <%= item.get("size") %></span>
                    <span class="font-medium">₱<%= item.get("price") %></span>
                </div>
                <div class="text-sm">
                    <div><%= item.get("ice") %> ice, <%= item.get("sugar") %>% sugar</div>
                    <% if(item.get("toppings") != null && !String.valueOf(item.get("toppings")).isEmpty()) { %>
                    <div>Toppings: <%= item.get("toppings") %></div>
                    <% } %>
                    <div>Qty: <%= item.get("quantity") %></div>
                </div>
                <a href="CustomerOrder?removeItem=<%= i %>" 
                   class="absolute right-2 bottom-2 text-sm text-red-600 hover:text-red-800 font-medium">
                    Remove
                </a>
            </div>
            <%
                }
            } else {
            %>
            <div class="text-center py-4 text-gray-500">Your cart is empty</div>
            <% } %>
        </div>

        <div class="flex flex-col gap-4">
            <button onclick="closeModal()"
                class="bg-[#efe5bd] hover:bg-[#e4dbc6] text-gray-800 py-3 rounded-full transition-colors duration-200 font-medium cursor-pointer">
                Continue Shopping
            </button>
            <form action="Payment" method="post">
                <button type="submit"
                    class="bg-[#f8d88b] hover:bg-[#ecd075] text-gray-800 py-3 rounded-full transition-colors duration-200 font-medium cursor-pointer w-full"
                    <%= session.getAttribute("cartItems") == null || ((java.util.List<?>)session.getAttribute("cartItems")).isEmpty() ? "disabled" : "" %>>
                    Proceed to Checkout
                </button>
            </form>
        </div>
    </div>
</div>		
<div id="logoutConfirmModal" class="modal">
   <div class="modal-content" style="max-width: 400px;">
       <span class="close-btn" data-modal="logoutConfirmModal">&times;</span>
       <h3 class="text-xl font-semibold mb-4">Confirm Logout?</h3>
       <div class="mt-6 flex justify-center">
           <button type="button" class="action-btn mr-3" data-close="logoutConfirmModal">No</button>
           <button type="button" class="action-btn btn-primary" id="confirmLogoutBtn">Yes</button>
       </div>
   </div>
</div>
		<script>
		  function decreaseQuantity() {
		    const input = document.getElementById('quantity');
		    if (parseInt(input.value) > 1) input.value = parseInt(input.value) - 1;
		  }
		
		  function increaseQuantity() {
		    const input = document.getElementById('quantity');
		    input.value = parseInt(input.value) + 1;
		  }
		//Add this script to handle modal
		  function showCartModal() {
		    const modal = document.getElementById('cartModal');
		    const modalContent = modal.querySelector('div');
		    modal.classList.remove('invisible', 'opacity-0');
		    modalContent.classList.remove('scale-95', 'opacity-0');
		  }
		
		  function closeModal() {
			    const modal = document.getElementById('cartModal');
			    const modalContent = modal.querySelector('div');
			    modal.classList.add('opacity-0');
			    modalContent.classList.add('scale-95', 'opacity-0');
			    // Wait for animation to finish before hiding completely
			    setTimeout(() => {
			      modal.classList.add('invisible');
			    }, 300);
			  }
		  document.addEventListener('DOMContentLoaded', function() {
		    <% if(request.getAttribute("selectedFlavor") != null) { %>
		        showCartModal();
		    <% } %>
			});
		// Logout functionality
          const logoutBtn = document.getElementById('logoutBtn');
          const logoutConfirmModal = document.getElementById('logoutConfirmModal');
          const confirmLogoutBtn = document.getElementById('confirmLogoutBtn');
          const cancelLogoutBtn = document.getElementById('cancelLogoutBtn');
          const closeLogoutModal = document.getElementById('closeLogoutModal');
          const logoutForm = document.getElementById('logoutForm');
         
          // Show logout confirmation modal when clicking logout button
          logoutBtn.addEventListener('click', function() {
              logoutConfirmModal.style.display = 'block';
          });
         
          // Handle confirmed logout
          confirmLogoutBtn.addEventListener('click', function() {
              // Update the form action to the correct servlet path
              logoutForm.action = '${pageContext.request.contextPath}/LogoutServlet';
              logoutForm.submit();
          });
         
          // Close logout modal when clicking No or X
          cancelLogoutBtn.addEventListener('click', function() {
              logoutConfirmModal.style.display = 'none';
          });
         
          closeLogoutModal.addEventListener('click', function() {
              logoutConfirmModal.style.display = 'none';
          });
         
          // Close logout modal when clicking outside of it
          window.addEventListener('click', function(event) {
              if (event.target === logoutConfirmModal) {
                  logoutConfirmModal.style.display = 'none';
              }
          });
		  
		</script>
</body>
</html>