<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Edit SubCategory | Expense Tracker</title>

<jsp:include page="AdminCSS.jsp"></jsp:include>

</head>

<body>

<div class="container-scroller">

<jsp:include page="AdminHeader.jsp"></jsp:include>

<div class="container-fluid page-body-wrapper">

<jsp:include page="AdminLeftSidebar.jsp"></jsp:include>

<div class="main-panel">

<div class="content-wrapper">

<h3>Edit Sub-Category</h3>

<div class="card shadow-sm">

    <!-- ✅ SAME STYLE -->
    <div class="card-header bg-primary text-white">
        Edit Sub-Category
    </div>

    <div class="card-body">

        <form action="${ctx}/admin/updateSubCategory" method="post">

            <input type="hidden" name="subCategoryId"
                   value="${subCategory.subCategoryId}" />

            <div class="row">

                <!-- CATEGORY -->
                <div class="col-md-4">
                    <label>Category</label>

                    <select name="categoryId" class="form-select" required>

                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}"
                                ${cat.categoryId == subCategory.category.categoryId ? 'selected' : ''}>
                                ${cat.categoryName}
                            </option>
                        </c:forEach>

                    </select>
                </div>

                <!-- NAME -->
                <div class="col-md-4">
                    <label>Sub-Category Name</label>

                    <input type="text"
                           name="subCategoryName"
                           value="${subCategory.subCategoryName}"
                           class="form-control"
                           required>
                </div>

                <!-- BUTTON -->
                <div class="col-md-3 d-flex align-items-end">
                    <button class="btn btn-success rounded-pill">
                        Update Sub-Category
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