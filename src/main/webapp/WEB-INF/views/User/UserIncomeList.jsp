<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>My Income | Expense Tracker</title>

<!-- USER CSS -->

<jsp:include page="UserCSS.jsp"></jsp:include>

</head>

<body>

<div class="container-scroller">

```
<!-- USER HEADER -->
<jsp:include page="UserHeader.jsp"></jsp:include>

<div class="container-fluid page-body-wrapper">

    <!-- USER SIDEBAR -->
    <jsp:include page="UserLeftSidebar.jsp"></jsp:include>

    <!-- MAIN PANEL -->
    <div class="main-panel">
        <div class="content-wrapper">

            <h3 class="mb-3">My Income</h3>

            <div class="card shadow-sm">

                <!-- UPDATED HEADER -->
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">

                    <span>Income List</span>

                    <!-- Add New Income Button -->
                    <a href="${pageContext.request.contextPath}/user/addIncome"
					   class="btn btn-success btn-sm">
					   + Add New Income
					</a>

                </div>

                <div class="card-body">
                
                <c:if test="${param.success == 'added'}">
					    <div class="alert alert-success">Income added successfully!</div>
					</c:if>
					
					<c:if test="${param.success == 'updated'}">
					    <div class="alert alert-success">Income updated successfully!</div>
					</c:if>
					
					<c:if test="${param.success == 'deleted'}">
					    <div class="alert alert-danger">Income deleted successfully!</div>
					</c:if>

                    <div class="table-responsive">
                    
                       <form method="get"
				      action="${pageContext.request.contextPath}/user/incomeList"
				      class="row g-2 align-items-center mb-3">
				
				    <!-- SEARCH -->
				    <div class="col-md-5">
				        <input type="text"
				               name="keyword"
				               value="${keyword}"
				               placeholder="Search income..."
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
				
				    <!-- STATUS FILTER -->
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
						   <a href="${pageContext.request.contextPath}/user/income/pdf"
							   class="btn"
							   style="background-color:#5A4FCF; color:white; border:none;">
							    Export Income PDF
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
                                    <th>Account</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>

                            <tbody>

                                <!-- No income -->
                                <c:if test="${empty incomes}">
                                    <tr>
                                        <td colspan="6" class="text-muted">
                                            No income records found
                                        </td>
                                    </tr>
                                </c:if>

                                <!-- Income list -->
                                <c:forEach var="i" items="${incomes}" varStatus="status">

                                    <tr>
                                        <td>${currentPage * 10 + status.index + 1}</td>
                                        <td>${i.title}</td>

                                        <td>${i.account.title}</td>

                                        <td>₹ ${i.amount}</td>

                                        <td>${i.date}</td>

                                        <td>${i.status.status}</td>

                                        <td>

										    <a href="${pageContext.request.contextPath}/user/editIncome?incomeId=${i.incomeId}"
										       class="btn btn-warning btn-sm">
										        Edit
										    </a>
										
										    <a href="${pageContext.request.contextPath}/user/deleteIncome?incomeId=${i.incomeId}"
										       class="btn btn-danger btn-sm"
										       onclick="return confirm('Delete this income?')">
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
        
       <c:if test="${totalPages > 1}">
    <nav class="mt-3">
        <ul class="pagination justify-content-center">

            <!-- PREVIOUS -->
            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/user/incomeList?page=${currentPage - 1}&keyword=${keyword}&sort=${sort}&status=${status}">
                    Previous
                </a>
            </li>

            <!-- PAGE NUMBERS -->
            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/user/incomeList?page=${i}&keyword=${keyword}&sort=${sort}&status=${status}">
                        ${i + 1}
                    </a>
                </li>
            </c:forEach>

            <!-- NEXT -->
            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/user/incomeList?page=${currentPage + 1}&keyword=${keyword}&sort=${sort}&status=${status}">
                    Next
                </a>
            </li>

        </ul>
    </nav>
</c:if>
        <!-- USER FOOTER -->
        <jsp:include page="UserFooter.jsp"></jsp:include>

    </div>

</div>
```

</div>

<!-- USER JS -->

<jsp:include page="UserJS.jsp"></jsp:include>

<script>
function downloadFilteredExpensePDF() {

    let start = document.getElementById("startDate").value;
    let end = document.getElementById("endDate").value;

    if (!start || !end) {
        alert("Please select both dates");
        return;
    }

    let url = "${pageContext.request.contextPath}/user/income/pdf/filter?startDate=" 
                + start + "&endDate=" + end;

    window.open(url, "_blank");
}
</script>

</body>
</html>
