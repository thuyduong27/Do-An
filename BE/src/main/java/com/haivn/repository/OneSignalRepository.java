package com.haivn.repository;

import com.haivn.common_api.OneSignal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface OneSignalRepository extends JpaRepository<OneSignal, Long>, JpaSpecificationExecutor<OneSignal> {
}
