<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- ================= CONTEXT PATH ================= -->
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">

<!-- ================= HEAD SECTION ================= -->
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>User Management | Expense Tracker</title>

    <!-- ===== COMMON ADMIN CSS ===== -->
    <jsp:include page="AdminCSS.jsp"/>

</head>

<!-- ================= BODY SECTION ================= -->
<body>

<div class="container-scroller">

    <!-- ===== HEADER ===== -->
    <jsp:include page="AdminHeader.jsp"/>

    <div class="container-fluid page-body-wrapper">

        <!-- ===== SIDEBAR ===== -->
        <jsp:include page="AdminLeftSidebar.jsp"/>

        <!-- ================= MAIN PANEL ================= -->
        <div class="main-panel">

            <div class="content-wrapper">

                <!-- ===== PAGE TITLE ===== -->
                <div class="row mb-3">
                    <div class="col-md-12">
                        <h3 class="font-weight-bold">User Management</h3>
                        <p class="text-muted">View and manage registered users</p>
                    </div>
                </div>

                <!-- ================= USER CARD ================= -->
                <div class="row">
                    <div class="col-md-12 grid-margin stretch-card">

                        <div class="card">

                            <!-- ===== CARD HEADER ===== -->
                            <div class="card-header bg-dark text-white">
                                User List
                            </div>

                            <!-- ===== CARD BODY ===== -->
                            <div class="card-body">

                                <!-- ================= SUCCESS ALERTS ================= -->
                                <c:if test="${param.success == 'added'}">
                                    <div class="alert alert-success alert-dismissible fade show">
                                        User Added Successfully!
                                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                                    </div>
                                </c:if>

                                <c:if test="${param.success == 'updated'}">
                                    <div class="alert alert-primary alert-dismissible fade show">
                                        User Updated Successfully!
                                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                                    </div>
                                </c:if>

                                <c:if test="${param.success == 'deleted'}">
                                    <div class="alert alert-danger alert-dismissible fade show">
                                        User Deleted Successfully!
                                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                                    </div>
                                </c:if>

                                <!-- ================= SEARCH BAR ================= -->
                                <form method="get"
                                      action="${ctx}/admin/users"
                                      class="mb-3 d-flex">

                                    <input type="text"
                                           name="keyword"
                                           value="${keyword}"
                                           placeholder="Search user..."
                                           class="form-control me-2"/>

                                    <button type="submit" class="btn btn-primary">Search</button>

                                </form>

                                <!-- ================= TABLE ================= -->
                                <div class="table-responsive">

                                    <table class="table table-bordered text-center">

                                        <!-- ===== TABLE HEADER ===== -->
                                        <thead class="table-light">
                                            <tr>
                                                <th>Sr. No</th>
                                                <th>Full Name</th>
                                                <th>Email</th>
                                                <th>Contact</th>
                                                <th>Role</th>
                                                <th>Status</th>
                                                <th>Registered On</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>

                                        <!-- ===== TABLE BODY ===== -->
                                        <tbody>

                                            <!-- NO DATA -->
                                            <c:if test="${empty users}">
                                                <tr>
                                                    <td colspan="8">No users found</td>
                                                </tr>
                                            </c:if>

                                            <!-- DATA LOOP -->
                                            <c:forEach var="u" items="${users}" varStatus="status">

                                                <tr>

                                                    <!-- SERIAL NUMBER -->
                                                    <td>${currentPage * 10 + status.index + 1}</td>

                                                    <!-- FULL NAME -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty u.firstName}">
                                                                N/A
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${u.firstName} ${u.lastName}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- USER DETAILS -->
                                                    <td>${u.email}</td>
                                                    <td>${u.contactNum}</td>
                                                    <td>${u.role}</td>

                                                    <!-- STATUS -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${u.active}">
                                                                <span class="badge badge-success">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-danger">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- DATE -->
                                                    <td>${u.createdAt}</td>

                                                    <!-- ACTION BUTTONS -->
                                                    <td>
                                                        <a href="viewUser?userId=${u.userId}" 
                                                           class="btn btn-info btn-sm">View</a>

                                                        <a href="editUser?userId=${u.userId}" 
                                                           class="btn btn-warning btn-sm">Edit</a>

                                                        <a href="deleteUser?userId=${u.userId}"
                                                           class="btn btn-danger btn-sm"
                                                           onclick="return confirm('Are you sure?')">
                                                           Delete
                                                        </a>
                                                    </td>

                                                </tr>

                                            </c:forEach>

                                        </tbody>

                                    </table>

                                </div>

                                <!-- ================= PAGINATION ================= -->
                                <!-- (Same logic as previous page) -->

                            </div>
                            <!-- ===== END CARD BODY ===== -->

                        </div>

                    </div>
                </div>

            </div>

            <!-- ===== FOOTER ===== -->
            <jsp:include page="AdminFooter.jsp"/>

        </div>
        <!-- ===== END MAIN PANEL ===== -->

    </div>

</div>

<!-- ================= JS ================= -->
<jsp:include page="AdminJS.jsp"/>

<!-- ================= AUTO HIDE ALERT ================= -->
<script>
    setTimeout(function () {
        let alertBox = document.querySelector(".alert");
        if (alertBox) {
            alertBox.style.display = "none";
        }
    }, 3000);
</script>

</body>
</html>