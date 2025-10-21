// assets/js/login.js
document.getElementById('loginForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const role = document.getElementById('role').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    if (!role) {
        showAlert('danger', 'Please select role');
        return;
    }

    const btn = this.querySelector('button');
    btn.disabled = true;
    btn.textContent = 'Logging in...';

    try {
        const res = await fetch('api/login.php', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({email, password, role})
        });

        const data = await res.json();

        if (data.success) {
            localStorage.setItem('user', JSON.stringify(data.user));
            showAlert('success', 'Login successful! Redirecting...');
            setTimeout(() => window.location.href = 'dashboard.html', 1000);
        } else {
            showAlert('danger', data.message);
            btn.disabled = false;
            btn.textContent = 'Login';
        }
    } catch(e) {
        showAlert('danger', 'Connection error. Check if XAMPP is running.');
        btn.disabled = false;
        btn.textContent = 'Login';
    }
});

function showAlert(type, msg) {
    document.getElementById('alert-container').innerHTML = 
        '<div class="alert alert-'+type+' alert-dismissible fade show">'+msg+
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
}
