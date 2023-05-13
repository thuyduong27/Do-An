package com.haivn.repository;

import com.haivn.common_api.Diem;
import com.haivn.dto.DiemDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DiemRepository extends JpaRepository<Diem, Long>, JpaSpecificationExecutor<Diem> {
//    List<Diem> findDiemBy
}