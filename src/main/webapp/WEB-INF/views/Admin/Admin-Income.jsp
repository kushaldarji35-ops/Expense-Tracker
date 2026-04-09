<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Income | Admin</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body {
        background-color: #f4f6f9;
    }

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

	<jsp:include page="AdminHeader.jsp"></jsp:include>
	
<!-- ================= SIDEBAR ================= -->

	<jsp:include page="AdminLeftSidebar.jsp"></jsp:include>
	

<!-- ================= MAIN CONTENT ================= -->
<div class="content">

    <h3>All Income</h3>
    <p class="text-muted">View all user income records</p>

    <!-- ================= INCOME TABLE ================= -->
    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white">
            Income List
        </div>

        <div class="card-body">
            <table class="table table-bordered table-hover text-center">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>User</th>
                        <th>Account</th>
                        <th>Status</th>
                        <th>Amount (₹)</th>
                        <th>Date</th>
                        <th>Description</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="i" items="${incomes}">
                        <tr>
                            <td>${i.incomeId}</td>
                            <td>${i.title}</td>
                            <td>${i.user.firstName}</td>
                            <td>${i.account.title}</td>
                            <td>
                                <span class="badge bg-success">
                                    ${i.status.status}
                                </span>
                            </td>
                            <td>${i.amount}</td>
                            <td>${i.date}</td>
                            <td>${i.description}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty incomes}">
                        <tr>
                            <td colspan="8" class="text-muted">
                                No income records found
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ================= FOOTER ================= -->
    <footer>
        © 2026 Expense Tracker | Admin Income Module
    </footer>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
