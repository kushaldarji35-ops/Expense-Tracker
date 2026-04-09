<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Manage Status | Admin</title>

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

						<h3>Status Management</h3>

						<p class="text-muted">
							Manage payment status (Paid / Unpaid / Partial)
						</p>

					</div>

				</div>



				<!-- ================= ADD STATUS FORM ================= -->
				<div class="row">

					<div class="col-md-12">

						<div class="card shadow-sm mb-4">


							<!-- FORM HEADER -->
							<div class="card-header bg-primary text-white">

								Add New Status

							</div>



							<!-- FORM BODY -->
							<div class="card-body">

								<form action="status" method="post">

									<div class="row">


										<!-- STATUS NAME -->
										<div class="col-md-6">

											<label class="form-label">
												Status Name
											</label>

											<input type="text"
												   name="status"
												   class="form-control"
												   placeholder="paid / unpaid / partialPaid"
												   required>

										</div>



										<!-- ADD BUTTON -->
										<div class="col-md-3 d-flex align-items-end">

											<button type="submit"
													class="btn btn-success">

												<i class="bi bi-plus-circle"></i>
												Add Status

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