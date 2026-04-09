<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | Expense Tracker</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body {
        background-color: #f4f6f9;
    }

    /* Sidebar */
    .sidebar {
        height: 100vh;
        background-color: #212529;
        color: #fff;
        position: fixed;
        width: 240px;
        top: 0;
        left: 0;
    }

    .sidebar a {
        color: #adb5bd;
        text-decoration: none;
        padding: 12px 20px;
        display: block;
    }

    .sidebar a:hover {
        background-color: #343a40;
        color: #fff;
    }

    .sidebar .active {
        background-color: #0d6efd;
        color: #fff;
    }

    /* Main content */
    .content {
        margin-left: 240px;
        margin-top:100px;
        padding: 20px;
    }

    footer {
        background-color: #fff;
        border-top: 1px solid #dee2e6;
        padding: 10px;
        text-align: center;
        margin-top: 30px;
    }
</style>
</head>

<body>

<!-- ================= HEADER ================= -->

  <%--  <jsp:include page="AdminHeader.jsp"></jsp:include>
   
<!-- ================= SIDEBAR ================= -->

	<jsp:include page="AdminLeftSidebar.jsp"></jsp:include>  --%>
<!-- ================= MAIN CONTENT ================= -->
<div class="content">

    <h3>Dashboard</h3>
    <p class="text-muted">System overview and statistics</p>

    <!-- ================= SUMMARY CARDS ================= -->
    <div class="row g-3 mb-4">

        <div class="col-md-3">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h6>Total Users</h6>
                    <h4>${totalUsers}</h4>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h6>Total Categories</h6>
                    <h4>${totalCategories}</h4>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h6>Total Expense</h6>
                    <h4 class="text-danger">₹ ${totalExpense}</h4>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h6>Total Income</h6>
                    <h4 class="text-success">₹ ${totalIncome}</h4>
                </div>
            </div>
        </div>

    </div>

    <!-- ================= RECENT EXPENSES ================= -->
    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white">
            Recent Expenses
        </div>

        <div class="card-body">
            <table class="table table-bordered table-hover text-center">
                <thead class="table-light">
                    <tr>
                        <th>Title</th>
                        <th>User</th>
                        <th>Category</th>
                        <th>Amount (₹)</th>
                        <th>Date</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="e" items="${recentExpenses}">
                        <tr>
                            <td>${e.title}</td>
                            <td>${e.user.firstName}</td>
                            <td>${e.category.categoryName}</td>
                            <td>${e.amount}</td>
                            <td>${e.date}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty recentExpenses}">
                        <tr>
                            <td colspan="5" class="text-muted">
                                No recent expenses found
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ================= FOOTER ================= -->
    <footer>
        © 2026 Expense Tracker | Admin Dashboard
    </footer>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
