package com.unipoint.board.dao;

import com.unipoint.board.domain.User;

public interface UserDao {
    int deleteUser(String id);

    User selectUser(String id) throws Exception;

    // the method that save the user's information to user_info Table
    int insertUser(User user);

    // 매개변수로 받은 사용자 정보로 user_info테이블을 update하는 메서드
    // the method that update the user's information get from argument to user_info Table
    int updateUser(User user);
}
