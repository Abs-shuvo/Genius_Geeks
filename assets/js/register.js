// assets/js/register.js
document.getElementById('registerForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const data = {
        full_name: document.getElementById('full_name').value,
        email: document.getElementById('email').value,
        username: document.getElementById('username').value,
        password: document.getElementById('password').value,
        phone: document.getElementById('phone').value,
        role: document.getElementById('role').value
    };

    if (!data.role) {
        showAlert('danger', 'Please select role');
        return;
    }

    const btn = this.querySelector('button');
    btn.disabled = true;
    btn.textContent = 'Registering...';

    try {
        const res = await fetch('api/register.php', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        });

        const result = await res.json();

        if (result.success) {
            showAlert('success', result.message);
            setTimeout(() => window.location.href = 'login.html', 2000);
        } else {
            showAlert('danger', result.message);
            btn.disabled = false;
            btn.textContent = 'Register';
        }
    } catch(e) {
        showAlert('danger', 'Error: ' + e.message);
        btn.disabled = false;
        btn.textContent = 'Register';
    }
});

function showAlert(type, msg) {
    document.getElementById('alert-container').innerHTML = 
        '<div class="alert alert-'+type+' alert-dismissible fade show">'+msg+
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
}
