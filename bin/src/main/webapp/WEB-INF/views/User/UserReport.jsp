<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Report | Expense Tracker</title>

<jsp:include page="UserCSS.jsp"></jsp:include>

</head>

<body>

<div class="container-scroller">

    <!-- HEADER -->
    <jsp:include page="UserHeader.jsp"></jsp:include>

    <div class="container-fluid page-body-wrapper">

        <!-- SIDEBAR -->
        <jsp:include page="UserLeftSidebar.jsp"></jsp:include>

        <!-- MAIN PANEL -->
        <div class="main-panel">
            <div class="content-wrapper">

                <!-- PAGE TITLE -->
                <h3 class="mb-3">Financial Report</h3>

                <!-- CARD -->
                <div class="card shadow-sm">

                    <!-- HEADER -->
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <span>Report Section</span>
                    </div>

                    <!-- BODY -->
                    <div class="card-body">

                        <p class="text-muted">
                            Download your complete financial report including Income, Expense and Balance.
                        </p>

                        <!-- BUTTON + FILTER SECTION -->
                        <div style="display:flex; gap:15px; flex-wrap:wrap; align-items:center;">

                            <!-- FULL REPORT -->
                            <a href="${pageContext.request.contextPath}/user/report/pdf"
                               class="btn"
                               style="background-color:#5A4FCF; color:white;">
                                📄 Download Full Report PDF
                            </a>

                            <!-- DATE FILTER -->
                            <input type="date" id="startDate" class="form-control" style="width:200px;" />
                            <input type="date" id="endDate" class="form-control" style="width:200px;" />

                            <!-- FILTER BUTTON -->
                            <button onclick="downloadFilteredReport()"
                                    class="btn"
                                    style="background-color:#28a745; color:white;">
                                📅 Download Filtered PDF
                            </button>

                        </div>

                    </div>

                </div>

            </div>

            <!-- FOOTER -->
            <jsp:include page="UserFooter.jsp"></jsp:include>

        </div>

    </div>

</div>

<jsp:include page="UserJS.jsp"></jsp:include>

<!-- ✅ JAVASCRIPT -->
<script>
function downloadFilteredReport() {

    let start = document.getElementById("startDate").value;
    let end = document.getElementById("endDate").value;

    if (!start || !end) {
        alert("Please select both dates");
        return;
    }

    let url = "${pageContext.request.contextPath}/user/report/pdf/filter?startDate="
              + start + "&endDate=" + end;

    window.open(url, "_blank");
}
</script>

</body>
</html>