package com.Grownited.controller.Admin;

/* ================= IMPORTS ================= */

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.AccountRepository;
import com.Grownited.repository.ExpenseRepository;
import com.Grownited.repository.IncomeRepository;
import com.Grownited.repository.UserDetailRepository;
import com.Grownited.repository.UserRepository;

import org.springframework.transaction.annotation.Transactional;

/* ================= CONTROLLER ================= */

@Controller
public class AdminUserController {

    /* ================= DEPENDENCY ================= */
    @Autowired
    UserRepository userRepository;
    
    @Autowired
    IncomeRepository incomeRepository;
    
    @Autowired
    ExpenseRepository expenseRepository;
    
    @Autowired
    UserDetailRepository userDetailRepository;
    
    @Autowired
    AccountRepository accountRepository;

    /* =========================================================
       ✅ USER LIST + SEARCH + PAGINATION
       ========================================================= */
    @GetMapping("/admin/users")
    public String listUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            Model model) {

        int size = 10;

        Pageable pageable = PageRequest.of(page, size);
        Page<UserEntity> userPage;

        // 🔍 SEARCH LOGIC
        if (keyword != null && !keyword.trim().isEmpty()) {
            userPage = userRepository
                    .findByFirstNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                            keyword, keyword, pageable);
        } else {
            userPage = userRepository.findAll(pageable);
        }

        // 📦 SEND DATA TO VIEW
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("keyword", keyword);

        return "Admin/Users";
    }

    /* =========================================================
       ✅ VIEW USER
       ========================================================= */
    @GetMapping("/admin/viewUser")
    public String viewUser(@RequestParam("userId") Integer userId, Model model) {

        Optional<UserEntity> op = userRepository.findById(userId);

        if (op.isPresent()) {
            model.addAttribute("user", op.get());
            return "Admin/ViewUser";
        }

        return "redirect:/admin/users";
    }

    /* =========================================================
       ✅ OPEN EDIT USER PAGE
       ========================================================= */
    @GetMapping("/admin/editUser")
    public String editUser(@RequestParam("userId") Integer userId, Model model) {

        Optional<UserEntity> op = userRepository.findById(userId);

        if (op.isPresent()) {
            model.addAttribute("user", op.get());
            return "Admin/EditUser";
        }

        return "redirect:/admin/users";
    }

    /* =========================================================
       ✅ UPDATE USER
       ========================================================= */
    @PostMapping("/admin/updateUser")
    public String updateUser(UserEntity userEntity) {

        Optional<UserEntity> op = userRepository.findById(userEntity.getUserId());

        if (op.isPresent()) {

            UserEntity existingUser = op.get();

            // ✏️ UPDATE BASIC DETAILS
            existingUser.setFirstName(userEntity.getFirstName());
            existingUser.setLastName(userEntity.getLastName());
            existingUser.setEmail(userEntity.getEmail());
            existingUser.setContactNum(userEntity.getContactNum());

            // ✅ ROLE UPDATE (SAFE CHECK)
            if (userEntity.getRole() != null && !userEntity.getRole().isEmpty()) {
                existingUser.setRole(userEntity.getRole());
            }

            // ✅ STATUS UPDATE (NULL SAFE)
            if (userEntity.getActive() != null) {
                existingUser.setActive(userEntity.getActive());
            }

            // 💾 SAVE UPDATED USER
            userRepository.save(existingUser);
        }

        return "redirect:/admin/users?success=updated";
    }

    /* =========================================================
       ✅ DELETE USER
       ========================================================= */
    @Transactional
    @GetMapping("/admin/deleteUser")
    public String deleteUser(@RequestParam Integer userId) {

        incomeRepository.deleteIncomeByUserId(userId);
        expenseRepository.deleteExpenseByUserId(userId);
        userDetailRepository.deleteUserDetailsByUserId(userId);

        // ✅ FIXED HERE
        accountRepository.deleteByUserId(userId);

        userRepository.deleteById(userId);

        return "redirect:/admin/users?success=deleted";
    }
    /* =========================================================
       ✅ ADD USER (SAVE)
       ========================================================= */
    @PostMapping("/admin/saveUser")
    public String saveUser(UserEntity userEntity) {

        userRepository.save(userEntity);

        return "redirect:/admin/users?success=added";
    }
}