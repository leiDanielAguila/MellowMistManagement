const modal = document.getElementById('orderModal');
        const closeBtn = document.querySelector('.close-btn');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const viewDetailsBtns = document.querySelectorAll('.view-details-btn');
        const orderDetails = document.getElementById('orderDetails');
        
        // Handle pagination
        const currentPage = parseInt(document.getElementById('currentPage').value);
        const totalPages = parseInt('${totalPages}');
        const prevPageBtn = document.getElementById('prevPage');
        const nextPageBtn = document.getElementById('nextPage');
        
        prevPageBtn.addEventListener('click', function() {
            if (currentPage > 1) {
                window.location.href = 'SalesServlet?page=' + (currentPage - 1) + getFilterParams();
            }
        });
        
        nextPageBtn.addEventListener('click', function() {
            if (currentPage < totalPages) {
                window.location.href = 'SalesServlet?page=' + (currentPage + 1) + getFilterParams();
            }
        });
        
        function getFilterParams() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            let params = '';
            
            if (startDate) {
                params += '&startDate=' + startDate;
            }
            
            if (endDate) {
                params += '&endDate=' + endDate;
            }
            
            return params;
        }
        
        // View details functionality
        viewDetailsBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const orderId = this.getAttribute('data-orderid');
                fetchOrderDetails(orderId);
            });
        });
        
		function fetchOrderDetails(orderId) {
		  fetch('SalesServlet', {
		    method: 'POST',
		    headers: {
		      'Content-Type': 'application/json'
		    },
		    body: JSON.stringify({
		      action: 'getOrderDetails',
		      orderId: orderId
		    })
		  })
		    .then(response => {
		      if (!response.ok) throw new Error(response.statusText);
		      return response.json();
		    })
		    .then(order => displayOrderDetails(order))
		    .catch(error => console.error('Error fetching order details:', error));
		}

        
        function displayOrderDetails(order) {
            let detailsHTML = `
                <div class="mb-4">
                    <p class="font-bold">Order No: ${order.orderNo}</p>
                    <p>Date: ${new Date(order.orderDate).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}</p>
                    <p>Time: ${order.orderTime}</p>
                    <p>Payment Method: ${order.paymentType}</p>
                </div>
                <hr class="my-4">
                <h4 class="font-bold mb-3">Items:</h4>
            `;
            
            order.forEach((item, index) => {
                detailsHTML += `
                    <div class="order-item">
                        <div class="flex justify-between">
                            <p class="font-medium">${index + 1}. ${item.name}</p>
                            <p class="font-medium">₱${item.price}</p>
                        </div>
                        <p class="text-sm text-gray-700">
                            ${item.size}, ${item.sweetness}, ${item.iceLevel}
                        </p>
                        <p class="text-sm text-gray-700">
                            Toppings: ${item.toppings.join(', ')}
                        </p>
                    </div>
                `;
            });
            
            detailsHTML += `
                <hr class="my-4">
                <div class="flex justify-between font-bold">
                    <p>Total:</p>
                    <p>₱${order.totalPrice}</p>
                </div>
            `;
            
            orderDetails.innerHTML = detailsHTML;
            modal.style.display = 'block';
        }
        
        // Export functionality
        document.getElementById('exportBtn').addEventListener('click', function() {
            window.location.href = 'SalesServlet?action=export' + getFilterParams();
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
		// Logout functionality
		const logoutBtn = document.getElementById('logoutBtn');
		const logoutConfirmModal = document.getElementById('logoutConfirmModal');
		const confirmLogoutBtn = document.getElementById('confirmLogoutBtn');

