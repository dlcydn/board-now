package com.unipoint.board.dao;

import com.unipoint.board.domain.CommentDto;

import java.util.List;

public interface CommentDao {
    int deleteCnoAll(Integer bno);

    int delete(Integer cno, String commenter) throws Exception;

    int insertCno (CommentDto commentDto) throws Exception;

    List<CommentDto> selectCnoAll(Integer bno) throws Exception;

    CommentDto select(Integer cno) throws Exception;

    int count(int bno) throws Exception;

    int update(CommentDto commentDto) throws Exception;
}
