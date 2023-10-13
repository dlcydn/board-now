package com.unipoint.board.controller;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.validation.Valid;

import com.unipoint.board.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.StringArrayPropertyEditor;
import org.springframework.core.convert.ConversionService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.unipoint.board.domain.User;
import com.unipoint.board.domain.UserValidator;

@Controller // ctrl+shift+o auto import
@RequestMapping("/register")
public class RegisterController {

	@Autowired
	UserDao userDao;

	final int FAIL = 0;

	@InitBinder
	public void toDate(WebDataBinder binder) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(df, false));
		binder.setValidator(new UserValidator()); //register the UserValidator to WebDataBinder's local validator
	//	List<Validator> validatorList = binder.getValidators();
	//	System.out.println("validatorList="+validatorList);
	}
	
	@GetMapping("/add")
	public String register() {

		return "registerForm"; // WEB-INF/views/registerForm.jsp
	}
	
	@PostMapping("/add")
	public String save(@Valid User user, BindingResult result, Model m) throws Exception {
		System.out.println("result="+result);
		System.out.println("user="+user);

		// if have the result of confirm User Obj, denote the error using by register Form
		// User객체를 검증한 결과 에러가 있으면, registerForm을 이용해서 에러를 보여줘야 함.
		if(!result.hasErrors()) {
			// 2. insert the new user inform to DB
			int rowCnt = userDao.insertUser(user);

			if (rowCnt!=FAIL) {
				return "registerInfo";
			}
		}

		return "registerForm";
	}

	private boolean isValid(User user) {
		return true;
	}
}
