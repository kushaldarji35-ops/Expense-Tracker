<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Manage Sub Categories | Admin</title>

    <!-- ================= ADMIN CSS ================= -->
    <jsp:include page="AdminCSS.jsp"></jsp:include>
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
                        <h3>Sub-Category Management</h3>
                        <p class="text-muted">Add and manage sub-categories</p>
                    </div>
                </div>

                <!-- ================= ADD SUB CATEGORY FORM ================= -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card shadow-sm mb-4">

                            <!-- FORM HEADER -->
                            <div class="card-header bg-primary text-white">
                                Add New Sub-Category
                            </div>

                            <!-- FORM BODY -->
                            <div class="card-body">

                                <form action="subCategory" method="post">

                                    <div class="row g-3">

                                        <!-- CATEGORY DROPDOWN -->
                                        <div class="col-md-4">
                                            <label class="form-label">Category</label>

                                            <select name="categoryId"
                                                    class="form-select"
                                                    required>

                                                <option value="">-- Select Category --</option>

                                                <c:forEach var="cat" items="${categories}">
                                                    <option value="${cat.categoryId}">
                                                        ${cat.categoryName}
                                                    </option>
                                                </c:forEach>

                                            </select>
                                        </div>

                                        <!-- SUB CATEGORY NAME -->
                                        <div class="col-md-4">
                                            <label class="form-label">Sub-Category Name</label>

                                            <input type="text"
                                                   name="subCategoryName"
                                                   class="form-control"
                                                   placeholder="Enter sub-category name"
                                                   required>
                                        </div>

                                        <!-- ADD BUTTON -->
                                        <div class="col-md-3 d-flex align-items-end">
                                            <button type="submit"
                                                    class="btn btn-success w-100">
                                                <i class="bi bi-plus-circle"></i>
                                                Add Sub-Category
                                            </button>
                                        </div>

                                    </div>

                                </form>

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