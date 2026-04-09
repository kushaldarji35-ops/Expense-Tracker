<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>List Category | Expense Tracker</title>

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

                        <h3>Category List</h3>

                        <p class="text-muted">
                            Manage all categories
                        </p>

                    </div>

                </div>



                <!-- ================= CATEGORY TABLE CARD ================= -->
                <div class="row">

                    <div class="col-md-12">

                        <div class="card shadow-sm">


                            <!-- ================= CARD HEADER ================= -->
                            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">

                                <span>
                                    <i class="ti-list mr-2"></i>
                                    Category List
                                </span>

                                <a href="${ctx}/admin/category"
                                   class="btn btn-success btn-sm rounded-pill">
                                    + Add New Category
                                </a>

                            </div>



                            <!-- ================= CARD BODY ================= -->
                            <div class="card-body">
                            
								                            <!-- ✅ SUCCESS MESSAGE (ONLY ONCE) -->
								<c:if test="${param.success == 'added'}">
								    <div class="alert alert-success alert-dismissible fade show">
								        ✅ Category added successfully!
								        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
								    </div>
								</c:if>
								
								<c:if test="${param.success == 'deleted'}">
								    <div class="alert alert-danger alert-dismissible fade show">
								        ❌ Category deleted successfully!
								        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
								    </div>
								</c:if>
								
								<c:if test="${param.success == 'updated'}">
								    <div class="alert alert-success alert-dismissible fade show">
								        ✅ Category updated successfully!
								        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
								    </div>
								</c:if>

                                <!-- 🔍 SEARCH BAR -->
                                <form method="get" action="${ctx}/admin/listCategory" class="mb-3 d-flex">

                                    <input type="text"
                                           name="keyword"
                                           value="${keyword}"
                                           placeholder="Search category..."
                                           class="form-control me-2"/>

                                    <button class="btn btn-primary">Search</button>

                                </form>

                                <div class="table-responsive">

                                    <table class="table table-bordered table-hover text-center align-middle">

                                        <thead class="table-light">
                                            <tr>
                                                <th>Sr. No</th>
                                                <th>Category Name</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>

                                        <tbody>

                                            <!-- IF EMPTY -->
                                            <c:if test="${empty listCategory}">
                                                <tr>
                                                    <td colspan="3" class="text-muted">
                                                        No categories found
                                                    </td>
                                                </tr>
                                            </c:if>

                                            <!-- LOOP DATA -->
                                            <c:forEach var="cat" items="${listCategory}" varStatus="status">

                                                <tr>

                                                    <!-- ✅ SERIAL FIX -->
                                                    <td>${currentPage * 10 + status.index + 1}</td>

                                                    <td>${cat.categoryName}</td>

                                                    <td>
                                                    <!-- ✏️ EDIT BUTTON -->
														    <a href="${ctx}/admin/editCategory?categoryId=${cat.categoryId}"
														       class="btn btn-warning btn-sm rounded-pill">
														        Edit
														    </a>
														    
                                                        <a href="${ctx}/admin/deleteCategory?categoryId=${cat.categoryId}"
                                                           class="btn btn-danger btn-sm rounded-pill"
                                                           onclick="return confirm('Are you sure you want to delete this category?')">
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
                                                   href="${ctx}/admin/listCategory?page=${currentPage - 1}&keyword=${keyword}">
                                                    Previous
                                                </a>
                                            </li>

                                            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link"
                                                       href="${ctx}/admin/listCategory?page=${i}&keyword=${keyword}">
                                                        ${i + 1}
                                                    </a>
                                                </li>
                                            </c:forEach>

                                            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                   href="${ctx}/admin/listCategory?page=${currentPage + 1}&keyword=${keyword}">
                                                    Next
                                                </a>
                                            </li>

                                        </ul>
                                    </nav>
                                </c:if>

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