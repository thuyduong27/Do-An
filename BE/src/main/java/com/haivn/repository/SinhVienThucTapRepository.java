package com.haivn.repository;

import com.haivn.common_api.NguoiDung;
import com.haivn.common_api.SinhVienThucTap;
import com.haivn.dto.SinhVienThucTapDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SinhVienThucTapRepository extends JpaRepository<SinhVienThucTap, Long>, JpaSpecificationExecutor<SinhVienThucTap> {
    List<SinhVienThucTap> findByIdKhtt(Long idKhtt);
    List<SinhVienThucTap> findByIdGvhd(Long idGvhd);
}