package com.websocket.user.service;

import com.websocket.user.vo.UserVo;

import java.util.List;

/**
 * Created by jinwoo on 2015-03-15.
 */
public interface UserService {
    public int register(UserVo userVo);
    public List users(String email);
}
