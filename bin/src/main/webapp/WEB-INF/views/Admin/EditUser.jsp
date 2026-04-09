<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>

<!-- ================= HEAD SECTION ================= -->
<head>

    <meta charset="UTF-8">
    <title>Edit User | Expense Tracker</title>

    <!-- ===== Bootstrap CSS ===== -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ===== Bootstrap Icons ===== -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- ================= CUSTOM CSS ================= -->
    <style>

        body{
            background:#f4f6fb;
            font-family:"Segoe UI",sans-serif;
        }

        /* Animation */
        @keyframes fadeSlide {
            from{
                opacity:0;
                transform: translateY(30px);
            }
            to{
                opacity:1;
                transform: translateY(0);
            }
        }

        /* Title */
        .logo-title{
            font-weight:600;
            color:#4B49AC;
        }

        /* Card Design */
        .register-card{
            border-radius:12px;
            border:none;
            animation: fadeSlide 0.6s ease;
        }

        .card-header{
            background:#4B49AC;
            color:white;
            font-weight:600;
            font-size:18px;
        }

        /* Button */
        .btn-register{
            background:#4B49AC;
            border:none;
            font-weight:500;
        }

        .btn-register:hover{
            background:#3d3aa3;
        }

        /* Form Styling */
        .form-control:focus{
            border-color:#4B49AC;
            box-shadow:none;
        }

        .input-group-text{
            background:white;
            border-right:none;
        }

        .form-control{
            border-left:none;
        }

    </style>

</head>

<!-- ================= BODY SECTION ================= -->
<body>

<div class="container mt-5">

    <div class="row justify-content-center">

        <div class="col-lg-6 col-md-8 col-sm-12">

            <!-- ===== TITLE ===== -->
            <h3 class="text-center mb-4 logo-title">
                Expense Tracker
            </h3>

            <!-- ================= CARD ================= -->
            <div class="card shadow register-card">

                <!-- ===== CARD HEADER ===== -->
                <div class="card-header text-center">
                    Edit User Details
                </div>

                <!-- ===== CARD BODY ===== -->
                <div class="card-body">

                    <!-- ================= FORM ================= -->
                    <form action="${pageContext.request.contextPath}/admin/updateUser" 
                          method="post" 
                          enctype="multipart/form-data">

                        <!-- ===== HIDDEN USER ID ===== -->
                        <input type="hidden" name="userId" value="${user.userId}"/>

                        <!-- ===== FIRST NAME ===== -->
                        <div class="mb-3">
                            <label class="form-label">First Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" name="firstName" value="${user.firstName}" 
                                       class="form-control" required>
                            </div>
                        </div>

                        <!-- ===== LAST NAME ===== -->
                        <div class="mb-3">
                            <label class="form-label">Last Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" name="lastName" value="${user.lastName}" 
                                       class="form-control" required>
                            </div>
                        </div>

                        <!-- ===== EMAIL ===== -->
                        <div class="mb-3">
                            <label class="form-label">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" name="email" value="${user.email}" 
                                       class="form-control" required>
                            </div>
                        </div>

                        <!-- ===== PASSWORD (OPTIONAL) ===== -->
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" name="password" class="form-control" 
                                       placeholder="Leave blank to keep same">
                            </div>
                        </div>

                        <!-- ===== GENDER ===== -->
                        <div class="mb-3">
                            <label class="form-label d-block">Gender</label>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" value="Male"
                                       ${user.gender == 'Male' ? 'checked' : ''}>
                                <label class="form-check-label">Male</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" value="Female"
                                       ${user.gender == 'Female' ? 'checked' : ''}>
                                <label class="form-check-label">Female</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" value="Other"
                                       ${user.gender == 'Other' ? 'checked' : ''}>
                                <label class="form-check-label">Other</label>
                            </div>
                        </div>

                        <!-- ===== DATE OF BIRTH ===== -->
                        <div class="mb-3">
                            <label class="form-label">Date of Birth</label>
                            <input type="date" name="birthDate" value="${user.birthDate}" 
                                   class="form-control">
                        </div>

                        <!-- ===== MOBILE NUMBER ===== -->
                        <div class="mb-3">
                            <label class="form-label">Mobile Number</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="text" name="contactNum" value="${user.contactNum}" 
                                       class="form-control" pattern="[0-9]{10}">
                            </div>
                        </div>

                        <!-- ===== ROLE ===== -->
                        <div class="mb-3">
                            <label class="form-label">Role</label>
                            <select name="role" class="form-control">
                                <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>USER</option>
                            </select>
                        </div>

                        <!-- ===== STATUS ===== -->
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select name="active" class="form-control">
                                <option value="true" ${user.active == true ? 'selected' : ''}>Active</option>
                                <option value="false" ${user.active == false ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <!-- ===== PROFILE PICTURE ===== -->
                        <div class="mb-3">
                            <label class="form-label">Profile Picture</label>
                            <input type="file" name="profilePic" class="form-control" accept="image/*">
                        </div>

                        <!-- ===== SUBMIT BUTTON ===== -->
                        <div class="d-grid">
                            <button type="submit" class="btn btn-register text-white">
                                Update User
                            </button>
                        </div>

                    </form>
                    <!-- ================= END FORM ================= -->

                </div>
            </div>

            <!-- ===== BACK LINK ===== -->
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/admin/users"
                   style="color:#4B49AC; font-weight:500;">
                    ← Back to Users
                </a>
            </div>

        </div>
    </div>
</div>

<!-- ================= JS ================= -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>