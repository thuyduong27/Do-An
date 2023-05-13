package com.haivn.repository;

import com.haivn.common_api.GiaoVien;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface GiaoVienRepository extends JpaRepository<GiaoVien, Long>, JpaSpecificationExecutor<GiaoVien> {
}