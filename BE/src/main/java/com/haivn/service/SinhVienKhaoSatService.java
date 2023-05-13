package com.haivn.service;

import com.haivn.common_api.KhaoSat;
import com.haivn.common_api.SinhVienKhaoSat;
import com.haivn.dto.SinhVienKhaoSatDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.SinhVienKhaoSatMapper;
import com.haivn.repository.SinhVienKhaoSatRepository;
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
public class SinhVienKhaoSatService {
    private final SinhVienKhaoSatRepository repository;
    private final SinhVienKhaoSatMapper sinhVienKhaoSatMapper;

    public SinhVienKhaoSatService(SinhVienKhaoSatRepository repository, SinhVienKhaoSatMapper sinhVienKhaoSatMapper) {
        this.repository = repository;
        this.sinhVienKhaoSatMapper = sinhVienKhaoSatMapper;
    }

    public SinhVienKhaoSatDto save(SinhVienKhaoSatDto sinhVienKhaoSatDto) {
        SinhVienKhaoSat entity = sinhVienKhaoSatMapper.toEntity(sinhVienKhaoSatDto);
        return sinhVienKhaoSatMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public SinhVienKhaoSatDto findById(Long id) {
        return sinhVienKhaoSatMapper.toDto(repository.findById(id).orElseThrow(()
        ->
                new EntityNotFoundException("Item Not Found! ID: " + id)));
    }

    public Page<SinhVienKhaoSatDto> findByCondition(@Filter Specification<SinhVienKhaoSat> spec, Pageable pageable) {
        Page<SinhVienKhaoSat> entityPage = repository.findAll(spec,pageable);
        List<SinhVienKhaoSat> entities = entityPage.getContent();
        return new PageImpl<>(sinhVienKhaoSatMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public SinhVienKhaoSatDto update(SinhVienKhaoSatDto sinhVienKhaoSatDto, Long id) {
        SinhVienKhaoSatDto data = findById(id);
        SinhVienKhaoSat entity = sinhVienKhaoSatMapper.toEntity(sinhVienKhaoSatDto);
        BeanUtils.copyProperties(data, entity, Utils.getNullPropertyNames(entity));
        return save(sinhVienKhaoSatMapper.toDto(entity));
    }

    public List<SinhVienKhaoSatDto> findByIdKhaoSat(Long idKhaoSat){
        List<SinhVienKhaoSat> entities = repository.findByIdKhaoSat(idKhaoSat);
        return sinhVienKhaoSatMapper.toDto(entities);
    }
}