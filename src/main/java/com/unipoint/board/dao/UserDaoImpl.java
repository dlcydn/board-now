package com.unipoint.board.dao;

import com.unipoint.board.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    DataSource ds;
    final int FAIL = 0;

    public int deleteUser(String id) {
        int rowCnt = FAIL; // 실패 시 반환값

        Connection conn = null;
        PreparedStatement pstmt = null;

        String deleteCommentsQuery = "DELETE FROM comment WHERE commenter = ?";
        String updateBoardCommentCountQuery = "UPDATE board b SET b.comment_cnt = (SELECT COUNT(*) FROM comment c WHERE c.bno = b.bno)";
        String deletePostsQuery = "DELETE FROM board WHERE writer = ?";
        String deleteUserQuery = "DELETE FROM user_info WHERE id = ?";

        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // Step 1: 삭제될 회원이 작성한 댓글을 삭제
            pstmt = conn.prepareStatement(deleteCommentsQuery);
            pstmt.setString(1, id);
            pstmt.executeUpdate();

            // Step 2: 삭제될 댓글이 존재하던 게시글에서 삭제된 만큼의 댓글 수를 차감
            pstmt = conn.prepareStatement(updateBoardCommentCountQuery);
            pstmt.executeUpdate();

            // Step 3: 삭제될 회원이 작성한 게시글을 삭제
            pstmt = conn.prepareStatement(deletePostsQuery);
            pstmt.setString(1, id);
            pstmt.executeUpdate();

            // Step 4: 삭제될 회원의 정보를 삭제
            pstmt = conn.prepareStatement(deleteUserQuery);
            pstmt.setString(1, id);
            rowCnt = pstmt.executeUpdate();

            conn.commit(); // 트랜잭션 커밋
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // 트랜잭션 롤백
                }
            } catch (SQLException rollbackException) {
                rollbackException.printStackTrace();
            }
            e.printStackTrace();
            return FAIL;
        } finally {
            close(pstmt, conn);
        }

        return rowCnt;
    }


    @Override
    public User selectUser(String id) throws Exception {
        User user = null;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select * from user_info where id= ? ";
        //prepared statement 를 사용하기 때문에 물음표가 포함된 쿼리를 사용함.
        //일반 Statement 객체일 경우 완성된 쿼리 문장이어야함.

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql); // SQL Injection attack, Performance improvement
            pstmt.setString(1, id);

            rs = pstmt.executeQuery(); //  select
            // pstmt가 가지고 있는 쿼리를 executeQuery(실행함수)로 실행하여 반환된 레코드 값을 가상의 DB 테이블 형태로 받아 저장함.
            //next() 를 이용하여 커서를 이동하고 다음 행에 필드가 있으면 true, 없으면 false 가 됨.
            //next()는 포인터와 같아서 이동만 하기 때문에 필드 값의 유형에 따라 getString, getDate 등 get() 을 통해서 값을 가져오고
            //그걸 각 DTO의 set()을 호출하여 DTO에 담고 있는 것.
            if (rs.next()) {
                user = new User();
                user.setId(rs.getString(1));
                user.setPwd(rs.getString(2));
                user.setName(rs.getString(3));
                user.setEmail(rs.getString(4));
                user.setBirth(new Date(rs.getDate(5).getTime()));
                user.setSns(rs.getString(6));
                user.setReg_date(new Date(rs.getTimestamp(7).getTime()));
            }
        } catch (SQLException e) {
            return null;
        } finally {
            // may cause error by close(), surround try-catch
            // close()를 호출하다가 예외가 발생할 수 있으므로, try-catch로 감싸야함.
            // The calling order of close() is the reverse of the creation order.
            // close()의 호출순서는 생성된 순서의 역순
//            try { if(rs!=null)    rs.close();    } catch (SQLException e) { e.printStackTrace();}
//            try { if(pstmt!=null) pstmt.close(); } catch (SQLException e) { e.printStackTrace();}
//            try { if(conn!=null)  conn.close();  } catch (SQLException e) { e.printStackTrace();}
            close(rs, pstmt, conn);  //     private void close(AutoCloseable... acs) {

            //rs : Result set : 쿼리를 통해 DB로부터 얻어온 데이터를 받는 객체. DB 테이블을 가상의 테이블 형식으로 담을 수 있는 객체.
            //pstmt : Prepared Statement : DB로 보낼 쿼리와 실행하는 함수를 가지고 있는 객체.
            //conn : Connection : 실제 java 프로그램과 DB를 네트워크 상에서 연결 해주고 connection 하나당 하나의 트랜잭션을 관리함.

        }

        return user;
    }

    // ==== kakao login ====
    @Override
    public User selectKakao(String email) throws Exception {
        User user = null;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM user_info WHERE email = ?";

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getString(1));
                user.setPwd(rs.getString(2));
                user.setName(rs.getString(3));
                user.setEmail(rs.getString(4));
                user.setBirth(new Date(rs.getDate(5).getTime()));
                user.setSns(rs.getString(6));
                user.setReg_date(new Date(rs.getTimestamp(7).getTime()));
            }
        } catch (SQLException e) {
            return user;
        } finally {
            close(rs, pstmt, conn);
        }

        return user;
    }


    //the method that save the user's information to user_info Table
    // 사용자 정보를 user_info테이블에 저장하는 메서드
    @Override
    public int insertUser(User user) {
        int rowCnt = FAIL;

        Connection conn = null;
        PreparedStatement pstmt = null;

//        insert into user_info (id, pwd, name, email, birth, sns, reg_date)
//        values ('asdf22', '1234', 'smith', 'aaa@aaa.com', '2022-01-01', 'facebook', now());
        String sql = "insert into user_info values (?, ?, ?, ?,?,?, now()) ";

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql); // SQL Injection attack, Performance improvement
            pstmt.setString(1, user.getId());
            pstmt.setString(2, user.getPwd());
            pstmt.setString(3, user.getName());
            pstmt.setString(4, user.getEmail());
            pstmt.setDate(5, new java.sql.Date(user.getBirth().getTime()));
            pstmt.setString(6, user.getSns());

            return pstmt.executeUpdate(); //  insert, delete, update;

        } catch (SQLException e) {
            e.printStackTrace();
            return FAIL;
        } finally {
            close(pstmt, conn);  //     private void close(AutoCloseable... acs) {
        }

    }

    //the method that update user_info Table
    // 매개변수로 받은 사용자 정보로 user_info테이블을 update하는 메서드
    @Override
    public int updateUser(User user) {
        int rowCnt = FAIL;

//        Connection conn = null;
//        PreparedStatement pstmt = null;

        String sql = "update user_info " +
                "set pwd = ?, name=?, email=?, birth=?, sns=?" +
                "where id = ? ";

        try (
                Connection conn = ds.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql); // SQL Injection attack, Performance improvement
        ){
            pstmt.setString(1, user.getPwd());
            pstmt.setString(2, user.getName());
            pstmt.setString(3, user.getEmail());
            pstmt.setDate(4, new java.sql.Date(user.getBirth().getTime()));
            pstmt.setString(5, user.getSns());
            pstmt.setString(6, user.getId());

            rowCnt = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            return FAIL;
        }

        return rowCnt;
    }

    public void deleteAll() throws Exception {
        Connection conn = ds.getConnection();

        String sql = "delete from user_info ";

        PreparedStatement pstmt = conn.prepareStatement(sql); // SQL Injection attack, Performance improvement
        pstmt.executeUpdate(); //  insert, delete, update
    }

    private void close(AutoCloseable... acs) {
        for(AutoCloseable ac :acs)
            try { if(ac!=null) ac.close(); } catch(Exception e) { e.printStackTrace(); }
    }
}