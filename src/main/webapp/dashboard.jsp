<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
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
    </style>
    <title>Admin Dashboard</title>
</head>
<body class="overflow-hidden">
    <div class="flex h-screen">
        <!-- Sidenav -->
        <div id="sidenav" class="w-80 h-screen flex-shrink-0 text-white font-bold p-4">
            <!-- Sidenav content here -->
            <div class="flex items-center">
            	<img src="img/mk.png" class="w-20 h-20 mr-3">
            	<h2 class="text-xl mb-4">Mellow Mist <br> Management</h2>
            </div>
            <hr class="mb-3 mt-3">
            <ul class="space-y-4">
                <li class="p-2 bg-[#efe5bd] text-black rounded-xl flex items-center">
                	<a href="#" class="flex items-center">
                		<img src="img/speedometer.png" class="w-6 h-6 mr-3"><span>Dashboard</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="#" class="flex items-center">
                		<img src="img/shopping-basket.png" class="w-6 h-6 mr-3"><span>Orders</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="#" class="flex items-center">
                		<img src="img/document.png" class="w-6 h-6 mr-3"><span>Queue</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="#" class="flex items-center">
                		<img src="img/delivery-box.png" class="w-6 h-6 mr-3"><span>Inventory</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="#" class="flex items-center">
                		<img src="img/increase.png" class="w-6 h-6 mr-3"><span>Sales</span>
                	</a>
                </li>
                <li class="p-2 text-black hover:bg-opacity-20 hover:bg-[#efe5bd] rounded hover:text-black hover: rounded-xl flex items-center">
                	<a href="#" class="flex items-center">
                		<img src="img/search-profile.png" class="w-6 h-6 mr-3"><span>Manage Users</span>
                	</a>
                </li>
            </ul>
        </div>
        
        <!-- Main content area -->
        <div class="flex flex-col flex-grow">
            <!-- Topnav -->
            <div id="topnav" class="w-full h-32 shadow-2xl flex items-center p-6">
                <!-- Topnav content here -->
                <div class=" flex items-center ml-auto">                	
                	<div class="w-1 h-22 bg-zinc-400 rounded-xl mr-6"></div>
                	<h1 class="text-l font-bold mr-3">Admin</h1> 
                	<img src="img/admin.png" class="w-10 h-10 ml-3 mr-3">
                </div>            
            </div>
            
            <!-- Dashboard content -->
            <div id="dashboardcontent" class="p-6 overflow-auto h-full">
                <!-- Dashboard content here -->
                <div class="p-6">
                    <h2 class="text-xl font-bold mb-4">Dashboard</h2>               
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div id="dashboardcontentcards" class="rounded-lg shadow-md p-6 flex overflow-hidden relative">
						<div class="absolute left-0 top-0 bottom-0 w-3 bg-amber-200"></div>
							<div class="flex-1">
								<div class="flex items-center">
							    	<h3 class="font-bold mb-2">Sales Today</h3>
							    	<img src="img/report.png" class="h-10 w-10 ml-auto">
							    </div>
							    <p>P10,000</p> <!-- sales today Placeholder -->
							</div>
						</div>
                    <div id="dashboardcontentcards" class="rounded-lg shadow-md p-6 flex overflow-hidden relative">
                     <div class="absolute left-0 top-0 bottom-0 w-3 bg-stone-500"></div>
                        <div class="flex-1">
                        	<div class="flex items-center">
	                        	<h3 class="font-bold mb-2">Pending Orders</h3>
	                        	<img src="img/timer.png" class="h-10 w-10 ml-auto">
	                        </div>
                        <p>10</p> <!-- pending orders placeholder -->
                        </div>
                    </div>
                    <div id="dashboardcontentcards" class="rounded-lg shadow-md p-6 flex overflow-hidden relative">
                    <div class="absolute left-0 top-0 bottom-0 w-3 bg-neutral-600"></div>
                        <div class="flex-1">
                        	<div class="flex items-center">
	                        	<h3 class="font-bold mb-2">Total Orders</h3>
	                        	<img src="img/shopping-basket.png" class="h-10 w-10 ml-auto">
	                        </div>
	                        <p>100</p> <!-- total orders placeholder -->
                        </div>
                    </div>
                </div>
                
                <!-- line chart -->
                
                <div class="p-6">
                	<h1 class="text-xl font-bold">Sales Overview</h1>
                </div>
                <canvas id="myChart" class="border-2 border-black rounded-xl"></canvas>
                
                <script>
                	const xValues = ["11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM"];
					const yValues = [350,420,650,120,320,440,900,1200,901,400,200];
					
					new Chart("myChart", {
					  type: "line",
					  data: {
					    labels: xValues,
					    datasets: [{
					      fill: false,
					      lineTension: 0.4,
					      backgroundColor: "rgba(189, 155, 97,1.0)",
					      borderColor: "rgb(189, 155, 97)",
					      data: yValues
					    }]
					  },
					  options: {
					    legend: {display: false},
					    scales: {					    	
					      	yAxes: [{ticks: {min: 0, max:1400}}],
					    }
					  }
					});
				</script>
            </div>
        </div>
    </div>
</body>
</html>