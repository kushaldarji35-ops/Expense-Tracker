package com.Grownited.controller.Admin;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.CategoryEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.CategoryRepository;

@Controller
public class CategoryController {

    @Autowired
    CategoryRepository categoryRepository;

    // ================= OPEN CATEGORY PAGE =================
    @GetMapping("/admin/category")
    public String openCategoryPage(
            @RequestParam(defaultValue = "0") int page,
            Model model,
            HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        int size = 10;

        Pageable pageable = PageRequest.of(page, size);
        Page<CategoryEntity> categoryPage = categoryRepository.findAll(pageable);

        model.addAttribute("listCategory", categoryPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", categoryPage.getTotalPages());

        return "Admin/Category";
    }

    // ================= SAVE CATEGORY =================
    @PostMapping("/admin/category")
    public String saveCategory(CategoryEntity categoryEntity,
                               HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        categoryEntity.setUserId(user.getUserId());

        categoryRepository.save(categoryEntity);

        // ✅ SUCCESS MESSAGE ADDED
        return "redirect:/admin/listCategory?success=added";
    }

    // ================= LIST CATEGORY PAGE =================
    @GetMapping("/admin/listCategory")
    public String listCategory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            Model model,
            HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        int size = 10;

        Pageable pageable = PageRequest.of(page, size);
        Page<CategoryEntity> categoryPage;

        // 🔍 SEARCH LOGIC
        if (keyword != null && !keyword.trim().isEmpty()) {
            categoryPage = categoryRepository
                    .findByCategoryNameContainingIgnoreCase(keyword, pageable);
        } else {
            categoryPage = categoryRepository.findAll(pageable);
        }

        model.addAttribute("listCategory", categoryPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", categoryPage.getTotalPages());
        model.addAttribute("keyword", keyword);

        return "Admin/ListCategory";
    }
    
 // ================= OPEN EDIT CATEGORY PAGE =================
    @GetMapping("/admin/editCategory")
    public String editCategory(@RequestParam Integer categoryId,
                               Model model,
                               HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        CategoryEntity category = categoryRepository.findById(categoryId).orElse(null);

        model.addAttribute("category", category);

        return "Admin/EditCategory";   // JSP file name
    }
    
 // ================= UPDATE CATEGORY =================
    @PostMapping("/admin/updateCategory")
    public String updateCategory(CategoryEntity categoryEntity,
                                 HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        categoryEntity.setUserId(user.getUserId());

        categoryRepository.save(categoryEntity); // 🔥 update

        return "redirect:/admin/listCategory?success=updated";
    }

    // ================= DELETE CATEGORY =================
    @GetMapping("/admin/deleteCategory")
    public String deleteCategory(Integer categoryId,
                                 HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        categoryRepository.deleteById(categoryId);

        // ✅ SUCCESS MESSAGE ADDED
        return "redirect:/admin/listCategory?success=deleted";
    }
}