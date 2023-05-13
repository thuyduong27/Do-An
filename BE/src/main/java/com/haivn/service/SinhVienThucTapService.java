package com.haivn.service;

import com.haivn.common_api.SinhVienThucTap;
import com.haivn.dto.DiemDto;
import com.haivn.dto.SinhVienThucTapDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.SinhVienThucTapMapper;
import com.haivn.repository.SinhVienThucTapRepository;
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
public class SinhVienThucTapService {
    private final SinhVienThucTapRepository repository;
    private final SinhVienThucTapMapper sinhVienThucTapMapper;
    private final NhatKyThucTapService nhatKyThucTapService;

    public SinhVienThucTapService(SinhVienThucTapRepository repository, SinhVienThucTapMapper sinhVienThucTapMapper, NhatKyThucTapService nhatKyThucTapService) {
        this.repository = repository;
        this.sinhVienThucTapMapper = sinhVienThucTapMapper;
        this.nhatKyThucTapService = nhatKyThucTapService;
    }

    public SinhVienThucTapDto save(SinhVienThucTapDto sinhVienThucTapDto) {
        SinhVienThucTap entity = sinhVienThucTapMapper.toEntity(sinhVienThucTapDto);
        return sinhVienThucTapMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public SinhVienThucTapDto findById(Long id) {
        return sinhVienThucTapMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<SinhVienThucTapDto> findByCondition(@Filter Specification<SinhVienThucTap> spec, Pageable pageable) {
        Page<SinhVienThucTap> entityPage = repository.findAll(spec,pageable);
        List<SinhVienThucTap> entities = entityPage.getContent();
        List<SinhVienThucTapDto> listDto = sinhVienThucTapMapper.toDto(entities);
        listDto.forEach(element ->{
            Integer count =0;
            count = nhatKyThucTapService.countNKTT(element.getId());
            element.setCountNTT(count);
        });
        return new PageImpl<>(listDto, pageable, entityPage.getTotalElements());
    }

    public SinhVienThucTapDto update(SinhVienThucTapDto sinhVienThucTapDto, Long id) {
        SinhVienThucTapDto data = findById(id);
        SinhVienThucTap entity = sinhVienThucTapMapper.toEntity(sinhVienThucTapDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(sinhVienThucTapMapper.toDto(entity));
    }

    public List<SinhVienThucTapDto> findByIdKhtt(Long idKhtt) {
        List<SinhVienThucTap> entities = repository.findByIdKhtt(idKhtt);
        return sinhVienThucTapMapper.toDto(entities);
    }
    public Integer countForGVHD(Long idGvhd) {
        Integer count =0;
        List<SinhVienThucTap> entities = repository.findByIdGvhd(idGvhd);
        count= entities.size();
        return count;
    }
}