package com.websocket.user.dao;

import com.websocket.user.vo.UserVo;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.List;

/**
 * Created by jinwoo on 2015-03-15.
 */
public interface UserDao {
    public int register(UserVo userVo);
    public List users(String email);
    public UserVo loadUserByUsername(String s) throws UsernameNotFoundException;
}
