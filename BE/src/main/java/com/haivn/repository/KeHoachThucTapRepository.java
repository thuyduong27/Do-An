package com.haivn.repository;

import com.haivn.common_api.KeHoachThucTap;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface KeHoachThucTapRepository extends JpaRepository<KeHoachThucTap, Long>, JpaSpecificationExecutor<KeHoachThucTap> {
}