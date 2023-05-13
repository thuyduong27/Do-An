package com.haivn.service;

import com.haivn.common_api.HethongNguoidungToken;
import org.springframework.stereotype.Service;

@Service
public interface TokenService {
    HethongNguoidungToken createToken(HethongNguoidungToken token);

    HethongNguoidungToken findByToken(String token);
}
