package com.unipoint.board.service;

import com.unipoint.board.dao.*;
import com.unipoint.board.domain.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import java.util.*;

@Service
public class BoardServiceImpl implements BoardService {
    //Dao가 DB와 연동해서 받아온 값을 처리해서 Controller로 전달하는 역할을 하는 클래스.
    //현재는 게시판 프로젝트로 별다른 값 연산이나  처리가 필요없기 때문에
    //거의 Dao를 호출해서 값을 return 하는 역할만 하고있음.

    @Autowired
    BoardDao boardDao;
    //여기서 Dao를 데리고오고, 밑의 함수들이 Dao를 부른 값을 Dto 형식으로 반환하는데
    //Dao와 Dto 사이의 오고가는 set get 등의 처리를 어노테이션 달아놓으면 Spring 이 해줌.
    //UserDao 같은 경우에는 Service 가 없기도하니까 Dao에 일일이 작성한것도 있고 -> 예전 방식과 값 넘어가는걸 보기 좋음
    //또한 UserDao를 데려오는 Service가 없기 때문에 해당 내용을 사용하는 Controller에서 직접 Dao를 호출하고있는 것을 확인.

    @Override
    public int getCount() throws Exception {
        return boardDao.count();
        // Service -> Controller 로 값을 옮기는 과정에서 별도로 복잡한 연산이 필요하기도함.
        // boardService 에서 함수 작성하고 reflactor - rename 해서 만들면 원래 파일이 인터페이스가 되고, 내용은 Impl로 옮겨짐.
        // 결합도를 낮추어서 재사용 가능하고 변경이 생겼을 경우 용이하게 하기 위해서 interface 를 사용함.
    }

    @Override
    public int remove(Integer bno, String writer) throws Exception {
        return boardDao.delete(bno, writer);
    }

    @Override
    public int write(BoardDto boardDto) throws Exception {
        return boardDao.insert(boardDto);
    }

    @Override
    public List<BoardDto> getList() throws Exception {
        return boardDao.selectAll();
    }

    @Override
    public BoardDto read(Integer bno) throws Exception {
        BoardDto boardDto = boardDao.select(bno);
        boardDao.increaseViewCnt(bno);

        return boardDto;
    }

    @Override
    public List<BoardDto> getPage(Map map) throws Exception {
        return boardDao.selectPage(map);
    }

    @Override
    public int modify(BoardDto boardDto) throws Exception {
        return boardDao.update(boardDto);
    }

    @Override
    public int getSearchResultCnt(SearchCondition sc) throws Exception {
        return boardDao.searchResultCnt(sc);
    }

    @Override
    public List<BoardDto> getSearchResultPage(SearchCondition sc) throws Exception {
        return boardDao.searchSelectPage(sc);
    }
}
