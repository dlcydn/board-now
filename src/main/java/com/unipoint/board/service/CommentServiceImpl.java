package com.unipoint.board.service;

import com.unipoint.board.dao.BoardDao;
import com.unipoint.board.dao.CommentDao;
import com.unipoint.board.domain.CommentDto;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CommentServiceImpl implements CommentService{

    private BoardDao boardDao;
    private CommentDao commentDao;

    public CommentServiceImpl(CommentDao commentDao, BoardDao boardDao) {
        this.commentDao = commentDao;
        this.boardDao = boardDao;
    }

    @Override
    public int getCount(Integer bno) throws Exception {
        return commentDao.count(bno);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int remove(Integer cno, Integer bno, String commenter) throws Exception {
        int rowCnt = boardDao.increaseCommentCnt(-1, bno);
        System.out.println("updateCommentCnt - rowCnt = " + rowCnt);

        rowCnt = commentDao.delete(cno, commenter);
        System.out.println("rowCnt = " + rowCnt);

        return rowCnt;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int write(CommentDto commentDto) throws Exception {
        boardDao.increaseCommentCnt(1, commentDto.getBno());
        return commentDao.insertCno(commentDto);
    }

    @Override
    public List<CommentDto> getList(Integer bno) throws Exception {
        return commentDao.selectCnoAll(bno);
    }

    @Override
    public CommentDto read (Integer cno) throws Exception {
        return commentDao.select(cno);
    }

    @Override
    public int modify (CommentDto commentDto) throws Exception {
        return commentDao.update(commentDto);
    }


}
