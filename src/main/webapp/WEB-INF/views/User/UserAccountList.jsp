<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>

<html>
<head>

<meta charset="UTF-8">
<title>My Account List | Expense Tracker</title>

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

            <h3 class="mb-2">My Account List</h3>
            <p class="text-muted mb-4">View and manage your accounts</p>

            <div class="card">

                <!-- CARD HEADER -->
                <div class="card-header d-flex justify-content-between align-items-center bg-primary text-white">

                    <span>My Accounts</span>

                    <!-- ADD NEW ACCOUNT BUTTON -->
                    <a href="${pageContext.request.contextPath}/user/account"
                       class="btn btn-success btn-sm">

                       + Add New Account

                    </a>

                </div>

                <div class="card-body">
                
                <!-- SUCCESS -->
				<c:if test="${param.success == 'added'}">
				    <div class="alert alert-success">Account added successfully!</div>
				</c:if>
				
				<c:if test="${param.success == 'updated'}">
				    <div class="alert alert-success">Account updated successfully!</div>
				</c:if>
				
				<c:if test="${param.success == 'deleted'}">
				    <div class="alert alert-danger">Account deleted successfully!</div>
				</c:if>
				
				<!-- ERROR -->
				<c:if test="${param.error == 'hasTransaction'}">
				    <div class="alert alert-warning">
				        Cannot delete account. Transactions exist!
				    </div>
				</c:if>
				
				<form method="get"
				      action="${pageContext.request.contextPath}/user/accountList"
				      class="mb-3 d-flex flex-wrap gap-2">
				
				    <!-- SEARCH -->
				    <input type="text"
				           name="keyword"
				           value="${keyword}"
				           placeholder="Search account..."
				           class="form-control me-2"
				           style="max-width: 200px;"/>
				
				    <!-- SORT -->
				    <select name="sort" class="form-select" style="max-width: 180px;">
				        <option value="">Sort By</option>
				        <option value="asc" ${sort == 'asc' ? 'selected' : ''}>Balance Low → High</option>
				        <option value="desc" ${sort == 'desc' ? 'selected' : ''}>Balance High → Low</option>
				    </select>
				
				    <!-- ACCOUNT TYPE FILTER -->
				    <select name="type" class="form-select" style="max-width: 180px;">
				        <option value="">All Types</option>
				        <option value="UPI" ${type == 'UPI' ? 'selected' : ''}>UPI</option>
				        <option value="Cash" ${type == 'Cash' ? 'selected' : ''}>Cash</option>
				        <option value="Debit Card" ${type == 'Debit Card' ? 'selected' : ''}>Debit Card</option>
				        <option value="Credit Card" ${type == 'Credit Card' ? 'selected' : ''}>Credit Card</option>
				    </select>
				
				    <button class="btn btn-primary">Apply</button>
				
				</form>

                    <table class="table table-bordered table-hover text-center align-middle">

                        <thead class="table-light">

                            <tr>
                                <th>S.No</th>
                                <th>Account Title</th>
                                <th>Account Type</th>
                                <th>Balance</th>
                                <th>Action</th>
                            </tr>

                        </thead>

                        <tbody>

                            <!-- If empty -->
                            <c:if test="${empty accounts}">
                                <tr>
                                    <td colspan="5">No accounts found</td>
                                </tr>
                            </c:if>

                            <!-- Account Loop -->
                            <c:forEach var="a" items="${accounts}" varStatus="i">

                                <tr>

                                    <!-- Serial Number -->
                                    <td>${currentPage * 10 + i.index + 1}</td>

                                    <td>${a.title}</td>
                                    <td>${a.accountType}</td>
                                    <td>₹ ${a.amount}</td>
                                    
                                 

                                    <td>

								    <a href="${pageContext.request.contextPath}/user/account/edit?accountId=${a.accountId}"
								       class="btn btn-warning btn-sm">
								        Edit
								    </a>
								
								    <a href="${pageContext.request.contextPath}/user/account/delete?accountId=${a.accountId}"
								       class="btn btn-danger btn-sm"
								       onclick="return confirm('Are you sure you want to delete this account?')">
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
        
		<c:if test="${totalPages > 1}">
		    <nav class="mt-3">
		        <ul class="pagination justify-content-center">
		
		            <!-- PREVIOUS -->
		            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
		                <a class="page-link"
		                   href="${pageContext.request.contextPath}/user/accountList?page=${currentPage - 1}&keyword=${keyword}&sort=${sort}&type=${type}">
		                    Previous
		                </a>
		            </li>
		
		            <!-- PAGE NUMBERS -->
		            <c:forEach begin="0" end="${totalPages - 1}" var="p">
		                <li class="page-item ${p == currentPage ? 'active' : ''}">
		                    <a class="page-link"
		                       href="${pageContext.request.contextPath}/user/accountList?page=${p}&keyword=${keyword}&sort=${sort}&type=${type}">
		                        ${p + 1}
		                    </a>
		                </li>
		            </c:forEach>
		
		            <!-- NEXT -->
		            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
		                <a class="page-link"
		                   href="${pageContext.request.contextPath}/user/accountList?page=${currentPage + 1}&keyword=${keyword}&sort=${sort}&type=${type}">
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

</div>

<!-- USER JS -->
<jsp:include page="UserJS.jsp"></jsp:include>

</body>
</html>