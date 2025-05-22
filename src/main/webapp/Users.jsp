<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mellowmist.model.User"%>
<%@ page import="com.mellowmist.dao.UserDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
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
       .users-table {
           border-collapse: collapse;
           width: 100%;
       }
      
       .users-table th {
           background-color: #f0ead2;
           border: 1px solid #000;
           padding: 12px;
           text-align: center;
       }
      
       .users-table td {
           border: 1px solid #000;
           padding: 12px;
           text-align: center;
       }
      
       /* Status indicator styles */
       .status-active {
           background-color: #a3d9a5;
           padding: 6px 12px;
           border-radius: 4px;
           display: inline-block;
       }
      
       .status-inactive {
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
      
       /* Message styles */
       .message {
           padding: 12px;
           margin-bottom: 20px;
           border-radius: 4px;
       }
      
       .success {
           background-color: #a3d9a5;
           color: #2b5329;
       }
      
       .error {
           background-color: #e5a9a9;
           color: #7a2121;
       }
   </style>
   <title>Manage Users | Mellow Mist</title>
</head>
<body class="overflow-hidden">
   <%
       // Initialize UserDAO
       UserDAO userDAO = new UserDAO();
       List<User> users = new ArrayList<>();
      
       // Get all users
       try {
           users = userDAO.getAllUsers();
       } catch (Exception e) {
           e.printStackTrace();
           // Handle exception
       }
      
       // Pagination logic
       int recordsPerPage = 5;
       int totalUsers = users.size();
       int totalPages = (int) Math.ceil((double) totalUsers / recordsPerPage);
      
       // Get current page from request parameter, default to 1 if not present
       String pageParam = request.getParameter("page");
       int currentPage = 1;
       if (pageParam != null && !pageParam.isEmpty()) {
           try {
               currentPage = Integer.parseInt(pageParam);
               if (currentPage < 1) {
                   currentPage = 1;
               } else if (currentPage > totalPages && totalPages > 0) {
                   currentPage = totalPages;
               }
           } catch (NumberFormatException e) {
               // Invalid page number, use default
               currentPage = 1;
           }
       }
      
       // Calculate start and end index for current page
       int startIndex = (currentPage - 1) * recordsPerPage;
       int endIndex = Math.min(startIndex + recordsPerPage, totalUsers);
      
       // Get users for current page
       List<User> currentPageUsers = new ArrayList<>();
       if (startIndex < totalUsers) {
           currentPageUsers = users.subList(startIndex, endIndex);
       }
      
       String message = (String) session.getAttribute("message");
       String messageType = (String) session.getAttribute("messageType");
      
    // Clear the session attributes to prevent message from showing again on refresh
       if (message != null) {
           session.removeAttribute("message");
           session.removeAttribute("messageType");
       }
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
               <li class="p-2 bg-[#efe5bd] text-black rounded-xl flex items-center">
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
          
           <!-- Users content -->
           <div class="p-6 overflow-auto h-full">
               <div class="flex justify-between items-center mb-6">
                   <h2 class="text-3xl">Manage Users</h2>
                   <div class="relative">
                       <button id="manageUsersBtn" class="action-btn flex items-center">
                           <span>Manage Users</span>
                           <svg class="ml-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                           </svg>
                       </button>
                       <div id="usersDropdown" class="dropdown-menu right-0">
                           <a class="dropdown-item flex items-center" id="addUserBtn">
                               <svg class="mr-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                               </svg>
                               Add User
                           </a>
                           <a class="dropdown-item flex items-center" id="removeUserBtn">
                               <svg class="mr-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                               </svg>
                               Remove User
                           </a>
                           <a class="dropdown-item flex items-center" id="editUserBtn">
                               <svg class="mr-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                   <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                               </svg>
                               Edit User
                           </a>
                       </div>
                   </div>
               </div>
              
               <!-- Display messages if any -->
               <% if (message != null && !message.isEmpty()) { %>
                   <div class="message <%= messageType %>">
                       <%= message %>
                   </div>
               <% } %>
              
               <!-- Pagination -->
               <div class="pagination mb-6">
                   <span>Page</span>
                   <button id="prevPageBtn" class="px-2 rounded-xl cursor-pointer hover:bg-[#efe5bd] <%= currentPage == 1 ? "text-gray-500" : "" %>">&lt;</button>
                   <input type="text" class="page-input" id="currentPageInput" value="<%= currentPage %>">
                   <button id="nextPageBtn" class="px-2 rounded-xl cursor-pointer hover:bg-[#efe5bd] <%= currentPage == totalPages || totalPages == 0 ? "text-gray-500" : "" %>">&gt;</button>
                   <span>of <%= totalPages == 0 ? 1 : totalPages %></span>
               </div>
              
               <!-- Users Table -->
               <table class="users-table">
                   <thead>
                       <tr>
                           <th>User ID</th>
                           <th>Username</th>
                           <th>Email</th>
                           <th>Role</th>

                       </tr>
                   </thead>
                   <tbody>
                       <% if (currentPageUsers.isEmpty()) { %>
                           <tr>
                               <td colspan="5" class="text-center py-4">No users found</td>
                           </tr>
                       <% } else { %>
                           <% for (User user : currentPageUsers) { %>
                               <tr>
                                   <td><%= user.getId() %></td>
                                   <td><%= user.getUsername() %></td>
                                   <td><%= user.getEmail() %></td>
                                   <td><%= user.getRole() %></td>
                               </tr>
                           <% } %>
                       <% } %>
                   </tbody>
               </table>
           </div>
       </div>
   </div>
  
   <!-- Add User Modal -->
   <div id="addUserModal" class="modal">
       <div class="modal-content">
           <span class="close-btn" data-modal="addUserModal">&times;</span>
           <h3 class="text-xl font-semibold mb-4">Add New User</h3>
           <form id="addUserForm" action="AddUserServlet" method="post">
               <div class="form-group">
                   <label for="fullName">Full Name</label>
                   <input type="text" id="fullName" name="username" required>
               </div>
               <div class="form-group">
                   <label for="email">Email</label>
                   <input type="email" id="email" name="email" required>
               </div>
               <div class="form-group">
                   <label for="password">Password</label>
                   <input type="password" id="password" name="password" required>
               </div>
               <div class="form-group">
                   <label for="role">Role</label>
                   <select id="role" name="role" required>
                       <option value="">Select Role</option>
                       <option value="Admin">Admin</option>
                       <option value="Manager">Manager</option>
                       <option value="Staff">Staff</option>
                   </select>
               </div>              
               <div class="mt-6 flex justify-end">
                   <button type="button" class="action-btn mr-3" data-close="addUserModal">Cancel</button>
                   <button type="submit" class="action-btn btn-primary">Add User</button>
               </div>
           </form>
       </div>
   </div>
  
   <!-- Remove User Modal -->
   <div id="removeUserModal" class="modal">
       <div class="modal-content">
           <span class="close-btn" data-modal="removeUserModal">&times;</span>
           <h3 class="text-xl font-semibold mb-4">Remove User</h3>
           <form id="removeUserForm" action="DeleteUserServlet" method="get">
               <div class="form-group">
                   <label for="userId">User ID</label>
                   <input type="text" id="userId" name="userId" required>
               </div>
               <div class="mt-6 flex justify-end">
                   <button type="button" class="action-btn mr-3" data-close="removeUserModal">Cancel</button>
                   <button type="submit" class="action-btn btn-primary">Remove User</button>
               </div>
           </form>
       </div>
   </div>
  
   <!-- Edit User Modal -->
   <div id="editUserModal" class="modal">
       <div class="modal-content">
           <span class="close-btn" data-modal="editUserModal">&times;</span>
           <h3 class="text-xl font-semibold mb-4">Edit User</h3>
           <form id="editUserForm" action="UpdateUserServlet" method="post">
               <div class="form-group">
                   <label for="editUserId">User ID</label>
                   <input type="text" id="editUserId" name="userId" required>
               </div>
               <div class="form-group">
                   <label for="editFullName">Full Name</label>
                   <input type="text" id="editFullName" name="username">
               </div>
               <div class="form-group">
                   <label for="editEmail">Email</label>
                   <input type="email" id="editEmail" name="email">
               </div>
               <div class="form-group">
                   <label for="editPassword">Password</label>
                   <input type="password" id="editPassword" name="password" placeholder="Leave blank to keep current password">
               </div>
               <div class="form-group">
                   <label for="editRole">Role</label>
                   <select id="editRole" name="role">
                       <option value="">Select Role</option>
                       <option value="Admin">Admin</option>
                       <option value="Manager">Manager</option>
                       <option value="Staff">Staff</option>
                   </select>
               </div>
               <div class="form-group">
                   <label for="editStatus">Status</label>
                   <select id="editStatus" name="status">
                       <option value="">Select Status</option>
                       <option value="Active">Active</option>
                       <option value="Inactive">Inactive</option>
                   </select>
               </div>
               <div class="mt-6 flex justify-end">
                   <button type="button" class="action-btn mr-3" data-close="editUserModal">Cancel</button>
                   <button type="submit" class="action-btn btn-primary">Update User</button>
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
       const manageUsersBtn = document.getElementById('manageUsersBtn');
       const usersDropdown = document.getElementById('usersDropdown');
      
       manageUsersBtn.addEventListener('click', function() {
           usersDropdown.classList.toggle('show');
       });
      
       // Close dropdown when clicking outside
       window.addEventListener('click', function(event) {
           if (!event.target.closest('#manageUsersBtn') && usersDropdown.classList.contains('show')) {
               usersDropdown.classList.remove('show');
           }
       });
      
       // Modal functionality
       const addUserBtn = document.getElementById('addUserBtn');
       const removeUserBtn = document.getElementById('removeUserBtn');
       const editUserBtn = document.getElementById('editUserBtn');
       const addUserModal = document.getElementById('addUserModal');
       const removeUserModal = document.getElementById('removeUserModal');
       const editUserModal = document.getElementById('editUserModal');
       const closeBtns = document.querySelectorAll('.close-btn');
       const closeModalBtns = document.querySelectorAll('[data-close]');
      
       // Open modals
       addUserBtn.addEventListener('click', function() {
           addUserModal.style.display = 'block';
           usersDropdown.classList.remove('show');
       });
      
       removeUserBtn.addEventListener('click', function() {
           removeUserModal.style.display = 'block';
           usersDropdown.classList.remove('show');
       });
      
       editUserBtn.addEventListener('click', function() {
           editUserModal.style.display = 'block';
           usersDropdown.classList.remove('show');
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
           if (event.target === addUserModal) {
               addUserModal.style.display = 'none';
           }
           if (event.target === removeUserModal) {
               removeUserModal.style.display = 'none';
           }
           if (event.target === editUserModal) {
               editUserModal.style.display = 'none';
           }
       });
      
       // Pagination functionality
       const currentPageInput = document.getElementById('currentPageInput');
       const prevPageBtn = document.getElementById('prevPageBtn');
       const nextPageBtn = document.getElementById('nextPageBtn');
      
       const totalPages = <%= totalPages == 0 ? 1 : totalPages %>;
      
       // Handle previous page button click
       prevPageBtn.addEventListener('click', function() {
           let currentPage = parseInt(currentPageInput.value);
           if (currentPage > 1) {
               navigateToPage(currentPage - 1);
           }
       });
      
       // Handle next page button click
       nextPageBtn.addEventListener('click', function() {
           let currentPage = parseInt(currentPageInput.value);
           if (currentPage < totalPages) {
               navigateToPage(currentPage + 1);
           }
       });
      
       // Handle page input change
       currentPageInput.addEventListener('change', function() {
           let value = parseInt(currentPageInput.value);
           if (isNaN(value) || value < 1) {
               currentPageInput.value = 1;
               value = 1;
           } else if (value > totalPages) {
               currentPageInput.value = totalPages;
               value = totalPages;
           }
          
           navigateToPage(value);
       });
      
       // Function to navigate to the specified page
       function navigateToPage(pageNumber) {
           window.location.href = 'Users.jsp?page=' + pageNumber;
       }
      
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


