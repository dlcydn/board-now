package com.unipoint.board.service;

import com.unipoint.board.dao.*;
import com.unipoint.board.domain.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.*;

import java.util.*;

@Service
public class CommentServiceImpl implements CommentService {
    @Autowired
    BoardDao boardDao;
    @Autowired
    CommentDao commentDao;

    @Autowired
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

        CommentDto comment = commentDao.select(cno);

        //삭제 이전의 댓글 수
        int before = commentDao.count(comment.getBno());

        //댓글 삭제 진행
        int rowCnt = commentDao.delete(cno, commenter);

        //삭제 이후의 댓글 수
        int after = commentDao.count(comment.getBno());

        //삭제 한 총 댓글 갯수
        //comment 삭제 시 reply 가 있는 comment 였다면 reply 까지 함께 삭제 -> 삭제된 총 comment + reply 갯수가 반영 되어야 함.
        //if remove the comment that have replies, they also removed too -> should count out all comment + replies.
        int tmp = before - after;

        //원래 댓글 수에서 삭제한 만큼의 댓글 수 삭제
        int updatedRows = boardDao.updateCommentCnt(comment.getBno(), -tmp);
        if (updatedRows != 1) {
            throw new Exception("Failed to update comment count.");
        }

        return rowCnt;

//        int rowCnt = boardDao.updateCommentCnt(bno, -1);
//        System.out.println("updateCommentCnt - rowCnt = " + rowCnt);
//        rowCnt = commentDao.delete(cno, commenter);
//        System.out.println("rowCnt = " + rowCnt);
//        return rowCnt;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int write(CommentDto commentDto) throws Exception {
        boardDao.updateCommentCnt(commentDto.getBno(), 1);
//                throw new Exception("test");
        return commentDao.insert(commentDto);
    }

    @Override
    public List<CommentDto> getList(Integer bno) throws Exception {
//        throw new Exception("test");
        return commentDao.selectAll(bno);
    }

    @Override
    public CommentDto read(Integer cno) throws Exception {
        return commentDao.select(cno);
    }

    @Override
    public int modify(CommentDto commentDto) throws Exception {
        return commentDao.update(commentDto);
    }
}