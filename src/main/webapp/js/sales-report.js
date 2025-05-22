document.addEventListener('DOMContentLoaded', function() {
    // Initialize date pickers with default values
    const today = new Date();
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(today.getDate() - 7);
    
    document.getElementById('start-date').valueAsDate = oneWeekAgo;
    document.getElementById('end-date').valueAsDate = today;
    
    // Set up filter button
    document.querySelector('.filter-btn').addEventListener('click', function() {
        applyFilter();
    });
    
    // Set up pagination
    setupPagination();
    
    // Set up order detail view buttons
    setupOrderDetailButtons();
    
    // Set up export button
    document.querySelector('.export-btn').addEventListener('click', function() {
        exportReport();
    });
});

function setupPagination() {
    const pageInput = document.querySelector('.page-input');
    const totalPages = parseInt(document.getElementById('totalPages').value || '1');
    
    document.querySelector('.pagination button:first-of-type').addEventListener('click', function() {
        let currentPage = parseInt(pageInput.value);
        if (currentPage > 1) {
            pageInput.value = currentPage - 1;
            applyFilter();
        }
    });
    
    document.querySelector('.pagination button:last-of-type').addEventListener('click', function() {
        let currentPage = parseInt(pageInput.value);
        if (currentPage < totalPages) {
            pageInput.value = currentPage + 1;
            applyFilter();
        }
    });
    
    pageInput.addEventListener('change', function() {
        let value = parseInt(pageInput.value);
        if (isNaN(value) || value < 1) {
            pageInput.value = 1;
        } else if (value > totalPages) {
            pageInput.value = totalPages;
        }
        applyFilter();
    });
}

function setupOrderDetailButtons() {
    document.querySelectorAll('.view-details-btn').forEach(function(button) {
        button.addEventListener('click', function() {
            const orderId = this.getAttribute('data-order');
            showOrderDetails(orderId);
        });
    });
}

function showOrderDetails(orderId) {
    // AJAX request to get order details
    fetch('sales?action=getOrderDetails&orderId=' + orderId, {
        method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
        displayOrderDetailsModal(orderId, data);
    })
    .catch(error => {
        console.error('Error fetching order details:', error);
    });
}

function displayOrderDetailsModal(orderId, items) {
    const modal = document.getElementById('orderModal');
    const orderDetails = document.getElementById('orderDetails');
    
    // Get order information from the table row
    const orderRow = document.querySelector(`tr[data-orderid="${orderId}"]`);
    const date = orderRow.querySelector('td:nth-child(1)').textContent;
    const time = orderRow.querySelector('td:nth-child(2)').textContent;
    const payment = orderRow.querySelector('td:nth-child(5)').textContent.trim();
    const total = orderRow.querySelector('td:nth-child(4)').textContent;
    
    // Build modal HTML
    let detailsHTML = `
        <div class="mb-4">
            <p class="font-bold">Order No: ${orderId}</p>
            <p>Date: ${date}</p>
            <p>Time: ${time}</p>
            <p>Payment Method: ${payment}</p>
        </div>
        <hr class="my-4">
        <h4 class="font-bold mb-3">Items:</h4>
    `;
    
    items.forEach((item, index) => {
        detailsHTML += `
            <div class="order-item">
                <div class="flex justify-between">
                    <p class="font-medium">${index + 1}. ${item.productName}</p>
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
            <p>${total}</p>
        </div>
    `;
    
    orderDetails.innerHTML = detailsHTML;
    modal.style.display = 'block';
}

function applyFilter() {
    const startDate = document.getElementById('start-date').value;
    const endDate = document.getElementById('end-date').value;
    const page = document.querySelector('.page-input').value;
    
    // Create URL with filter parameters
    let url = 'sales?';
    if (startDate) url += `startDate=${startDate}&`;
    if (endDate) url += `endDate=${endDate}&`;
    if (page) url += `page=${page}`;
    
    // Navigate to filtered URL
    window.location.href = url;
}

function exportReport() {
    const startDate = document.getElementById('start-date').value;
    const endDate = document.getElementById('end-date').value;
    
    // Create URL for export with current filter
    let url = 'sales?action=exportReport';
    if (startDate) url += `&startDate=${startDate}`;
    if (endDate) url += `&endDate=${endDate}`;
    
    // For a real implementation, this would download a file
    // For now, just redirect to this URL
    window.location.href = url;
}
