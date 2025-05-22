<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Success | Mellow Mist</title>
    <!-- Same style imports as Payment.jsp -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@300;400&display=swap" rel="stylesheet">
    
    <style>
        #sidenav {
            background-color: #bd9b61;
        }
        #topnav {
            background-color: #efe5bd;
        }
        body {
            background-color: #f0ead2;
            font-family: 'Bricolage Grotesque', sans-serif;
        }
    </style>
</head>
<body>
    <div class="flex h-screen">
        <!-- Sidenav (Same as in Payment.jsp) -->
        <div id="sidenav" class="w-80 h-screen flex-shrink-0 px-6 text-white p-4">
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
                <div class="flex items-center ml-auto">                    
                    <div class="w-[2px] h-22 bg-black rounded-xl mr-6"></div>
                    <h1 class="text-l font-bold mr-3">Welcome, <%= username %>!</h1> 
                    <img src="img/admin.png" class="w-10 h-10 ml-3 mr-3">
                </div>            
            </div>
            
            <!-- Success content -->
            <div class="flex items-center justify-center flex-grow">
                <div class="bg-white rounded-2xl p-8 max-w-md w-full mx-4 shadow-lg">
                    <div class="flex flex-col items-center">
                        <div class="w-20 h-20 rounded-full bg-green-100 flex items-center justify-center mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                            </svg>
                        </div>
                        <h2 class="text-[24px] font-bold mb-4 text-center">Payment Successful!</h2>
                        <p class="text-center mb-6">Your order has been placed and is being prepared.</p>
                        
                        <div class="w-full border-t border-gray-300 pt-4 mb-4"></div>
                        
                        <div class="w-full mb-6">
                            <%
                            // Get queue number from request attribute
                            Integer queueNumber = (Integer) request.getAttribute("queueNumber");
                            // Get payment method from request attribute
                            String paymentMethod = (String) request.getAttribute("paymentMethod");
                            %>
                            
                            
                        </div>
                        
                        <div class="flex flex-col gap-4 w-full">
                            <a href="CustomerOrder.jsp" 
                                class="bg-[#bd9b61] hover:bg-[#a98b51] text-white py-3 rounded-full transition-colors duration-200 font-medium cursor-pointer text-center">
                                New Order
                            </a>
                            <a href="dashboard" 
                                class="bg-[#e4dbc6] hover:bg-[#d8ceb2] text-gray-800 py-3 rounded-full transition-colors duration-200 font-medium cursor-pointer text-center">
                                Return to Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="logoutConfirmModal" class="modal">
</div>
<div class="modal-content" style="max-width: 400px;">
       <span class="close-btn" data-modal="logoutConfirmModal">&times;</span>
       <h3 class="text-xl font-semibold mb-4">Confirm Logout?</h3>
       <div class="mt-6 flex justify-center">
           <button type="button" class="action-btn mr-3" data-close="logoutConfirmModal">No</button>
           <button type="button" class="action-btn btn-primary" id="confirmLogoutBtn">Yes</button>
       </div>
   </div>
<script>
//Logout functionality
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