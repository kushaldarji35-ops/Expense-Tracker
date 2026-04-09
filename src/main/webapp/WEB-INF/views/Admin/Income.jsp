<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>Add Income | Expense Tracker</title>

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

						<h3 class="mb-2">Add Income</h3>

						<p class="text-muted">
							Record your income details
						</p>

					</div>

				</div>



				<!-- ================= INCOME FORM CARD ================= -->
				<div class="row">

					<div class="col-md-12">

						<div class="card">


							<!-- ================= CARD HEADER ================= -->
							<div class="card-header bg-primary text-white">

								Income Details

							</div>



							<!-- ================= CARD BODY ================= -->
							<div class="card-body">

								<!-- ================= FORM ================= -->
                    <form action="${pageContext.request.contextPath}/admin/income/save" method="post">


									<!-- ================= ROW 1 ================= -->
									<div class="row mb-3">


										<!-- TITLE -->
										<div class="col-md-4">

											<label class="form-label">
												Title
											</label>

											<input type="text"
												   name="title"
												   class="form-control"
												   placeholder="Salary / Bonus / Other"
												   required>

										</div>



										<!-- DATE -->
										<div class="col-md-4">

											<label class="form-label">
												Date
											</label>

											<input type="date"
												   name="date"
												   class="form-control"
												   required>

										</div>



										<!-- AMOUNT -->
										<div class="col-md-4">

											<label class="form-label">
												Amount
											</label>

											<input type="number"
												   name="amount"
												   step="0.01"
												   class="form-control"
												   required>

										</div>

									</div>



									<!-- ================= ROW 2 ================= -->
									<div class="row mb-3">


										<!-- ACCOUNT -->
										<div class="col-md-4">

											<label class="form-label">
												Account
											</label>

											<select name="account.accountId"
													class="form-select"
													required>

												<option value="">
													-- Select Account --
												</option>

												<c:forEach var="a" items="${accounts}">

													<option value="${a.accountId}">
														${a.title}
													</option>

												</c:forEach>

											</select>

										</div>



										<!-- STATUS -->
										<div class="col-md-4">

											<label class="form-label">
												Status
											</label>

											<select name="status.statusId"
													class="form-select"
													required>

												<option value="">
													-- Select Status --
												</option>

												<c:forEach var="st" items="${statuses}">

													<option value="${st.statusId}">
														${st.status}
													</option>

												</c:forEach>

											</select>

										</div>



										<!-- DESCRIPTION -->
										<div class="col-md-4">

											<label class="form-label">
												Description
											</label>

											<input type="text"
												   name="description"
												   class="form-control"
												   placeholder="Optional note">

										</div>

									</div>



									<!-- ================= SAVE BUTTON ================= -->
									<button type="submit"
											class="btn btn-success">

										<i class="mdi mdi-content-save"></i>
										Save Income

									</button>


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