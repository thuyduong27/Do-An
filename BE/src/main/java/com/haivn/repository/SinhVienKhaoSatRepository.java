package com.haivn.repository;

import com.haivn.common_api.SinhVienKhaoSat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SinhVienKhaoSatRepository extends JpaRepository<SinhVienKhaoSat, Long>, JpaSpecificationExecutor<SinhVienKhaoSat> {
    List<SinhVienKhaoSat> findByIdKhaoSat(Long idKhaoSat);
}