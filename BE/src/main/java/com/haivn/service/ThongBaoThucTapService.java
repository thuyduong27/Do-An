package com.haivn.service;

import com.haivn.common_api.ThongBaoThucTap;
import com.haivn.common_api.Thongbao;
import com.haivn.dto.FileGvhdGuiSvDto;
import com.haivn.dto.ThongBaoThucTapDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.ThongBaoThucTapMapper;
import com.haivn.repository.ThongBaoThucTapRepository;
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
public class ThongBaoThucTapService {
    private final ThongBaoThucTapRepository repository;
    private final ThongBaoThucTapMapper thongBaoThucTapMapper;

    public ThongBaoThucTapService(ThongBaoThucTapRepository repository, ThongBaoThucTapMapper thongBaoThucTapMapper) {
        this.repository = repository;
        this.thongBaoThucTapMapper = thongBaoThucTapMapper;
    }

    public ThongBaoThucTapDto save(ThongBaoThucTapDto thongBaoThucTapDto) {
        ThongBaoThucTap entity = thongBaoThucTapMapper.toEntity(thongBaoThucTapDto);
        return thongBaoThucTapMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public ThongBaoThucTapDto findById(Long id) {
        return thongBaoThucTapMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<ThongBaoThucTapDto> findByCondition(@Filter Specification<ThongBaoThucTap> spec, Pageable pageable) {
        Page<ThongBaoThucTap> entityPage = repository.findAll(spec,pageable);
        List<ThongBaoThucTap> entities = entityPage.getContent();
        return new PageImpl<>(thongBaoThucTapMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public ThongBaoThucTapDto update(ThongBaoThucTapDto thongBaoThucTapDto, Long id) {
        ThongBaoThucTapDto data = findById(id);
        ThongBaoThucTap entity = thongBaoThucTapMapper.toEntity(thongBaoThucTapDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(thongBaoThucTapMapper.toDto(entity));
    }
}