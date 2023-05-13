package com.haivn.repository;

import com.haivn.common_api.HethongNguoidungToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TokenRepository extends JpaRepository<HethongNguoidungToken, Long> {
    HethongNguoidungToken findByToken(String token);
}
