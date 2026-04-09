<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Edit Category | Expense Tracker</title>

<!-- ================= ADMIN CSS ================= -->
<jsp:include page="AdminCSS.jsp"></jsp:include>

<style>
    /* 🔥 Extra UI Enhancement */
    .card {
        border-radius: 12px;
    }

    .btn {
        padding: 8px 18px;
        font-weight: 500;
    }
</style>

</head>

<body>

<div class="container-scroller">

    <!-- ================= HEADER ================= -->
    <jsp:include page="AdminHeader.jsp"></jsp:include>

    <div class="container-fluid page-body-wrapper">

        <!-- ================= SIDEBAR ================= -->
        <jsp:include page="AdminLeftSidebar.jsp"></jsp:include>

        <!-- ================= MAIN PANEL ================= -->
        <div class="main-panel">

            <div class="content-wrapper">

                <!-- ================= PAGE TITLE ================= -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h3>Edit Category</h3>
                        <p class="text-muted">Update category details</p>
                    </div>
                </div>

                <!-- ================= EDIT FORM ================= -->
                <div class="row">
                    <div class="col-md-12 grid-margin stretch-card">

                        <div class="card shadow-sm">

                            <!-- ✅ PURPLE HEADER (FIXED) -->
                            <div class="card-header bg-primary text-white">
                                Edit Category
                            </div>

                            <div class="card-body">

                                <form action="${ctx}/admin/updateCategory" method="post">

                                    <!-- 🔥 IMPORTANT (ID hidden) -->
                                    <input type="hidden" name="categoryId"
                                           value="${category.categoryId}" />

                                    <div class="row">

                                        <!-- CATEGORY NAME -->
                                        <div class="col-md-6">

                                            <label class="form-label">
                                                Category Name
                                            </label>

                                            <input type="text"
                                                   name="categoryName"
                                                   value="${category.categoryName}"
                                                   class="form-control"
                                                   placeholder="Enter category name"
                                                   required>

                                        </div>

                                        <!-- BUTTON -->
                                        <div class="col-md-3 d-flex align-items-end">

                                            <!-- ✅ GREEN BUTTON (FIXED) -->
                                            <button type="submit"
                                                    class="btn btn-success btn-sm rounded-pill">

                                                <i class="bi bi-pencil-square"></i>
                                                Update Category

                                            </button>

                                        </div>

                                    </div>

                                </form>

                            </div>

                        </div>

                    </div>
                </div>

            </div>

            <!-- ================= FOOTER ================= -->
            <jsp:include page="AdminFooter.jsp"></jsp:include>

        </div>

    </div>

</div>

<!-- ================= ADMIN JS ================= -->
<jsp:include page="AdminJS.jsp"></jsp:include>

</body>
</html>