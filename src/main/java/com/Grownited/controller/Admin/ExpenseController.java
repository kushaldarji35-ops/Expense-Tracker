package com.Grownited.controller.Admin;

import java.io.ByteArrayInputStream;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.*;
import com.Grownited.repository.*;
import com.Grownited.util.PdfGenerator;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import com.Grownited.repository.UserRepository;


@Controller
@RequestMapping("/admin")
public class ExpenseController {

    @Autowired
    private ExpenseRepository expenseRepository;
    
    @Autowired
    UserRepository userRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private SubCategoryRepository subCategoryRepository;

    @Autowired
    private VendorRepository vendorRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private StatusRepository statusRepository;
    
   
    // ================= HELPER METHOD =================
    private UserEntity getAdmin(HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            return null;
        }

        return user;
    }


    // ================= OPEN EXPENSE PAGE =================
    @GetMapping("/expense")
    public String openExpensePage(Model model, HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("subCategories", subCategoryRepository.findAll());
        model.addAttribute("vendors", vendorRepository.findAll());
        model.addAttribute("accounts", accountRepository.findAll());
        model.addAttribute("statuses", statusRepository.findAll());

        return "Admin/Expense";
    }


 // ================= SAVE EXPENSE =================
    @PostMapping("/expense/save")
    public String saveExpense(ExpenseEntity expense,
                              HttpSession session,
                              Model model) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        expense.setUser(admin);

        AccountEntity account = accountRepository
                .findById(expense.getAccount().getAccountId())
                .orElse(null);

        if (account == null) {
            model.addAttribute("error", "Account not found!");
            return "Admin/Expense";
        }

        Double balance = account.getAmount() == null ? 0.0 : account.getAmount();
        Float amount = expense.getAmount();

        // ✅ VALIDATION
        if (amount == null || amount <= 0) {
            model.addAttribute("error", "Amount must be greater than 0!");
            return "Admin/Expense";
        }

        if (balance < amount) {
            model.addAttribute("error",
                    "❌ Insufficient Balance! Available: ₹ " + balance);
            return "Admin/Expense";
        }

        // ✅ SAFE DEDUCTION
        account.setAmount(balance - amount);

        accountRepository.save(account);
        expenseRepository.save(expense);

        return "redirect:/admin/expense-list?success=added";
    }

    // ================= EXPENSE LIST =================
    @GetMapping("/expense-list")
    public String expenseList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) String sort,   // ✅ ADDED
            Model model) {

        List<ExpenseEntity> list;

        // ✅ CLEAN VALUES (FIX)
        keyword = (keyword == null) ? "" : keyword.trim();
        status = (status == null) ? "" : status.trim();
        startDate = (startDate == null) ? "" : startDate.trim();
        endDate = (endDate == null) ? "" : endDate.trim();
        sort = (sort == null) ? "" : sort.trim(); // ✅ ADDED

        LocalDate start = null;
        LocalDate end = null;

        // ✅ SAFE DATE PARSE (FIXED ERROR)
        if (!startDate.isEmpty() && !endDate.isEmpty()) {
            try {
                start = LocalDate.parse(startDate);
                end = LocalDate.parse(endDate);
            } catch (Exception e) {
                start = null;
                end = null;
            }
        }

        UserEntity user = null;
        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
        }

        // ✅ YOUR ORIGINAL LOGIC (UNCHANGED)
        if (keyword.isEmpty() && status.isEmpty() && user == null && start == null) {

            list = expenseRepository.findAll();

        } else if (user != null && !status.isEmpty() && start != null) {

            list = expenseRepository
                    .findByUserAndStatus_StatusAndDateBetweenAndTitleContainingIgnoreCase(
                            user, status, start, end, keyword
                    );

        } else if (user != null && !status.isEmpty()) {

            list = expenseRepository.findByUserAndStatus_Status(user, status);

        } else if (!status.isEmpty()) {

            list = expenseRepository.findByStatus_Status(status);

        } else if (user != null) {

            list = expenseRepository.findByUser(user);

        } else if (start != null) {

            list = expenseRepository
                    .findByDateBetweenAndTitleContainingIgnoreCase(start, end, keyword);

        } else {

            list = expenseRepository.findByTitleContainingIgnoreCase(keyword);
        }

        // ✅ SORT LOGIC (ADDED ONLY)
        if (!sort.isEmpty()) {
            switch (sort) {
                case "amountAsc":
                    list.sort(Comparator.comparing(ExpenseEntity::getAmount));
                    break;
                case "amountDesc":
                    list.sort(Comparator.comparing(ExpenseEntity::getAmount).reversed());
                    break;
                case "dateAsc":
                    list.sort(Comparator.comparing(ExpenseEntity::getDate));
                    break;
                case "dateDesc":
                    list.sort(Comparator.comparing(ExpenseEntity::getDate).reversed());
                    break;
            }
        }

        // ✅ PAGINATION LOGIC (SAFE FIX ADDED)
        int startIndex = page * size;

        if (startIndex > list.size()) {
            startIndex = 0;
        }

        int endIndex = Math.min(startIndex + size, list.size());

        List<ExpenseEntity> paginatedList = list.subList(startIndex, endIndex);

        int totalPages = (int) Math.ceil((double) list.size() / size);

        // ✅ SEND DATA
        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("list", paginatedList);

        model.addAttribute("keyword", keyword);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("status", status);
        model.addAttribute("userId", userId);
        model.addAttribute("sort", sort); // ✅ ADDED

        // ✅ PAGINATION DATA
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);

        return "Admin/ExpenseList";
    }
    
 // ================= EDIT EXPENSE =================
    @GetMapping("/expense/edit")
    public String editExpense(@RequestParam Integer expenseId,
                              Model model,
                              HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        ExpenseEntity expense = expenseRepository.findById(expenseId).orElse(null);

        model.addAttribute("expense", expense);
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("subCategories", subCategoryRepository.findAll());
        model.addAttribute("vendors", vendorRepository.findAll());
        model.addAttribute("accounts", accountRepository.findAll());
        model.addAttribute("statuses", statusRepository.findAll());

        return "Admin/EditExpense";
    }
    
 // ================= UPDATE EXPENSE =================
    @PostMapping("/expense/update")
    public String updateExpense(ExpenseEntity expense,
                                HttpSession session,
                                Model model) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        ExpenseEntity oldExpense =
                expenseRepository.findById(expense.getExpenseId()).orElse(null);

        if (oldExpense == null) {
            return "redirect:/admin/expense-list";
        }

        AccountEntity account = accountRepository
                .findById(expense.getAccount().getAccountId())
                .orElse(null);

        Double balance = account.getAmount() == null ? 0.0 : account.getAmount();

        // ✅ ADD BACK OLD AMOUNT
        balance += oldExpense.getAmount();

        // ❌ CHECK AGAIN
        if (balance < expense.getAmount()) {
            model.addAttribute("error", "Insufficient balance!");
            return "Admin/EditExpense";
        }

        // ✅ FINAL UPDATE
        account.setAmount(balance - expense.getAmount());
        accountRepository.save(account);

        expense.setUser(admin);
        expenseRepository.save(expense);

        return "redirect:/admin/expense-list?success=updated";
    }
    
 // ================= PDF EXPENSE =================
    
    @GetMapping("/expense/pdf")
    public ResponseEntity<InputStreamResource> exportPdf() {

        List<ExpenseEntity> list = expenseRepository.findAll();

        ByteArrayInputStream pdf =
                PdfGenerator.generateExpensePdf(list);

        return ResponseEntity.ok()
                .header("Content-Disposition", "inline; filename=expense.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }
    
 // ================= FILTER EXPENSE =================
    
    @GetMapping("/expense/pdf/filter")
    public ResponseEntity<InputStreamResource> exportFilteredPdf(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer userId) {

        List<ExpenseEntity> list;

        LocalDate start = null;
        LocalDate end = null;

        if (startDate != null && !startDate.isEmpty() &&
            endDate != null && !endDate.isEmpty()) {

            start = LocalDate.parse(startDate);
            end = LocalDate.parse(endDate);
        }

        UserEntity user = null;
        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
        }

        if (keyword == null) keyword = "";
        if (status == null) status = "";

     // ✅ SAME LOGIC AS LIST (FIXED)
        if (user != null && !status.isEmpty() && start != null) {

            list = expenseRepository
                    .findByUserAndStatus_StatusAndDateBetweenAndTitleContainingIgnoreCase(
                            user, status, start, end, keyword
                    );

        } else if (user != null && !status.isEmpty()) {

            list = expenseRepository.findByUserAndStatus_Status(user, status);

        } else if (!status.isEmpty()) {

            list = expenseRepository.findByStatus_Status(status);

        } else if (user != null) {

            list = expenseRepository.findByUser(user);

        } else if (start != null) {

            list = expenseRepository
                    .findByDateBetweenAndTitleContainingIgnoreCase(start, end, keyword);

        } else if (!keyword.isEmpty()) {

            list = expenseRepository.findByTitleContainingIgnoreCase(keyword);

        } else {

            list = expenseRepository.findAll();
        }

        ByteArrayInputStream pdf =
                PdfGenerator.generateExpensePdf(list);

        return ResponseEntity.ok()
                .header("Content-Disposition", "inline; filename=filtered_expense.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }
    
 // ================= DELETE EXPENSE =================
    @GetMapping("/expense/delete")
    public String deleteExpense(@RequestParam Integer expenseId) {

        ExpenseEntity expense = expenseRepository.findById(expenseId).orElse(null);

        if (expense != null) {

            // 🔥 OPTIONAL (balance restore)
            AccountEntity account = expense.getAccount();

            if (account != null && account.getAmount() != null) {
                account.setAmount(account.getAmount() + expense.getAmount());
                accountRepository.save(account);
            }

            expenseRepository.deleteById(expenseId);
        }

        return "redirect:/admin/expense-list?success=deleted";
    }
}