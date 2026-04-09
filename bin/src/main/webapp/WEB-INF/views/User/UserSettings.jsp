<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>Settings | Expense Tracker</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
rel="stylesheet">

<style>

body{
    background:#f4f6fb;
    font-family:"Segoe UI",sans-serif;
}

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

.logo-title{
    font-weight:600;
    color:#4B49AC;
}

.settings-card{
    border-radius:12px;
    border:none;
    animation: fadeSlide 0.6s ease;
}

.card-header{
    background:#4B49AC;
    color:white;
    font-weight:600;
    font-size:18px;
}

.btn-main{
    background:#4B49AC;
    border:none;
    color:white;
}

.btn-main:hover{
    background:#3d3aa3;
}

.form-control:focus{
    border-color:#4B49AC;
    box-shadow:none;
}

.profile-img{
    border:3px solid #4B49AC;
    padding:3px;
}

</style>

</head>

<body>

<div class="container mt-5">

<h3 class="text-center mb-4 logo-title">Account Settings</h3>

<!-- SUCCESS / ERROR -->
<c:if test="${param.success == 'updated'}">
    <div class="alert alert-success text-center">Profile updated successfully!</div>
</c:if>

<c:if test="${param.success == 'password'}">
    <div class="alert alert-success text-center">Password changed successfully!</div>
</c:if>

<c:if test="${param.error == 'wrong'}">
    <div class="alert alert-danger text-center">Old password incorrect!</div>
</c:if>

<c:if test="${param.success == 'removed'}">
    <div class="alert alert-success text-center">
        Profile picture removed successfully!
    </div>
</c:if>

<div class="row justify-content-center">

<div class="col-lg-6">

<div class="card shadow settings-card">

<div class="card-header text-center">
Manage Your Account
</div>

<div class="card-body">

<!-- PROFILE IMAGE -->
<div class="text-center mb-4">

    <c:choose>
        <c:when test="${not empty user.profilePicURL}">
            <!-- ✅ CLOUDINARY IMAGE -->
            <img src="${user.profilePicURL}?t=${System.currentTimeMillis()}"
                 class="rounded-circle profile-img"
                 width="120" height="120"
                 style="object-fit: cover;">
        </c:when>
        <c:otherwise>
            <img src="${pageContext.request.contextPath}/assets/images/default-user.png"
                 class="rounded-circle profile-img"
                 width="120" height="120">
        </c:otherwise>
    </c:choose>

<div class="mt-3 text-center">

    <!-- File Input -->
    <form action="${pageContext.request.contextPath}/user/uploadProfilePic"
          method="post"
          enctype="multipart/form-data">

        <input type="file" name="profilePic" class="form-control mb-2" required>

        <div class="d-flex justify-content-center gap-2">

            <!-- Upload -->
            <button type="submit" class="btn btn-info btn-sm px-3">
                Upload
            </button>

    </form>

            <!-- Remove -->
            <form action="${pageContext.request.contextPath}/user/removeProfilePic"
                  method="post">

                <button type="submit" class="btn btn-danger btn-sm px-3">
                    Remove
                </button>

            </form>

        </div>

</div>

<!-- UPDATE PROFILE -->
<form action="${pageContext.request.contextPath}/user/updateProfile" method="post">

<div class="mb-3">
<label>First Name</label>
<input type="text" name="firstName" value="${user.firstName}" class="form-control" required>
</div>

<div class="mb-3">
<label>Last Name</label>
<input type="text" name="lastName" value="${user.lastName}" class="form-control">
</div>

<div class="mb-3">
<label>Email</label>
<input type="email" name="email" value="${user.email}" class="form-control" required>
</div>

<button class="btn btn-main w-100">
    <i class="bi bi-check-circle"></i> Update Profile
</button>

</form>

<hr>

<!-- CHANGE PASSWORD -->
<form action="${pageContext.request.contextPath}/user/changePassword" method="post">

<div class="mb-3">
<label>Old Password</label>
<input type="password" name="oldPassword" class="form-control" required>
</div>

<div class="mb-3">
<label>New Password</label>
<input type="password" name="newPassword" class="form-control" required>
</div>

<button class="btn btn-warning w-100">
    <i class="bi bi-shield-lock"></i> Change Password
</button>

</form>

<hr>

<!-- BUTTONS -->
<div class="d-flex justify-content-between">

<a href="${pageContext.request.contextPath}/user/dashboard"
   class="btn btn-outline-primary">
   ← Back
</a>

<a href="${pageContext.request.contextPath}/user/logout"
   class="btn btn-danger">
   Logout
</a>

</div>

</div>

</div>

</div>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>