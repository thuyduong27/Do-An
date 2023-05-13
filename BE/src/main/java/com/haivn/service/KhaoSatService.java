package com.haivn.service;

import com.haivn.common_api.KhaoSat;
import com.haivn.dto.KhaoSatDto;
import com.haivn.dto.SinhVienKhaoSatDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.KhaoSatMapper;
import com.haivn.repository.KhaoSatRepository;
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
public class KhaoSatService {
    private final KhaoSatRepository repository;
    private final KhaoSatMapper khaoSatMapper;
    private final SinhVienThucTapService sinhVienThucTapService;
    private final SinhVienKhaoSatService sinhVienKhaoSatService;


    public KhaoSatService(KhaoSatRepository repository, KhaoSatMapper khaoSatMapper, SinhVienThucTapService sinhVienThucTapService,SinhVienKhaoSatService sinhVienKhaoSatService) {
        this.repository = repository;
        this.khaoSatMapper = khaoSatMapper;
        this.sinhVienThucTapService = sinhVienThucTapService;
        this.sinhVienKhaoSatService = sinhVienKhaoSatService;
    }

    public KhaoSatDto save(KhaoSatDto khaoSatDto) {
        KhaoSat entity = khaoSatMapper.toEntity(khaoSatDto);
        return khaoSatMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        KhaoSat data = repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        );
        data.setDeleted(true);
        repository.save(data);
    }

    public KhaoSatDto findById(Long id) {
        return khaoSatMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<KhaoSatDto> findByCondition(@Filter Specification<KhaoSat> spec, Pageable pageable) {
        Page<KhaoSat> entityPage = repository.findAll(spec,pageable);
        List<KhaoSat> entities = entityPage.getContent();
        List<KhaoSatDto> dto = khaoSatMapper.toDto(entities);

        dto.forEach((element)->{
            element.setSoluongKS( sinhVienKhaoSatService.findByIdKhaoSat(element.getId()).size());
            element.setSoluongSV(sinhVienThucTapService.findByIdKhtt(element.getIdKhtt()).size());
        });
        return new PageImpl<>(dto, pageable, entityPage.getTotalElements());
    }

    public KhaoSatDto update(KhaoSatDto khaoSatDto, Long id) {
        KhaoSatDto data = findById(id);
        KhaoSat entity = khaoSatMapper.toEntity(khaoSatDto);
        BeanUtils.copyProperties(data, entity, Utils.getNullPropertyNames(entity));
        return save(khaoSatMapper.toDto(entity));
    }
}