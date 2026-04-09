<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Category Management | Expense Tracker</title>

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

						<h3>Category Management</h3>

						<p class="text-muted">
							Add and manage expense categories
						</p>

					</div>

				</div>



				<!-- ================= ADD CATEGORY ================= -->
				<div class="row">

					<div class="col-md-12 grid-margin stretch-card">

						<div class="card shadow-sm">

							<div class="card-header bg-primary text-white">

								Add New Category

							</div>

							<div class="card-body">

								<form action="${ctx}/admin/category" method="post">

									<div class="row">

										<div class="col-md-6">

											<label class="form-label">
												Category Name
											</label>

											<input type="text"
												   name="categoryName"
												   class="form-control"
												   placeholder="Enter category name"
												   required>

										</div>


										<div class="col-md-3 d-flex align-items-end">

											<button type="submit"
													class="btn btn-success btn-sm rounded-pill">

												<i class="bi bi-plus-circle"></i>
												Add Category

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