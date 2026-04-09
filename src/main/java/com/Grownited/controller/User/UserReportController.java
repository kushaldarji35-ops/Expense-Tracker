package com.Grownited.controller.User;

import java.io.ByteArrayInputStream;
import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.*;
import com.Grownited.repository.*;
import com.Grownited.util.PdfGenerator;

@Controller
@RequestMapping("/user")   // ✅ BASE URL
public class UserReportController {

    @Autowired
    private IncomeRepository incomeRepository;

    @Autowired
    private ExpenseRepository expenseRepository;

    // ============================
    // ✅ 1. OPEN REPORT PAGE (VERY IMPORTANT)
    // ============================
    @GetMapping("/report")
    public String reportPage() {
        return "User/UserReport";   // JSP FILE NAME
    }

    // ============================
    // ✅ 2. FULL REPORT PDF
    // ============================
    @GetMapping("/report/pdf")
    public ResponseEntity<InputStreamResource> exportFullReport(HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        List<IncomeEntity> incomes = incomeRepository.findByUser(user);
        List<ExpenseEntity> expenses = expenseRepository.findByUser(user);

        ByteArrayInputStream pdf =
                PdfGenerator.generateFullReportPdf(incomes, expenses);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=full_report.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }

    // ============================
    // ✅ 3. FILTER REPORT PDF
    // ============================
    @GetMapping("/report/pdf/filter")
    public ResponseEntity<InputStreamResource> exportFilteredReport(
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate,
            HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        // ✅ DATE PARSE (IMPORTANT FORMAT)
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);

        List<IncomeEntity> incomes =
                incomeRepository.findByUserAndDateBetween(user, start, end);

        List<ExpenseEntity> expenses =
                expenseRepository.findByUserAndDateBetween(user, start, end);

        ByteArrayInputStream pdf =
                PdfGenerator.generateFullReportPdf(incomes, expenses);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=filtered_report.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }
}