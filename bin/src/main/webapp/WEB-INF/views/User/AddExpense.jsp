<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Add Expense | Expense Tracker</title>

<!-- USER CSS -->
<jsp:include page="UserCSS.jsp"></jsp:include>

</head>

<body>

<div class="container-scroller">

	<!-- USER HEADER -->
	<jsp:include page="UserHeader.jsp"></jsp:include>

	<div class="container-fluid page-body-wrapper">

		<!-- USER SIDEBAR -->
		<jsp:include page="UserLeftSidebar.jsp"></jsp:include>

		<!-- MAIN PANEL -->
		<div class="main-panel">

			<div class="content-wrapper">

				<!-- PAGE TITLE -->
				<div class="row mb-4">
					<div class="col-md-12">
						<h3>Add Expense</h3>
						<p class="text-muted">Record your daily expenses</p>
					</div>
				</div>

				<!-- FORM CARD -->
				<div class="row">
					<div class="col-md-12">

						<div class="card shadow-sm">

							<div class="card-header bg-primary text-white">
								Expense Details
							</div>

							<div class="card-body">

								<form action="${pageContext.request.contextPath}/user/saveExpense" method="post">

								<c:if test="${not empty error}">
								    <div class="alert alert-danger text-center">
								        ${error}
								    </div>
								</c:if>
									<!-- ROW 1 -->
									<div class="row mb-3">

										<div class="col-md-4">
											<label class="form-label">Title</label>
											<input type="text" name="title"
												class="form-control"
												placeholder="Expense title" required>
										</div>

										<div class="col-md-4">
											<label class="form-label">Date</label>
											<input type="date" name="date"
												class="form-control" required>
										</div>

										<div class="col-md-4">
											<label class="form-label">Amount</label>
											<input type="number" name="amount"
												step="0.01"
												class="form-control" required>
										</div>

									</div>

									<!-- ROW 2 -->
									<div class="row mb-3">

										<div class="col-md-4">
											<label class="form-label">Category</label>

											<select name="category.categoryId"
												class="form-select" required>

												<option value="">Select Category</option>

												<c:forEach var="c" items="${categories}">
													<option value="${c.categoryId}">
														${c.categoryName}
													</option>
												</c:forEach>

											</select>

										</div>

										<div class="col-md-4">

											<label class="form-label">Sub Category</label>

											<select name="subCategory.subCategoryId"
												class="form-select" required>

												<option value="">Select Sub Category</option>

												<c:forEach var="s" items="${subCategories}">
													<option value="${s.subCategoryId}">
														${s.subCategoryName}
													</option>
												</c:forEach>

											</select>

										</div>

										<div class="col-md-4">

											<label class="form-label">Vendor</label>

											<select name="vendor.vendorId"
												class="form-select" required>

												<option value="">Select Vendor</option>

												<c:forEach var="v" items="${vendors}">
													<option value="${v.vendorId}">
														${v.vendorName}
													</option>
												</c:forEach>

											</select>

										</div>

									</div>

									<!-- ROW 3 -->
									<div class="row mb-3">

										<div class="col-md-4">

											<label class="form-label">Account</label>

											<select name="account.accountId"
												class="form-select" required>

												<option value="">Select Account</option>

												<c:forEach var="a" items="${accounts}">
													<option value="${a.accountId}">
														${a.title}
													</option>
												</c:forEach>

											</select>

										</div>

										<div class="col-md-4">

											<label class="form-label">Status</label>

											<select name="status.statusId"
												class="form-select" required>

												<option value="">Select Status</option>

												<c:forEach var="st" items="${statuses}">
													<option value="${st.statusId}">
														${st.status}
													</option>
												</c:forEach>

											</select>

										</div>

										<div class="col-md-4">

											<label class="form-label">Description</label>

											<input type="text"
												name="description"
												class="form-control"
												placeholder="Optional note">

										</div>

									</div>

									<!-- SAVE BUTTON -->

									<button type="submit"
										class="btn btn-success">

										Save Expense

									</button>

								</form>

							</div>

						</div>

					</div>
				</div>

			</div>

			<!-- USER FOOTER -->
			<jsp:include page="UserFooter.jsp"></jsp:include>

		</div>

	</div>

</div>

<!-- USER JS -->
<jsp:include page="UserJS.jsp"></jsp:include>
</body>
</html> 