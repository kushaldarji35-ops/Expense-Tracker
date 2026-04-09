package com.Grownited.controller.Admin;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.AccountEntity;
import com.Grownited.entity.IncomeEntity;
import com.Grownited.entity.StatusEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.IncomeRepository;
import com.Grownited.repository.AccountRepository;
import com.Grownited.repository.StatusRepository;
import com.Grownited.repository.UserRepository;
import com.Grownited.util.PdfGenerator;

import org.springframework.data.domain.Pageable;

import java.io.ByteArrayInputStream;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;


@Controller
@RequestMapping("/admin")
public class IncomeController {

    @Autowired
    private IncomeRepository incomeRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private StatusRepository statusRepository;
    
    @Autowired
    private UserRepository userRepository;


    // ================= HELPER METHOD =================
    private UserEntity getAdmin(HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            return null;
        }

        return user;
    }


    // ================= OPEN INCOME PAGE =================
    @GetMapping("/income")
    public String openIncomePage(Model model, HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        model.addAttribute("accounts", accountRepository.findAll());
        model.addAttribute("statuses", statusRepository.findAll());

        return "Admin/Income";
    }

 // ================= SAVE INCOME =================
    @PostMapping("/income/save")
    public String saveIncome(IncomeEntity income,
                             HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        income.setUser(admin);

        if (income.getAccount() == null || income.getStatus() == null) {
            return "redirect:/admin/income";
        }

        AccountEntity account = accountRepository
                .findById(income.getAccount().getAccountId())
                .orElse(null);

        StatusEntity status = statusRepository
                .findById(income.getStatus().getStatusId())
                .orElse(null);

        if (account == null || status == null) {
            return "redirect:/admin/income";
        }

        income.setAccount(account);
        income.setStatus(status);

        // 🔥 BALANCE PLUS
        if (account.getAmount() == null) {
            account.setAmount(0.0);
        }

        account.setAmount(account.getAmount() + income.getAmount());

        incomeRepository.save(income);
        accountRepository.save(account); // 🔥 SAVE UPDATED BALANCE

        return "redirect:/admin/incomeList?success=added";
    }
   
    // ================= INCOME LIST =================
    @GetMapping("/incomeList")
    public String incomeList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) String sort,
            Model model) {

        List<IncomeEntity> list;

        keyword = (keyword == null) ? "" : keyword.trim();
        status = (status == null) ? "" : status.trim();
        startDate = (startDate == null) ? "" : startDate.trim();
        endDate = (endDate == null) ? "" : endDate.trim();
        sort = (sort == null) ? "" : sort.trim();

        LocalDate start = null;
        LocalDate end = null;

        try {
            if (!startDate.isEmpty() && !endDate.isEmpty()) {
                start = LocalDate.parse(startDate);
                end = LocalDate.parse(endDate);
            }
        } catch (Exception e) {
            start = null;
            end = null;
        }

        UserEntity user = null;
        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
        }

        // ✅ SAME AS EXPENSE LOGIC
        if (keyword.isEmpty() && status.isEmpty() && user == null && start == null) {

            list = incomeRepository.findAll();

        } else if (user != null && !status.isEmpty() && start != null) {

            list = incomeRepository
                    .findByUserAndStatus_StatusAndDateBetweenAndTitleContainingIgnoreCase(
                            user, status, start, end, keyword
                    );

        } else if (user != null && !status.isEmpty()) {

            list = incomeRepository.findByUserAndStatus_Status(user, status);

        } else if (!status.isEmpty()) {

            list = incomeRepository.findByStatus_Status(status);

        } else if (user != null) {

            list = incomeRepository.findByUser(user);

        } else if (start != null) {

            list = incomeRepository
                    .findByDateBetweenAndTitleContainingIgnoreCase(start, end, keyword);

        } else {

            list = incomeRepository.findByTitleContainingIgnoreCase(keyword);
        }

        // ✅ SORT
        if (!sort.isEmpty()) {
            switch (sort) {
                case "amountAsc":
                    list.sort(Comparator.comparing(IncomeEntity::getAmount));
                    break;
                case "amountDesc":
                    list.sort(Comparator.comparing(IncomeEntity::getAmount).reversed());
                    break;
                case "dateAsc":
                    list.sort(Comparator.comparing(IncomeEntity::getDate));
                    break;
                case "dateDesc":
                    list.sort(Comparator.comparing(IncomeEntity::getDate).reversed());
                    break;
            }
        }

        // ✅ PAGINATION (MANUAL)
        int startIndex = page * size;
        if (startIndex > list.size()) startIndex = 0;

        int endIndex = Math.min(startIndex + size, list.size());

        List<IncomeEntity> paginatedList = list.subList(startIndex, endIndex);

        int totalPages = (int) Math.ceil((double) list.size() / size);

        model.addAttribute("incomes", paginatedList);
        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("statuses", statusRepository.findAll());

        model.addAttribute("keyword", keyword);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("status", status);
        model.addAttribute("userId", userId);
        model.addAttribute("sort", sort);

        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);

        return "Admin/IncomeList";
    }

    // ================= DELETE INCOME =================
    @GetMapping("/income/delete")
    public String deleteIncome(@RequestParam Integer incomeId,
                               HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        Optional<IncomeEntity> incomeOpt =
                incomeRepository.findById(incomeId);

        if (incomeOpt.isPresent()) {
            incomeRepository.deleteById(incomeId);
        }

        return "redirect:/admin/incomeList?success=deleted";
    }
    
 // ================= EDIT INCOME =================
    @GetMapping("/income/edit")
    public String editIncome(@RequestParam Integer incomeId,
                             Model model,
                             HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        IncomeEntity income = incomeRepository.findById(incomeId).orElse(null);

        model.addAttribute("income", income);
        model.addAttribute("accounts", accountRepository.findAll());
        model.addAttribute("statuses", statusRepository.findAll());

        return "Admin/EditIncome";
    }
    
 // ================= UPDATE INCOME =================
    @PostMapping("/income/update")
    public String updateIncome(IncomeEntity income,
                               HttpSession session) {

        UserEntity admin = getAdmin(session);

        if (admin == null) {
            return "redirect:/login";
        }

        income.setUser(admin);

        income.setAccount(
            accountRepository.findById(income.getAccount().getAccountId()).orElse(null)
        );

        income.setStatus(
            statusRepository.findById(income.getStatus().getStatusId()).orElse(null)
        );

        incomeRepository.save(income);

        return "redirect:/admin/incomeList?success=updated";
    }
    
    @GetMapping("/income/pdf")
    public ResponseEntity<InputStreamResource> exportIncomePdf() {

        List<IncomeEntity> list = incomeRepository.findAll();

        ByteArrayInputStream pdf =
                PdfGenerator.generateIncomePdf(list);

        return ResponseEntity.ok()
                .header("Content-Disposition", "inline; filename=income.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }
    
    @GetMapping("/income/pdf/filter")
    public ResponseEntity<InputStreamResource> exportFilteredIncomePdf(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer userId
    ) {

        keyword = (keyword == null) ? "" : keyword.trim();
        status = (status == null) ? "" : status.trim();

        LocalDate start = null;
        LocalDate end = null;

        try {
            if (startDate != null && !startDate.isEmpty() &&
                endDate != null && !endDate.isEmpty()) {

                start = LocalDate.parse(startDate);
                end = LocalDate.parse(endDate);
            }
        } catch (Exception e) {
            start = null;
            end = null;
        }

        UserEntity user = null;
        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
        }

        List<IncomeEntity> list;

        // ✅ SAME LOGIC AS UI (IMPORTANT)
        if (user != null && !status.isEmpty() && start != null) {

            list = incomeRepository
                    .findByUserAndTitleContainingIgnoreCaseAndStatus_Status(
                            user, keyword, status, Pageable.unpaged()
                    ).getContent();

        } else if (user != null && !status.isEmpty()) {

            list = incomeRepository
                    .findByUserAndStatus_Status(user, status, Pageable.unpaged())
                    .getContent();

        } else if (!status.isEmpty()) {

            list = incomeRepository.findByStatus_Status(status);

        } else if (user != null) {

            list = incomeRepository.findByUser(user);

        } else if (start != null) {

            list = incomeRepository
                    .findByDateBetweenAndTitleContainingIgnoreCase(start, end, keyword);

        } else if (!keyword.isEmpty()) {

            list = incomeRepository
                    .findByTitleContainingIgnoreCase(keyword, Pageable.unpaged())
                    .getContent();

        } else {

            list = incomeRepository.findAll();
        }

        ByteArrayInputStream pdf = PdfGenerator.generateIncomePdf(list);

        return ResponseEntity.ok()
                .header("Content-Disposition", "inline; filename=filtered_income.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(pdf));
    }
}