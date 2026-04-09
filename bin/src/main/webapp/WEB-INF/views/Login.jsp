<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Expense Tracker</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<!-- Lottie -->
<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>

<style>

:root {
    --primary: #4b49ac;
    --bg: #f5f6fa;
    --card: #ffffff;
}

body {
    background: var(--bg);
    font-family: 'Segoe UI';
}

/* Layout */
.main-container {
    display: flex;
    height: 100vh;
}

/* LEFT ANIMATION */
.left-side {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* RIGHT FORM */
.right-side {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
}

.login-card {
    width: 400px;
    background: white;
    padding: 35px;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.08);
    animation: slideIn 0.6s ease;
}

/* Animation */
@keyframes slideIn {
    from {opacity:0; transform: translateX(40px);}
    to {opacity:1; transform: translateX(0);}
}

/* 🔥 NEW PREMIUM LOGO */
.logo {
    text-align: center;
    margin-bottom: 20px;
}

.logo svg {
    width: 55px;
}

.logo-text {
    font-size: 22px;
    font-weight: 600;
}

/* Input with icon */
.input-box {
    position: relative;
    margin-bottom: 20px;
}

.input-box i {
    position: absolute;
    left: 10px;
    top: 12px;
    color: gray;
}

.form-control {
    padding-left: 35px;
    height: 45px;
}

/* Button */
.btn-login {
    background: var(--primary);
    color: white;
    height: 45px;
    border: none;
}

.btn-login:hover {
    background: #3d3aa3;
}

/* Links */
a {
    color: var(--primary);
}

/* Remember */
.remember {
    display: flex;
    justify-content: space-between;
    font-size: 14px;
}

</style>
</head>

<body>

<div class="main-container">

    <!-- 🎬 LOTTIE SIDE -->
    <div class="left-side">
        <lottie-player 
            src="https://assets2.lottiefiles.com/packages/lf20_jcikwtux.json"  
            background="transparent"  
            speed="1"  
            style="width: 350px;"  
            loop autoplay>
        </lottie-player>
    </div>

    <!-- 🔐 LOGIN SIDE -->
    <div class="right-side">
        <div class="login-card">

            <!-- 🔥 UPDATED PREMIUM LOGO -->
            <div class="logo">

                <svg viewBox="0 0 48 48">
                    
                    <!-- Background -->
                    <rect x="2" y="2" width="44" height="44" rx="10" fill="#4b49ac"/>
                    
                    <!-- Wallet -->
                    <rect x="10" y="18" width="28" height="16" rx="4" fill="white"/>
                    
                    <!-- Wallet top -->
                    <rect x="10" y="14" width="20" height="8" rx="3" fill="white"/>
                    
                    <!-- Growth Chart -->
                    <path d="M14 28 L20 24 L26 27 L34 20" 
                          stroke="#4b49ac" 
                          stroke-width="2.5" 
                          fill="none"
                          stroke-linecap="round"/>

                    <circle cx="34" cy="20" r="2" fill="#4b49ac"/>

                </svg>

                <div class="logo-text">ExpenseTracker</div>

            </div>

            <h4 class="text-center">Login</h4>
            <p class="text-center">Manage your expenses smartly</p>

            <form action="authenticate" method="post">

                <!-- Email -->
                <div class="input-box">
                    <i class="bi bi-envelope"></i>
                    <input type="email" name="email" class="form-control" placeholder="Email Address" required>
                </div>

                <!-- Password -->
                <div class="input-box">
                    <i class="bi bi-lock"></i>
                    <input type="password" name="password" class="form-control" placeholder="Password" required>
                </div>

                <!-- Remember -->
                <div class="remember mb-2">
                    <label><input type="checkbox"> Remember me</label>
                    <a href="forgot-password">Forgot?</a>
                </div>

                <div class="d-grid mb-3">
                    <button class="btn btn-login">Login</button>
                </div>

                <div class="text-center">
                    <a href="signup">Create account</a>
                </div>

                <span class="text-danger">${error}</span>

            </form>
        </div>
    </div>

</div>

</body>
</html>