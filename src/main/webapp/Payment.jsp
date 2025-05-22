<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@300;400&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
    
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
        
        /* Selected payment method */
        .payment-option input:checked + label {
            background-color: #efe5bd;
            border: 2px solid #bd9b61;
        }
    </style>
    <title>Payment | Mellow Mist</title>
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
                	<a href="SalesServelet" class="flex items-center">
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
                <!-- Payment section -->
                <div>
                    <h2 class="text-[30px] mb-4">Payment</h2>               
                </div>
                
                <!-- Display any payment errors if they exist -->
                <% if(request.getAttribute("paymentError") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("paymentError") %></span>
                </div>
                <% } %>
                
                <!-- Payment Form that posts to the servlet -->
                <form action="Payment" method="post" id="paymentForm">
                    <input type="hidden" name="processPayment" value="true" />
                
                    <!-- Review Order Section -->
                    <div>
                        <h2 class="text-[24px] mb-4">Review Order</h2>
                        <hr class="border-t border-black-300 mb-4" />               
                    </div>
                    
                    <!-- Order Table -->
                    <div class="mb-6">
                        <div class="flex flex-col">
                            <!-- Header Row - Now with 5 columns -->
                            <div class="flex flex-row text-[18px] font-semibold mb-2">
                                <div class="w-1/4">Flavor</div>
                                <div class="w-1/3">Details</div>
                                <div class="w-1/6">Quantity</div>
                                <div class="w-1/6">Price</div>
                                
                            </div>
                            
                            <!-- Order Item -->
                            <%
                                List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");
                                Integer cartTotal = (Integer) session.getAttribute("cartTotal"); // Now using Integer
                            %>
                            <!-- Order Item -->
                            <%
                                if (cartItems != null && !cartItems.isEmpty()) {
                                    for (Map<String, Object> item : cartItems) {
                                        String flavor = (String) item.get("flavor");
                                        String size = (String) item.get("size");
                                        String ice = (String) item.get("ice");
                                        String sweetness = (String) item.get("sugar");
                                        String toppings = (String) item.get("toppings");
                                        int quantity = (Integer) item.get("quantity");
                                        int price = (Integer) item.get("price");
                                        String image = (String) item.get("image"); // e.g., "img/flavor-strawberry.png"
                            %>												
                            <div class="flex flex-row items-start rounded-lg p-4 mb-4">
                                <div class="w-1/4 flex items-start">
                                    <div class="relative group">
                                        <div class="rounded-2xl p-4 pb-8 bg-[#e4dbc6] flex flex-col items-center w-40 h-40">
                                            <img src="<%= image %>"  class="w-20 h-20 mb-2" />
                                            <span class="text-[12px] mb-1"><%= flavor %></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="w-1/3">
                                    <p class="text-[16px]">Size: <%= size %></p>
                                    <p class="text-[16px]">Ice Level: <%= ice %></p>
                                    <p class="text-[16px]">Sweetness Level: <%= sweetness %>%</p>
                                    <p class="text-[16px]">Toppings: <%= toppings %></p>
                                </div>
                                <div class="w-1/6 text-start">
                                    <span class="text-[18px]"><%= quantity %></span>
                                </div>
                                <div class="w-1/6 text-start">
                                    <span class="text-[18px]"><%= price %></span>
                                </div> 
                                                                                       
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <div class="text-center text-gray-600 text-lg">Your cart is empty.</div>
                            <%
                                }
                            %>

                            
                            <!-- Horizontal line before total -->
                            <hr class="border-t border-black-300 mb-4" />
                            
                            <!-- Total Price -->
                            <div class="flex justify-end items-center mb-8 pr-4">
                                <div class="text-[20px] font-semibold mr-4">Total Price:</div>
                                <div class="text-[20px] font-bold"><%= (cartTotal != null) ? "₱" + cartTotal : "₱0" %></div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Choose Payment Method Section -->
                    <div>
                        <h2 class="text-[24px] mb-4">Choose Payment Method</h2>
                        <hr class="border-t border-black-300 mb-4" />               
                    </div>
                    
                    <!-- Payment Options with PNG images -->
                    <div class="flex flex-wrap gap-6 mb-8">
                        <!-- Cash -->
                        <div class="payment-option">
                            <input type="radio" id="cash" name="payment" value="Cash" class="hidden peer" checked>
                            <label for="cash" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-40 h-40 peer-checked:bg-[#efe5bd] transition-all hover:scale-105 active:scale-95 duration-200">
                                <div class="w-28 h-28 flex items-center justify-center">
                                    <img src="img/payment-cash.png" alt="Cash Payment" class="w-16 h-16">
                                </div>
                                <span class="text-[20px] font-medium">Cash</span>
                            </label>
                        </div>
                        
                        <!-- Card -->
                        <div class="payment-option">
                            <input type="radio" id="card" name="payment" value="Card" class="hidden peer">
                            <label for="card" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-40 h-40 peer-checked:bg-[#efe5bd] transition-all hover:scale-105 active:scale-95 duration-200">
                                <div class="w-28 h-28 flex items-center justify-center">
                                    <img src="img/payment-card.png" alt="Card Payment" class="w-16 h-16">
                                </div>
                                <span class="text-[20px] font-medium">Card</span>
                            </label>
                        </div>
                        
                        <!-- E-wallet -->
                        <div class="payment-option">
                            <input type="radio" id="e-wallet" name="payment" value="E-wallet" class="hidden peer">
                            <label for="e-wallet" class="cursor-pointer rounded-2xl p-4 pb-8 hover:bg-[#efe5bd] bg-[#e4dbc6] flex flex-col items-center w-40 h-40 peer-checked:bg-[#efe5bd] transition-all hover:scale-105 active:scale-95 duration-200">
                                <div class="w-28 h-28 flex items-center justify-center">
                                    <img src="img/payment-ewallet.png" alt="E-Wallet Payment" class="w-16 h-16">
                                </div>
                                <span class="text-[20px] font-medium">E-wallet</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Confirm Payment Button -->
                    <div class="flex flex-row mt-8">
                        <button type="button" id="confirmPaymentBtn"
                                class="flex items-center justify-center gap-2 bg-[#e4dbc6] hover:bg-[#d8ceb2] rounded-lg px-8 py-4 text-[18px] font-medium transition-colors duration-200 cursor-pointer">
                            Confirm Payment
                        </button>
                        <button type="button" onClick="window.location.href='CustomerOrder.jsp'"
                                class="flex items-center ml-2 justify-center gap-2 bg-[#e4dbc6] hover:bg-[#d8ceb2] rounded-lg px-8 py-4 text-[18px] font-medium transition-colors duration-200 cursor-pointer">
                            Add more to cart
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Payment Success Modal -->
    <div id="paymentSuccessModal" class="fixed inset-0 flex items-center justify-center p-4 invisible opacity-0 transition-all duration-300 ease-out" 
         style="background-color: rgba(0, 0, 0, 0.15)">
        <div class="bg-[#f0ead2] rounded-2xl p-8 max-w-md w-full mx-4 shadow-lg relative z-50 transform transition-all duration-300 scale-95 opacity-0">
            <div class="flex flex-col items-center">
                <div class="w-20 h-20 rounded-full bg-green-100 flex items-center justify-center mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                </div>
                <h2 class="text-[24px] font-bold mb-4 text-center">Payment Processing</h2>
                <p class="text-center mb-6">Please wait while we process your payment...</p>
                
                <div class="w-full border-t border-gray-300 pt-4 mb-4"></div>
                
                <div class="w-full mb-6">
                    <div class="flex justify-between">
                        <span>Payment Method:</span>
                        <span class="font-medium" id="modalPaymentMethod">Cash</span>
                    </div>
                </div>
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
        // Show payment processing modal
        function showPaymentProcessingModal() {
            const modal = document.getElementById('paymentSuccessModal');
            const modalContent = modal.querySelector('div');
            
            // Update payment method in the modal
            const selectedPayment = document.querySelector('input[name="payment"]:checked');
            const modalPaymentMethod = document.getElementById('modalPaymentMethod');
            
            if (selectedPayment) {
                modalPaymentMethod.textContent = selectedPayment.value;
            }
            
            modal.classList.remove('invisible', 'opacity-0');
            modalContent.classList.remove('scale-95', 'opacity-0');
            setTimeout(() => {
                modalContent.classList.add('scale-100', 'opacity-100');
            }, 10);
        }

        function closeModal() {
            const modal = document.getElementById('paymentSuccessModal');
            const modalContent = modal.querySelector('div');
            modalContent.classList.remove('scale-100', 'opacity-100');
            modalContent.classList.add('scale-95', 'opacity-0');
            
            // Wait for animation to finish before hiding completely
            setTimeout(() => {
                modal.classList.add('invisible', 'opacity-0');
            }, 300);
        }

        // Attach event listener to confirm payment button
        document.getElementById('confirmPaymentBtn').addEventListener('click', function(e) {
            e.preventDefault();
            
            // Check if cart is empty
            const cartEmpty = <%= (cartItems == null || cartItems.isEmpty()) ? "true" : "false" %>;
            if (cartEmpty) {
                alert("Your cart is empty. Please add items to your cart before proceeding to payment.");
                return;
            }
            
            // Show processing modal
            showPaymentProcessingModal();
            
            // Submit the form after a short delay to show the modal
            setTimeout(() => {
                document.getElementById('paymentForm').submit();
            }, 1000);
        });
        
        // Remove item functionality (would need to be connected to a remove cart endpoint)
        document.querySelectorAll('.remove-item').forEach(button => {
            button.addEventListener('click', function(e) {
                // Would need to implement item removal logic
                alert("This functionality would remove the item from the cart");
            });
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