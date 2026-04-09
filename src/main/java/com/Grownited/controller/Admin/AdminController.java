package com.Grownited.controller.Admin;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.repository.AccountRepository;
import com.Grownited.repository.ExpenseRepository;
import com.Grownited.repository.IncomeRepository;
import com.Grownited.repository.UserRepository;

@Controller
public class AdminController {

    @Autowired
    private IncomeRepository incomeRepository;

    @Autowired
    private ExpenseRepository expenseRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AccountRepository accountRepository;

    @GetMapping(value = {"/admin/dashboard", "/"})
    public String adminDashboard(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer userId,
            Model model) {

        LocalDate now = LocalDate.now();

        if (year == null) year = now.getYear();
        if (month == null) month = now.getMonthValue();

        LocalDate startDate = LocalDate.of(year, month, 1);
        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

        Double totalIncome;
        Double totalExpense;
        List<Object[]> topCategory;

        // ===== FILTER =====
        if (userId != null) {
            totalIncome = incomeRepository.sumIncomeBetweenDatesByUser(userId, startDate, endDate);
            totalExpense = expenseRepository.sumExpenseBetweenDatesByUser(userId, startDate, endDate);
            topCategory = expenseRepository.findTopExpenseCategoryByUser(userId, startDate, endDate);
        } else {
            totalIncome = incomeRepository.sumIncomeBetweenDates(startDate, endDate);
            totalExpense = expenseRepository.sumExpenseBetweenDates(startDate, endDate);
            topCategory = expenseRepository.findTopExpenseCategory(startDate, endDate);
        }

        if (totalIncome == null) totalIncome = 0.0;
        if (totalExpense == null) totalExpense = 0.0;

        Double currentBalance = totalIncome - totalExpense;

        // ===== TOP CATEGORY =====
        String topCategoryName = "N/A";
        Double topCategoryAmount = 0.0;

        if (!topCategory.isEmpty()) {
            topCategoryName = (String) topCategory.get(0)[0];
            topCategoryAmount = (Double) topCategory.get(0)[1];
        }

        // ===== CATEGORY DATA =====
        List<Object[]> categoryYearData = expenseRepository.findCategoryYearWise(year);
        List<Object[]> categoryMonthData = expenseRepository.findTopExpenseCategory(startDate, endDate);

        // ===== FIX BAR CHART =====
        Double[] monthlyIncome = new Double[12];
        Double[] monthlyExpense = new Double[12];

        for (int i = 0; i < 12; i++) {
            monthlyIncome[i] = 0.0;
            monthlyExpense[i] = 0.0;
        }

        // Only selected month data
        monthlyIncome[month - 1] = totalIncome;
        monthlyExpense[month - 1] = totalExpense;

        // ===== SEND DATA =====
        model.addAttribute("totalUsers", userRepository.count());
        model.addAttribute("totalAccounts", accountRepository.count());

        model.addAttribute("totalIncome", totalIncome);
        model.addAttribute("totalExpense", totalExpense);
        model.addAttribute("currentBalance", currentBalance);

        model.addAttribute("topCategoryName", topCategoryName);
        model.addAttribute("topCategoryAmount", topCategoryAmount);

        model.addAttribute("selectedYear", year);
        model.addAttribute("selectedMonth", month);
        model.addAttribute("selectedUser", userId);

        model.addAttribute("users", userRepository.findAll());

        model.addAttribute("monthlyIncome", monthlyIncome);
        model.addAttribute("monthlyExpense", monthlyExpense);

        model.addAttribute("categoryYearData", categoryYearData);
        model.addAttribute("categoryMonthData", categoryMonthData);

        return "Admin/AdminDashboard";
    }
}