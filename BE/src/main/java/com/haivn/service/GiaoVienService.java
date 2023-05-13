package com.haivn.service;

import com.haivn.common_api.GiaoVien;
import com.haivn.dto.GiaoVienDto;
import com.haivn.dto.KeHoachThucTapDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.GiaoVienMapper;
import com.haivn.repository.GiaoVienRepository;
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
public class GiaoVienService {
    private final GiaoVienRepository repository;
    private final GiaoVienMapper giaoVienMapper;
    private final SinhVienThucTapService sinhVienThucTapService;

    public GiaoVienService(GiaoVienRepository repository, GiaoVienMapper giaoVienMapper,SinhVienThucTapService sinhVienThucTapService) {
        this.repository = repository;
        this.giaoVienMapper = giaoVienMapper;
        this.sinhVienThucTapService = sinhVienThucTapService;
    }

    public GiaoVienDto save(GiaoVienDto giaoVienDto) {
        GiaoVien entity = giaoVienMapper.toEntity(giaoVienDto);
        return giaoVienMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public GiaoVienDto findById(Long id) {
        return giaoVienMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<GiaoVienDto> findByCondition(@Filter Specification<GiaoVien> spec, Pageable pageable) {
        Page<GiaoVien> entityPage = repository.findAll(spec,pageable);
        List<GiaoVien> entities = entityPage.getContent();
        List<GiaoVienDto> listData = giaoVienMapper.toDto(entities);
        listData.forEach(element ->{
            Integer count = sinhVienThucTapService.countForGVHD(element.getId());
            System.out.printf("===="+element.getId()+"====");
            element.setSoLuong(count);
        });
        return new PageImpl<>(listData, pageable, entityPage.getTotalElements());
    }

    public GiaoVienDto update(GiaoVienDto giaoVienDto, Long id) {
        GiaoVienDto data = findById(id);
        GiaoVien entity = giaoVienMapper.toEntity(giaoVienDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(giaoVienMapper.toDto(entity));
    }
}