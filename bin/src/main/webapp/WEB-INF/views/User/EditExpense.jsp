<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Expense</title>
<jsp:include page="UserCSS.jsp"/>
</head>

<body>

<div class="container-scroller">

<jsp:include page="UserHeader.jsp"/>
<div class="container-fluid page-body-wrapper">
<jsp:include page="UserLeftSidebar.jsp"/>

<div class="main-panel">
<div class="content-wrapper">

<h3>Edit Expense</h3>

<div class="card shadow-sm">

<div class="card-header bg-primary text-white">
    Edit Expense
</div>

<div class="card-body">

<form action="${ctx}/user/updateExpense" method="post">

<c:if test="${not empty error}">
    <div class="alert alert-danger text-center">
        ${error}
    </div>
</c:if>

<input type="hidden" name="expenseId" value="${expense.expenseId}" />

<div class="row mb-3">

<div class="col-md-4">
<label>Title</label>
<input type="text" name="title" value="${expense.title}" class="form-control"/>
</div>

<div class="col-md-4">
<label>Date</label>
<input type="date" name="date" value="${expense.date}" class="form-control"/>
</div>

<div class="col-md-4">
<label>Amount</label>
<input type="number" name="amount" value="${expense.amount}" class="form-control"/>
</div>

</div>

<div class="row mb-3">

<div class="col-md-4">
<label>Category</label>
<select name="category.categoryId" class="form-select">
<c:forEach var="c" items="${categories}">
<option value="${c.categoryId}"
${c.categoryId == expense.category.categoryId ? 'selected' : ''}>
${c.categoryName}
</option>
</c:forEach>
</select>
</div>

<div class="col-md-4">
<label>SubCategory</label>
<select name="subCategory.subCategoryId" class="form-select">
<c:forEach var="s" items="${subCategories}">
<option value="${s.subCategoryId}"
${s.subCategoryId == expense.subCategory.subCategoryId ? 'selected' : ''}>
${s.subCategoryName}
</option>
</c:forEach>
</select>
</div>

<div class="col-md-4">
<label>Vendor</label>
<select name="vendor.vendorId" class="form-select">
<c:forEach var="v" items="${vendors}">
<option value="${v.vendorId}"
${v.vendorId == expense.vendor.vendorId ? 'selected' : ''}>
${v.vendorName}
</option>
</c:forEach>
</select>
</div>

</div>

<div class="row mb-3">

<div class="col-md-4">
<label>Account</label>
<select name="account.accountId" class="form-select">
<c:forEach var="a" items="${accounts}">
<option value="${a.accountId}"
${a.accountId == expense.account.accountId ? 'selected' : ''}>
${a.title}
</option>
</c:forEach>
</select>
</div>

<div class="col-md-4">
<label>Status</label>
<select name="status.statusId" class="form-select">
<c:forEach var="st" items="${statuses}">
<option value="${st.statusId}"
${st.statusId == expense.status.statusId ? 'selected' : ''}>
${st.status}
</option>
</c:forEach>
</select>
</div>

<div class="col-md-4">
<label>Description</label>
<input type="text" name="description" value="${expense.description}" class="form-control"/>
</div>

</div>

<button class="btn btn-success">Update Expense</button>

</form>

</div>

</div>

</div>

<jsp:include page="UserFooter.jsp"/>

</div>
</div>
</div>

<jsp:include page="UserJS.jsp"/>

</body>
</html>