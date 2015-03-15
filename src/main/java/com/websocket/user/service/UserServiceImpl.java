package com.websocket.user.service;

import com.websocket.user.dao.UserDao;
import com.websocket.user.vo.UserVo;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by jinwoo on 2015-03-15.
 */
@Service
public class UserServiceImpl implements UserService, UserDetailsService {
    private UserDao userDao;

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return this.userDao.loadUserByUsername(email);
    }

    @Override
    public int register(UserVo userVo) {
        return this.userDao.register(userVo);
    }

    @Override
    public List users(String email) {
        return this.userDao.users(email);
    }
}
