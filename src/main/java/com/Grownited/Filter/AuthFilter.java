 package com.Grownited.Filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;

import org.springframework.stereotype.Component;

import com.Grownited.entity.UserEntity;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		@SuppressWarnings("unused")
		String url = req.getRequestURL().toString();
		String uri = req.getRequestURI().toString();

		ArrayList<String> publicUrl = new ArrayList<>();

		publicUrl.add("/login");
		publicUrl.add("/signup");
		publicUrl.add("/forgot-password");
		publicUrl.add("/authenticate");
		publicUrl.add("/reset-password");
		publicUrl.add("/verify-otp");
		publicUrl.add("/register");
		publicUrl.add("/send-otp"); 
		


		if (publicUrl.contains(uri) || uri.contains("assets")) {
			// go ahead
			chain.doFilter(request, response);
		} else {
			System.out.println("AuthFilter ......" + new Date());
			System.out.println(uri);
			HttpSession session = req.getSession();
			UserEntity user = (UserEntity) session.getAttribute("user");
			if (user == null) {
				// login
//				req.getRequestDispatcher("/login").forward(request, response);
				res.sendRedirect("/login");
			} else {
				chain.doFilter(request, response);
			}

		}

		// login no
		// forgetpassword no
		// admin-dashboard yes

	}
}
