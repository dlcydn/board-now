package com.unipoint.board.dao;

import com.unipoint.board.domain.*;
import org.apache.ibatis.session.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import java.util.*;

@Repository
public class CommentDaoImpl implements CommentDao {

    @Autowired
    private SqlSession session;

    private static String namespace = "com.unipoint.board.dao.CommentMapper.";

    @Override
    public int deleteCnoAll(Integer bno){
        return session.delete(namespace + "deleteCnoAll", bno);
    }

    @Override
    public int delete(Integer cno, String commenter) throws Exception {
        Map map = new HashMap();
        map.put("cno",cno);
        map.put("commenter", commenter);
        return session.delete(namespace + "delete", map);
    }

    @Override
    public int insertCno(CommentDto commentDto) throws Exception {
        return session.insert(namespace + "insertCno", commentDto);
    }

    @Override
    public List<CommentDto> selectCnoAll(Integer bno) throws Exception {
        return session.selectList(namespace + "selectCnoAll" + bno );
    }

    @Override
    public CommentDto select(Integer cno) throws Exception {
        return session.selectOne(namespace + "select"+cno);
    }

    @Override
    public int count(int bno) throws Exception {
        return session.selectOne(namespace + "count", bno);
    }

    @Override
    public int update(CommentDto commentDto) throws Exception {
        return session.update(namespace + "update" + commentDto);
    }

}
