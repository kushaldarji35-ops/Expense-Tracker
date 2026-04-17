package com.Grownited.service;

import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.Grownited.entity.UserEntity;
import jakarta.mail.internet.MimeMessage;

@Service
public class MailerService {

	@Autowired
	JavaMailSender javaMailSender;

	@Autowired
	private ResourceLoader resourceLoader;

	public void sendWelcomeMail(UserEntity user) {

		MimeMessage message = javaMailSender.createMimeMessage();

		Resource resource = resourceLoader.getResource("classpath:templates/WelcomeMailTempate.html");

		try {
			String html = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);

			MimeMessageHelper helper;

			String body = html.replace("${name}", user.getFirstName()).replace("${email}", user.getEmail())
					.replace("${loginUrl}", "http://localhost:9999/login").replace("${companyName}", "MoneyTrail");

			helper = new MimeMessageHelper(message, true);
			helper.setTo(user.getEmail());
			helper.setSubject("MoneyTrail - Welcome aboard !!! ");
			helper.setText(body, true);

			javaMailSender.send(message);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	public void sendOtpMail(UserEntity user) {
		 MimeMessage message = javaMailSender.createMimeMessage();
		 Resource resource = resourceLoader.getResource("classpath:templates/OtpMailTemplate.html");

	    try {
	    	String html = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);

	        String body = html
	                .replace("${name}", user.getFirstName())
	                .replace("${otp}", user.getOtp())
	                .replace("${companyName}", "MoneyTrail");
	        MimeMessageHelper helper = new MimeMessageHelper(message, true);
	        
	        helper.setTo(user.getEmail());
	        helper.setSubject("MoneyTrail - Password Reset OTP");
	        helper.setText(body, true);
	        javaMailSender.send(message);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}