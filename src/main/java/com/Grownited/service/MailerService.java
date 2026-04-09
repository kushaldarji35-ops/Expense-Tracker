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

//		public void sendWelcomeMail(UserEntity user) {
	//	
//			SimpleMailMessage message = new SimpleMailMessage(); 
//			
//			message.setTo(user.getEmail());
//			message.setFrom("tejasshah2k19@gmail.com");
//			message.setSubject("CodeVerse - Welcome aboard !!! ");
//			message.setText("Hey "+user.getFirstName()+", We are happy to on board in CodeVerse.");
	//	
//			javaMailSender.send(message);
//		}

		public void sendWelcomeMail(UserEntity user) {

		    if (user == null) {
		        System.out.println("User is null. Mail not sent.");
		        return;
		    }

		    String firstName = user.getFirstName() != null ? user.getFirstName() : "User";
		    String email = user.getEmail();

		    if (email == null || email.isEmpty()) {
		        System.out.println("Email is null. Mail not sent.");
		        return;
		    }

		    try {

		        MimeMessage message = javaMailSender.createMimeMessage();
		        MimeMessageHelper helper = new MimeMessageHelper(message, true);

		        Resource resource = resourceLoader.getResource("classpath:templates/WelcomeMailTempate.html");
		        String html = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);

		        String body = html
		                .replace("${name}", firstName)
		                .replace("${email}", email)
		                .replace("${loginUrl}", "http://localhost:9999/login")
		                .replace("${companyName}", "ExpenseTracker");

		        helper.setTo(email);
		        helper.setSubject("ExpenseTracker - Welcome aboard !!! ");
		        helper.setText(body, true);

		        javaMailSender.send(message);

		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}

		
		
	}
	
	

