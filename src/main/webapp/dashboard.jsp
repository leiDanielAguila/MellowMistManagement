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
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
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

    /* Chart container styles */
    .chart-container {
      position: relative;
      height: 50vh;
      width: 100%;
    }

    /* Chart filter controls */
    .chart-controls {
      display: flex;
      justify-content: flex-end;
      gap: 1rem;
      margin-bottom: 1rem;
    }

    .chart-controls button {
      padding: 0.5rem 1rem;
      border-radius: 0.5rem;
      border: none;
      background-color: #bd9b61;
      color: white;
      cursor: pointer;
      transition: background-color 0.3s;
    }

    .chart-controls button:hover {
      background-color: #a58752;
    }

    .chart-controls button.active {
      background-color: #8c713e;
    }

    /* Loading indicator */
    .loading-overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(240, 234, 210, 0.7);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 10;
    }
    
    .hidden {
      display: none !important;
    }

    .loading-spinner {
      border: 4px solid rgba(189, 155, 97, 0.3);
      border-radius: 50%;
      border-top: 4px solid #bd9b61;
      width: 40px;
      height: 40px;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    /* Date picker styles */
    .date-picker {
      padding: 0.5rem;
      border-radius: 0.5rem;
      border: 1px solid #bd9b61;
      background-color: white;
    }
  </style>
  <title>Admin Dashboard</title>
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
        <li class="p-2 bg-[#efe5bd] text-black rounded-xl flex items-center">
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
      
      <!-- Dashboard content -->
      <div id="dashboardcontent" class="p-6 overflow-auto h-full">
        <!-- Dashboard content here -->
        <div class="p-2">
          <h2 class="text-[30px] mb-4">Dashboard</h2>               
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div id="dashboardcontentcards" class="rounded-lg shadow-md p-6 flex overflow-hidden relative">
            <div class="absolute left-0 top-0 bottom-0 w-3 bg-amber-200"></div>
            <div class="flex-1">
              <div class="flex items-center">
                <h3 class="font-bold mb-2">Sales Today</h3>
                <img src="img/report.png" class="h-10 w-10 ml-auto">
              </div>
              <p><%= request.getAttribute("salesToday") %></p> <!-- sales today Placeholder -->
            </div>
          </div>
          <div id="dashboardcontentcards" class="rounded-lg shadow-md p-6 flex overflow-hidden relative">
            <div class="absolute left-0 top-0 bottom-0 w-3 bg-stone-500"></div>
            <div class="flex-1">
              <div class="flex items-center">
                <h3 class="font-bold mb-2">Pending Orders</h3>
                <img src="img/timer.png" class="h-10 w-10 ml-auto">
              </div>
              <p><%= request.getAttribute("pendingOrders") %></p> <!-- pending orders placeholder -->
            </div>
          </div>
          <div id="dashboardcontentcards" class="rounded-lg shadow-md p-6 flex overflow-hidden relative">
            <div class="absolute left-0 top-0 bottom-0 w-3 bg-neutral-600"></div>
            <div class="flex-1">
              <div class="flex items-center">
                <h3 class="font-bold mb-2">Total Orders</h3>
                <img src="img/shopping-basket.png" class="h-10 w-10 ml-auto">
              </div>
              <p><%= request.getAttribute("totalOrders") %></p> <!-- total orders placeholder -->
            </div>
          </div>
        </div>
        
        <!-- Enhanced chart section -->
        <div class="p-6 mt-4 border-2 border-black rounded-xl relative">
          <div class="flex justify-between items-center mb-4">
            <h1 class="text-xl font-bold">Sales Overview</h1>
            <div class="chart-controls">
              <input type="date" id="datePicker" class="date-picker" title="Select date to view">
              <button id="viewToday" class="active">Today</button>
              <button id="viewWeek">This Week</button>
              <button id="toggleChartType">Toggle Chart Type</button>
            </div>
          </div>
          
          <div class="chart-container">
            <div id="loadingOverlay" class="loading-overlay hidden">
              <div class="loading-spinner"></div>
            </div>
            <canvas id="salesChart"></canvas>
          </div>
          
          <!-- Sales summary section -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-6">
            <div class="bg-amber-100 p-4 rounded-lg shadow">
              <h3 class="font-bold text-lg">Peak Hour</h3>
              <p id="peakHour">Loading...</p>
            </div>
            <div class="bg-amber-100 p-4 rounded-lg shadow">
              <h3 class="font-bold text-lg">Average Sales/Hour</h3>
              <p id="avgSales">Loading...</p>
            </div>
            <div class="bg-amber-100 p-4 rounded-lg shadow">
              <h3 class="font-bold text-lg">Total Transactions</h3>
              <p id="totalTransactions">Loading...</p>
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
          // Initialize variables
          let salesChart;
          let chartType = 'line';
          let currentViewMode = 'daily';
          
          // Parse initial data from server or use fallback data if there's an error
          let initialHours = ['11 AM', '12 PM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM', '6 PM', '7 PM', '8 PM', '9 PM'];
          let initialSalesData = [350, 420, 650, 120, 320, 440, 900, 1200, 901, 400, 200];
          
          try {
            const serverHours = <%= request.getAttribute("initialHours") %>;
            const serverSalesData = <%= request.getAttribute("initialSalesData") %>;
            
            if (serverHours && serverHours.length > 0) {
              initialHours = serverHours;
            }
            
            if (serverSalesData && serverSalesData.length > 0) {
              initialSalesData = serverSalesData;
            }
          } catch (error) {
            console.warn('Using fallback data because server data could not be parsed:', error);
          }
          
          // Initialize the chart on page load
          document.addEventListener('DOMContentLoaded', function() {
            initializeChart(initialHours, initialSalesData);
            updateSalesSummary(initialHours, initialSalesData);
            
            // Set date picker to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('datePicker').value = today;
            
            // Event listeners
            document.getElementById('viewToday').addEventListener('click', function() {
              setActiveButton(this);
              currentViewMode = 'daily';
              fetchDailyData(document.getElementById('datePicker').value);
            });
            
            document.getElementById('viewWeek').addEventListener('click', function() {
              setActiveButton(this);
              currentViewMode = 'weekly';
              fetchWeeklyData();
            });
            
            document.getElementById('toggleChartType').addEventListener('click', function() {
              chartType = chartType === 'line' ? 'bar' : 'line';
              
              // Just update the existing chart without fetching
              salesChart.config.type = chartType;
              salesChart.update();
            });
            
            document.getElementById('datePicker').addEventListener('change', function() {
              if (currentViewMode === 'daily') {
                fetchDailyData(this.value);
              }
            });
          });
          
          // Initialize chart
          function initializeChart(labels, data) {
            const ctx = document.getElementById('salesChart').getContext('2d');
            
            // Destroy previous chart if it exists
            if (salesChart) {
              salesChart.destroy();
            }
            
            salesChart = new Chart(ctx, {
              type: chartType,
              data: {
                labels: labels,
                datasets: [{
                  label: 'Sales (PHP)',
                  data: data,
                  fill: false,
                  backgroundColor: "rgba(189, 155, 97,0.4)",
                  borderColor: "rgb(189, 155, 97)",
                  borderWidth: 2,
                  pointBackgroundColor: "rgb(189, 155, 97)",
                  pointBorderColor: "#fff",
                  pointHoverBackgroundColor: "#fff",
                  pointHoverBorderColor: "rgb(189, 155, 97)",
                  lineTension: 0.4
                }]
              },
              options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                  yAxes: [{
                    ticks: {
                      beginAtZero: true,
                      callback: function(value) {
                        return 'P' + value;
                      }
                    },
                    scaleLabel: {
                      display: true,
                      labelString: 'Sales (PHP)'
                    }
                  }],
                  xAxes: [{
                    scaleLabel: {
                      display: true,
                      labelString: 'Time'
                    }
                  }]
                },
                tooltips: {
                  callbacks: {
                    label: function(tooltipItem, data) {
                      return 'Sales: P' + tooltipItem.yLabel;
                    }
                  }
                },
                legend: {
                  display: false
                },
                title: {
                  display: true,
                  text: 'Hourly Sales'
                }
              }
            });
            
            // Hide loading overlay if it was shown
            hideLoading();
          }
          
          // Fetch daily data
          function fetchDailyData(date) {
            // If there's no AJAX yet, use fallback data
            showLoading();
            
            // Simulate AJAX with timeout (in a real app, use the fetch calls)
            setTimeout(function() {
              // Generate random data for demonstration purposes
              const hours = initialHours;
              const randomData = hours.map(() => Math.floor(Math.random() * 1000) + 100);
              
              updateChart(hours, randomData, 'Hourly Sales - ' + formatDate(date));
              updateSalesSummary(hours, randomData);
              hideLoading();
            }, 1000);
            
            
            fetch('dashboard?action=getHourlySales&date=' + date)
              .then(response => response.json())
              .then(data => {
                updateChart(data.hours, data.salesData, 'Hourly Sales - ' + formatDate(date));
                updateSalesSummary(data.hours, data.salesData);
                hideLoading();
              })
              .catch(error => {
                console.error('Error fetching data:', error);
                // Use fallback data on error
                const hours = initialHours;
                const randomData = hours.map(() => Math.floor(Math.random() * 1000) + 100);
                updateChart(hours, randomData, 'Hourly Sales (Fallback Data)');
                updateSalesSummary(hours, randomData);
                hideLoading();
              });
            
          }
          
          // Fetch weekly data
          function fetchWeeklyData() {
            showLoading();
            
            // Simulate AJAX with timeout (in a real app, use the fetch calls)
            setTimeout(function() {
              // Generate random data for demonstration purposes
              const days = ['May 15', 'May 16', 'May 17', 'May 18', 'May 19', 'May 20', 'May 21'];
              const randomData = days.map(() => Math.floor(Math.random() * 5000) + 1000);
              
              updateChart(days, randomData, 'Weekly Sales Overview');
              updateSalesSummary(days, randomData);
              hideLoading();
            }, 1000);
            
            
            fetch('dashboard?action=getWeeklySales')
              .then(response => response.json())
              .then(data => {
                // Format dates for display
                const formattedDates = data.dates.map(date => formatDate(date));
                updateChart(formattedDates, data.salesData, 'Weekly Sales Overview');
                updateSalesSummary(formattedDates, data.salesData);
                hideLoading();
              })
              .catch(error => {
                console.error('Error fetching data:', error);
                // Use fallback data on error
                const days = ['May 15', 'May 16', 'May 17', 'May 18', 'May 19', 'May 20', 'May 21'];
                const randomData = days.map(() => Math.floor(Math.random() * 5000) + 1000);
                updateChart(days, randomData, 'Weekly Sales (Fallback Data)');
                updateSalesSummary(days, randomData);
                hideLoading();
              });
            
          }
          
          // Update chart with new data
          function updateChart(labels, data, title) {
            salesChart.data.labels = labels;
            salesChart.data.datasets[0].data = data;
            salesChart.options.title.text = title;
            salesChart.update();
          }
          
          // Format date for display
          function formatDate(dateStr) {
            const options = { month: 'short', day: 'numeric' };
            try {
              const date = new Date(dateStr);
              return date.toLocaleDateString('en-US', options);
            } catch (e) {
              return dateStr; // Return as is if parsing fails
            }
          }
          
          // Update sales summary section
          function updateSalesSummary(labels, data) {
            // Find peak hour
            let peakIndex = 0;
            let peakValue = 0;
            
            for (let i = 0; i < data.length; i++) {
              if (data[i] > peakValue) {
                peakValue = data[i];
                peakIndex = i;
              }
            }
            
            // Calculate average
            const totalSales = data.reduce((sum, value) => sum + value, 0);
            const avgSalesValue = data.length > 0 ? Math.round(totalSales / data.length) : 0;
            
            // Update DOM
            document.getElementById('peakHour').textContent = data.length > 0 ? 
              `${labels[peakIndex]} (P${peakValue})` : 'No data';
              
            document.getElementById('avgSales').textContent = `P${avgSalesValue}`;
            document.getElementById('totalTransactions').textContent = data.length > 0 ?
              data.length : 'No data';
          }
          
          // Set active button
          function setActiveButton(button) {
            // Remove active class from all buttons
            document.querySelectorAll('.chart-controls button').forEach(btn => {
              btn.classList.remove('active');
            });
            
            // Add active class to clicked button
            button.classList.add('active');
          }
          
          // Show loading overlay
          function showLoading() {
            document.getElementById('loadingOverlay').classList.remove('hidden');
          }
          
          // Hide loading overlay
          function hideLoading() {
            document.getElementById('loadingOverlay').classList.add('hidden');
          }
          
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
      </div>
    </div>
  </div>
</body>
</html>