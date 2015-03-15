package com.websocket.user.dao;

import com.websocket.user.vo.UserVo;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

/**
 * Created by jinwoo on 2015-03-15.
 */
@Repository
public class UserDaoImpl implements UserDao {
    private SqlSessionTemplate sqlSessionTemplate;

    public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
        this.sqlSessionTemplate = sqlSessionTemplate;
    }

    @Override
    public int register(UserVo userVo) {
        return this.sqlSessionTemplate.insert("user.register", userVo);
    }

    @Override
    public List users(String email) {
        return this.sqlSessionTemplate.selectList("user.users", email);
    }

    @Override
    public UserVo loadUserByUsername(String email) throws UsernameNotFoundException {
        UserVo userVo = this.sqlSessionTemplate.selectOne("user.usersByUsernameQuery", email);
        List<HashMap> list = this.sqlSessionTemplate.selectList("user.authoritiesByUsernameQuery", email);
        HashSet hs = new HashSet();
        for(HashMap map : list) {
            final String authority = (String) map.get("authority");
            hs.add(new GrantedAuthority() {
                @Override
                public String getAuthority() {
                    return authority;
                }
            });
        }
        userVo.setAuthorities(hs);
        return userVo;
    }
}
