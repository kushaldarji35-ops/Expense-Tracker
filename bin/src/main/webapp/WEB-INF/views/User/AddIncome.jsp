<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Income | Expense Tracker</title>

<!-- USER CSS -->
<jsp:include page="UserCSS.jsp"></jsp:include>

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

                <h3 class="mb-2">Add Income</h3>
                <p class="text-muted mb-4">Record your income details</p>

                <div class="card">
                    <div class="card-header bg-primary text-white">
                        Income Details
                    </div>

                    <div class="card-body">

                       <form action="${pageContext.request.contextPath}/user/saveIncome" method="post">

                            <!-- ROW 1 -->
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label class="form-label">Title</label>
                                    <input type="text"
                                           name="title"
                                           class="form-control"
                                           placeholder="Salary / Bonus / Other"
                                           required>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Date</label>
                                    <input type="date"
                                           name="date"
                                           class="form-control"
                                           required>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Amount</label>
                                    <input type="number"
                                           name="amount"
                                           step="0.01"
                                           class="form-control"
                                           required>
                                </div>
                            </div>

                            <!-- ROW 2 -->
                            <div class="row mb-3">

                                <div class="col-md-4">
                                    <label class="form-label">Account</label>
                                    <select name="account.accountId"
                                            class="form-select"
                                            required>

                                        <option value="">Select Account</option>

                                        <c:forEach var="a" items="${accounts}">
                                            <option value="${a.accountId}">
                                                ${a.title}
                                            </option>
                                        </c:forEach>

                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Status</label>
                                    <select name="status.statusId"
                                            class="form-select"
                                            required>

                                        <option value="">Select Status</option>

                                        <c:forEach var="st" items="${statuses}">
                                            <option value="${st.statusId}">
                                                ${st.status}
                                            </option>
                                        </c:forEach>

                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Description</label>
                                    <input type="text"
                                           name="description"
                                           class="form-control"
                                           placeholder="Optional note">
                                </div>

                            </div>

                            <button type="submit" class="btn btn-success">
                                <i class="mdi mdi-content-save"></i> Save Income
                            </button>

                        </form>

                    </div>
                </div>

            </div>

            <!-- USER FOOTER -->
            <jsp:include page="UserFooter.jsp"></jsp:include>

        </div>
    </div>
</div>

<!-- USER JS -->
<jsp:include page="UserJS.jsp"></jsp:include>

</body>
</html>