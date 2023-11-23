package com.unipoint.board.controller;

import com.unipoint.board.dao.UserDao;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import com.unipoint.board.domain.*;
import com.unipoint.board.service.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.*;

import javax.servlet.http.*;
import javax.validation.Valid;
import java.net.URI;
import java.text.SimpleDateFormat;
import java.time.*;
import java.util.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MypageController {

    @Autowired
    UserDao userDao;

    @GetMapping("/mypage")
    public String myPage(Model model, HttpSession session) throws Exception {
        //HTTP Request 로 받을 수도 있음.
        //String loginId = (String) request.getSession().getAttribute("loginId");

        //Session 을 통해서 id 를 받음.
        String id = (String)session.getAttribute("id");

        // 사용자 정보를 모델에 추가하고 mypage.jsp로 전달할 수 있습니다.
        // 사용자 정보를 userDao를 통해 가져와서 모델에 추가할 수 있습니다.
        User user = userDao.selectUser(id); //User 객체를 생성하고 안에 selectUser 한 결과를 담음.
        model.addAttribute("user", user); //model 에 user를 담아서 보냄

        return "mypage";
    } //my page inform

    // deleteUser 메서드 추가
    @RequestMapping(value = "/deleteUser", method = RequestMethod.POST)
    @ResponseBody
    public String deleteUser(HttpSession session) {
        String id = (String)session.getAttribute("id");

        if (id != null && !id.isEmpty()) {
            int result = userDao.deleteUser(id);
            if (result > 0) {
                // 사용자 정보 삭제 성공
                return "success to delete user";
            } else {
                // 사용자 정보 삭제 실패
                return "failed to delete user";
            }
        } else {
            // 사용자 정보가 없거나 비어있음
            return "no user";
        }
    } //delete


    @RequestMapping(value = "/updateUser", method = RequestMethod.POST)
    @ResponseBody
    public String updateUser(@Valid @RequestBody User user, BindingResult result, Model model) {
        // 사용자 정보를 업데이트하고 결과를 받아옵니다.

        if (result.hasErrors()) {
            return "error";
        }

        int UpdateRslt = userDao.updateUser(user);

        if (UpdateRslt > 0) {
            // 업데이트 성공 시 "success" 문자열을 반환
            return "success";
        } else {
            // 업데이트 실패 시 "fail" 또는 오류 메시지를 반환
            return "fail";
        }
    }//update

    @InitBinder
    public void toDate(WebDataBinder binder) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        binder.registerCustomEditor(Date.class, new CustomDateEditor(df, false));
        binder.setValidator(new UserValidator()); // UserValidator를 WebDataBinder의 로컬 validator로 등록
    }


} //class