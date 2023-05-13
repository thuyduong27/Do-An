package com.haivn.service;

import com.haivn.common_api.KeHoachThucTap;
import com.haivn.dto.DoanhNghiepDto;
import com.haivn.dto.KeHoachThucTapDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.KeHoachThucTapMapper;
import com.haivn.repository.KeHoachThucTapRepository;
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
public class KeHoachThucTapService {
    private final KeHoachThucTapRepository repository;
    private final KeHoachThucTapMapper keHoachThucTapMapper;


    public KeHoachThucTapService(KeHoachThucTapRepository repository, KeHoachThucTapMapper keHoachThucTapMapper) {
        this.repository = repository;
        this.keHoachThucTapMapper = keHoachThucTapMapper;

    }

    public KeHoachThucTapDto save(KeHoachThucTapDto keHoachThucTapDto) {
        KeHoachThucTap entity = keHoachThucTapMapper.toEntity(keHoachThucTapDto);
        entity.setNgayDiTt(keHoachThucTapDto.getNgayDiTt());
        entity.setNgayVeTt(keHoachThucTapDto.getNgayVeTt());
        return keHoachThucTapMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public KeHoachThucTapDto findById(Long id) {
        return keHoachThucTapMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<KeHoachThucTap> findByCondition(@Filter Specification<KeHoachThucTap> spec, Pageable pageable) {
        Page<KeHoachThucTap> entityPage = repository.findAll(spec,pageable);
        List<KeHoachThucTap> entities = entityPage.getContent();
        return new PageImpl<>(entities, pageable, entityPage.getTotalElements());
    }

    public KeHoachThucTapDto update(KeHoachThucTapDto keHoachThucTapDto, Long id) {
        KeHoachThucTapDto data = findById(id);
        KeHoachThucTap entity = keHoachThucTapMapper.toEntity(keHoachThucTapDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(keHoachThucTapDto);
    }
}