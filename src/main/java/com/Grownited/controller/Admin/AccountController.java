package com.Grownited.controller.Admin;

import java.util.List;
import java.util.Optional;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.AccountEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.AccountRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;

@Controller
@RequestMapping("/admin")
public class AccountController {

    @Autowired
    private AccountRepository accountRepository;


    // ================= HELPER METHOD =================
    private UserEntity getAdmin(HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            return null;
        }
        return user;
    }


    // ================= OPEN ACCOUNT PAGE =================
    @GetMapping("/account")
    public String openAccountPage(Model model, HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        List<AccountEntity> accounts = accountRepository.findAll();
        model.addAttribute("accounts", accounts);

        return "Admin/Account";
    }


    // ================= SAVE ACCOUNT =================
    @PostMapping("/account")
    public String saveAccount(AccountEntity accountEntity,
                              HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        // ✅ SET USER
        accountEntity.setUserId(admin.getUserId());

        // ✅ NULL SAFETY
        if (accountEntity.getAmount() == null) {
            accountEntity.setAmount(0.0);
        }

        // ✅ NEGATIVE CHECK
        if (accountEntity.getAmount() < 0) {
            return "redirect:/admin/account?error=invalidAmount";
        }

        accountRepository.save(accountEntity);

        return "redirect:/admin/accountList?success=added";
    }


    // ================= ACCOUNT LIST =================
    @GetMapping("/accountList")
    public String openAccountListPage(
            @RequestParam(defaultValue = "0") int page,      // ✅ ADDED
            @RequestParam(required = false) String keyword,  // ✅ ADDED
            Model model,
            HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        int size = 10;

        Pageable pageable = PageRequest.of(page, size);
        Page<AccountEntity> accountPage;

        // 🔍 SEARCH LOGIC
        if (keyword != null && !keyword.trim().isEmpty()) {
            accountPage = accountRepository
                    .findByTitleContainingIgnoreCase(keyword, pageable);
        } else {
            accountPage = accountRepository.findAll(pageable);
        }

        model.addAttribute("accounts", accountPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", accountPage.getTotalPages());
        model.addAttribute("keyword", keyword);

        return "Admin/AccountList";
    }
    // ================= DELETE ACCOUNT =================
    @GetMapping("/account/delete")
    public String deleteAccount(@RequestParam Integer accountId,
                                HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        Optional<AccountEntity> accountOpt =
                accountRepository.findById(accountId);

        if (accountOpt.isPresent()) {

            AccountEntity account = accountOpt.get();

            // ⚠️ OPTIONAL SAFETY CHECK
            // If account has balance → prevent delete
            if (account.getAmount() != null && account.getAmount() > 0) {
                return "redirect:/admin/account?error=hasBalance";
            }

            accountRepository.deleteById(accountId);
        }

        return "redirect:/admin/account";
    }
    
 // ================= EDIT ACCOUNT =================
    @GetMapping("/account/edit")
    public String editAccount(@RequestParam Integer accountId,
                               Model model,
                               HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        AccountEntity account = accountRepository.findById(accountId).orElse(null);

        model.addAttribute("account", account);

        return "Admin/EditAccount";
    }
    
 // ================= UPDATE ACCOUNT =================
    @PostMapping("/account/update")
    public String updateAccount(AccountEntity accountEntity,
                                 HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        // 👉 Get existing account from DB
        AccountEntity existingAccount =
                accountRepository.findById(accountEntity.getAccountId()).orElse(null);

        if (existingAccount == null) {
            return "redirect:/admin/accountList";
        }

        // ✅ Update only allowed fields
        existingAccount.setTitle(accountEntity.getTitle());
        existingAccount.setAccountType(accountEntity.getAccountType());

        // ❌ DO NOT update amount (balance)

        accountRepository.save(existingAccount);

        return "redirect:/admin/accountList?success=updated";
    }

}   