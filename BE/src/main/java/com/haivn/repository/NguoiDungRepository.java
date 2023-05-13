package com.haivn.repository;

import com.haivn.common_api.NguoiDung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NguoiDungRepository extends JpaRepository<NguoiDung, Long>, JpaSpecificationExecutor<NguoiDung> {
    NguoiDung findByEmail(String email);
    NguoiDung findByUsername(String username);
    List<NguoiDung> findByRole(Short role);

}