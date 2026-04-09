<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>View User | Admin</title>

    <!-- Common Admin CSS -->
    <jsp:include page="AdminCSS.jsp"></jsp:include>

    <style>
        .profile-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #4e73df;
        }
    </style>
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

                <div class="row justify-content-center">
                    <div class="col-md-10 col-lg-8">

                        <div class="card shadow">
                            <div class="card-header bg-primary text-white">
                                <h4 class="mb-0">User Details</h4>
                            </div>

                            <div class="card-body text-center">

                                <!-- ✅ PROFILE IMAGE -->
                                <c:choose>
                                    <c:when test="${not empty user.profilePicURL}">
                                        <img src="${pageContext.request.contextPath}${user.profilePicURL}" 
                                             class="profile-img shadow mb-3">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/default.png" 
                                             class="profile-img shadow mb-3">
                                    </c:otherwise>
                                </c:choose>

                                <!-- ✅ USER NAME -->
                                <h5>${user.firstName} ${user.lastName}</h5>

                                <hr>

                                <!-- ✅ USER DETAILS TABLE -->
                                <table class="table table-bordered table-hover text-start mt-3">
                                    <tr>
                                        <th width="30%">Serial No</th>
                                        <td>${user.userId}</td>
                                    </tr>

                                    <tr>
                                        <th>First Name</th>
                                        <td>${user.firstName}</td>
                                    </tr>

                                    <tr>
                                        <th>Last Name</th>
                                        <td>${user.lastName}</td>
                                    </tr>

                                    <tr>
                                        <th>Email</th>
                                        <td>${user.email}</td>
                                    </tr>

                                    <tr>
                                        <th>Contact Number</th>
                                        <td>${user.contactNum}</td>
                                    </tr>

                                    <tr>
                                        <th>Role</th>
                                        <td>
                                            <span class="badge bg-info text-dark">
                                                ${user.role}
                                            </span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th>Status</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.active == true}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th>Registered On</th>
                                        <td>${user.createdAt}</td>
                                    </tr>
                                </table>

                                <!-- ✅ BACK BUTTON -->
                                <div class="text-end mt-3">
                                    <a href="${pageContext.request.contextPath}/admin/users" 
                                       class="btn btn-secondary">
                                        Back to List
                                    </a>
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

<!-- ================= COMMON JS ================= -->
<jsp:include page="AdminJS.jsp"></jsp:include>

</body>
</html>