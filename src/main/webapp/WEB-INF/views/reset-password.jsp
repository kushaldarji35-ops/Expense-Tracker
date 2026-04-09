<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Reset Password | Expense Tracker</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background:#f4f6fb;
    font-family:"Segoe UI";
}

/* Animation */
@keyframes fadeSlide {
    from{opacity:0; transform:translateY(25px);}
    to{opacity:1; transform:translateY(0);}
}

.card{
    border-radius:12px;
    animation:fadeSlide 0.5s ease;
}

.card-header{
    background:#4B49AC;
    color:white;
    font-weight:600;
}

/* Input focus */
.form-control:focus{
    border-color:#4B49AC;
    box-shadow:none;
}

/* Eye icon */
.password-toggle{
    cursor:pointer;
    position:absolute;
    right:15px;
    top:50%;
    transform:translateY(-50%);
}

/* Button */
.btn-main{
    background:#4B49AC;
}

.btn-main:hover{
    background:#3d3aa3;
}

</style>

</head>

<body>

<div class="container mt-5">
<div class="row justify-content-center">
<div class="col-md-5">

<h3 class="text-center mb-4" style="color:#4B49AC;">
Expense Tracker
</h3>

<div class="card shadow">

<div class="card-header text-center">
Reset Password
</div>

<div class="card-body">

<p class="text-muted text-center">
Create a new secure password
</p>

<form action="reset-password" method="post" onsubmit="return validatePassword()">

<!-- PASSWORD -->
<div class="mb-3 position-relative">
<input type="password" id="password" name="password"
class="form-control" placeholder="New Password" required minlength="6">

<span class="password-toggle" onclick="togglePassword('password')">👁️</span>
</div>

<!-- CONFIRM -->
<div class="mb-3 position-relative">
<input type="password" id="cpassword" name="cpassword"
class="form-control" placeholder="Confirm Password" required minlength="6">

<span class="password-toggle" onclick="togglePassword('cpassword')">👁️</span>
</div>

<div id="passwordError" class="text-danger"></div>

<c:if test="${param.error eq 'nomatch'}">
<div class="text-danger mt-2">Passwords do not match</div>
</c:if>

<c:if test="${param.error eq 'expired'}">
<div class="text-danger mt-2">Session expired. Try again.</div>
</c:if>

<c:if test="${not empty success}">
<div class="alert alert-success mt-2">${success}</div>
</c:if>

<div class="d-grid mt-3">
<button class="btn btn-main text-white">Update Password</button>
</div>

<div class="text-center mt-3">
<a href="login" style="color:#4B49AC;">Back to Login</a>
</div>

</form>

</div>
</div>

</div>
</div>
</div>

<script>

function togglePassword(id){
let field=document.getElementById(id);
field.type = field.type==="password" ? "text" : "password";
}

function validatePassword(){
let p=document.getElementById("password").value;
let c=document.getElementById("cpassword").value;
let err=document.getElementById("passwordError");

if(p!==c){
err.innerText="Passwords do not match";
return false;
}

err.innerText="";
return true;
}

</script>

</body>
</html>