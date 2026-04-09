package com.Grownited.controller.User;

import java.io.ByteArrayInputStream;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.*;
import com.Grownited.repository.*;
import com.Grownited.util.PdfGenerator;

import jakarta.servlet.http.HttpSession;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.data.domain.PageRequest;

import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;

@Controller
@RequestMapping("/user")
public class UserExpenseController {

    @Autowired
    ExpenseRepository expenseRepository;

    @Autowired
    CategoryRepository categoryRepository;

    @Autowired
    SubCategoryRepository subCategoryRepository;

    @Autowired
    VendorRepository vendorRepository;

    @Autowired
    AccountRepository accountRepository;

    @Autowired
    StatusRepository statusRepository;


    // =============================
    // OPEN ADD EXPENSE PAGE
    // =============================
    @GetMapping("/addExpense")
    public String addExpensePage(Model model, HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("subCategories", subCategoryRepository.findAll());
        model.addAttribute("vendors", vendorRepository.findAll());

        // ✅ FIX: show only logged-in user's accounts
        model.addAttribute("accounts",
                accountRepository.findByUserId(user.getUserId()));

        model.addAttribute("statuses", statusRepository.findAll());

        model.addAttribute("expense", new ExpenseEntity());

        return "User/AddExpense";
    }


    // =============================
    // SAVE EXPENSE
    // =============================
    @PostMapping("/saveExpense")
    public String saveExpense(@ModelAttribute ExpenseEntity expense,
                              HttpSession session,
                              Model model) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        expense.setUser(user);

        AccountEntity account = accountRepository
                .findById(expense.getAccount().getAccountId())
                .orElse(null);

        if (account == null) {
            model.addAttribute("error", "Account not found!");
            return "User/AddExpense";
        }

        Double balance = account.getAmount() == null ? 0.0 : account.getAmount();
        Float amount = expense.getAmount();

        if (amount <= 0) {
            model.addAttribute("error", "Amount must be greater than 0!");
            return "User/AddExpense";
        }

        if (balance < amount) {
            model.addAttribute("error",
                    "❌ Insufficient Balance! Available: ₹ " + balance);
            return "User/AddExpense";
        }

        account.setAmount(balance - amount);
        accountRepository.save(account);

        expenseRepository.save(expense);

        return "redirect:/user/expenseList?success=added";
    }
    // =============================
    // USER EXPENSE LIST
    // =============================
    @GetMapping("/expenseList")
    public String expenseList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) String status,
            Model model,
            HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        int size = 10;

        // ✅ SORT
        org.springframework.data.domain.Sort sorting = org.springframework.data.domain.Sort.unsorted();

        if ("asc".equals(sort)) {
            sorting = org.springframework.data.domain.Sort.by("amount").ascending();
        } else if ("desc".equals(sort)) {
            sorting = org.springframework.data.domain.Sort.by("amount").descending();
        }

        Pageable pageable = PageRequest.of(page, size, sorting);
        Page<ExpenseEntity> expensePage;

        // ✅ FILTER LOGIC
        if (keyword != null && !keyword.trim().isEmpty() && status != null && !status.isEmpty()) {

            expensePage = expenseRepository
                    .findByUserAndTitleContainingIgnoreCaseAndStatus_Status(
                            user, keyword, status, pageable);

        } else if (keyword != null && !keyword.trim().isEmpty()) {

            expensePage = expenseRepository
                    .findByUserAndTitleContainingIgnoreCase(user, keyword, pageable);

        } else if (status != null && !status.isEmpty()) {

            expensePage = expenseRepository
                    .findByUserAndStatus_Status(user, status, pageable);

        } else {

            expensePage = expenseRepository
                    .findByUser(user, pageable);
        }

        model.addAttribute("expenses", expensePage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", expensePage.getTotalPages());
        model.addAttribute("keyword", keyword);

        // NEW
        model.addAttribute("sort", sort);
        model.addAttribute("status", status);

        return "User/UserExpenseList";
    }

    // =============================
    // DELETE EXPENSE (SECURE)
    // =============================
    @GetMapping("/deleteExpense")
    public String deleteExpense(@RequestParam Integer expenseId,
                                HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        Optional<ExpenseEntity> expenseOpt = expenseRepository.findById(expenseId);

        if (expenseOpt.isPresent()) {

            ExpenseEntity expense = expenseOpt.get();

            if (expense.getUser().getUserId().equals(user.getUserId())) {

                AccountEntity account = expense.getAccount();

                Double balance = account.getAmount();
                if(balance == null){
                    balance = (double) 0f;
                }

                Float expenseAmount = expense.getAmount();

                String status = "";
                if(expense.getStatus() != null){
                    status = expense.getStatus().getStatus();
                }

                if("Paid".equalsIgnoreCase(status)){
                    balance = balance + expenseAmount;
                }
                else if("Partial".equalsIgnoreCase(status)){
                    balance = balance + (expenseAmount / 2);
                }

                account.setAmount(balance);
                accountRepository.save(account);

                expenseRepository.delete(expense);
            }
        }

        return "redirect:/user/expenseList?success=deleted";
    }
    
 // ================= EDIT EXPENSE =================
    @GetMapping("/editExpense")
    public String editExpense(@RequestParam Integer expenseId,
                              Model model,
                              HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        ExpenseEntity expense = expenseRepository.findById(expenseId).orElse(null);

        model.addAttribute("expense", expense);
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("subCategories", subCategoryRepository.findAll());
        model.addAttribute("vendors", vendorRepository.findAll());
        model.addAttribute("accounts",
                accountRepository.findByUserId(user.getUserId()));
        model.addAttribute("statuses", statusRepository.findAll());

        return "User/EditExpense";
    }
    
 // ================= UPDATE EXPENSE =================
    @PostMapping("/updateExpense")
    public String updateExpense(@ModelAttribute ExpenseEntity expense,
                                HttpSession session,
                                Model model) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        ExpenseEntity oldExpense =
                expenseRepository.findById(expense.getExpenseId()).orElse(null);

        AccountEntity account =
                accountRepository.findById(expense.getAccount().getAccountId()).orElse(null);

        Double balance = account.getAmount() == null ? 0.0 : account.getAmount();

        // ✅ restore old amount
        balance += oldExpense.getAmount();

        if (balance < expense.getAmount()) {
            model.addAttribute("error", "Insufficient balance!");
            return "User/EditExpense";
        }

        account.setAmount(balance - expense.getAmount());
        accountRepository.save(account);

        expense.setUser(user);
        expenseRepository.save(expense);

        return "redirect:/user/expenseList?success=updated";
    }
    
    @GetMapping("/expense/pdf")
    public ResponseEntity<InputStreamResource> exportExpensePdf(HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        List<ExpenseEntity> expenses = expenseRepository.findByUser(user);

        ByteArrayInputStream pdf = PdfGenerator.generateExpensePdf(expenses);

        return ResponseEntity.ok()
                .header("Content-Disposition", "inline; filename=expense_report.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }

    @GetMapping("/expense/pdf/filter")
    public ResponseEntity<InputStreamResource> exportFilteredExpensePdf(
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        List<ExpenseEntity> expenses = expenseRepository
                .findByUserAndDateBetween(user, startDate, endDate);

        ByteArrayInputStream pdf = PdfGenerator.generateExpensePdf(expenses);

        return ResponseEntity.ok()
                .header("Content-Disposition", "inline; filename=expense_filtered_report.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }
}