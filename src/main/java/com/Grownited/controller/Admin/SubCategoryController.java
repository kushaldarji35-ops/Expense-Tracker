package com.Grownited.controller.Admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.SubCategoryEntity;
import com.Grownited.repository.CategoryRepository;
import com.Grownited.repository.SubCategoryRepository;

@Controller
public class SubCategoryController {

    @Autowired
    private SubCategoryRepository subCategoryRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    // ================= OPEN ADD PAGE =================
    @GetMapping("/admin/subCategory")
    public String openSubCategoryPage(Model model) {

        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("subCategories", subCategoryRepository.findAll());

        return "Admin/SubCategory";
    }

    // ================= SAVE =================
    @PostMapping("/admin/subCategory")
    public String saveSubCategory(
            @RequestParam("subCategoryName") String subCategoryName,
            @RequestParam("categoryId") Integer categoryId) {

        SubCategoryEntity sub = new SubCategoryEntity();

        sub.setSubCategoryName(subCategoryName);
        sub.setCategory(categoryRepository.findById(categoryId).get());

        subCategoryRepository.save(sub);

        return "redirect:/admin/listSubCategory?success=added"; // ✅ added
    }

    // ================= LIST =================
    @GetMapping("/admin/listSubCategory")
    public String listSubCategory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            Model model) {

        int size = 10;

        Pageable pageable = PageRequest.of(page, size);
        Page<SubCategoryEntity> subCategoryPage;

        if (keyword != null && !keyword.trim().isEmpty()) {
            subCategoryPage = subCategoryRepository
                    .findBySubCategoryNameContainingIgnoreCase(keyword, pageable);
        } else {
            subCategoryPage = subCategoryRepository.findAll(pageable);
        }

        model.addAttribute("subCategories", subCategoryPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", subCategoryPage.getTotalPages());
        model.addAttribute("keyword", keyword);

        return "Admin/ListSubCategory";
    }

    // ================= DELETE =================
    @GetMapping("/admin/deleteSubCategory")
    public String deleteSubCategory(@RequestParam("subCategoryId") Integer subCategoryId) {

        subCategoryRepository.deleteById(subCategoryId);

        return "redirect:/admin/listSubCategory?success=deleted"; // ✅ added
    }

    // ================= EDIT =================
    @GetMapping("/admin/editSubCategory")
    public String editSubCategory(@RequestParam Integer subCategoryId,
                                 Model model) {

        SubCategoryEntity sub = subCategoryRepository.findById(subCategoryId).orElse(null);

        model.addAttribute("subCategory", sub);
        model.addAttribute("categories", categoryRepository.findAll());

        return "Admin/EditSubCategory";
    }

    // ================= UPDATE =================
    @PostMapping("/admin/updateSubCategory")
    public String updateSubCategory(
            @RequestParam Integer subCategoryId,
            @RequestParam String subCategoryName,
            @RequestParam Integer categoryId) {

        SubCategoryEntity sub = subCategoryRepository.findById(subCategoryId).orElse(null);

        sub.setSubCategoryName(subCategoryName);
        sub.setCategory(categoryRepository.findById(categoryId).get());

        subCategoryRepository.save(sub);

        return "redirect:/admin/listSubCategory?success=updated"; // ✅ added
    }
}