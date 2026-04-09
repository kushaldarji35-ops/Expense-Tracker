<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>My Expenses | Expense Tracker</title>

<jsp:include page="UserCSS.jsp"></jsp:include>

</head>

<body>

<div class="container-scroller">

```
<jsp:include page="UserHeader.jsp"></jsp:include>

<div class="container-fluid page-body-wrapper">

    <jsp:include page="UserLeftSidebar.jsp"></jsp:include>

    <div class="main-panel">

        <div class="content-wrapper">

            <div class="row mb-4">
                <div class="col-md-12">
                    <h3>My Expenses</h3>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">

                    <div class="card shadow-sm">

                        <!-- UPDATED HEADER -->
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">

                            <span>Expense List</span>

                            <!-- Add New Expense Button -->
                            <a href="${pageContext.request.contextPath}/user/addExpense"
							   class="btn btn-success btn-sm">
							   + Add New Expense
							</a>

                        </div>

                        <div class="card-body">
                        
                        <c:if test="${param.success == 'added'}">
						    <div class="alert alert-success">Expense added successfully!</div>
						</c:if>
						
						<c:if test="${param.success == 'updated'}">
						    <div class="alert alert-success">Expense updated successfully!</div>
						</c:if>
						
						<c:if test="${param.success == 'deleted'}">
						    <div class="alert alert-danger">Expense deleted successfully!</div>
						</c:if>

                            <div class="table-responsive">
                          
                          
                          <form method="get"
						      action="${pageContext.request.contextPath}/user/expenseList"
						      class="row g-2 align-items-center mb-3">
						
						    <!-- SEARCH -->
						    <div class="col-md-5">
						        <input type="text"
						               name="keyword"
						               value="${keyword}"
						               placeholder="Search expense..."
						               class="form-control"/>
						    </div>
						
						    <!-- SORT -->
						    <div class="col-md-2">
						        <select name="sort" class="form-select">
						            <option value="">Sort</option>
						            <option value="asc" ${sort == 'asc' ? 'selected' : ''}>Low → High</option>
						            <option value="desc" ${sort == 'desc' ? 'selected' : ''}>High → Low</option>
						        </select>
						    </div>
						
						    <!-- STATUS -->
						    <div class="col-md-2">
						        <select name="status" class="form-select">
						            <option value="">All Status</option>
						            <option value="Paid" ${status == 'Paid' ? 'selected' : ''}>Paid</option>
						            <option value="Partial" ${status == 'Partial' ? 'selected' : ''}>Partial</option>
						            <option value="Unpaid" ${status == 'Unpaid' ? 'selected' : ''}>Unpaid</option>
						        </select>
						    </div>
						
						    <!-- BUTTON -->
						    <div class="col-md-2">
						        <button class="btn btn-primary w-100">Search</button>
						    </div>
						
						</form>
						
						
						<!-- ================= FILTER + PDF ================= -->
						
						<div style="display:flex; gap:10px; margin-bottom:15px; flex-wrap:wrap;">
						
						    <!-- Export Full PDF -->
						    <a href="${pageContext.request.contextPath}/user/expense/pdf"
							   class="btn"
							   style="background-color:#5A4FCF; color:white; border:none;">
							    Export Expense PDF
							</a>
						
						    <!-- Date Filter -->
						    <input type="date" id="startDate" class="form-control" style="width:200px;" />
						
						    <input type="date" id="endDate" class="form-control" style="width:200px;" />
						
						    <!-- Filter Button -->
						    <button onclick="downloadFilteredExpensePDF()" class="btn btn-primary">
						        Download Filtered PDF
						    </button>
						
						</div>
                                <table class="table table-bordered table-hover text-center align-middle">

                                    <thead class="table-light">
                                        <tr>
                                            <th>Sr. No</th>
                                            <th>Title</th>
                                            <th>Category</th>
                                            <th>Vendor</th>
                                            <th>Amount</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <!-- No expenses -->
                                        <c:if test="${empty expenses}">
                                            <tr>
                                                <td colspan="7" class="text-muted">
                                                    No expenses found
                                                </td>
                                            </tr>
                                        </c:if>

                                        <!-- Expense list -->
                                        <c:forEach var="e" items="${expenses}" varStatus="status">
                                            <tr>
                                                <td>${currentPage * 10 + status.index + 1}</td>
                                                <td>${e.title}</td>

                                                <td>${e.category.categoryName}</td>

                                                <td>${e.vendor.vendorName}</td>

                                                <td>₹ ${e.amount}</td>

                                                <td>${e.date}</td>

                                                <td>${e.status.status}</td>

                                                <td>

												    <a href="${pageContext.request.contextPath}/user/editExpense?expenseId=${e.expenseId}"
												       class="btn btn-warning btn-sm">
												        Edit
												    </a>
												
												    <a href="${pageContext.request.contextPath}/user/deleteExpense?expenseId=${e.expenseId}"
												       class="btn btn-danger btn-sm"
												       onclick="return confirm('Delete this expense?')">
												        Delete
												    </a>
												
												</td>

                                            </tr>
                                        </c:forEach>

                                    </tbody>

                                </table>

                            </div>

                        </div>

                    </div>

                </div>
            </div>

        </div>
        
        <c:if test="${totalPages > 1}">
    <nav class="mt-3">
        <ul class="pagination justify-content-center">

            <!-- PREVIOUS -->
            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/user/expenseList?page=${currentPage - 1}&keyword=${keyword}&sort=${sort}&status=${status}">
                    Previous
                </a>
            </li>

            <!-- PAGE NUMBERS -->
            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/user/expenseList?page=${i}&keyword=${keyword}&sort=${sort}&status=${status}">
                        ${i + 1}
                    </a>
                </li>
            </c:forEach>

            <!-- NEXT -->
            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/user/expenseList?page=${currentPage + 1}&keyword=${keyword}&sort=${sort}&status=${status}">
                    Next
                </a>
            </li>

        </ul>
    </nav>
</c:if>

        <jsp:include page="UserFooter.jsp"></jsp:include>

    </div>

</div>
</div>

<jsp:include page="UserJS.jsp"></jsp:include>

<script>
function downloadFilteredExpensePDF() {

    let start = document.getElementById("startDate").value;
    let end = document.getElementById("endDate").value;

    if (!start || !end) {
        alert("Please select both dates");
        return;
    }

    let url = "${pageContext.request.contextPath}/user/expense/pdf/filter?startDate=" 
                + start + "&endDate=" + end;

    window.open(url, "_blank");
}
</script>


</body>
</html>
