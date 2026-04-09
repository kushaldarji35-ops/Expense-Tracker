<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Edit Account</title>
<jsp:include page="UserCSS.jsp"/>
</head>

<body>

<div class="container-scroller">

<jsp:include page="UserHeader.jsp"/>
<div class="container-fluid page-body-wrapper">
<jsp:include page="UserLeftSidebar.jsp"/>

<div class="main-panel">
<div class="content-wrapper">

<h3>Edit Account</h3>

<div class="card">

<div class="card-header bg-primary text-white">
    Edit Account
</div>

<div class="card-body">

<form action="${ctx}/user/account/update" method="post">

<input type="hidden" name="accountId" value="${account.accountId}" />

<div class="row">

<div class="col-md-4">
<label>Title</label>
<input type="text" name="title" value="${account.title}" class="form-control"/>
</div>

<div class="col-md-4">
<label>Type</label>
<input type="text" name="accountType" value="${account.accountType}" class="form-control"/>
</div>

<div class="col-md-4">
<label>Balance</label>
<input type="number" value="${account.amount}" class="form-control" readonly/>
</div>

</div>

<br>

<button class="btn btn-success">
    Update Account
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