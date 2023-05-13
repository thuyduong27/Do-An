package com.haivn.service;

import com.haivn.common_api.DoanhNghiep;
import com.haivn.dto.DoanhNghiepDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.DoanhNghiepMapper;
import com.haivn.repository.DoanhNghiepRepository;
import com.llq.springfilter.boot.Filter;
import lombok.extern.slf4j.Slf4j;
import org.mapstruct.factory.Mappers;
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
public class DoanhNghiepService {
    private final DoanhNghiepRepository repository;
    private final DoanhNghiepMapper doanhNghiepMapper;

    public DoanhNghiepService(DoanhNghiepRepository repository, DoanhNghiepMapper doanhNghiepMapper) {
        this.repository = repository;
        this.doanhNghiepMapper = doanhNghiepMapper;
    }

    public DoanhNghiepDto save(DoanhNghiepDto doanhNghiepDto) {
        DoanhNghiep entity = doanhNghiepMapper.toEntity(doanhNghiepDto);
        return doanhNghiepMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public DoanhNghiepDto findById(Long id) {
        return doanhNghiepMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<DoanhNghiepDto> findByCondition(@Filter Specification<DoanhNghiep> spec, Pageable pageable) {
        Page<DoanhNghiep> entityPage = repository.findAll(spec,pageable);
        List<DoanhNghiep> entities = entityPage.getContent();
        return new PageImpl<>(doanhNghiepMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public DoanhNghiepDto update(DoanhNghiepDto doanhNghiepDto, Long id) {
        DoanhNghiepDto data = findById(id);
        DoanhNghiep entity = doanhNghiepMapper.toEntity(doanhNghiepDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(doanhNghiepMapper.toDto(entity));
    }
}