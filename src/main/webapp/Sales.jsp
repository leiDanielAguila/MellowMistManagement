<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
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
       }
       /* Using Bricolage Grotesque as the main font */
       body {
           font-family: 'Bricolage Grotesque', sans-serif;
       }
      
       h1, h2, h3 {
           font-family: 'Bricolage Grotesque', sans-serif;
       }
      
       /* Table styles */
       .sales-table {
           border-collapse: collapse;
           width: 100%;
       }
      
       .sales-table th {
           background-color: #f0ead2;
           border: 1px solid #000;
           padding: 12px;
           text-align: center;
       }
      
       .sales-table td {
           border: 1px solid #000;
           padding: 12px;
           text-align: center;
       }
      
       /* Payment method indicator styles */
       .payment-cash {
           background-color: #f7e28d;
           padding: 6px 12px;
           border-radius: 4px;
           display: inline-block;
       }
      
       .payment-card {
           background-color: #a3d9a5;
           padding: 6px 12px;
           border-radius: 4px;
           display: inline-block;
       }
      
       .payment-ewallet {
           background-color: #9ec3eb;
           padding: 6px 12px;
           border-radius: 4px;
           display: inline-block;
       }
      
       /* Date range picker styles */
       .date-picker {
           border: 1px solid #ccc;
           border-radius: 4px;
           padding: 6px 8px;
           font-size: 14px;
       }
      
       /* Export button */
       .export-btn {
           background-color: #bd9b61;
           color: white;
           padding: 8px 16px;
           border-radius: 4px;
           font-size: 14px;
           cursor: pointer;
           transition: background-color 0.2s;
           border: none;
       }
      
       .export-btn:hover {
           background-color: #a58752;
       }
      
       /* Pagination styles */
       .pagination {
           display: flex;
           align-items: center;
           gap: 10px;
           margin-bottom: 20px;
       }
      
       /* View Details button */
       .view-details-btn {
           background-color: #e4dbc6;
           padding: 4px 8px;
           border-radius: 4px;
           font-size: 14px;
           cursor: pointer;
           transition: background-color 0.2s;
       }
      
       .view-details-btn:hover {
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
      
       /* Filter section */
       .filter-section {
           background-color: #efe5bd;
           padding: 16px;
           border-radius: 8px;
           margin-bottom: 20px;
       }
      
       /* Filter button */
       .filter-btn {
           background-color: #bd9b61;
           color: white;
           padding: 8px 16px;
           border-radius: 4px;
           font-size: 14px;
           cursor: pointer;
           transition: background-color 0.2s;
           border: none;
       }
      
       .filter-btn:hover {
           background-color: #a58752;
       }
      
       /* Summary section */
       .summary-section {
           display: flex;
           justify-content: space-between;
           margin-bottom: 20px;
       }
      
       .summary-card {
           background-color: #efe5bd;
           padding: 16px;
           border-radius: 8px;
           width: 30%;
       }
      
       /* Export notification styles */
       .export-notification {
           display: none;
           position: fixed;
           top: 20px;
           right: 20px;
           background-color: #bd9b61;
           color: white;
           padding: 16px;
           border-radius: 8px;
           box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
           z-index: 1100;
           transition: opacity 0.3s ease-in-out;
       }
      
       /* Action button styles */
       .action-btn {
           padding: 8px 16px;
           border-radius: 4px;
           font-size: 14px;
           cursor: pointer;
           transition: background-color 0.2s;
           border: none;
           background-color: #e4dbc6;
       }
      
       .btn-primary {
           background-color: #bd9b61;
           color: white;
       }
      
       .btn-primary:hover {
           background-color: #a58752;
       }
   </style>
   <title>Sales Report | Mellow Mist</title>
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
               <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
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
               <li class="p-2 bg-[#efe5bd] text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                   <a href="SalesServlet" class="flex items-center">
                       <img src="img/increase.png" class="w-7 h-7 mr-3"><span>Sales</span>
                   </a>
               </li>
               <li class="p-2 hover:bg-opacity-20 hover:bg-[#efe5bd] text-black rounded-xl flex items-center">
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
          
           <!-- Sales Report content -->
           <div class="p-6 overflow-auto h-full">
               <div>
                   <h2 class="text-3xl mb-6">Sales Report</h2>
               </div>
              
               <!-- Filter Section -->
               <form action="SalesServlet" method="GET" id="filterForm">
                   <div class="filter-section flex items-center gap-4 mb-6">
                       <div>
                           <label for="startDate" class="mr-2">From:</label>
                           <input type="date" id="startDate" name="startDate" class="date-picker" value="${filter.startDate != null ? filter.startDate : ''}">
                       </div>
                       <div>
                           <label for="endDate" class="mr-2">To:</label>
                           <input type="date" id="endDate" name="endDate" class="date-picker" value="${filter.endDate != null ? filter.endDate : ''}">
                       </div>
                       <button type="submit" class="filter-btn">Apply Filter</button>
                       <div class="ml-auto">
                           <button type="button" id="exportBtn" class="export-btn flex items-center">
                               <span>Export Report</span>
                               <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                               </svg>
                           </button>
                       </div>
                   </div>
                   <input type="hidden" name="pageSize" value="8">
               </form>
              
               <!-- Sales Summary -->
               <div class="summary-section">
                   <div class="summary-card">
                       <h3 class="text-xl mb-2">Total Sales</h3>
                       <p class="text-2xl font-bold">₱${totalSales}</p>
                   </div>
                   <div class="summary-card">
                       <h3 class="text-xl mb-2">Orders</h3>
                       <p class="text-2xl font-bold">${orderCount}</p>
                   </div>
                   <div class="summary-card">
                       <h3 class="text-xl mb-2">Average Order Value</h3>
                       <p class="text-2xl font-bold">₱${avgOrderValue}</p>
                   </div>
               </div>
              
               <!-- Pagination -->
               <div class="pagination mb-6">
                   <span>Page</span>
                   <button type="button" id="prevPage" class="px-2 hover:bg-[#efe5bd] rounded-xl cursor-pointer ${currentPage == 1 ? 'text-gray-500' : ''}" ${currentPage == 1 ? 'disabled' : ''}>&lt;</button>
                   <input type="text" id="currentPage" class="page-input" value="${currentPage}" readOnly>
                   <button type="button" id="nextPage" class="px-2 hover:bg-[#efe5bd] rounded-xl cursor-pointer ${currentPage == totalPages ? 'text-gray-500' : ''}" ${currentPage == totalPages ? 'disabled' : ''}>&gt;</button>
                   <span>of ${totalPages}</span>
               </div>
              
               <!-- Sales Table -->
               <table class="sales-table">
                   <thead>
                       <tr>
                           <th class="w-1/5">Date</th>
                           <th class="w-1/5">Time</th>
                           <th class="w-1/5">Order No.</th>
                           <th class="w-1/5">Total Price</th>
                           <th class="w-1/5">Payment Type</th>
                       </tr>
                   </thead>
                   <tbody>
                       <c:forEach var="sale" items="${salesList}">
                           <tr>
                               <td>
                                   <fmt:formatDate value="${sale.getOrderDate()}" pattern="MMM dd, yyyy" />
                               </td>
                               <td>${sale.getOrderTime()}</td>
                               <td>${sale.getOrderId()}</td>
                               <td>₱${sale.getTotalAmount()}</td>
                               <td>
                                   <c:choose>
                                       <c:when test="${sale.getPaymentMethod() == 'Cash'}">
                                           <span class="payment-cash">Cash</span>
                                       </c:when>
                                       <c:when test="${sale.getPaymentMethod() == 'Card'}">
                                           <span class="payment-card">Card</span>
                                       </c:when>
                                       <c:when test="${sale.getPaymentMethod() == 'E-wallet'}">
                                           <span class="payment-ewallet">E-wallet</span>
                                       </c:when>
                                       <c:otherwise>
                                           <span>${sale.getPaymentMethod()}</span>
                                       </c:otherwise>
                                   </c:choose>
                               </td>
                           </tr>
                       </c:forEach>
                   </tbody>
               </table>
           </div>
       </div>
   </div>
  
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
  
   <!-- Export Notification -->
   <div id="exportNotification" class="export-notification">
       <div class="flex items-center">
           <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
           </svg>
           <span id="exportMessage">Report exported successfully!</span>
       </div>
   </div>
  
   <!-- Logout Confirmation Modal -->
   <div id="logoutConfirmModal" class="modal">
       <div class="modal-content" style="max-width: 400px;">
           <span class="close-btn" id="closeLogoutModal">&times;</span>
           <h3 class="text-xl font-semibold mb-4">Confirm Logout?</h3>
           <div class="mt-6 flex justify-center gap-4">
               <button type="button" class="action-btn" id="cancelLogoutBtn">No</button>
               <button type="button" class="action-btn btn-primary" id="confirmLogoutBtn">Yes</button>
           </div>
       </div>
   </div>
  
   <!-- Form for logout submission -->
   <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post" style="display: none;"></form>
  
   <script>
       document.addEventListener('DOMContentLoaded', function() {
           // Pagination functionality
           const prevPageBtn = document.getElementById('prevPage');
           const nextPageBtn = document.getElementById('nextPage');
           const currentPageInput = document.getElementById('currentPage');
           const filterForm = document.getElementById('filterForm');
          
           // Set page size to 8 (for 8 transactions per page)
           const pageSize = 8;
          
           prevPageBtn.addEventListener('click', function() {
               const currentPage = parseInt(currentPageInput.value);
               if (currentPage > 1) {
                   navigateToPage(currentPage - 1);
               }
           });
          
           nextPageBtn.addEventListener('click', function() {
               const currentPage = parseInt(currentPageInput.value);
               const totalPages = ${totalPages};
               if (currentPage < totalPages) {
                   navigateToPage(currentPage + 1);
               }
           });
          
           function navigateToPage(page) {
               // Create a form and append needed values
               const form = document.createElement('form');
               form.method = 'GET';
               form.action = 'SalesServlet';
              
               // Add page parameter
               const pageInput = document.createElement('input');
               pageInput.type = 'hidden';
               pageInput.name = 'page';
               pageInput.value = page;
               form.appendChild(pageInput);
              
               // Add page size parameter
               const pageSizeInput = document.createElement('input');
               pageSizeInput.type = 'hidden';
               pageSizeInput.name = 'pageSize';
               pageSizeInput.value = pageSize;
               form.appendChild(pageSizeInput);
              
               // Add any filter values if they exist
               const startDate = document.getElementById('startDate').value;
               if (startDate) {
                   const startDateInput = document.createElement('input');
                   startDateInput.type = 'hidden';
                   startDateInput.name = 'startDate';
                   startDateInput.value = startDate;
                   form.appendChild(startDateInput);
               }
              
               const endDate = document.getElementById('endDate').value;
               if (endDate) {
                   const endDateInput = document.createElement('input');
                   endDateInput.type = 'hidden';
                   endDateInput.name = 'endDate';
                   endDateInput.value = endDate;
                   form.appendChild(endDateInput);
               }
              
               // Submit the form
               document.body.appendChild(form);
               form.submit();
           }
          
           // Modal functionality
           const modal = document.getElementById('orderModal');
           const closeModalBtn = document.querySelector('.close-btn');
           const closeBtn = document.getElementById('closeModalBtn');
           const orderDetails = document.getElementById('orderDetails');
          
           // Get all view details buttons
           const viewDetailsBtns = document.querySelectorAll('.view-details-btn');
          
           // Add click event to each button
           viewDetailsBtns.forEach(btn => {
               btn.addEventListener('click', function() {
                   const orderId = this.getAttribute('data-orderid');
                   fetchOrderDetails(orderId);
               });
           });
          
           // Close modal when clicking the X button
           closeModalBtn.addEventListener('click', function() {
               modal.style.display = 'none';
           });
          
           // Close modal when clicking the Close button
           closeBtn.addEventListener('click', function() {
               modal.style.display = 'none';
           });
          
           // Close modal when clicking outside of it
           window.addEventListener('click', function(event) {
               if (event.target === modal) {
                   modal.style.display = 'none';
               }
           });
          
           // Function to fetch order details
           function fetchOrderDetails(orderId) {
               // Fetch order details via AJAX
               fetch(`GetOrderDetailsServlet?orderId=${orderId}`)
                   .then(response => response.json())
                   .then(data => {
                       // Create HTML content for order details
                       let html = `
                           <div class="mb-4">
                               <p><strong>Order ID:</strong> ${data.orderId}</p>
                               <p><strong>Date:</strong> ${data.orderDate}</p>
                               <p><strong>Time:</strong> ${data.orderTime}</p>
                               <p><strong>Payment Method:</strong> ${data.paymentMethod}</p>
                           </div>
                           <div class="mb-4">
                               <h4 class="font-semibold mb-2">Items:</h4>
                       `;
                      
                       // Add each order item
                       data.items.forEach(item => {
                           html += `
                               <div class="order-item">
                                   <p><strong>${item.productName}</strong></p>
                                   <p>Quantity: ${item.quantity}</p>
                                   <p>Price: ₱${item.price}</p>
                               </div>
                           `;
                       });
                      
                       html += `
                           </div>
                           <div class="mt-4 pt-4 border-t">
                               <p class="text-xl font-bold">Total: ₱${data.totalAmount}</p>
                           </div>
                       `;
                      
                       // Set the HTML content
                       orderDetails.innerHTML = html;
                      
                       // Show the modal
                       modal.style.display = 'block';
                   })
                   .catch(error => {
                       console.error('Error fetching order details:', error);
                       alert('Error loading order details. Please try again.');
                   });
           }
          
           // Export notification functionality
           const exportBtn = document.getElementById('exportBtn');
           const exportNotification = document.getElementById('exportNotification');
           const exportMessage = document.getElementById('exportMessage');
          
           exportBtn.addEventListener('click', function() {
               // Show "Exporting report..." notification
               exportMessage.textContent = "Exporting report...";
               exportNotification.style.display = "block";
              
               // Simulate export process with timeout
               setTimeout(function() {
                   // Change to success message after 1.5 seconds
                   exportMessage.textContent = "Report exported successfully!";
                  
                   // Hide notification after another 2 seconds
                   setTimeout(function() {
                       exportNotification.style.display = "none";
                   }, 2000);
               }, 1500);
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
       });
   </script>
</body>
</html>


