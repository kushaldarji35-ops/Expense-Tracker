package com.Grownited.controller.Admin;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.Grownited.entity.UserDetailEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.UserDetailRepository;
import com.Grownited.repository.UserRepository;
import com.Grownited.service.MailerService;
import com.cloudinary.Cloudinary;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserDetailRepository userDetailRepository;

    @Autowired
    private MailerService mailerService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private Cloudinary cloudinary;

    // ================= SIGNUP PAGE =================
    @GetMapping("/signup")
    public String openSignupPage() {
        return "Signup";
    }

    // ================= LOGIN PAGE =================
    @GetMapping("/login")
    public String openLoginPage() {
        return "Login";
    }

    // ================= AUTHENTICATE =================
    @PostMapping("/authenticate")
    public String authenticate(String email,
                               String password,
                               Model model,
                               HttpSession session) {

        Optional<UserEntity> op = userRepository.findByEmail(email);

        if (op.isPresent()) {

            UserEntity dbUser = op.get();

            if (passwordEncoder.matches(password, dbUser.getPassword())) {

                session.setAttribute("user", dbUser);

                if ("ADMIN".equalsIgnoreCase(dbUser.getRole())) {
                    return "redirect:/admin/dashboard";
                } 
                else if ("USER".equalsIgnoreCase(dbUser.getRole())) {
                    return "redirect:/user/dashboard";
                }
            }
        }

        model.addAttribute("error", "Invalid Credentials");
        return "Login";
    }

    // ================= REGISTER =================
    @PostMapping("/register")
    public String register(UserEntity userEntity,
                           UserDetailEntity userDetailEntity,
                           MultipartFile profilePic,
                           Model model) {

        try {

            if (userRepository.findByEmail(userEntity.getEmail()).isPresent()) {
                model.addAttribute("error", "Email already registered");
                return "Signup";
            }

            userEntity.setRole("USER");
            userEntity.setActive(true);
            userEntity.setCreatedAt(LocalDate.now());

            String encodedPassword = passwordEncoder.encode(userEntity.getPassword());
            userEntity.setPassword(encodedPassword);

            if (profilePic != null && !profilePic.isEmpty()) {

                Map<?, ?> uploadResult = cloudinary.uploader()
                        .upload(profilePic.getBytes(), null);

                String profilePicUrl = uploadResult.get("secure_url").toString();
                userEntity.setProfilePicURL(profilePicUrl);
            }

            userRepository.save(userEntity);

            userDetailEntity.setUser(userEntity);
            userDetailRepository.save(userDetailEntity);

            mailerService.sendWelcomeMail(userEntity);

            return "redirect:/login";

        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "Registration failed. Try again.");
            return "Signup";
        }
    }

    // ================= LOGOUT =================
    @GetMapping("/admin/logout")
    public String logout(HttpSession session) {

        session.invalidate();
        return "redirect:/login";
    }
}