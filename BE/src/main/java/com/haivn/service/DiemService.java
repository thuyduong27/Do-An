package com.haivn.service;

import com.haivn.common_api.Diem;
import com.haivn.dto.DiemDto;
import com.haivn.mapper.DiemMapper;
import com.haivn.repository.DiemRepository;
import com.llq.springfilter.boot.Filter;
import lombok.extern.slf4j.Slf4j;
import org.mapstruct.factory.Mappers;
import com.haivn.handler.Utils;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@Transactional
public class DiemService {
    private final DiemRepository repository;
    private final DiemMapper diemMapper;

    public DiemService(DiemRepository repository, DiemMapper diemMapper) {
        this.repository = repository;
        this.diemMapper = diemMapper;
    }

    public DiemDto save(DiemDto diemDto) {
        Diem entity = diemMapper.toEntity(diemDto);
        return diemMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public DiemDto findById(Long id) {
        return diemMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<DiemDto> findByCondition(@Filter Specification<Diem> spec, Pageable pageable) {
        Page<Diem> entityPage = repository.findAll(spec,pageable);
        List<Diem> entities = entityPage.getContent();
        return new PageImpl<>(diemMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public DiemDto update(DiemDto diemDto, Long id) {
        DiemDto data = findById(id);
        Diem entity = diemMapper.toEntity(diemDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(diemMapper.toDto(entity));
    }
}