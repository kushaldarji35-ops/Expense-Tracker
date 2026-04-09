<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Income</title>
<jsp:include page="UserCSS.jsp"/>
</head>

<body>

<div class="container-scroller">

<jsp:include page="UserHeader.jsp"/>
<div class="container-fluid page-body-wrapper">
<jsp:include page="UserLeftSidebar.jsp"/>

<div class="main-panel">
<div class="content-wrapper">

<h3>Edit Income</h3>

<div class="card shadow-sm">

<div class="card-header bg-primary text-white">
    Edit Income
</div>

<div class="card-body">

<form action="${ctx}/user/updateIncome" method="post">

<input type="hidden" name="incomeId" value="${income.incomeId}" />

<div class="row mb-3">

<div class="col-md-4">
<label>Title</label>
<input type="text" name="title" value="${income.title}" class="form-control"/>
</div>

<div class="col-md-4">
<label>Date</label>
<input type="date" name="date" value="${income.date}" class="form-control"/>
</div>

<div class="col-md-4">
<label>Amount</label>
<input type="number" name="amount" value="${income.amount}" class="form-control"/>
</div>

</div>

<div class="row mb-3">

<div class="col-md-4">
<label>Account</label>
<select name="account.accountId" class="form-select">

<c:forEach var="a" items="${accounts}">
<option value="${a.accountId}"
${a.accountId == income.account.accountId ? 'selected' : ''}>
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
${st.statusId == income.status.statusId ? 'selected' : ''}>
${st.status}
</option>
</c:forEach>

</select>
</div>

<div class="col-md-4">
<label>Description</label>
<input type="text" name="description" value="${income.description}" class="form-control"/>
</div>

</div>

<button class="btn btn-success">
    Update Income
</button>

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