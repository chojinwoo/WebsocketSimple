package com.websocket.user.vo;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.HashSet;

/**
 * Created by jinwoo on 2015-03-15.
 */
public class UserVo implements UserDetails{

    private String email;
    private String password;
    private String name;
    private String phoneNum;
    private String img = "";
    private String regId;
    private HashSet<GrantedAuthority> authorities;
    private boolean ACCOUNTNONEXPIRED = true;
    private boolean ACCOUNTNONLOCKED = true;
    private boolean CREDENTIALSNONEXPIRED = true;
    private boolean ENABLED = true;

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {

        this.regId = regId;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum;
    }

    public void setAuthorities(HashSet<GrantedAuthority> authorities) {
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return this.authorities;
    }

    @Override
    public String getPassword() {
        return this.password;
    }

    @Override
    public String getUsername() {
        return this.email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return this.ACCOUNTNONEXPIRED;
    }

    @Override
    public boolean isAccountNonLocked() {
        return this.ACCOUNTNONLOCKED;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return this.CREDENTIALSNONEXPIRED;
    }

    @Override
    public boolean isEnabled() {
        return this.ENABLED;
    }
}
