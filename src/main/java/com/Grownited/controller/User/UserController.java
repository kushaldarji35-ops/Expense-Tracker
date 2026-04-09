package com.Grownited.controller.User;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ExpenseRepository;
import com.Grownited.repository.IncomeRepository;

import jakarta.servlet.http.HttpSession;
import tools.jackson.databind.ObjectMapper;

@Controller
public class UserController {

    @Autowired
    private ExpenseRepository expenseRepository;

    @Autowired
    private IncomeRepository incomeRepository;

    // ================= USER DASHBOARD =================
    @GetMapping("/user/dashboard")
    public String userDashboard(Model model, HttpSession session) throws Exception {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        Integer userId = user.getUserId();

        // ✅ FIXED CURRENT YEAR
        int year = LocalDate.now().getYear();

        // ================= CURRENT MONTH =================
        YearMonth currentMonth = YearMonth.now();
        LocalDate startDate = currentMonth.atDay(1);
        LocalDate endDate = currentMonth.atEndOfMonth();

        Double monthExpense = expenseRepository
                .sumExpenseBetweenDatesByUser(userId, startDate, endDate);

        Double monthIncome = incomeRepository
                .sumIncomeBetweenDatesByUser(userId, startDate, endDate);

        if (monthExpense == null) monthExpense = 0.0;
        if (monthIncome == null) monthIncome = 0.0;

        // ================= BALANCE =================
        Double balance = monthIncome - monthExpense;

        // ================= QUARTER =================
        LocalDate quarterStart = LocalDate.now().minusMonths(3);

        Double quarterExpense = expenseRepository
                .sumExpenseBetweenDatesByUser(userId, quarterStart, endDate);

        Double quarterIncome = incomeRepository
                .sumIncomeBetweenDatesByUser(userId, quarterStart, endDate);

        if (quarterExpense == null) quarterExpense = 0.0;
        if (quarterIncome == null) quarterIncome = 0.0;

        // ================= FULL YEAR CHART =================
        List<String> months = new ArrayList<>();
        List<Double> incomeList = new ArrayList<>();
        List<Double> expenseList = new ArrayList<>();

        for (int i = 1; i <= 12; i++) {

            YearMonth ym = YearMonth.of(year, i);

            LocalDate start = ym.atDay(1);
            LocalDate end = ym.atEndOfMonth();

            Double income = incomeRepository
                    .sumIncomeBetweenDatesByUser(userId, start, end);

            Double expense = expenseRepository
                    .sumExpenseBetweenDatesByUser(userId, start, end);

            if (income == null) income = 0.0;
            if (expense == null) expense = 0.0;

            months.add(ym.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH));
            incomeList.add(income);
            expenseList.add(expense);
        }

        // ================= CATEGORY CHART =================
        LocalDate monthStart = currentMonth.atDay(1);
        LocalDate monthEnd = currentMonth.atEndOfMonth();

        LocalDate yearStart = LocalDate.of(year, 1, 1);
        LocalDate yearEnd = LocalDate.of(year, 12, 31);

        List<Object[]> monthCategory = expenseRepository
                .sumExpenseByCategory(userId, monthStart, monthEnd);

        List<Object[]> yearCategory = expenseRepository
                .sumExpenseByCategory(userId, yearStart, yearEnd);

        List<String> monthLabels = new ArrayList<>();
        List<Double> monthData = new ArrayList<>();

        for (Object[] row : monthCategory) {
            monthLabels.add(row[0].toString());
            monthData.add(Double.parseDouble(row[1].toString()));
        }

        List<String> yearLabels = new ArrayList<>();
        List<Double> yearData = new ArrayList<>();

        for (Object[] row : yearCategory) {
            yearLabels.add(row[0].toString());
            yearData.add(Double.parseDouble(row[1].toString()));
        }

        // ================= JSON =================
        ObjectMapper mapper = new ObjectMapper();

        model.addAttribute("monthsJson", mapper.writeValueAsString(months));
        model.addAttribute("incomeList", mapper.writeValueAsString(incomeList));
        model.addAttribute("expenseList", mapper.writeValueAsString(expenseList));

        model.addAttribute("monthCategoryLabels", mapper.writeValueAsString(monthLabels));
        model.addAttribute("monthCategoryData", mapper.writeValueAsString(monthData));

        model.addAttribute("yearCategoryLabels", mapper.writeValueAsString(yearLabels));
        model.addAttribute("yearCategoryData", mapper.writeValueAsString(yearData));

        // ================= DATA =================
        model.addAttribute("monthExpense", monthExpense);
        model.addAttribute("quarterExpense", quarterExpense);
        model.addAttribute("monthIncome", monthIncome);
        model.addAttribute("quarterIncome", quarterIncome);
        model.addAttribute("balance", balance);
        model.addAttribute("selectedYear", year);

        return "User/UserDashboard";
    }

    // ================= LOGOUT =================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    
}