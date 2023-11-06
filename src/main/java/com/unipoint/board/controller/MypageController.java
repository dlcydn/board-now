package com.unipoint.board.controller;

import com.unipoint.board.dao.UserDao;
import org.springframework.stereotype.Controller;
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
import java.net.URI;
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
    }


}
