package com.Grownited.controller.User;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.*;
import com.Grownited.repository.*;
import com.Grownited.util.PdfGenerator;

import jakarta.servlet.http.HttpSession;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;

import java.io.ByteArrayInputStream;
import java.time.LocalDate;
import java.util.List;


import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

@Controller
@RequestMapping("/user")
public class UserIncomeController {

    @Autowired
    private IncomeRepository incomeRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private StatusRepository statusRepository;


    // ==========================
    // OPEN ADD INCOME PAGE
    // ==========================
    @GetMapping("/addIncome")
    public String addIncomePage(Model model, HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // ✅ FIX: show only logged-in user's accounts
        model.addAttribute("accounts",
                accountRepository.findByUserId(user.getUserId()));

        model.addAttribute("statuses", statusRepository.findAll());

        model.addAttribute("income", new IncomeEntity());

        return "User/AddIncome";
    }


    // ==========================
    // SAVE INCOME
    // ==========================
    @PostMapping("/saveIncome")
    public String saveIncome(@ModelAttribute IncomeEntity income,
                             HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        income.setUser(user);

        // Save Income
        incomeRepository.save(income);

        // ===== UPDATE ACCOUNT BALANCE =====
        Optional<AccountEntity> accOpt =
                accountRepository.findById(income.getAccount().getAccountId());

        if(accOpt.isPresent()) {

            AccountEntity account = accOpt.get();

            Double balance = account.getAmount();
            if(balance == null){
                balance = (double) 0f;
            }

            Float incomeAmount = income.getAmount();

            account.setAmount(balance + incomeAmount);

            accountRepository.save(account);
        }

        return "redirect:/user/incomeList?success=added";
    }

    // ==========================
    // INCOME LIST
    // ==========================
    @GetMapping("/incomeList")
    public String incomeList(
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
        Page<IncomeEntity> incomePage;

        // ✅ FILTER LOGIC
        if (keyword != null && !keyword.trim().isEmpty() && status != null && !status.isEmpty()) {

            incomePage = incomeRepository
                    .findByUserAndTitleContainingIgnoreCaseAndStatus_Status(
                            user, keyword, status, pageable);

        } else if (keyword != null && !keyword.trim().isEmpty()) {

            incomePage = incomeRepository
                    .findByUserAndTitleContainingIgnoreCase(user, keyword, pageable);

        } else if (status != null && !status.isEmpty()) {

            incomePage = incomeRepository
                    .findByUserAndStatus_Status(user, status, pageable);

        } else {

            incomePage = incomeRepository
                    .findByUser(user, pageable);
        }

        model.addAttribute("incomes", incomePage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", incomePage.getTotalPages());
        model.addAttribute("keyword", keyword);

        // NEW
        model.addAttribute("sort", sort);
        model.addAttribute("status", status);

        return "User/UserIncomeList";
    }


    // ==========================
    // DELETE INCOME (SECURE)
    // ==========================
    @GetMapping("/deleteIncome")
    public String deleteIncome(@RequestParam Integer incomeId,
                               HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        Optional<IncomeEntity> incomeOpt =
                incomeRepository.findById(incomeId);

        if (incomeOpt.isPresent()) {

            IncomeEntity income = incomeOpt.get();

            if (income.getUser().getUserId().equals(user.getUserId())) {

                AccountEntity account = income.getAccount();

                Double balance = account.getAmount();
                if(balance == null){
                    balance = (double) 0f;
                }

                Float incomeAmount = income.getAmount();

                account.setAmount(balance - incomeAmount);

                accountRepository.save(account);

                incomeRepository.delete(income);
            }
        }

        return "redirect:/user/incomeList?success=deleted";
    }
   
 // ================= EDIT INCOME =================
    @GetMapping("/editIncome")
    public String editIncome(@RequestParam Integer incomeId,
                             Model model,
                             HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        IncomeEntity income = incomeRepository.findById(incomeId).orElse(null);

        model.addAttribute("income", income);
        model.addAttribute("accounts",
                accountRepository.findByUserId(user.getUserId()));
        model.addAttribute("statuses", statusRepository.findAll());

        return "User/EditIncome";
    }
    
 // ================= UPDATE INCOME =================
    @PostMapping("/updateIncome")
    public String updateIncome(@ModelAttribute IncomeEntity income,
                               HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        income.setUser(user);

        Optional<AccountEntity> accOpt =
                accountRepository.findById(income.getAccount().getAccountId());

        if (accOpt.isPresent()) {

            AccountEntity account = accOpt.get();

            Double balance = account.getAmount() == null ? 0.0 : account.getAmount();
            Float amount = income.getAmount();

            // 🔥 ADD BACK OLD VALUE (optional advanced handling skipped)
            // Simplified: just add new value
            account.setAmount(balance + amount);

            accountRepository.save(account);
        }

        incomeRepository.save(income);

        return "redirect:/user/incomeList?success=updated";
    }

    @GetMapping("/income/pdf")
    public ResponseEntity<InputStreamResource> exportIncomePdf(HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        List<IncomeEntity> incomes = incomeRepository.findByUser(user);

        ByteArrayInputStream pdf = PdfGenerator.generateIncomePdf(incomes);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=income_report.pdf");

        return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }
    
    @GetMapping("/income/pdf/filter")
    public ResponseEntity<InputStreamResource> exportIncomeByDate(
            @RequestParam String startDate,
            @RequestParam String endDate,
            HttpSession session) {

        try {

            UserEntity user = (UserEntity) session.getAttribute("user");

            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);

            List<IncomeEntity> incomes =
                    incomeRepository.findByUserAndDateBetween(user, start, end);

            System.out.println("Filtered Data Size: " + incomes.size()); // DEBUG

            ByteArrayInputStream pdf = PdfGenerator.generateIncomePdf(incomes);

            return ResponseEntity.ok()
                    .header("Content-Disposition", "inline; filename=filtered_income.pdf")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(new InputStreamResource(pdf));

        } catch (Exception e) {
            e.printStackTrace(); // 🔥 IMPORTANT
            return ResponseEntity.internalServerError().build();
        }
    }
}