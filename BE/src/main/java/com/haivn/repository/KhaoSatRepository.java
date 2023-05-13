package com.haivn.repository;

import com.haivn.common_api.KhaoSat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface KhaoSatRepository extends JpaRepository<KhaoSat, Long>, JpaSpecificationExecutor<KhaoSat> {
}