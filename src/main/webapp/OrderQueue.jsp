<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mellowmist.model.OrderQueue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@300;400&display=swap" rel="stylesheet">
    
    <style>
    .status-completed {
    background-color: #4CAF50; /* Green */
    color: white;
    padding: 5px 10px;
    border-radius: 4px;
    font-weight: bold;
}

.status-pending {
    background-color: #FFC107; /* Yellow */
    color: black;
    padding: 5px 10px;
    border-radius: 4px;
    font-weight: bold;
}

.status-update-form {
    margin-left: 10px;
    display: inline-block;
}

/* Optional: Add some animation for status change */
@keyframes statusChanged {
    0% { transform: scale(1); }
    50% { transform: scale(1.2); }
    100% { transform: scale(1); }
}

.status-change {
    animation: statusChanged 0.5s ease;
}
        #sidenav {
            background-color: #bd9b61;
        }
        #topnav {
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
        
        /* Table styles */
        .queue-table {
            border-collapse: collapse;
            width: 100%;
        }
        
        .queue-table th {
            background-color: #f0ead2;
            border: 1px solid #000;
            padding: 12px;
            text-align: center;
        }
        
        .queue-table td {
            border: 1px solid #000;
            padding: 12px;
            text-align: center;
        }
        
        /* Status indicator styles */
        .status-preparing {
            background-color: #f7e28d;
            padding: 6px 12px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .status-completed {
            background-color: #a3d9a5;
            padding: 6px 12px;
            border-radius: 4px;
            display: inline-block;
        }
        
        /* Pagination styles */
        .pagination {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        /* View Order button */
        .view-order-btn {
            background-color: #e4dbc6;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .view-order-btn:hover {
            background-color: #d8ceb2;
        }
        
        /* Mark as Done button */
        .mark-done-btn {
            background-color: #e4dbc6;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-left: 8px;
        }
        
        .mark-done-btn:hover {
            background-color: #d8ceb2;
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: #f0ead2;
            margin: 15% auto;
            padding: 20px;
            border-radius: 8px;
            width: 50%;
            position: relative;
        }
        
        .close-btn {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 24px;
            cursor: pointer;
        }
        
        .order-item {
            margin-bottom: 12px;
            padding-bottom: 12px;
            border-bottom: 1px solid #ddd;
        }
        
        /* Page input style */
        .page-input {
            width: 40px;
            text-align: center;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 2px 4px;
        }

        /* Total amount style */
        .total-amount {
            font-weight: bold;
            color: #155724;
        }
    </style>
    <title>Queue | Mellow Mist</title>
</head>
<body class="overflow-hidden">
<%
    List<OrderQueue> queues = (List<OrderQueue>) request.getAttribute("queues");
    System.out.println("Debug: queues attribute: " + (queues != null ? queues.size() + " items" : "null"));
    int currentPage = (request.getAttribute("currentPage") != null)
        ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null)
        ? (Integer) request.getAttribute("totalPages") : 1;
    
    // Create a currency formatter for PHP
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "PH"));
%>
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
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                    <a href="CustomerOrder" class="flex items-center">
                        <img src="img/shopping-basket.png" class="w-7 h-7 mr-3"><span>Orders</span>
                    </a>
                </li>
                <li class="p-2 bg-[#efe5bd] text-black rounded-xl flex items-center">
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
                <div class="flex items-center ml-auto">                    
                    <div class="w-[2px] h-22 bg-black rounded-xl mr-6"></div>
                    <h1 class="text-l font-bold mr-3">Welcome, <%= username %>!</h1> 
                    <img src="img/admin.png" class="w-10 h-10 ml-3 mr-3">
                </div>            
            </div>
            
            <!-- Queue content -->
            <div class="p-6 overflow-auto h-full">
                <div>
                    <h2 class="text-3xl mb-6">Queue</h2>
                </div>
                
                <!-- Pagination -->
				<div class="pagination mb-6">
				    <span>Page</span>
				    <% if (currentPage > 1) { %>
				        <a href="OrderQueue?page=<%= currentPage - 1 %>" class="px-2 cursor-pointer hover:bg-[#efe5bd]">&lt;</a>
				    <% } else { %>
				        <span class="px-2 cursor-pointer text-gray-500">&lt;</span>
				    <% } %>
				    
				    <input type="text" class="page-input" value="<%= currentPage %>">
				    
				    <% if (currentPage < totalPages) { %>
				        <a href="OrderQueue?page=<%= currentPage + 1 %>" class="px-2 cursor-pointer hover:bg-[#efe5bd]">&gt;</a>
				    <% } else { %>
				        <span class="px-2 cursor-pointer text-gray-500">&gt;</span>
				    <% } %>
				    
				    <span>of <%= totalPages %></span>
				</div>
                
                <!-- Queue Table -->
				<table class="queue-table">
				  <thead>
				    <tr>
				      <th class="w-1/4">Order No.</th>
				      <th class="w-1/4">Total Amount</th>
				      <th class="w-1/4">Queue ID</th>
				      <th class="w-1/4">Status</th>
				    </tr>
				  </thead>
				  <tbody>
				    <%
				      if (queues != null && !queues.isEmpty()) {
				        for (OrderQueue queue : queues) {
				          String statusClass = "Completed".equalsIgnoreCase(queue.getQueueStatus()) 
				            ? "status-completed" 
				            : "status-pending";
				
				          int totalAmount = queue.getTotalAmount();
				          
				    %>
				    <tr>
				      <td>
				        <div class="flex items-center justify-center">
				          <span class="mr-4">
				            <%= String.format("%05d", queue.getOrderId()) %>
				          </span>
							<button class="view-order-btn" data-order="<%= queue.getOrderId() %>">
							    View Order
							</button>
				        </div>
				      </td>
				      <td>
				        <span class="total-amount">
				          ₱<%= totalAmount %>
				        </span>
				      </td>
				      <td><%= queue.getQueueId() %></td>
				      <td>
				        <div class="flex items-center justify-center">
				          <span class="<%= statusClass %>">
				            <%= queue.getQueueStatus() %>
				          </span>
				          <%
				            if (!"Completed".equalsIgnoreCase(queue.getQueueStatus())) {
				          %>
				          <form method="post" action="OrderQueue" class="status-update-form">
				            <input type="hidden" name="queueId" value="<%= queue.getQueueId() %>" />
				            <input type="hidden" name="queueStatus" value="Completed" />
				            <button type="submit" class="mark-done-btn">
				              Mark as Done
				            </button>
				          </form>
				          <%
				            }
				          %>
				        </div>
				      </td>
				    </tr>
				    <%
				        }
				      } else {
				    %>
				    <tr>
				      <td colspan="4" class="text-center">No queue records found.</td>
				    </tr>
				    <%
				      }
				    %>
				  </tbody>
				</table>

    <!-- Order Details Modal -->
    <div id="orderModal" class="modal">
        <div class="modal-content">
            <span class="close-btn">&times;</span>
            <h3 class="text-xl font-semibold mb-4">Order Details</h3>
            <div id="orderDetails" class="mt-4">
                <!-- Order details will be populated here -->
            </div>
            <div class="mt-6 flex justify-end">
                <button id="closeModalBtn" class="bg-[#bd9b61] text-white py-2 px-4 rounded">Close</button>
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
        // Modal functionality
        const modal = document.getElementById('orderModal');
        const closeBtn = document.querySelector('.close-btn');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const viewOrderBtns = document.querySelectorAll('.view-order-btn');
        const orderDetails = document.getElementById('orderDetails');
        
        // Mock order data with prices
        function showOrderDetails(orderNo) {
    // Show loading indicator
    orderDetails.innerHTML = '<p>Loading order details...</p>';
    modal.style.display = 'block';
    
    // Extract just the number without formatting
    const orderId = parseInt(orderNo);
    
    // Fetch order details from server
    fetch('OrderDetails?orderId=' + orderId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch order details');
            }
            return response.json();
        })
        .then(order => {
            if (!order || !order.items) {
                orderDetails.innerHTML = '<p>No details found for this order.</p>';
                return;
            }
            
            let detailsHTML = `
                <h4 class="font-bold mb-3">Order No. ${order.orderNo}</h4>
                <p class="font-medium mb-4">Total Amount: ₱${order.totalAmount}</p>
            `;
            
            order.items.forEach((item, index) => {
                const toppings = Array.isArray(item.toppings) ? item.toppings.join(', ') : '';
                
                detailsHTML += `
                    <div class="order-item">
                        <div class="flex justify-between">
                            <p class="font-medium">${index + 1}x ${item.name}</p>
                            <p class="font-medium">₱${item.price}</p>
                        </div>
                        <p class="text-sm text-gray-700">
                            (${item.size}, ${item.sweetness}, ${item.iceLevel}${toppings ? ', ' + toppings : ''})
                        </p>
                    </div>
                `;
            });
            
            orderDetails.innerHTML = detailsHTML;
        })
        .catch(error => {
            console.error('Error:', error);
            orderDetails.innerHTML = `<p class="text-red-500">Error loading order details: ${error.message}</p>`;
        });
}
        
        // Event listeners for opening the modal
        viewOrderBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const orderNo = this.getAttribute('data-order');
                showOrderDetails(orderNo);
            });
        });
        
        // Event listeners for closing the modal
        closeBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });
        
        closeModalBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });
        
        window.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
                        
        // Simple pagination functionality
        const pageInput = document.querySelector('.page-input');
        
        pageInput.addEventListener('change', () => {
            let value = parseInt(pageInput.value);
            if (isNaN(value) || value < 1) {
                pageInput.value = 1;
            } else if (value > <%= totalPages %>) {
                pageInput.value = <%= totalPages %>;
            } else {
                // Navigate to the selected page
                window.location.href = 'OrderQueue?page=' + value;
            }
        });
        
     // Modified event handler for status update forms
        document.addEventListener('DOMContentLoaded', function() {
            // Clear any existing event handlers by cloning and replacing all 'mark-done-btn' elements
            document.querySelectorAll('.mark-done-btn').forEach(btn => {
                const newBtn = btn.cloneNode(true);
                btn.parentNode.replaceChild(newBtn, btn);
            });
            
            // Add new event listeners to all status update forms
            document.querySelectorAll('.status-update-form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    // Prevent default form submission
                    e.preventDefault();
                    
                    // Get the queue ID from the form
                    const queueId = this.querySelector('input[name="queueId"]').value;
                    console.log("Updating queue ID:", queueId);
                    
                    // Create form data for submission
                    const statusData = new FormData(this);
                    
                    // Use fetch API to submit the form asynchronously
                    fetch('OrderQueue', {
                        method: 'POST',
                        body: statusData
                    })
                    .then(response => {
                        console.log("Server response status:", response.status);
                        
                        // Instead of checking for response.ok and returning response.text()
                        // Just handle the update UI directly, as we know what we want to happen
                        
                        // Find the status span element
                        const row = this.closest('tr');
                        const statusSpan = row.querySelector('span[class^="status-"]');
                        
                        // Update status display
                        statusSpan.textContent = 'Completed';
                        statusSpan.classList.remove('status-pending');
                        statusSpan.classList.add('status-completed');
                        statusSpan.classList.add('status-change');
                        
                        // Remove the form (Mark as Done button)
                        this.remove();
                        
                        return;
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Failed to update status. Please try again.');
                    });
                });
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