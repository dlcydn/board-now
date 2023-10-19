package com.unipoint.board.controller;

import com.unipoint.board.domain.*;
import com.unipoint.board.service.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.*;

import javax.servlet.http.*;
import java.time.*;
import java.util.*;

@Controller
@RequestMapping("/board")
public class BoardController {
    //Service 로 부터 필요한 값들을 받아서 화면에 연결해주는 역할을 하는 클래스

    @Autowired
    BoardService boardService;
    //Board Service를 받아옴.

    @Autowired
    CommentService commentService;

    @PostMapping("/modify")
    public String modify(BoardDto boardDto, SearchCondition sc, RedirectAttributes rattr, Model m, HttpSession session) {
        String writer = (String)session.getAttribute("id");
        boardDto.setWriter(writer);

        try {
            if (boardService.modify(boardDto)!= 1)
                throw new Exception("Modify failed.");

            rattr.addFlashAttribute("msg", "MOD_OK");
            return "redirect:/board/list"+sc.getQueryString();
        } catch (Exception e) {
            e.printStackTrace();
            m.addAttribute(boardDto);
            m.addAttribute("msg", "MOD_ERR");
            return "board";
        }
        //값을 처리한다기보다는 거의 맵핑 - 네비게이션 역할을 함.
    }

    @GetMapping("/write")
    public String write(Model m) {
        m.addAttribute("mode", "new");

        return "board";
        //same board but diffrent page is return. by the value of model -> if the model is new then return writing page
    }

    @PostMapping("/write")
    //this write is for the post mapping. when you click the write button, then this function works
    //for hide the post contents and information
    public String write(BoardDto boardDto, RedirectAttributes rattr, Model m, HttpSession session) {
        String writer = (String)session.getAttribute("id");
        boardDto.setWriter(writer);

        try {
            if (boardService.write(boardDto) != 1)
                throw new Exception("Write failed.");

            rattr.addFlashAttribute("msg", "WRT_OK");
            return "redirect:/board/list";
        } catch (Exception e) {
            e.printStackTrace();
            m.addAttribute(boardDto);
            m.addAttribute("mode", "new");
            m.addAttribute("msg", "WRT_ERR");
            return "board";
        }
    }

    @GetMapping("/read")
    public String read(Integer bno, SearchCondition sc, RedirectAttributes rattr, Model m) {
        try {
            BoardDto boardDto = boardService.read(bno);
            m.addAttribute(boardDto);
        } catch (Exception e) {
            e.printStackTrace();
            rattr.addFlashAttribute("msg", "READ_ERR");
            return "redirect:/board/list"+sc.getQueryString();
        }

        return "board";
    }
//
//    @RequestMapping(value="/read/comments",  produces="application/json; charset=utf8") // comments?bno=1080
//    public ResponseEntity<List<CommentDto>> list(Integer bno) {
//        List<CommentDto> list = null;
//
//        try {
//            list = commentService.getList(bno);
//            return new ResponseEntity<List<CommentDto>>(list, HttpStatus.OK); // 200
//        } catch (Exception e) {
//            e.printStackTrace();
//            // 사용자가 잘못 요청해서 에러나니까 400번대를 날린다.
//            return new ResponseEntity<List<CommentDto>>(HttpStatus.BAD_REQUEST); // 400
//        }
//    } //list

    @PostMapping("/remove")
    public String remove(Integer bno, SearchCondition sc, RedirectAttributes rattr, HttpSession session) {
        String writer = (String)session.getAttribute("id");
        String msg = "DEL_OK";

        try {
            if(boardService.remove(bno, writer)!=1)
                throw new Exception("Delete failed.");
        } catch (Exception e) {
            e.printStackTrace();
            msg = "DEL_ERR";
        }

        rattr.addFlashAttribute("msg", msg);
        return "redirect:/board/list"+sc.getQueryString();
    }

    @GetMapping("/list")
    public String list(Model m, SearchCondition sc, HttpServletRequest request) {
        if(!loginCheck(request))
            return "redirect:/login/login?toURL="+request.getRequestURL();  //if do not login, move to login page

        try {
            int totalCnt = boardService.getSearchResultCnt(sc);
            m.addAttribute("totalCnt", totalCnt);

            PageHandler pageHandler = new PageHandler(totalCnt, sc);

            List<BoardDto> list = boardService.getSearchResultPage(sc);
            m.addAttribute("list", list);
            m.addAttribute("ph", pageHandler);

            Instant startOfToday = LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant();
            m.addAttribute("startOfToday", startOfToday.toEpochMilli());
        } catch (Exception e) {
            e.printStackTrace();
            m.addAttribute("msg", "LIST_ERR");
            m.addAttribute("totalCnt", 0);
        }

        return "boardList"; // if do login, move to board list
    }

    private boolean loginCheck(HttpServletRequest request) {
        // 1. get the session (if the session doesn't exist, don't make new one - just return null)
        HttpSession session = request.getSession(false);
        // 2. confirm the session and if it has an id, return true
        return session!=null && session.getAttribute("id")!=null;
    }

}