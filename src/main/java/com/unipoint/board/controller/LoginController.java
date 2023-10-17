package com.unipoint.board.controller;

import java.net.URLEncoder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.unipoint.board.dao.UserDao;
import com.unipoint.board.domain.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/login") //this one is like a family name of url page name
public class LoginController {
	@Autowired
	UserDao userDao;
	// UserDao를 가지고있는 Service가 없기 때문에 해당 내용을 사용하는 Controller에서 직접 Dao를 호출함.

	@GetMapping("/login") //this one is like a last name of url page name
	public String loginForm() {

		return "loginForm"; //this one is the address of jsp
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		// 1. end the session
		session.invalidate();
		// 2. move to home
		return "redirect:/";
	}

	@PostMapping("/login")
	public String login(String id, String pwd, String toURL, boolean rememberId, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {

		// 1. confirm the id and pwd
		if (!loginCheck(id, pwd)) {
			// 2-1 if not match, move on to loginForm
			String msg = URLEncoder.encode("id 또는 pwd가 일치하지 않습니다.", "utf-8");

			return "redirect:/login/login?msg=" + msg;
		}
		// 2-2. if match the id and pwd,
		// create session - by session obj that get from request
		HttpSession session = request.getSession(); //get 으로 받아온 세션주소를 session 에 저장하면서 세션을 생성하고
		// set the id to created session
		session.setAttribute("id", id); //생성한 session에 id를 set

		if (rememberId) {
			// 1. make cookie
			Cookie cookie = new Cookie("id", id); // ctrl+shift+o auto import
//		       2. save to response
			response.addCookie(cookie);
		} else {
			// 1. delete cookie
			Cookie cookie = new Cookie("id", id); // ctrl+shift+o auto import
			cookie.setMaxAge(0); // delete cookie
//		       2. save to response
			response.addCookie(cookie);
		}

//		       3. move to home
		toURL = toURL == null || toURL.equals("") ? "/" : toURL;

		return "redirect:" + toURL;
	}

	private boolean loginCheck(String id, String pwd) {
		User user = null;

		try {
			user = userDao.selectUser(id);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

		return user != null && user.getPwd().equals(pwd);
//        return "asdf".equals(id) && "1234".equals(pwd);
	}
}
