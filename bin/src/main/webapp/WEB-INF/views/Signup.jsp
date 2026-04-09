<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>User Registration | Expense Tracker</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
rel="stylesheet">

<style>

/* Background */
body{
    background:#f4f6fb;
    font-family:"Segoe UI",sans-serif;
}

/* Animation */
@keyframes fadeSlide {
    from{
        opacity:0;
        transform: translateY(30px);
    }
    to{
        opacity:1;
        transform: translateY(0);
    }
}

/* Title */
.logo-title{
    font-weight:600;
    color:#4B49AC;
}

/* Card */
.register-card{
    border-radius:12px;
    border:none;
    animation: fadeSlide 0.6s ease;
}

/* Header */
.card-header{
    background:#4B49AC;
    color:white;
    font-weight:600;
    font-size:18px;
}

/* Button */
.btn-register{
    background:#4B49AC;
    border:none;
    font-weight:500;
}

.btn-register:hover{
    background:#3d3aa3;
}

/* Input focus */
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

<div class="col-lg-6 col-md-8 col-sm-12">

<h3 class="text-center mb-4 logo-title">
Expense Tracker
</h3>

<div class="card shadow register-card">

<div class="card-header text-center">
Create Your Account
</div>

<div class="card-body">

<form action="register" method="post" enctype="multipart/form-data">

<!-- FIRST NAME -->
<div class="mb-3">
<label class="form-label">First Name</label>
<div class="input-group">
<span class="input-group-text"><i class="bi bi-person"></i></span>
<input type="text" name="firstName" class="form-control" placeholder="Enter first name" required>
</div>
</div>

<!-- LAST NAME -->
<div class="mb-3">
<label class="form-label">Last Name</label>
<div class="input-group">
<span class="input-group-text"><i class="bi bi-person"></i></span>
<input type="text" name="lastName" class="form-control" placeholder="Enter last name" required>
</div>
</div>

<!-- EMAIL -->
<div class="mb-3">
<label class="form-label">Email Address</label>
<div class="input-group">
<span class="input-group-text"><i class="bi bi-envelope"></i></span>
<input type="email" name="email" class="form-control" placeholder="Enter email address" required>
</div>
</div>

<!-- PASSWORD -->
<div class="mb-3">
<label class="form-label">Password</label>
<div class="input-group">
<span class="input-group-text"><i class="bi bi-lock"></i></span>
<input type="password" name="password" class="form-control" placeholder="Create password" required>
</div>
</div>

<!-- GENDER -->
<div class="mb-3">
<label class="form-label d-block">Gender</label>

<div class="form-check form-check-inline">
<input class="form-check-input" type="radio" name="gender" value="Male" required>
<label class="form-check-label">Male</label>
</div>

<div class="form-check form-check-inline">
<input class="form-check-input" type="radio" name="gender" value="Female">
<label class="form-check-label">Female</label>
</div>

<div class="form-check form-check-inline">
<input class="form-check-input" type="radio" name="gender" value="Other">
<label class="form-check-label">Other</label>
</div>

</div>

<!-- DOB -->
<div class="mb-3">
<label class="form-label">Date of Birth</label>
<input type="date" name="birthDate" class="form-control" required>
</div>

<!-- MOBILE -->
<div class="mb-3">
<label class="form-label">Mobile Number</label>
<div class="input-group">
<span class="input-group-text"><i class="bi bi-telephone"></i></span>
<input type="text" name="contactNum" class="form-control" placeholder="Enter 10 digit mobile number"
pattern="[0-9]{10}" required>
</div>
</div>

<!-- PROFILE PIC -->
<div class="mb-3">
<label class="form-label">Profile Picture</label>
<input type="file" name="profilePic" class="form-control" accept="image/*">
</div>

<!-- BUTTON -->
<div class="d-grid">
<button type="submit" class="btn btn-register text-white">
Register Account
</button>
</div>

</form>

</div>

</div>

<!-- LOGIN LINK -->
<div class="text-center mt-3">
Already have an account?
<a href="login" style="color:#4B49AC; font-weight:500;">
Login Here
</a>
</div>

</div>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>