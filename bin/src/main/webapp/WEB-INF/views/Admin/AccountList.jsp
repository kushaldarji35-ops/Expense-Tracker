<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- ================= CONTEXT PATH ================= -->
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<!-- ================= HEAD SECTION ================= -->
<head>
    <meta charset="UTF-8">
    <title>Account List | Expense Tracker</title>

    <!-- ===== COMMON ADMIN CSS ===== -->
    <jsp:include page="AdminCSS.jsp"></jsp:include>
</head>

<!-- ================= BODY SECTION ================= -->
<body>

<div class="container-scroller">

    <!-- ===== HEADER ===== -->
    <jsp:include page="AdminHeader.jsp"></jsp:include>

    <div class="container-fluid page-body-wrapper">

        <!-- ===== SIDEBAR ===== -->
        <jsp:include page="AdminLeftSidebar.jsp"></jsp:include>

        <!-- ================= MAIN PANEL ================= -->
        <div class="main-panel">

            <div class="content-wrapper">

                <!-- ===== PAGE TITLE ===== -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h3>Account List</h3>
                        <p class="text-muted">View and manage all accounts</p>
                    </div>
                </div>

                <!-- ================= ACCOUNT CARD ================= -->
                <div class="row">
                    <div class="col-md-12">

                        <div class="card shadow-sm">

                            <!-- ===== CARD HEADER ===== -->
                            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">

                                <span>
                                    <i class="ti-wallet mr-2"></i>
                                    All Accounts
                                </span>

                                <!-- ADD ACCOUNT BUTTON -->
                                <a href="${ctx}/admin/account"
                                   class="btn btn-success btn-sm rounded-pill">
                                   + Add New Account
                                </a>

                            </div>

                            <!-- ===== CARD BODY ===== -->
                            <div class="card-body">

                                <!-- ================= SUCCESS MESSAGE ================= -->
                                <c:if test="${param.success == 'updated'}">
								    <div class="alert alert-success">
								        Account Updated Successfully!
								    </div>
								</c:if>
								
								<c:if test="${param.success == 'deleted'}">
								    <div class="alert alert-danger">
								        Account Deleted Successfully!
								    </div>
								</c:if>
                                <c:if test="${param.success == 'added'}">
                                    <div class="alert alert-success">
                                        Account Added Successfully!
                                    </div>
                                </c:if>

                                <!-- ================= SEARCH BAR ================= -->
                                <form method="get"
                                      action="${ctx}/admin/accountList"
                                      class="mb-3 d-flex">

                                    <input type="text"
                                           name="keyword"
                                           value="${keyword}"
                                           placeholder="Search account..."
                                           class="form-control me-2"/>

                                    <button class="btn btn-primary">Search</button>

                                </form>

                                <!-- ================= TABLE ================= -->
                                <div class="table-responsive">

                                    <table class="table table-bordered table-hover text-center align-middle">

                                        <!-- ===== TABLE HEADER ===== -->
                                        <thead class="table-light">
                                            <tr>
                                                <th>Sr. No</th>
                                                <th>Account Title</th>
                                                <th>Account Type</th>
                                                <th>Balance</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>

                                        <!-- ===== TABLE BODY ===== -->
                                        <tbody>

                                            <!-- NO DATA -->
                                            <c:if test="${empty accounts}">
                                                <tr>
                                                    <td colspan="5">No accounts found</td>
                                                </tr>
                                            </c:if>

                                            <!-- DATA LOOP -->
                                            <c:forEach var="a" items="${accounts}" varStatus="status">

                                                <tr>

                                                    <!-- SERIAL NUMBER -->
                                                    <td>${currentPage * 10 + status.index + 1}</td>

                                                    <!-- ACCOUNT DETAILS -->
                                                    <td>${a.title}</td>
                                                    <td>${a.accountType}</td>

                                                    <!-- BALANCE -->
                                                    <td>
                                                        ₹
                                                        <c:choose>
                                                            <c:when test="${a.amount != null}">
                                                                ${a.amount}
                                                            </c:when>
                                                            <c:otherwise>
                                                                0.00
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- ACTION -->
                                                    <td>
													
													    <a href="${ctx}/admin/account/edit?accountId=${a.accountId}"
													       class="btn btn-warning btn-sm rounded-pill">
													        Edit
													    </a>
													
													    <a href="${ctx}/admin/account/delete?accountId=${a.accountId}"
													       class="btn btn-danger btn-sm rounded-pill"
													       onclick="return confirm('Are you sure?')">
													        Delete
													    </a>
													
													</td>

                                                </tr>

                                            </c:forEach>

                                        </tbody>

                                    </table>

                                </div>

                                <!-- ================= PAGINATION ================= -->
                                <c:if test="${totalPages > 1}">

                                    <nav class="mt-3">

                                        <ul class="pagination justify-content-center">

                                            <!-- PREVIOUS -->
                                            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                   href="${ctx}/admin/accountList?page=${currentPage - 1}&keyword=${keyword}">
                                                    Previous
                                                </a>
                                            </li>

                                            <!-- PAGE NUMBERS -->
                                            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link"
                                                       href="${ctx}/admin/accountList?page=${i}&keyword=${keyword}">
                                                        ${i + 1}
                                                    </a>
                                                </li>
                                            </c:forEach>

                                            <!-- NEXT -->
                                            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                   href="${ctx}/admin/accountList?page=${currentPage + 1}&keyword=${keyword}">
                                                    Next
                                                </a>
                                            </li>

                                        </ul>

                                    </nav>

                                </c:if>

                            </div>
                            <!-- ===== END CARD BODY ===== -->

                        </div>

                    </div>
                </div>

            </div>

            <!-- ===== FOOTER ===== -->
            <jsp:include page="AdminFooter.jsp"></jsp:include>

        </div>
        <!-- ===== END MAIN PANEL ===== -->

    </div>

</div>

<!-- ================= JS ================= -->
<jsp:include page="AdminJS.jsp"></jsp:include>

</body>
</html>