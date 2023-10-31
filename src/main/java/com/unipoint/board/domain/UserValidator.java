package com.unipoint.board.domain;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.Date;

//import java.text.SimpleDateFormat;
//import java.util.Date;


public class UserValidator implements Validator {
	@Override
	public boolean supports(Class<?> clazz) {
//		return User.class.equals(clazz); // 검증하려는 객체가 User타입인지 확인 //Check whether the object want to verify is User type
		return User.class.isAssignableFrom(clazz); // clazz가 User 또는 그 자손인지 확인 //check wether the clazz is the User Type or child of User
	}

	@Override
	public void validate(Object target, Errors errors) {
		System.out.println("UserValidator.validate() is called");

		User user = (User)target;

		String id = user.getId();
		String pwd = user.getPwd();

		String name = user.getName();
		String email = user.getEmail();
		Date birth = user.getBirth();

//		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "id",  "required");
//		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "pwd", "required");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "required");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "required");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "birth", "required");

		//error message properties 에서 invalidLength 코드로 저장된 에러 메세지를 출력함. {"5","12"} 의 경우는 정수 출력을 위한 매개 변수.
		if(id==null || id.length() <  5 || id.length() > 12) {
			errors.rejectValue("id", "invalidLength", new String[]{"5","12"}, null);
		}

		if(pwd==null || pwd.length()<8 || pwd.length() > 20) {
			errors.rejectValue("pwd", "invalidLength", new String[]{"8","20"}, null);
		}

		if(!pwd.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")){
			errors.rejectValue("pwd", "noMatchPattern", null, null);
		}



	}//validate
}