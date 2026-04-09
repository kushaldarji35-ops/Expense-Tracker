package com.Grownited.controller.User;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.UserRepository;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserProfileController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ✅ CLOUDINARY
    @Autowired
    private Cloudinary cloudinary;

    // ================= SETTINGS =================
    @GetMapping("/settings")
    public String openSettings(HttpSession session, Model model) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) return "redirect:/login";

        model.addAttribute("user", user);
        return "User/UserSettings";
    }

    // ================= UPDATE PROFILE =================
    @PostMapping("/updateProfile")
    public String updateProfile(@RequestParam String firstName,
                               @RequestParam String lastName,
                               @RequestParam String email,
                               HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) return "redirect:/login";

        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setEmail(email.trim());

        userRepository.save(user);
        session.setAttribute("user", user);

        return "redirect:/user/settings?success=updated";
    }

    // ================= CHANGE PASSWORD =================
    @PostMapping("/changePassword")
    public String changePassword(@RequestParam String oldPassword,
                                @RequestParam String newPassword,
                                HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user == null) return "redirect:/login";

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            return "redirect:/user/settings?error=wrong";
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        return "redirect:/user/settings?success=password";
    }

    // ================= PROFILE IMAGE (CLOUDINARY) =================
    @PostMapping("/uploadProfilePic")
    public String uploadProfilePic(@RequestParam("profilePic") MultipartFile file,
                                  HttpSession session) {

        try {
            UserEntity user = (UserEntity) session.getAttribute("user");

            if (user == null) return "redirect:/login";
            if (file.isEmpty()) return "redirect:/user/settings";

            // ✅ Upload new image to Cloudinary
            Map uploadResult = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.emptyMap()
            );

            String newImageUrl = uploadResult.get("secure_url").toString();

            // ✅ OPTIONAL: delete old image from Cloudinary
            if (user.getProfilePicURL() != null) {
                String oldUrl = user.getProfilePicURL();

                try {
                    String publicId = oldUrl.substring(
                            oldUrl.lastIndexOf("/") + 1,
                            oldUrl.lastIndexOf(".")
                    );

                    cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());

                } catch (Exception e) {
                    // ignore if parsing fails
                }
            }

            // ✅ Save new URL
            user.setProfilePicURL(newImageUrl);
            userRepository.save(user);

            session.setAttribute("user", user);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/user/settings";
    }
    
 // ================= RemoveProfilePic =================
    
    @PostMapping("/removeProfilePic")
    public String removeProfilePic(HttpSession session) {

        try {
            UserEntity user = (UserEntity) session.getAttribute("user");

            if (user == null) return "redirect:/login";

            if (user.getProfilePicURL() != null) {

                String imageUrl = user.getProfilePicURL();

                // 🔥 Extract public_id from Cloudinary URL
                String publicId = imageUrl.substring(
                        imageUrl.lastIndexOf("/") + 1,
                        imageUrl.lastIndexOf(".")
                );

                // 🔥 Delete from Cloudinary
                cloudinary.uploader().destroy(publicId,
                        com.cloudinary.utils.ObjectUtils.emptyMap());

                // 🔥 Remove from DB
                user.setProfilePicURL(null);
                userRepository.save(user);

                session.setAttribute("user", user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/user/settings?success=removed";
    }

    // ================= LOGOUT =================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}