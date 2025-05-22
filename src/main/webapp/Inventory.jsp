<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mellowmist.model.Inventory" %>
<%@ page import="com.mellowmist.dao.InventoryDAO" %>
<%@ page import="java.util.List" %>
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
       .inventory-table {
           border-collapse: collapse;
           width: 100%;
       }
      
       .inventory-table th {
           background-color: #f0ead2;
           border: 1px solid #000;
           padding: 12px;
           text-align: center;
       }
      
       .inventory-table td {
           border: 1px solid #000;
           padding: 12px;
           text-align: center;
       }
      
       /* Status indicator styles */
       .status-instock {
           background-color: #a3d9a5;
           padding: 6px 12px;
           border-radius: 4px;
           display: inline-block;
       }
      
       .status-lowstock {
           background-color: #f7e28d;
           padding: 6px 12px;
           border-radius: 4px;
           display: inline-block;
       }
      
       .status-outofstock {
           background-color: #e5a9a9;
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
      
       /* Page input style */
       .page-input {
           width: 40px;
           text-align: center;
           border: 1px solid #ccc;
           border-radius: 4px;
           padding: 2px 4px;
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
      
       /* Form styles */
       .form-group {
           margin-bottom: 16px;
       }
      
       .form-group label {
           display: block;
           margin-bottom: 6px;
           font-weight: 500;
       }
      
       .form-group input,
       .form-group select {
           width: 100%;
           padding: 8px;
           border: 1px solid #ccc;
           border-radius: 4px;
       }
      
       /* Button styles */
       .action-btn {
           background-color: #e4dbc6;
           padding: 8px 16px;
           border-radius: 4px;
           font-size: 14px;
           cursor: pointer;
           transition: background-color 0.2s;
           border: none;
       }
      
       .action-btn:hover {
           background-color: #d8ceb2;
       }
      
       .btn-primary {
           background-color: #bd9b61;
           color: white;
       }
      
       .btn-primary:hover {
           background-color: #a88a54;
       }
      
       .dropdown-menu {
           display: none;
           position: absolute;
           background-color: #f0ead2;
           min-width: 160px;
           box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
           z-index: 1;
           border-radius: 4px;
       }
      
       .dropdown-menu.show {
           display: block;
       }
      
       .dropdown-item {
           padding: 10px 16px;
           text-decoration: none;
           display: block;
           color: black;
           cursor: pointer;
       }
      
       .dropdown-item:hover {
           background-color: #e4dbc6;
       }
   </style>
   <title>Inventory | Mellow Mist</title>
</head>
<body class="overflow-hidden">
   <%
       // Set up pagination
       int recordsPerPage = 9;
       int currentPage = 1;
       String pageParam = request.getParameter("page");
       if (pageParam != null) {
           try {
               currentPage = Integer.parseInt(pageParam);
               if (currentPage < 1) currentPage = 1;
           } catch (NumberFormatException e) {
               currentPage = 1;
           }
       }
      
       // Get inventory items with pagination
       InventoryDAO inventoryDAO = new InventoryDAO();
       // Get total count first - this is a new method you need to implement
       int totalRecords = inventoryDAO.getTotalInventoryCount();
       // Calculate total pages based on total record count, not the current page items
       int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
      
       // Adjust current page if it's out of bounds
       if (currentPage > totalPages && totalPages > 0) {
           currentPage = totalPages;
       }
      
       // Now get only the current page items
       List<Inventory> currentPageItems = inventoryDAO.getAllInventory(currentPage, recordsPerPage);
      
       // Get error or success messages if any
       String successMessage = (String) session.getAttribute("successMessage");
       String errorMessage = (String) session.getAttribute("errorMessage");
       session.removeAttribute("successMessage");
       session.removeAttribute("errorMessage");
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
                   <a href="CustomerOrder.jsp" class="flex items-center">
                       <img src="img/shopping-basket.png" class="w-7 h-7 mr-3"><span>Orders</span>
                   </a>
               </li>
               <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                   <a href="OrderQueue" class="flex items-center">
                       <img src="img/document.png" class="w-7 h-7 mr-3"><span>Queue</span>
                   </a>
               </li>
               <li class="p-2 bg-[#efe5bd] text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                   <a href="Inventory.jsp" class="flex items-center">
                       <img src="img/delivery-box.png" class="w-7 h-7 mr-3"><span>Inventory</span>
                   </a>
               </li>
               <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                   <a href="SalesServlet" class="flex items-center">
                       <img src="img/increase.png" class="w-7 h-7 mr-3"><span>Sales</span>
                   </a>
               </li>
               <li class="p-2 hover:bg-opacity-20 hover:bg-[#efe5bd]  text-black rounded-xl flex items-center">
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
      
       <!-- Main content area -->
       <div class="flex flex-col flex-grow">
           <!-- Topnav -->
           <div id="topnav" class="w-full h-32 shadow-md flex items-center p-6">
               <!-- Topnav content here -->
               <div class="flex items-center ml-auto">                   
                   <div class="w-[2px] h-22 bg-black rounded-xl mr-6"></div>
                   <h1 class="text-l font-bold mr-3">Admin</h1>
                   <img src="img/admin.png" alt="Admin" class="w-10 h-10 ml-3 mr-3">
               </div>           
           </div>
          
           <!-- Inventory content -->
           <div class="p-6 overflow-auto h-full">
               <% if (successMessage != null && !successMessage.isEmpty()) { %>
                   <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
                       <span class="block sm:inline"><%= successMessage %></span>
                   </div>
               <% } %>
              
               <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                   <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                       <span class="block sm:inline"><%= errorMessage %></span>
                   </div>
               <% } %>
              
               <div class="flex justify-between items-center mb-6">
                   <h2 class="text-3xl">Inventory</h2>
                   <div class="relative">
                       <button id="manageInventoryBtn" class="action-btn flex items-center">
                           <span>Manage Inventory</span>
                           <svg class="ml-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                           </svg>
                       </button>
                       <div id="inventoryDropdown" class="dropdown-menu right-0">
                           <a class="dropdown-item flex items-center" id="addItemBtn">
                               <svg class="mr-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                               </svg>
                               Add Item
                           </a>
                           <a class="dropdown-item flex items-center" id="removeItemBtn">
                               <svg class="mr-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                               </svg>
                               Remove Item
                           </a>
                           <a class="dropdown-item flex items-center" id="editItemBtn">
                               <svg class="mr-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                               </svg>
                               Edit Item
                           </a>
                       </div>
                   </div>
               </div>
              
               <!-- Pagination -->
               <div class="pagination mb-6">
                   <span>Page</span>
                   <button class="px-2 hover:bg-[#efe5bd] rounded-xl cursor-pointer <%= currentPage == 1 ? "text-gray-500" : "" %>"
                           onclick="goToPage(<%= currentPage - 1 %>)"
                           <%= currentPage == 1 ? "disabled" : "" %>>&lt;</button>
                   <input type="text" class="page-input" id="pageInput" value="<%= currentPage %>" onchange="setPage(this.value)">
                   <button class="px-2 hover:bg-[#efe5bd] rounded-xl cursor-pointer <%= currentPage == totalPages ? "text-gray-500" : "" %>"
                           onclick="goToPage(<%= currentPage + 1 %>)"
                           <%= currentPage == totalPages ? "disabled" : "" %>>&gt;</button>
                   <span>of <%= totalPages %></span>
               </div>
              
               <!-- Inventory Table -->
               <table class="inventory-table">
                   <thead>
                       <tr>
                           <th>Inventory No.</th>
                           <th>Item Name</th>
                           <th>Category</th>
                           <th>Unit</th>
                           <th>Quantity</th>
                           <th>Reorder Level</th>
                           <th>Status</th>
                       </tr>
                   </thead>
                   <tbody>
                       <% if (currentPageItems.isEmpty()) { %>
                           <tr>
                               <td colspan="7" class="text-center py-4">No inventory items found</td>
                           </tr>
                       <% } else { %>
                           <% for (Inventory item : currentPageItems) { %>
                               <tr>
                                   <td><%= item.getInventoryId() %></td>
                                   <td><%= item.getItemName() %></td>
                                   <td><%= item.getCategoryName() %></td>
                                   <td><%= item.getUnit() %></td>
                                   <td><%= item.getQuantity() %></td>
                                   <td><%= item.getReorderLevel() %></td>
                                   <td>
                                       <%
                                           String statusClass = "";
                                           String statusText = "";
                                          
                                           if (item.getQuantity() <= 0) {
                                               statusClass = "status-outofstock";
                                               statusText = "Out of Stock";
                                           } else if (item.getQuantity() <= item.getReorderLevel()) {
                                               statusClass = "status-lowstock";
                                               statusText = "Low Stock";
                                           } else {
                                               statusClass = "status-instock";
                                               statusText = "In Stock";
                                           }
                                       %>
                                       <span class="<%= statusClass %>"><%= statusText %></span>
                                   </td>
                               </tr>
                           <% } %>
                       <% } %>
                   </tbody>
               </table>
           </div>
       </div>
   </div>
  
   <!-- Add Item Modal -->
   <div id="addItemModal" class="modal">
       <div class="modal-content">
           <span class="close-btn" data-modal="addItemModal">&times;</span>
           <h3 class="text-xl font-semibold mb-4">Add New Item</h3>
           <form id="addItemForm" action="AddInventoryServlet" method="post">
               <div class="form-group">
                   <label for="itemName">Item Name</label>
                   <input type="text" id="itemName" name="itemName" required>
               </div>
               <div class="form-group">
                   <label for="category">Category</label>
                   <select id="category" name="category" required>
                       <option value="">Select Category</option>
                       <option value="toppings">Toppings</option>
                       <option value="base">base</option>
                       <option value="ingredients">Ingredients</option>
                       <option value="packaging">Packaging</option>
                   </select>
               </div>
               <div class="form-group">
                   <label for="unit">Unit</label>
                   <select id="unit" name="unit" required>
                       <option value="">Select Unit</option>
                       <option value="kg">kg</option>
                       <option value="L">L</option>
                       <option value="pcs">pcs</option>
                   </select>
               </div>
               <div class="form-group">
                   <label for="quantity">Quantity</label>
                   <input type="number" id="quantity" name="quantity" min="0" required>
               </div>
               <div class="form-group">
                   <label for="reorderLevel">Reorder Level</label>
                   <input type="number" id="reorderLevel" name="reorderLevel" min="0" required>
               </div>
               <div class="mt-6 flex justify-end">
                   <button type="button" class="action-btn mr-3" data-close="addItemModal">Cancel</button>
                   <button type="submit" class="action-btn btn-primary">Add Item</button>
               </div>
           </form>
       </div>
   </div>
  
   <!-- Remove Item Modal -->
   <div id="removeItemModal" class="modal">
       <div class="modal-content">
           <span class="close-btn" data-modal="removeItemModal">&times;</span>
           <h3 class="text-xl font-semibold mb-4">Remove Item</h3>
           <form id="removeItemForm" action="DeleteInventoryServlet" method="post">
               <div class="form-group">
                   <label for="inventoryId">Inventory Number</label>
                   <input type="number" id="inventoryId" name="inventoryId" required>
               </div>
               <div class="mt-6 flex justify-end">
                   <button type="button" class="action-btn mr-3" data-close="removeItemModal">Cancel</button>
                   <button type="submit" class="action-btn btn-primary">Remove Item</button>
               </div>
           </form>
       </div>
   </div>
  
   <!-- Edit Item Modal -->
  <div id="editItemModal" class="modal">
   <div class="modal-content">
       <span class="close-btn" data-modal="editItemModal">&times;</span>
       <h3 class="text-xl font-semibold mb-4">Edit Item</h3>
       <form id="editItemForm" action="UpdateInventoryServlet" method="post">
           <div class="form-group">
               <label for="editInventoryId">Inventory Number</label>
               <input type="number" id="editInventoryId" name="inventoryId" required>
           </div>
           <div class="form-group">
               <label for="editItemName">Item Name</label>
               <input type="text" id="editItemName" name="itemName">
           </div>
           <!-- Category dropdown removed to prevent errors -->
           <input type="hidden" id="editCategory" name="category">
           <div class="form-group">
               <label for="editUnit">Unit</label>
               <select id="editUnit" name="unit">
                   <option value="">Select Unit</option>
                   <option value="kg">kg</option>
                   <option value="L">L</option>
                   <option value="pcs">pcs</option>
               </select>
           </div>
           <div class="form-group">
               <label for="editQuantity">Quantity</label>
               <input type="number" id="editQuantity" name="quantity" min="0">
           </div>
           <div class="form-group">
               <label for="editReorderLevel">Reorder Level</label>
               <input type="number" id="editReorderLevel" name="reorderLevel" min="0">
           </div>
           <div class="mt-6 flex justify-end">
               <button type="button" class="action-btn mr-3" data-close="editItemModal">Cancel</button>
               <button type="submit" class="action-btn btn-primary">Update Item</button>
           </div>
       </form>
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
       // Dropdown functionality
       const manageInventoryBtn = document.getElementById('manageInventoryBtn');
       const inventoryDropdown = document.getElementById('inventoryDropdown');
      
       manageInventoryBtn.addEventListener('click', function() {
           inventoryDropdown.classList.toggle('show');
       });
      
       // Close dropdown when clicking outside
       window.addEventListener('click', function(event) {
           if (!event.target.closest('#manageInventoryBtn') && inventoryDropdown.classList.contains('show')) {
               inventoryDropdown.classList.remove('show');
           }
       });
      
       // Modal functionality
       const addItemBtn = document.getElementById('addItemBtn');
       const removeItemBtn = document.getElementById('removeItemBtn');
       const editItemBtn = document.getElementById('editItemBtn');
       const addItemModal = document.getElementById('addItemModal');
       const removeItemModal = document.getElementById('removeItemModal');
       const editItemModal = document.getElementById('editItemModal');
       const closeBtns = document.querySelectorAll('.close-btn');
       const closeModalBtns = document.querySelectorAll('[data-close]');
      
       // Open modals
       addItemBtn.addEventListener('click', function() {
           addItemModal.style.display = 'block';
           inventoryDropdown.classList.remove('show');
       });
      
       removeItemBtn.addEventListener('click', function() {
           removeItemModal.style.display = 'block';
           inventoryDropdown.classList.remove('show');
       });
      
       editItemBtn.addEventListener('click', function() {
           // Reset form fields
           document.getElementById('editInventoryId').value = '';
           document.getElementById('editItemName').value = '';
           document.getElementById('editCategory').value = '';
           document.getElementById('editUnit').value = '';
           document.getElementById('editQuantity').value = '';
           document.getElementById('editReorderLevel').value = '';
          
           // Show the modal
           editItemModal.style.display = 'block';
           inventoryDropdown.classList.remove('show');
       });
      
       // Add event listener to fetch inventory details when inventory ID is entered
       document.getElementById('editInventoryId').addEventListener('change', function() {
   const inventoryId = this.value.trim();
   if (!inventoryId) return;
  
   // Use AJAX to fetch inventory details
   fetch('GetInventoryDetailsServlet?inventoryId=' + inventoryId)
       .then(response => response.json())
       .then(data => {
           if (data.error) {
               alert(data.error);
               return;
           }
          
           // Fill form with inventory details
           document.getElementById('editItemName').value = data.itemName;
           // Store category name in hidden field but don't show it in UI
           document.getElementById('editCategory').value = data.categoryName;
           document.getElementById('editUnit').value = data.unit;
           document.getElementById('editQuantity').value = data.quantity;
           document.getElementById('editReorderLevel').value = data.reorderLevel;
       })
       .catch(error => {
           console.error('Error fetching inventory details:', error);
           alert('Error fetching inventory details. Please try again.');
       });
});
      
       // Close modals with X button
       closeBtns.forEach(btn => {
           btn.addEventListener('click', function() {
               const modalId = this.getAttribute('data-modal');
               document.getElementById(modalId).style.display = 'none';
           });
       });
      
       // Close modals with Cancel button
       closeModalBtns.forEach(btn => {
           btn.addEventListener('click', function() {
               const modalId = this.getAttribute('data-close');
               document.getElementById(modalId).style.display = 'none';
           });
       });
      
       // Close modals when clicking outside
       window.addEventListener('click', function(event) {
           if (event.target === addItemModal) {
               addItemModal.style.display = 'none';
           }
           if (event.target === removeItemModal) {
               removeItemModal.style.display = 'none';
           }
           if (event.target === editItemModal) {
               editItemModal.style.display = 'none';
           }
       });
      
       // Pagination functions
       function goToPage(page) {
           if (page < 1 || page > <%= totalPages %>) return;
           window.location.href = 'Inventory.jsp?page=' + page;
       }
      
       function setPage(page) {
           const pageNum = parseInt(page);
           if (isNaN(pageNum) || pageNum < 1) {
               document.getElementById('pageInput').value = 1;
               goToPage(1);
           } else if (pageNum > <%= totalPages %>) {
               document.getElementById('pageInput').value = <%= totalPages %>;
               goToPage(<%= totalPages %>);
           } else {
               goToPage(pageNum);
           }
       }
      
       // Form validation and error handling
       document.getElementById('addItemForm').addEventListener('submit', function(e) {
           if (!validateForm('addItemForm')) {
               e.preventDefault();
               alert('Please fill all required fields correctly.');
           }
       });
      
       document.getElementById('removeItemForm').addEventListener('submit', function(e) {
           if (!validateForm('removeItemForm')) {
               e.preventDefault();
               alert('Please enter a valid inventory ID.');
           }
       });
      
       document.getElementById('editItemForm').addEventListener('submit', function(e) {
           if (!validateForm('editItemForm')) {
               e.preventDefault();
               alert('Please fill required fields correctly.');
           }
       });
      
       function validateForm(formId) {
           const form = document.getElementById(formId);
           const required = form.querySelectorAll('[required]');
          
           for (let i = 0; i < required.length; i++) {
               if (!required[i].value.trim()) {
                   return false;
               }
           }
          
           return true;
       }
    // Logout functionality
       const logoutBtn = document.getElementById('logoutBtn');
       const logoutConfirmModal = document.getElementById('logoutConfirmModal');
       const confirmLogoutBtn = document.getElementById('confirmLogoutBtn');
       // Show logout confirmation modal when clicking logout button
       logoutBtn.addEventListener('click', function() {
           logoutConfirmModal.style.display = 'block';
       });
       // Handle confirmed logout
       confirmLogoutBtn.addEventListener('click', function() {
           // Redirect to logout servlet or action
           window.location.href = "LogoutServlet";
       });
   </script>
</body>
</html>


