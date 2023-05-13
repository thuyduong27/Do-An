package com.haivn.authenticate;

import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;

public class UserPrincipal  implements UserDetails {
    private Long userId;
    private String username;
    private String password;
    private boolean isTts = false;
    private boolean isCtv = false;
    private boolean isAam = false;
    private boolean isAdmin = false;
    private boolean isActive = true;
    private boolean isLocked = false;
    private String lockedReason;
    private Collection authorities;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    @Override
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Override
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isTts() {
        return isTts;
    }

    public void setTts(boolean tts) {
        isTts = tts;
    }

    public boolean isCtv() {
        return isCtv;
    }

    public void setCtv(boolean ctv) {
        isCtv = ctv;
    }

    public boolean isAam() {
        return isAam;
    }

    public void setAam(boolean aam) {
        isAam = aam;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    @Override
    public Collection getAuthorities() {
        return authorities;
    }

    public void setAuthorities(Collection authorities) {
        this.authorities = authorities;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public boolean isLocked() {
        return isLocked;
    }

    public void setLocked(boolean locked) {
        isLocked = locked;
    }

    public String getLockedReason() {
        return lockedReason;
    }

    public void setLockedReason(String lockedReason) {
        this.lockedReason = lockedReason;
    }

    @Override
    public boolean isAccountNonExpired() {
        return false;
    }

    @Override
    public boolean isAccountNonLocked() {
        return false;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return false;
    }

    @Override
    public boolean isEnabled() {
        return false;
    }
}
