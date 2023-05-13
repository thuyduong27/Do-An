package com.haivn.repository;

import com.haivn.common_api.DoanhNghiep;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface DoanhNghiepRepository extends JpaRepository<DoanhNghiep, Long>, JpaSpecificationExecutor<DoanhNghiep> {
}