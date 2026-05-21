// Form Validation
document.addEventListener('DOMContentLoaded', () => {
    const authForms = document.querySelectorAll('form');
    
    authForms.forEach(form => {
        form.addEventListener('submit', (e) => {
            const email = form.querySelector('input[type="email"]');
            const password = form.querySelector('input[type="password"]');
            const phone = form.querySelector('input[name="phone"]');

            if (email && !validateEmail(email.value)) {
                alert('Please enter a valid email address.');
                e.preventDefault();
            }

            if (password && password.value.length > 0 && password.value.length < 6) {
                alert('Password must be at least 6 characters long.');
                e.preventDefault();
            }

            if (phone && !validatePhone(phone.value)) {
                alert('Please enter a valid phone number (10 digits).');
                e.preventDefault();
            }
        });
    });

    // Table Filtering
    const searchInput = document.getElementById('tableSearch');
    if (searchInput) {
        searchInput.addEventListener('keyup', () => {
            const filter = searchInput.value.toLowerCase();
            const rows = document.querySelectorAll('.data-table tbody tr');
            
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(filter) ? '' : 'none';
            });
        });
    }
});

function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function validatePhone(phone) {
    return /^\d{10}$/.test(phone);
}

// Toast Notification System
function showToast(title, desc, type = 'success') {
    // Find or create toast container
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    
    // Create toast
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    const iconClass = type === 'success' ? 'fa-solid fa-circle-check' : 'fa-solid fa-circle-exclamation';
    
    toast.innerHTML = `
        <div class="toast-icon">
            <i class="${iconClass}"></i>
        </div>
        <div class="toast-content">
            <div class="toast-title">${title}</div>
            <div class="toast-desc">${desc}</div>
        </div>
        <button class="toast-close" onclick="this.parentElement.remove()">
            <i class="fa-solid fa-xmark"></i>
        </button>
        <div class="toast-progress"></div>
    `;
    
    container.appendChild(toast);
    
    // Auto remove after 4 seconds
    setTimeout(() => {
        toast.style.animation = 'toast-out 0.4s ease forwards';
        setTimeout(() => {
            toast.remove();
        }, 400);
    }, 4000);
}
