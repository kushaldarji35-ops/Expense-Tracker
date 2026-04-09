<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Edit Vendor | Expense Tracker</title>

<jsp:include page="AdminCSS.jsp"></jsp:include>

</head>

<body>

<div class="container-scroller">

<jsp:include page="AdminHeader.jsp"></jsp:include>

<div class="container-fluid page-body-wrapper">

<jsp:include page="AdminLeftSidebar.jsp"></jsp:include>

<div class="main-panel">

<div class="content-wrapper">

<div class="row mb-4">
    <div class="col-md-12">
        <h3>Edit Vendor</h3>
        <p class="text-muted">Update vendor details</p>
    </div>
</div>

<div class="card shadow-sm">

    <!-- ✅ SAME UI -->
    <div class="card-header bg-primary text-white">
        Edit Vendor
    </div>

    <div class="card-body">

        <form action="${ctx}/admin/updateVendor" method="post">

            <!-- HIDDEN ID -->
            <input type="hidden" name="vendorId"
                   value="${vendor.vendorId}" />

            <div class="row">

                <div class="col-md-6">
                    <label class="form-label">Vendor Name</label>

                    <input type="text"
                           name="vendorName"
                           value="${vendor.vendorName}"
                           class="form-control"
                           required>
                </div>

                <div class="col-md-3 d-flex align-items-end">

                    <button class="btn btn-success btn-sm rounded-pill">
                        <i class="bi bi-pencil-square"></i>
                        Update Vendor
                    </button>

                </div>

            </div>

        </form>

    </div>

</div>

</div>

<jsp:include page="AdminFooter.jsp"></jsp:include>

</div>

</div>

</div>

<jsp:include page="AdminJS.jsp"></jsp:include>

</body>
</html>