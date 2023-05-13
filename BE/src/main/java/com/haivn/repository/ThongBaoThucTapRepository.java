package com.haivn.repository;

import com.haivn.common_api.ThongBaoThucTap;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ThongBaoThucTapRepository extends JpaRepository<ThongBaoThucTap, Long>, JpaSpecificationExecutor<ThongBaoThucTap> {
}