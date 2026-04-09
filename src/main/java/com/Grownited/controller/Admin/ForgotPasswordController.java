package com.Grownited.controller.Admin;

import java.util.Optional;
import java.util.Random;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.UserRepository;

@Controller
public class ForgotPasswordController {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // STEP 1: Open Forgot Password Page
    @GetMapping("/forgot-password")
    public String forgotPage() {
        return "forgot-password";   // forgot-password.jsp
    }

    // STEP 2: Send OTP
    @PostMapping("/send-otp")
    public String sendOtp(@RequestParam String email, HttpSession session) {

        Optional<UserEntity> user = userRepo.findByEmail(email);

        if (user.isEmpty()) {
            return "redirect:/forgot-password?error=notfound";
        }

        // Generate OTP
        int otp = new Random().nextInt(900000) + 100000;

        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setAttribute("otpTime", System.currentTimeMillis());

        // Send email
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Expense Tracker - Password Reset OTP");
        message.setText("Your OTP is: " + otp + "\nValid for 5 minutes.");

        mailSender.send(message);

        return "redirect:/verify-otp";
    }

    // STEP 3: Open OTP Page
    @GetMapping("/verify-otp")
    public String otpPage() {
        return "verify-otp";   // verify-otp.jsp
    }

    // STEP 4: Verify OTP
    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam int otp, HttpSession session) {

        Integer sessionOtp = (Integer) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpTime");

        if (sessionOtp == null || otpTime == null) {
            return "redirect:/forgot-password";
        }

        // OTP expiry check (5 minutes)
        if (System.currentTimeMillis() - otpTime > 300000) {
            session.invalidate();
            return "redirect:/forgot-password?error=expired";
        }

        // Check OTP
        if (otp == sessionOtp) {
            return "redirect:/reset-password";
        }

        return "redirect:/verify-otp?error=invalid";
    }

    // STEP 5: Open Reset Password Page
    @GetMapping("/reset-password")
    public String resetPage(HttpSession session) {

        if (session.getAttribute("email") == null) {
            return "redirect:/forgot-password";
        }

        return "reset-password";   // reset-password.jsp
    }

    // STEP 6: Update Password
    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String password,
                                @RequestParam String cpassword,
                                HttpSession session) {

        if (!password.equals(cpassword)) {
            return "redirect:/reset-password?error=nomatch";
        }

        String email = (String) session.getAttribute("email");

        if (email == null) {
            return "redirect:/forgot-password";
        }

        Optional<UserEntity> optionalUser = userRepo.findByEmail(email);

        if (optionalUser.isEmpty()) {
            return "redirect:/forgot-password?error=notfound";
        }

        UserEntity user = optionalUser.get();

        // Encode password
        String encodedPassword = passwordEncoder.encode(password);

        user.setPassword(encodedPassword);
        userRepo.save(user);

        session.invalidate();

        return "redirect:/login?reset=success";
    }
}