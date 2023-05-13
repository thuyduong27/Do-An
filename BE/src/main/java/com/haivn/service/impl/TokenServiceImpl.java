package com.haivn.service.impl;

import com.haivn.common_api.HethongNguoidungToken;
import com.haivn.repository.TokenRepository;
import com.haivn.service.TokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TokenServiceImpl implements TokenService {
    @Autowired
    private TokenRepository tokenRepository;

    public HethongNguoidungToken createToken(HethongNguoidungToken token){
        return tokenRepository.saveAndFlush(token);
    }

    @Override
    public HethongNguoidungToken findByToken(String token) {
        return tokenRepository.findByToken(token);
    }
}
