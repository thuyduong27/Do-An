package com.haivn.service;

import com.haivn.common_api.NhatKyThucTap;
import com.haivn.common_api.ThongBaoThucTap;
import com.haivn.dto.NhatKyThucTapDto;
import com.haivn.dto.ThongBaoThucTapDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.NhatKyThucTapMapper;
import com.haivn.repository.NhatKyThucTapRepository;
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
public class NhatKyThucTapService {
    private final NhatKyThucTapRepository repository;
    private final NhatKyThucTapMapper nhatKyThucTapMapper;

    public NhatKyThucTapService(NhatKyThucTapRepository repository, NhatKyThucTapMapper nhatKyThucTapMapper) {
        this.repository = repository;
        this.nhatKyThucTapMapper = nhatKyThucTapMapper;
    }

    public NhatKyThucTapDto save(NhatKyThucTapDto nhatKyThucTapDto) {
        NhatKyThucTap entity = nhatKyThucTapMapper.toEntity(nhatKyThucTapDto);
        return nhatKyThucTapMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public NhatKyThucTapDto findById(Long id) {
        return nhatKyThucTapMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<NhatKyThucTapDto> findByCondition(@Filter Specification<NhatKyThucTap> spec, Pageable pageable) {
        Page<NhatKyThucTap> entityPage = repository.findAll(spec,pageable);
        List<NhatKyThucTap> entities = entityPage.getContent();
        return new PageImpl<>(nhatKyThucTapMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public NhatKyThucTapDto update(NhatKyThucTapDto nhatKyThucTapDto, Long id) {
        NhatKyThucTapDto data = findById(id);
        NhatKyThucTap entity = nhatKyThucTapMapper.toEntity(nhatKyThucTapDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(nhatKyThucTapMapper.toDto(entity));
    }

    public Integer countNKTT(Long idSv){
        Integer count= 0 ;
        List<NhatKyThucTap> listNKTT = repository.findByIdSv(idSv);
        count = listNKTT.size();
        return count;
    }
}