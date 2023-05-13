package com.haivn.repository;

import com.haivn.common_api.Thongbao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ThongbaoRepository extends JpaRepository<Thongbao, Long>, JpaSpecificationExecutor<Thongbao> {
}