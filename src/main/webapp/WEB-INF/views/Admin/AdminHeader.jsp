<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<nav class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">

  <!-- Logo -->
  <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-start">
    <a class="navbar-brand fw-bold fs-4 text-dark" href="<c:url value='/user/dashboard'/>">
        Expense Tracker
    </a>
  </div>

  <!-- Right Navbar -->
  <div class="navbar-menu-wrapper d-flex align-items-center justify-content-end">

    <!-- Sidebar Toggle -->
    <button class="navbar-toggler align-self-center" type="button" data-toggle="minimize">
      <span class="icon-menu"></span>
    </button>

    <!-- Profile Dropdown -->
    <ul class="navbar-nav navbar-nav-right">
      <li class="nav-item nav-profile dropdown">

        <!-- Profile Image -->
        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" id="profileDropdown">

          <!-- If User has Profile Pic -->
          <c:if test="${not empty sessionScope.user.profilePicURL}">
            <img src="${sessionScope.user.profilePicURL}" 
                 alt="profile" 
                 style="width:35px;height:35px;border-radius:50%;">
          </c:if>

          <!-- Default Profile Pic -->
          <c:if test="${empty sessionScope.user.profilePicURL}">
            <img src="<c:url value='/assets/images/faces/dummy.jpg'/>" 
                 alt="profile"
                 style="width:35px;height:35px;border-radius:50%;">
          </c:if>

        </a>

        <!-- Dropdown Menu -->
        <div class="dropdown-menu dropdown-menu-right navbar-dropdown"
             aria-labelledby="profileDropdown">

          <!-- Settings -->
          <a class="dropdown-item" href="#">
            <i class="ti-settings text-primary"></i>
            Settings
          </a>

          <!-- Logout -->
          <a class="dropdown-item" href="<c:url value='/logout'/>">
            <i class="ti-power-off text-primary"></i>
            Logout
          </a>

        </div>

      </li>
    </ul>

    <!-- Mobile Toggle -->
    <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center"
            type="button" data-toggle="offcanvas">
      <span class="icon-menu"></span>
    </button>

  </div>
</nav>