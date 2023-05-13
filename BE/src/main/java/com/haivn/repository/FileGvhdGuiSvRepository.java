package com.haivn.repository;

import com.haivn.common_api.FileGvhdGuiSv;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface FileGvhdGuiSvRepository extends JpaRepository<FileGvhdGuiSv, Long>, JpaSpecificationExecutor<FileGvhdGuiSv> {
}