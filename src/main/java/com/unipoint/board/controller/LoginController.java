package com.unipoint.board.controller;

import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.unipoint.board.dao.UserDao;
import com.unipoint.board.domain.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.datetime.joda.LocalDateParser;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UrlPathHelper;

import static java.time.LocalTime.now;

@Controller
@RequestMapping("/login") //this one is like a family name of url page name
public class LoginController {
	@Autowired
	UserDao userDao;
	// UserDao를 가지고있는 Service가 없기 때문에 해당 내용을 사용하는 Controller에서 직접 Dao를 호출함.

	final int FAIL = 0;

	//=================== kakao login ====================
	@GetMapping("/kakao")
	public String loginKakao(HttpServletRequest request, HttpServletResponse response,
							 HttpSession session, Model model, String toURL) throws Exception {
		String clientId = "3966e15f85376df6e71aba28e12d0fcc"; //인증 및 동의
		String redirectUri = "http://localhost:80/login/kakao"; //인가 코드 발급 위치
		String code = request.getParameter("code"); //인가 코드

		String url = "https://kauth.kakao.com/oauth/token";
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		MultiValueMap<String, String> map= new LinkedMultiValueMap<>();
		map.add("client_id", clientId);
		map.add("redirect_uri", redirectUri);
		map.add("grant_type", "authorization_code");
		map.add("code", code);

		HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(map, headers);

		ResponseEntity<Map> responseEntity = new RestTemplate().postForEntity(url, requestEntity, Map.class);
		Map<String, Object> responseBody = responseEntity.getBody();

		//인가 코드로 토큰 요청
		String accessToken = (String) responseBody.get("access_token");

		session.setAttribute("accessToken", accessToken);
		model.addAttribute("accessToken", accessToken);

		return "/loginForm";
	}

	@PostMapping("/kakaoConnect")
	@ResponseBody
	public String kakaoUserCheck(@RequestBody Map<String, String> kakaoMessage,
								 String toURL, HttpServletRequest request) throws Exception {

		String email = kakaoMessage.get("email");

		//해당 이메일로 가입된 회원이 있는지 확인
		User exist = userDao.selectKakao(email);

		int rowCnt;
		User user = new User();
		Date now = new Date();

		try {
			if (exist != null) {
				//email에 해당하는 유저가 있을 경우 update
				User select = userDao.selectUser(kakaoMessage.get("id"));

				user.setId(kakaoMessage.get("id"));
				user.setPwd(select.getPwd());
				user.setEmail(kakaoMessage.get("email"));
				user.setName(select.getName());
				user.setBirth(select.getBirth());
				user.setSns("kakaotalk");
				user.setReg_date(select.getReg_date());

				rowCnt = userDao.updateUser(user);

			} else {
				//email 에 해당하는 유저가 없을 경우 insert

				user.setId(kakaoMessage.get("id"));
				user.setPwd("k" + kakaoMessage.get("id"));
				user.setName(kakaoMessage.get("nickname"));
				user.setEmail(kakaoMessage.get("email"));
				user.setBirth(now);
				user.setSns("kakaotalk");
				user.setReg_date(now);

				rowCnt = userDao.insertUser(user);
			}

			if(rowCnt != FAIL) {
				HttpSession session = request.getSession();
				session.setAttribute("id", user.getId());
				return "kakao login succeed.";

			} else {
				throw new Exception("kakao login failed.");
			}

		}catch (Exception e){
			e.printStackTrace();
			throw new Exception("kakao login failed!!");
		}
	}


	//============ normal login ===============
		@GetMapping("/login") //this one is like a last name of url page name
		public String loginForm () {

			return "loginForm"; //this one is the address of jsp
		}

		@GetMapping("/logout")
		public String logout (HttpSession session){
			session.invalidate();
			return "redirect:/";
		}

		@PostMapping("/login")
		public String login (String id, String pwd, String toURL,boolean rememberId, HttpServletRequest request,
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
			toURL = toURL == null || toURL.equals("") ? "/board/list" : toURL;
			return "redirect:" + toURL;

		}

		private boolean loginCheck (String id, String pwd){
			User user = null;

			try {
				user = userDao.selectUser(id);
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}

			return user != null && user.getPwd().equals(pwd);
		}

	}

