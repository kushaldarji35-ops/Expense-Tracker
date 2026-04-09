<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>My Accounts | Expense Tracker</title>

<!-- USER CSS -->
<jsp:include page="UserCSS.jsp"></jsp:include>

<style>
/* ✅ FIX FOOTER POSITION */
html, body {
    height: 100%;
}

.container-scroller {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

.page-body-wrapper {
    flex: 1;
    display: flex;
}

.main-panel {
    display: flex;
    flex-direction: column;
    flex: 1;
}

.content-wrapper {
    flex-grow: 1;
}
</style>

</head>

<body>

<div class="container-scroller">

    <!-- USER HEADER -->
    <jsp:include page="UserHeader.jsp"></jsp:include>

    <div class="container-fluid page-body-wrapper">

        <!-- USER SIDEBAR -->
        <jsp:include page="UserLeftSidebar.jsp"></jsp:include>

        <!-- MAIN PANEL -->
        <div class="main-panel">

            <div class="content-wrapper">

                <h3 class="mb-2">My Accounts</h3>
                <p class="text-muted mb-4">Manage your accounts</p>

                <!-- ================= ADD ACCOUNT ================= -->

                <div class="card mb-4">

                    <div class="card-header bg-primary text-white">
                        Add New Account
                    </div>

                    <div class="card-body">

                        <form action="${pageContext.request.contextPath}/user/account"
                              method="post">

                            <div class="row">

                                <div class="col-md-3">
                                    <label class="form-label">Account Title</label>
                                    <input type="text"
                                           name="title"
                                           class="form-control"
                                           placeholder="Example: Personal Wallet"
                                           required>
                                </div>

                                <div class="col-md-3">
                                    <label class="form-label">Payment Type</label>

                                    <select name="accountType"
                                            class="form-select"
                                            required>

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
                                           placeholder="0"
                                           required>
                                </div>

                                <div class="col-md-3 d-flex align-items-end">

                                    <button class="btn btn-success w-100">
                                        Add Account
                                    </button>

                                </div>

                            </div>

                        </form>

                    </div>

                </div>

            </div> <!-- ✅ content-wrapper END -->

            <!-- ✅ FOOTER NOW AT BOTTOM -->
            <jsp:include page="UserFooter.jsp"></jsp:include>

        </div> <!-- ✅ main-panel END -->

    </div>

</div>

<!-- USER JS -->
<jsp:include page="UserJS.jsp"></jsp:include>

</body>
</html>