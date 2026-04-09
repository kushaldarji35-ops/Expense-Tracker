<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>Expense Tracker Admin</title>

<jsp:include page="AdminCSS.jsp"></jsp:include>

<style>
.dashboard-card {
    border-radius: 15px;
    color: #fff;
    padding: 20px;
    transition: 0.3s;
    height: 100%;              /* ✅ SAME HEIGHT */
    display: flex;
    flex-direction: column;
    justify-content: center;
}
.dashboard-card:hover { transform: translateY(-5px); }

/* colors */
.bg-users { background: linear-gradient(45deg, #6f42c1, #4e73df); }

/* ✅ UPDATED (better visible blue theme) */
.bg-accounts { background: linear-gradient(45deg, #0d6efd, #0b5ed7); }

.bg-income { background: linear-gradient(45deg, #1cc88a, #17a673); }
.bg-expense { background: linear-gradient(45deg, #e74a3b, #c0392b); }
.bg-balance { background: linear-gradient(45deg, #4e73df, #6f42c1); }
.bg-category { background: linear-gradient(45deg, #f6c23e, #dda20a); }

/* CHART FIX */
.chart-container {
    position: relative;
    height: 300px;
    width: 100%;
}
</style>

</head>

<body>

<div class="container-scroller">

<jsp:include page="AdminHeader.jsp"></jsp:include>

<div class="container-fluid page-body-wrapper">

<jsp:include page="AdminLeftSidebar.jsp"></jsp:include>

<div class="main-panel">
<div class="content-wrapper">

<!-- ================= WELCOME ================= -->
<h3>Welcome ${sessionScope.user.firstName}</h3>
<p class="text-muted">Track your income and expenses efficiently.</p>

<!-- ================= CARDS ================= -->
<div class="row">

<div class="col-md-3 mb-3">
<div class="dashboard-card bg-users">
<h6>Total Users</h6>
<h3>${totalUsers}</h3>
</div>
</div>

<div class="col-md-3 mb-3">
<div class="dashboard-card bg-accounts">
<h6>Total Accounts</h6>
<h3>${totalAccounts}</h3>
</div>
</div>

<div class="col-md-3 mb-3">
<div class="dashboard-card bg-income">
<h6>Total Income</h6>
<h3>₹ <fmt:formatNumber value="${totalIncome}" minFractionDigits="2"/></h3>
</div>
</div>

<div class="col-md-3 mb-3">
<div class="dashboard-card bg-expense">
<h6>Total Expense</h6>
<h3>₹ <fmt:formatNumber value="${totalExpense}" minFractionDigits="2"/></h3>
</div>
</div>

<div class="col-md-3 mb-3">
<div class="dashboard-card bg-balance">
<h6>Current Balance</h6>
<h3>₹ <fmt:formatNumber value="${currentBalance}" minFractionDigits="2"/></h3>
</div>
</div>

<div class="col-md-3 mb-3">
<div class="dashboard-card bg-category">
<h6>Top Category</h6>
<h4>${topCategoryName}</h4>
<small>₹ <fmt:formatNumber value="${topCategoryAmount}" minFractionDigits="2"/></small>
</div>
</div>

</div>

<!-- ================= FILTER ================= -->
<form method="get" action="${pageContext.request.contextPath}/admin/dashboard">
<div class="row mb-4">

<div class="col-md-2">
<select name="year" class="form-select" onchange="this.form.submit()">
<c:forEach var="y" begin="2022" end="2030">
<option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
</c:forEach>
</select>
</div>

<div class="col-md-3">
<select name="month" class="form-select" onchange="this.form.submit()">
<option value="1" ${selectedMonth==1?'selected':''}>January</option>
<option value="2" ${selectedMonth==2?'selected':''}>February</option>
<option value="3" ${selectedMonth==3?'selected':''}>March</option>
<option value="4" ${selectedMonth==4?'selected':''}>April</option>
<option value="5" ${selectedMonth==5?'selected':''}>May</option>
<option value="6" ${selectedMonth==6?'selected':''}>June</option>
<option value="7" ${selectedMonth==7?'selected':''}>July</option>
<option value="8" ${selectedMonth==8?'selected':''}>August</option>
<option value="9" ${selectedMonth==9?'selected':''}>September</option>
<option value="10" ${selectedMonth==10?'selected':''}>October</option>
<option value="11" ${selectedMonth==11?'selected':''}>November</option>
<option value="12" ${selectedMonth==12?'selected':''}>December</option>
</select>
</div>

<div class="col-md-3">
<select name="userId" class="form-select" onchange="this.form.submit()">
<option value="">All Users</option>
<c:forEach var="u" items="${users}">
<option value="${u.userId}" ${u.userId == selectedUser ? 'selected' : ''}>
${u.firstName}
</option>
</c:forEach>
</select>
</div>

</div>
</form>

<!-- ================= CHARTS ================= -->

<!-- 🔥 BAR FULL WIDTH -->
<div class="row">
<div class="col-md-12">
<div class="card shadow">
<div class="card-body">
<h5>Monthly Income vs Expense</h5>
<div class="chart-container">
<canvas id="barChart"></canvas>
</div>
</div>
</div>
</div>
</div>

<!-- 🔥 TWO PIE SIDE BY SIDE -->
<div class="row mt-3">

<div class="col-md-6">
<div class="card shadow">
<div class="card-body">
<h5>Category Wise (Year)</h5>
<div class="chart-container">
<canvas id="yearPieChart"></canvas>
</div>
</div>
</div>
</div>

<div class="col-md-6">
<div class="card shadow">
<div class="card-body">
<h5>Category Wise (Month)</h5>
<div class="chart-container">
<canvas id="monthPieChart"></canvas>
</div>
</div>
</div>
</div>

</div>

</div>

<jsp:include page="AdminFooter.jsp"></jsp:include>

</div>
</div>
</div>

<jsp:include page="AdminJS.jsp"></jsp:include>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

// SAFE DATA
const incomeData = [
<c:forEach var="i" items="${monthlyIncome}">
${i != null ? i : 0},
</c:forEach>
];

const expenseData = [
<c:forEach var="e" items="${monthlyExpense}">
${e != null ? e : 0},
</c:forEach>
];

// BAR
new Chart(document.getElementById('barChart'), {
type:'bar',
data:{
labels:['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
datasets:[
{label:'Income',data:incomeData,backgroundColor:'#1cc88a'},
{label:'Expense',data:expenseData,backgroundColor:'#e74a3b'}
]
},
options:{
responsive:true,
maintainAspectRatio:false
}
});

//✅ FIXED CATEGORY ORDER + COLOR
const categoryOrder = [
    'Food',
    'Transportation',
    'Bills',
    'Shopping',
    'Entertainment'
];

const categoryColorMap = {
    'Food': '#4e73df',
    'Transportation': '#1cc88a',
    'Bills': '#f6c23e',
    'Shopping': '#e74a3b',
    'Entertainment': '#36b9cc'
};

// ===== FUNCTION TO FORMAT DATA =====
function formatChartData(rawData) {
    let dataMap = {};

    // convert backend data to map
    rawData.forEach(item => {
        dataMap[item[0]] = item[1];
    });

    // create ordered data
    let labels = [];
    let data = [];
    let colors = [];

    categoryOrder.forEach(cat => {
        labels.push(cat);
        data.push(dataMap[cat] || 0); // if missing → 0
        colors.push(categoryColorMap[cat]);
    });

    return { labels, data, colors };
}

// ===== YEAR DATA =====
const yearRaw = [
<c:forEach var="c" items="${categoryYearData}">
['${c[0]}', ${c[1]}],
</c:forEach>
];

const yearFormatted = formatChartData(yearRaw);

new Chart(document.getElementById('yearPieChart'), {
type:'pie',
data:{
labels: yearFormatted.labels,
datasets:[{
    data: yearFormatted.data,
    backgroundColor: yearFormatted.colors
}]
},
options:{maintainAspectRatio:false}
});

// ===== MONTH DATA =====
const monthRaw = [
<c:forEach var="c" items="${categoryMonthData}">
['${c[0]}', ${c[1]}],
</c:forEach>
];

const monthFormatted = formatChartData(monthRaw);

new Chart(document.getElementById('monthPieChart'), {
type:'pie',
data:{
labels: monthFormatted.labels,
datasets:[{
    data: monthFormatted.data,
    backgroundColor: monthFormatted.colors
}]
},
options:{maintainAspectRatio:false}
});

</script>

</body>
</html>