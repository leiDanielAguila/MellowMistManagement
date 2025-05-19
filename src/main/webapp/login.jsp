<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    </style>
    <title>Login</title>
</head>
<body>
    <!-- Background Container -->
    <div class="min-h-screen flex items-center justify-center bg-cover bg-center" 
         style="background-image: url('img/background.png')">
        
        <!-- Login Form -->
        <div class="bg-white bg-opacity-90 backdrop-blur-sm rounded-2xl p-8 max-w-md w-full mx-4 shadow-lg">
            <!-- Logo -->
            <div class="flex justify-center mb-8">
                <img src="img/logo.png" alt="Mellow Mist Logo" class="h-20">
            </div>

            <!-- Login Form -->
            <form class="space-y-6" method="post" action="ProcessLogin">
                <!-- Email Input -->
                <div>
                    <label for="username" class="block text-gray-700 text-sm font-medium mb-2">Username</label>
                    <input type="text" name="username"
                           class="w-full px-4 py-3 rounded-lg border focus:ring-2 focus:ring-[#f8d88b] focus:border-[#f8d88b] outline-none transition"
                           placeholder="Enter your username">
                </div>

                <!-- Password Input -->
                <div>
                    <label for="password" class="block text-gray-700 text-sm font-medium mb-2">Password</label>
                    <input type="password" name="password"
                           class="w-full px-4 py-3 rounded-lg border focus:ring-2 focus:ring-[#f8d88b] focus:border-[#f8d88b] outline-none transition"
                           placeholder="Enter your password">
                </div>
                
                <div class="flex items-center justify-between">
                	<div class="flex items-center">
                		<% if ("1".equals(request.getAttribute("error"))) { %>
		                <div class="block text-red-600 text-sm font-medium mb-2">Invalid username or password</div>
		            	<% } %>
                	</div>
                </div>

                <!-- Remember Me & Forgot Password -->
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input type="checkbox" class="rounded border-gray-300 text-[#f8d88b] focus:ring-[#f8d88b]">
                        <label class="ml-2 text-sm text-gray-600">Remember me</label>
                    </div>
                    <a href="#" class="text-sm text-[#f8d88b] hover:text-[#ecd075] transition">Forgot Password?</a>
                </div>

                <!-- Login Button -->
                <button type="submit" 
                        class="w-full bg-[#f8d88b] cursor-pointer hover:bg-[#ecd075] text-white py-3 rounded-full transition-colors duration-300">
                    Sign In
                </button>

            </form>
        </div>
    </div>
</body>
</html>