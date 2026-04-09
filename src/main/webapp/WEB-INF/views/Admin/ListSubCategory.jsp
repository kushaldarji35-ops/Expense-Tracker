<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>List Sub-Categories | Expense Tracker</title>

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
                        <h3>All Sub-Categories</h3>
                        <p class="text-muted">Manage all sub-categories</p>
                    </div>
                </div>

                <div class="card shadow-sm">

                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">

                        <span>
                            <i class="ti-list mr-2"></i>
                            Sub-Category List
                        </span>

                        <a href="${ctx}/admin/subCategory"
                           class="btn btn-success btn-sm rounded-pill">
                           + Add New Sub-Category
                        </a>

                    </div>

                    <div class="card-body">
                    
                    <!-- ✅ SUCCESS MESSAGE -->
						<c:if test="${param.success == 'added'}">
						    <div class="alert alert-success">Sub-Category added successfully!</div>
						</c:if>
						
						<c:if test="${param.success == 'updated'}">
						    <div class="alert alert-success">Sub-Category updated successfully!</div>
						</c:if>
						
						<c:if test="${param.success == 'deleted'}">
						    <div class="alert alert-danger">Sub-Category deleted successfully!</div>
						</c:if>

                        <!-- 🔍 SEARCH -->
                        <form method="get" action="${ctx}/admin/listSubCategory" class="mb-3 d-flex">

                            <input type="text"
                                   name="keyword"
                                   value="${keyword}"
                                   placeholder="Search sub-category..."
                                   class="form-control me-2"/>

                            <button class="btn btn-primary">Search</button>

                        </form>

                        <div class="table-responsive">

                            <table class="table table-bordered table-hover text-center align-middle">

                                <thead class="table-light">
                                    <tr>
                                        <th>Sr. No</th>
                                        <th>Sub-Category Name</th>
                                        <th>Category</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:if test="${empty subCategories}">
                                        <tr>
                                            <td colspan="4">No sub-categories found</td>
                                        </tr>
                                    </c:if>

                                    <c:forEach var="s" items="${subCategories}" varStatus="status">

                                        <tr>

                                            <!-- ✅ SERIAL FIX -->
                                            <td>${currentPage * 10 + status.index + 1}</td>

                                            <td>${s.subCategoryName}</td>
                                            <td>${s.category.categoryName}</td>

                                            <td>

                                                <a href="${ctx}/admin/editSubCategory?subCategoryId=${s.subCategoryId}"
                                                   class="btn btn-warning btn-sm rounded-pill">
                                                    Edit
                                                </a>

                                                <a href="${ctx}/admin/deleteSubCategory?subCategoryId=${s.subCategoryId}"
                                                   class="btn btn-danger btn-sm rounded-pill"
                                                   onclick="return confirm('Are you sure?')">
                                                    Delete
                                                </a>

                                            </td>

                                        </tr>

                                    </c:forEach>

                                </tbody>

                            </table>

                        </div>

                        <!-- 🔢 PAGINATION -->
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-3">
                                <ul class="pagination justify-content-center">

                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="${ctx}/admin/listSubCategory?page=${currentPage - 1}&keyword=${keyword}">
                                            Previous
                                        </a>
                                    </li>

                                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${ctx}/admin/listSubCategory?page=${i}&keyword=${keyword}">
                                                ${i + 1}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="${ctx}/admin/listSubCategory?page=${currentPage + 1}&keyword=${keyword}">
                                            Next
                                        </a>
                                    </li>

                                </ul>
                            </nav>
                        </c:if>

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