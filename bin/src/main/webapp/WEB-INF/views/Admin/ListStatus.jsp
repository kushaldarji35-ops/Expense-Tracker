<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>List Status | Admin</title>

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

						<h3>All Status Records</h3>

					</div>

				</div>



				<!-- ================= STATUS CARD ================= -->
				<div class="row">

					<div class="col-md-12">

						<div class="card shadow-sm">


							<!-- ================= CARD HEADER ================= -->
							<div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">

								<span>
									<i class="ti-list mr-2"></i>
									Status List
								</span>


								<!-- GREEN BUTTON (UNCHANGED) -->
								<a href="${pageContext.request.contextPath}/admin/status"
								   class="btn btn-success btn-sm rounded-pill">

									+ Add New Status

								</a>

							</div>



							<!-- ================= CARD BODY ================= -->
							<div class="card-body">

								<div class="table-responsive">


									<!-- ================= STATUS TABLE ================= -->
									<table class="table table-bordered table-hover text-center align-middle">


										<!-- ================= TABLE HEADER ================= -->
										<thead class="table-light">

											<tr>
												<th>Sr. No</th>
												<th>Status Name</th>
												<th>Preview</th>
												<th>Actions</th>
											</tr>

										</thead>



										<!-- ================= TABLE BODY ================= -->
										<tbody>


											<!-- IF EMPTY -->
											<c:if test="${empty statuses}">

												<tr>

													<td colspan="4">
														No status records found
													</td>

												</tr>

											</c:if>



											<!-- LOOP DATA -->
											<c:forEach var="s" items="${statuses}" varStatus="status">

												<tr>

													<td>${status.index + 1}</td>

													<td>${s.status}</td>



													<!-- STATUS BADGE -->
													<td>

														<span class="badge
															${fn:toUpperCase(s.status) == 'PAID' ? 'bg-success' :
															fn:toUpperCase(s.status) == 'UNPAID' ? 'bg-danger' :
															'bg-warning text-dark'}">

															${s.status}

														</span>

													</td>



													<td>

														<!-- DELETE BUTTON -->
														<a href="deleteStatus?statusId=${s.statusId}"
														   class="btn btn-danger btn-sm rounded-pill"
														   onclick="return confirm('Are you sure you want to delete this status?')">

															Delete

														</a>

													</td>

												</tr>

											</c:forEach>

										</tbody>

									</table>

								</div>

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