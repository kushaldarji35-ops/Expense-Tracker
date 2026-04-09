<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Verify OTP | Expense Tracker</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

:root{
    --primary:#4B49AC;
}

body{
    background:#f4f6fb;
    font-family:"Segoe UI";
}

.card{
    border-radius:12px;
}

/* HEADER FIX (NO BLUE) */
.card-header{
    background:var(--primary);
    color:white;
    font-weight:600;
}

/* OTP BOX */
.otp-input{
    width:45px;
    height:50px;
    font-size:22px;
    text-align:center;
    margin:5px;
    border-radius:8px;
    border:1px solid #ccc;
}

.otp-input:focus{
    border-color:var(--primary);
    box-shadow:0 0 8px rgba(75,73,172,0.4);
    outline:none;
}

/* BUTTON */
.btn-main{
    background:var(--primary);
    color:white;
    border:none;
}

.btn-main:hover{
    background:#3d3aa3;
}

/* SHAKE */
@keyframes shake {
    0%{transform:translateX(0);}
    25%{transform:translateX(-5px);}
    50%{transform:translateX(5px);}
    75%{transform:translateX(-5px);}
    100%{transform:translateX(0);}
}

.shake{
    animation:shake 0.3s;
}

/* LOADER */
.loader{
    display:none;
}

/* TOAST */
.toast-container{
    position:fixed;
    top:20px;
    right:20px;
    z-index:9999;
}

</style>

</head>

<body>

<!-- 🔔 TOAST -->
<div class="toast-container">
    <div id="toastMsg" class="toast text-white border-0">
        <div class="d-flex">
            <div class="toast-body" id="toastText"></div>
            <button type="button" class="btn-close btn-close-white m-auto me-2" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<div class="container mt-5">
<div class="row justify-content-center">
<div class="col-md-5">

<h3 class="text-center mb-4" style="color:#4B49AC;">
Expense Tracker
</h3>

<div class="card shadow">

<div class="card-header text-center">
Verify OTP
</div>

<div class="card-body text-center">

<form id="otpForm" action="verify-otp" method="post">

<div id="otpBox" class="d-flex justify-content-center">

<input type="password" maxlength="1" class="otp-input" onkeyup="handleOTP(this,event)">
<input type="password" maxlength="1" class="otp-input" onkeyup="handleOTP(this,event)">
<input type="password" maxlength="1" class="otp-input" onkeyup="handleOTP(this,event)">
<input type="password" maxlength="1" class="otp-input" onkeyup="handleOTP(this,event)">
<input type="password" maxlength="1" class="otp-input" onkeyup="handleOTP(this,event)">
<input type="password" maxlength="1" class="otp-input" onkeyup="handleOTP(this,event)">

</div>

<input type="hidden" name="otp" id="finalOtp">

<div class="mt-4 d-grid">

<button id="verifyBtn" class="btn btn-main">

<span id="btnText">Verify OTP</span>
<span id="loader" class="spinner-border spinner-border-sm loader"></span>

</button>

</div>

<!-- TIMER -->
<div class="mt-3">
<span id="timerText">Resend OTP in 30s</span><br>
<a href="#" id="resendLink" style="display:none; color:#4B49AC;">Resend OTP</a>
</div>

</form>

</div>
</div>

</div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>

let inputs=document.querySelectorAll(".otp-input");

// 🔥 HANDLE INPUT
function handleOTP(current,event){

if(event.key==="Backspace" && current.value===""){
if(current.previousElementSibling){
current.previousElementSibling.focus();
}
return;
}

if(current.value.length===1){
if(current.nextElementSibling){
current.nextElementSibling.focus();
}
}

combineAndSubmit();
}

// 🔥 AUTO SUBMIT
function combineAndSubmit(){
let otp="";
inputs.forEach(i=>otp+=i.value);

if(otp.length===6){
document.getElementById("finalOtp").value=otp;

// loader
document.getElementById("btnText").style.display="none";
document.getElementById("loader").style.display="inline-block";
document.getElementById("verifyBtn").disabled=true;

document.getElementById("otpForm").submit();
}
}

// 🔥 PASTE SUPPORT
inputs[0].addEventListener("paste",function(e){
let paste=e.clipboardData.getData("text").trim();

if(paste.length===6){
for(let i=0;i<6;i++){
inputs[i].value=paste[i];
}
combineAndSubmit();
}
});

// 🔥 TIMER
let time=30;
let timerText=document.getElementById("timerText");
let resendLink=document.getElementById("resendLink");

let interval=setInterval(()=>{
time--;
timerText.innerText="Resend OTP in "+time+"s";

if(time<=0){
clearInterval(interval);
timerText.style.display="none";
resendLink.style.display="inline";
}
},1000);

// 🔥 TOAST FUNCTION
function showToast(msg,type="success"){
let toastEl=document.getElementById("toastMsg");
let toastText=document.getElementById("toastText");

toastText.innerText=msg;

toastEl.classList.remove("bg-success","bg-danger");
toastEl.classList.add(type==="error" ? "bg-danger" : "bg-success");

let toast=new bootstrap.Toast(toastEl);
toast.show();
}

// 🔥 AJAX RESEND (NO RELOAD)
resendLink.addEventListener("click",function(e){
e.preventDefault();

fetch("send-otp",{method:"POST"})
.then(()=>{

showToast("OTP Resent Successfully");

time=30;
timerText.style.display="inline";
resendLink.style.display="none";

interval=setInterval(()=>{
time--;
timerText.innerText="Resend OTP in "+time+"s";

if(time<=0){
clearInterval(interval);
timerText.style.display="none";
resendLink.style.display="inline";
}
},1000);

});
});

// 🔥 SHAKE ON ERROR
<c:if test="${not empty error}">
document.getElementById("otpBox").classList.add("shake");
showToast("${error}", "error");
</c:if>

</script>

</body>
</html>