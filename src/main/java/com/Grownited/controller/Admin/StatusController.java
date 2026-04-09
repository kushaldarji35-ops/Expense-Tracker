package com.Grownited.controller.Admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.StatusEntity;
import com.Grownited.repository.StatusRepository;

@Controller
public class StatusController {

    @Autowired
    StatusRepository statusRepository;

    // OPEN STATUS PAGE
    @GetMapping("/admin/status")
    public String openStatusPage(Model model) {

        model.addAttribute("statuses", statusRepository.findAll());
        return "Admin/Status";
    }

    // SAVE STATUS
    @PostMapping("/admin/status")
    public String saveStatus(StatusEntity statusEntity) {

        statusRepository.save(statusEntity);
        return "redirect:/admin/listStatus";
    }

    // LIST PAGE
    @GetMapping("/admin/listStatus")
    public String listStatus(Model model) {

        model.addAttribute("statuses", statusRepository.findAll());
        return "Admin/ListStatus";
    }

    // DELETE
    @GetMapping("/admin/deleteStatus")
    public String deleteStatus(@RequestParam("statusId") Integer statusId) {

        statusRepository.deleteById(statusId);
        return "redirect:/admin/listStatus";
    }
}