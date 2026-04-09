<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Forgot Password | Expense Tracker</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>

/* Background */
body{
    background:#f4f6fb;
    font-family:"Segoe UI",sans-serif;
}

/* Animation */
@keyframes fadeSlide {
    from {opacity:0; transform: translateY(25px);}
    to {opacity:1; transform: translateY(0);}
}

/* Title */
.logo-title{
    font-weight:600;
    color:#4B49AC;
}

/* Card */
.forgot-card{
    border-radius:12px;
    border:none;
    animation: fadeSlide 0.5s ease;
}

/* Header */
.card-header{
    background:#4B49AC;
    color:white;
    font-weight:600;
}

/* Button */
.btn-main{
    background:#4B49AC;
    border:none;
}

.btn-main:hover{
    background:#3d3aa3;
}

/* Input */
.form-control:focus{
    border-color:#4B49AC;
    box-shadow:none;
}

/* Input with icon */
.input-group-text{
    background:white;
    border-right:none;
}

.form-control{
    border-left:none;
}

</style>

</head>

<body>

<div class="container mt-5">

<div class="row justify-content-center">

<div class="col-lg-5 col-md-7 col-sm-12">

<!-- Title -->
<h3 class="text-center mb-4 logo-title">
Expense Tracker
</h3>

<!-- Card -->
<div class="card shadow forgot-card">

<div class="card-header text-center">
Forgot Password
</div>

<div class="card-body">

<p class="text-muted text-center mb-4">
Enter your registered email to receive OTP
</p>

<!-- SUCCESS -->
<c:if test="${not empty success}">
    <div class="alert alert-success text-center">
        ${success}
    </div>
</c:if>

<!-- ERROR -->
<c:if test="${not empty error}">
    <div class="alert alert-danger text-center">
        ${error}
    </div>
</c:if>

<form action="send-otp" method="post">

<!-- EMAIL -->
<div class="mb-3">
<label class="form-label">Email Address</label>

<div class="input-group">
<span class="input-group-text">
<i class="bi bi-envelope"></i>
</span>

<input type="email"
name="email"
class="form-control"
placeholder="Enter registered email"
required>
</div>

</div>

<!-- BUTTON -->
<div class="d-grid">
<button type="submit"
class="btn btn-main text-white">

Send OTP

</button>
</div>

</form>

</div>

</div>

<!-- BACK -->
<div class="text-center mt-3">
<a href="login" style="color:#4B49AC; font-weight:500;">
← Back to Login
</a>
</div>

</div>

</div>

</div>

</body>
</html>