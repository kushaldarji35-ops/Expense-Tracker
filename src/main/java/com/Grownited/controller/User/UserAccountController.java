package com.Grownited.controller.User;

import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.AccountEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.AccountRepository;
import com.Grownited.repository.ExpenseRepository;
import com.Grownited.repository.IncomeRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;

@Controller
@RequestMapping("/user")
public class UserAccountController {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private ExpenseRepository expenseRepository;

    @Autowired
    private IncomeRepository incomeRepository;

    // ================= OPEN ADD ACCOUNT =================
    @GetMapping("/account")
    public String openAccountPage(Model model, HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        List<AccountEntity> accounts =
                accountRepository.findByUserId(user.getUserId());

        model.addAttribute("accounts", accounts);

        return "User/AddAccount";
    }

    // ================= SAVE =================
    @PostMapping("/account")
    public String saveAccount(AccountEntity accountEntity,
                              HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        accountEntity.setUserId(user.getUserId());

        if (accountEntity.getAmount() == null) {
            accountEntity.setAmount(0.0);
        }

        if (accountEntity.getAmount() < 0) {
            return "redirect:/user/account?error=invalidAmount";
        }

        accountRepository.save(accountEntity);

        return "redirect:/user/accountList?success=added";
    }

    // ================= LIST =================
    @GetMapping("/accountList")
    public String openAccountListPage(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) String type,
            Model model,
            HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        int size = 10;

        org.springframework.data.domain.Sort sorting = org.springframework.data.domain.Sort.unsorted();

        if ("asc".equals(sort)) {
            sorting = org.springframework.data.domain.Sort.by("amount").ascending();
        } else if ("desc".equals(sort)) {
            sorting = org.springframework.data.domain.Sort.by("amount").descending();
        }

        Pageable pageable = PageRequest.of(page, size, sorting);
        Page<AccountEntity> accountPage;

        if (keyword != null && !keyword.trim().isEmpty() && type != null && !type.isEmpty()) {

            accountPage = accountRepository
                    .findByUserIdAndTitleContainingIgnoreCaseAndAccountType(
                            user.getUserId(), keyword, type, pageable);

        } else if (keyword != null && !keyword.trim().isEmpty()) {

            accountPage = accountRepository
                    .findByUserIdAndTitleContainingIgnoreCase(
                            user.getUserId(), keyword, pageable);

        } else if (type != null && !type.isEmpty()) {

            accountPage = accountRepository
                    .findByUserIdAndAccountType(
                            user.getUserId(), type, pageable);

        } else {

            accountPage = accountRepository
                    .findByUserId(user.getUserId(), pageable);
        }

        model.addAttribute("accounts", accountPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", accountPage.getTotalPages());
        model.addAttribute("keyword", keyword);

        model.addAttribute("sort", sort);
        model.addAttribute("type", type);

        return "User/UserAccountList";
    }

    // ================= DELETE =================
    @GetMapping("/account/delete")
    public String deleteAccount(@RequestParam Integer accountId,
                                HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        boolean hasExpense =
                expenseRepository.existsByAccountAccountId(accountId);

        boolean hasIncome =
                incomeRepository.existsByAccountAccountId(accountId);

        if (hasExpense || hasIncome) {
            return "redirect:/user/accountList?error=hasTransaction";
        }

        accountRepository.deleteById(accountId);

        return "redirect:/user/accountList?success=deleted";
    }

    // ================= EDIT =================
    @GetMapping("/account/edit")
    public String editAccount(@RequestParam Integer accountId,
                              Model model,
                              HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        AccountEntity account =
                accountRepository.findById(accountId).orElse(null);

        model.addAttribute("account", account);

        return "User/EditAccount";
    }

    // ================= UPDATE =================
    @PostMapping("/account/update")
    public String updateAccount(AccountEntity accountEntity,
                                HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // 👉 Get existing account from DB
        AccountEntity existingAccount =
                accountRepository.findById(accountEntity.getAccountId()).orElse(null);

        if (existingAccount == null) {
            return "redirect:/user/accountList?error=notfound";
        }

        // ✅ Update only allowed fields
        existingAccount.setTitle(accountEntity.getTitle());
        existingAccount.setAccountType(accountEntity.getAccountType());

        // ❌ DO NOT update amount (balance)

        accountRepository.save(existingAccount);

        return "redirect:/user/accountList?success=updated";
    }
    
}