<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Expense Tracker User</title>

<jsp:include page="UserCSS.jsp"></jsp:include>

<style>
/* Chart Size Control */
.chart-container {
    position: relative;
    height: 280px;
}

.pie-container {
    height: 250px;
}
</style>

</head>

<body>

<div class="container-scroller">

    <jsp:include page="UserHeader.jsp"/>

    <div class="container-fluid page-body-wrapper">

        <jsp:include page="UserLeftSidebar.jsp"/>

        <div class="main-panel">
        <div class="content-wrapper">

            <!-- WELCOME -->
            <div class="row mb-3">
                <div class="col-md-12">
                    <h4 class="font-weight-bold">
                        Welcome ${sessionScope.user.firstName}
                    </h4>
                </div>
            </div>

            <!-- CARDS -->
            <div class="row mb-4">

                <div class="col-md-3">
                    <div class="card card-light-danger">
                        <div class="card-body">
                            <p>This Month Expenses</p>
                            <h4>₹ <fmt:formatNumber value="${monthExpense}" minFractionDigits="2"/></h4>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-dark-blue">
                        <div class="card-body">
                            <p>Quarterly Expenses</p>
                            <h4>₹ <fmt:formatNumber value="${quarterExpense}" minFractionDigits="2"/></h4>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-tale">
                        <div class="card-body">
                            <p>This Month Income</p>
                            <h4>₹ <fmt:formatNumber value="${monthIncome}" minFractionDigits="2"/></h4>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-light-blue">
                        <div class="card-body">
                            <p>Quarterly Income</p>
                            <h4>₹ <fmt:formatNumber value="${quarterIncome}" minFractionDigits="2"/></h4>
                        </div>
                    </div>
                </div>

            </div>

            <!-- BAR CHART -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5>Monthly Income vs Expense</h5>
                    <div class="chart-container">
                        <canvas id="sales-chart"></canvas>
                    </div>
                </div>
            </div>

            <!-- PIE CHART -->
            <div class="row">

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h6>Category Wise (Year)</h6>
                            <div class="pie-container">
                                <canvas id="yearPieChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h6>Category Wise (Month)</h6>
                            <div class="pie-container">
                                <canvas id="monthPieChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <jsp:include page="UserFooter.jsp"/>
        </div>

    </div>

</div>

<jsp:include page="UserJS.jsp"></jsp:include>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

// ===== MODERN COLORS =====
const incomeColor = "#22c55e";   // green
const expenseColor = "#ef4444";  // red

// BAR CHART
new Chart(document.getElementById('sales-chart'), {
    type: 'bar',
    data: {
        labels: ${monthsJson},
        datasets: [
            {
                label: 'Income',
                data: ${incomeList},
                backgroundColor: incomeColor,
                borderRadius: 8
            },
            {
                label: 'Expense',
                data: ${expenseList},
                backgroundColor: expenseColor,
                borderRadius: 8
            }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { position: 'top' }
        },
        scales: {
            x: { ticks: { autoSkip: false } },
            y: { beginAtZero: true }
        }
    }
});

// CATEGORY COLORS
const colors = {
    "Food": "#6366f1",
    "Transportation": "#10b981",
    "Bills": "#f59e0b",
    "Shopping": "#ef4444",
    "Entertainment": "#06b6d4"
};

function getColors(labels){
    return labels.map(l => colors[l] || "#9ca3af");
}

// YEAR PIE
new Chart(document.getElementById("yearPieChart"), {
    type: 'doughnut',
    data: {
        labels: ${yearCategoryLabels},
        datasets: [{
            data: ${yearCategoryData},
            backgroundColor: getColors(${yearCategoryLabels})
        }]
    },
    options: {
        maintainAspectRatio: false,
        cutout: "60%",
        onClick: (e, item) => {
            if(item.length){
                let cat = ${yearCategoryLabels}[item[0].index];
                window.location.href = "expenseList?category=" + cat;
            }
        }
    }
});

// MONTH PIE
new Chart(document.getElementById("monthPieChart"), {
    type: 'doughnut',
    data: {
        labels: ${monthCategoryLabels},
        datasets: [{
            data: ${monthCategoryData},
            backgroundColor: getColors(${monthCategoryLabels})
        }]
    },
    options: {
        maintainAspectRatio: false,
        cutout: "60%",
        onClick: (e, item) => {
            if(item.length){
                let cat = ${monthCategoryLabels}[item[0].index];
                window.location.href = "expenseList?category=" + cat;
            }
        }
    }
});

</script>

</body>
</html> 