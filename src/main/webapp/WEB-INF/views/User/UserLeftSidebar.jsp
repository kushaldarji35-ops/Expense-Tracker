<nav class="sidebar sidebar-offcanvas" id="sidebar">
  <ul class="nav">

    <!-- Dashboard -->
    <li class="nav-item">
      <a class="nav-link" href="${pageContext.request.contextPath}/user/dashboard">
        <i class="ti-dashboard menu-icon"></i>
        <span class="menu-title">Dashboard</span>
      </a>
    </li>


    <!-- Account -->
    <li class="nav-item">
      <a class="nav-link" data-bs-toggle="collapse" href="#account-menu">
        <i class="ti-wallet menu-icon"></i>
        <span class="menu-title">Account</span>
        <i class="menu-arrow"></i>
      </a>

      <div class="collapse" id="account-menu">
        <ul class="nav flex-column sub-menu">

          <li class="nav-item">
            <a class="nav-link"
               href="${pageContext.request.contextPath}/user/account">
               Add Account
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link"
               href="${pageContext.request.contextPath}/user/accountList">
               Account List
            </a>
          </li>

        </ul>
      </div>
    </li>


    <!-- Expense -->
    <li class="nav-item">
      <a class="nav-link" data-bs-toggle="collapse" href="#expense-menu">
        <i class="ti-arrow-down menu-icon"></i>
        <span class="menu-title">Expense</span>
        <i class="menu-arrow"></i>
      </a>

      <div class="collapse" id="expense-menu">
        <ul class="nav flex-column sub-menu">

          <li class="nav-item">
            <a class="nav-link"
               href="${pageContext.request.contextPath}/user/addExpense">
               Add Expense
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link"
               href="${pageContext.request.contextPath}/user/expenseList">
               Expense List
            </a>
          </li>

        </ul>
      </div>
    </li>


    <!-- Income -->
    <li class="nav-item">
      <a class="nav-link" data-bs-toggle="collapse" href="#income-menu">
        <i class="ti-arrow-up menu-icon"></i>
        <span class="menu-title">Income</span>
        <i class="menu-arrow"></i>
      </a>

      <div class="collapse" id="income-menu">
        <ul class="nav flex-column sub-menu">

          <li class="nav-item">
            <a class="nav-link"
               href="${pageContext.request.contextPath}/user/addIncome">
               Add Income
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link"
               href="${pageContext.request.contextPath}/user/incomeList">
               Income List
            </a>
          </li>

        </ul>
      </div>
    </li>
    
   <!-- Report -->
<li class="nav-item">
    <a class="nav-link"
       href="${pageContext.request.contextPath}/user/report">
        <i class="ti-file menu-icon"></i>
        <span class="menu-title">Report</span>
    </a>
</li>
  </ul>
</nav>