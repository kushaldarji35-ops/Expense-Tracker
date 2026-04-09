<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- ================= CONTEXT PATH ================= -->
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Vendor List | Admin</title>

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
						<h3>All Vendors</h3>
					</div>
				</div>



				<!-- ================= VENDOR LIST CARD ================= -->
				<div class="row">

					<div class="col-md-12">

						<div class="card shadow-sm">


							<!-- ================= CARD HEADER ================= -->
							<div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">

								<span>
									<i class="ti-user mr-2"></i>
									Vendor List
								</span>

								<a href="${ctx}/admin/vendor"
								   class="btn btn-success btn-sm rounded-pill">
									+ Add New Vendor
								</a>

							</div>



							<!-- ================= CARD BODY ================= -->
							<div class="card-body">
							
							<!-- ✅ SUCCESS MESSAGE -->
								<c:if test="${param.success == 'added'}">
								    <div class="alert alert-success">Vendor added successfully!</div>
								</c:if>
								
								<c:if test="${param.success == 'updated'}">
								    <div class="alert alert-success">Vendor updated successfully!</div>
								</c:if>
								
								<c:if test="${param.success == 'deleted'}">
								    <div class="alert alert-danger">Vendor deleted successfully!</div>
								</c:if>

								<!-- ================= SEARCH BAR ================= -->
								<form method="get" action="${ctx}/admin/listVendor" class="mb-3 d-flex">

									<input type="text"
									       name="keyword"
									       value="${keyword}"
									       placeholder="Search vendor..."
									       class="form-control me-2"/>

									<button type="submit" class="btn btn-primary">Search</button>

								</form>



								<div class="table-responsive">

									<!-- ================= VENDOR TABLE ================= -->
									<table class="table table-bordered table-hover text-center align-middle">

										<!-- ================= TABLE HEADER ================= -->
										<thead class="table-light">
											<tr>
												<th>Sr. No</th>
												<th>Vendor Name</th>
												<th>Actions</th>
											</tr>
										</thead>


										<!-- ================= TABLE BODY ================= -->
										<tbody>

											<!-- IF EMPTY -->
											<c:if test="${empty vendors}">
												<tr>
													<td colspan="3" class="text-muted">
														No vendors found
													</td>
												</tr>
											</c:if>


											<!-- LOOP DATA -->
											<c:forEach var="v" items="${vendors}" varStatus="status">

												<tr>

													<!-- SERIAL NUMBER (FIXED WITH PAGINATION) -->
													<td>
														${currentPage * 10 + status.index + 1}
													</td>

													<td>${v.vendorName}</td>

													<td>

														<a href="${ctx}/admin/editVendor?vendorId=${v.vendorId}"
														   class="btn btn-warning btn-sm rounded-pill">
															Edit
														</a>

														<a href="${ctx}/admin/deleteVendor?vendorId=${v.vendorId}"
														   class="btn btn-danger btn-sm rounded-pill"
														   onclick="return confirm('Are you sure you want to delete this vendor?')">
															Delete
														</a>

													</td>

												</tr>

											</c:forEach>

										</tbody>

									</table>

								</div>



								<!-- ================= PAGINATION ================= -->
								<c:if test="${totalPages > 1}">
									<nav class="mt-3">
										<ul class="pagination justify-content-center">

											<!-- PREVIOUS -->
											<li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
												<a class="page-link"
												   href="${ctx}/admin/listVendor?page=${currentPage - 1}&keyword=${keyword}">
													Previous
												</a>
											</li>

											<!-- PAGE NUMBERS -->
											<c:forEach begin="0" end="${totalPages - 1}" var="i">
												<li class="page-item ${i == currentPage ? 'active' : ''}">
													<a class="page-link"
													   href="${ctx}/admin/listVendor?page=${i}&keyword=${keyword}">
														${i + 1}
													</a>
												</li>
											</c:forEach>

											<!-- NEXT -->
											<li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
												<a class="page-link"
												   href="${ctx}/admin/listVendor?page=${currentPage + 1}&keyword=${keyword}">
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