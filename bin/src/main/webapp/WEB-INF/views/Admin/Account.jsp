<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>My Accounts | Expense Tracker</title>

<!-- ================= ADMIN CSS ================= -->
<jsp:include page="AdminCSS.jsp"/>

</head>

<body>

<div class="container-scroller">

    <!-- ================= HEADER ================= -->
    <jsp:include page="AdminHeader.jsp"/>

    <div class="container-fluid page-body-wrapper">

        <!-- ================= SIDEBAR ================= -->
        <jsp:include page="AdminLeftSidebar.jsp"/>

        <!-- ================= MAIN PANEL ================= -->
        <div class="main-panel">

            <div class="content-wrapper">

                <!-- PAGE TITLE -->
                <div class="row mb-3">
                    <div class="col-md-12">
                        <h3 class="font-weight-bold">Account Management</h3>
                        <p class="text-muted">Add and view your accounts</p>
                    </div>
                </div>

                <!-- ================= ADD ACCOUNT FORM ================= -->
                <div class="row">
                    <div class="col-md-12 grid-margin stretch-card">

                        <div class="card">

                            <div class="card-header bg-primary text-white">
                                Add New Account
                            </div>

                            <div class="card-body">

                                <form action="${pageContext.request.contextPath}/admin/account" method="post">

                                    <div class="row">

                                        <div class="col-md-3">
                                            <label class="form-label">Account Title</label>
                                            <input type="text" name="title" class="form-control" required>
                                        </div>

                                        <div class="col-md-3">
                                            <label class="form-label">Payment Type</label>
                                            <select name="accountType" class="form-control" required>
                                                <option value="">-- Select Type --</option>
                                                <option value="Cash">Cash</option>
                                                <option value="UPI">UPI</option>
                                                <option value="Credit Card">Credit Card</option>
                                                <option value="Debit Card">Debit Card</option>
                                                <option value="Net Banking">Net Banking</option>
                                                <option value="Other">Other</option>
                                            </select>
                                        </div>

                                        <div class="col-md-3">
                                            <label class="form-label">Initial Amount</label>
                                            <input type="number" 
                                               name="amount" 
                                               class="form-control" 
                                               step="0.01"
                                               min="0"
                                               placeholder="Enter amount"
                                               required>
                                        </div>

                                        <div class="col-md-3 d-flex align-items-end">
                                            <button class="btn btn-success">
                                                Add Account
                                            </button>
                                        </div>

                                        <c:if test="${param.error == 'invalidAmount'}">
                                            <div class="alert alert-danger">
                                                Amount cannot be negative!
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${param.error == 'hasBalance'}">
                                            <div class="alert alert-warning">
                                                Cannot delete account with balance!
                                            </div>
                                        </c:if>
                                    </div>

                                </form>

                            </div>

                        </div>

                    </div>
                </div>

            <!-- ================= FOOTER ================= -->
            <jsp:include page="AdminFooter.jsp"/>

        </div>

    </div>

</div>

<!-- ================= ADMIN JS ================= -->
<jsp:include page="AdminJS.jsp"/>

</body>
</html>