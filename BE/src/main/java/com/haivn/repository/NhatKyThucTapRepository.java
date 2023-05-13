package com.haivn.repository;

import com.haivn.common_api.NhatKyThucTap;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NhatKyThucTapRepository extends JpaRepository<NhatKyThucTap, Long>, JpaSpecificationExecutor<NhatKyThucTap> {
    List<NhatKyThucTap> findByIdSv (Long idSv);
}