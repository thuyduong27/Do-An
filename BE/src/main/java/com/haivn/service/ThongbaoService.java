package com.haivn.service;

import com.haivn.common_api.Thongbao;
import com.haivn.dto.ThongbaoDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.ThongbaoMapper;
import com.haivn.repository.ThongbaoRepository;
import com.llq.springfilter.boot.Filter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.util.List;

@Slf4j
@Service
@Transactional
public class ThongbaoService {
    private final ThongbaoRepository repository;
    private final ThongbaoMapper thongbaoMapper;

    public ThongbaoService(ThongbaoRepository repository, ThongbaoMapper thongbaoMapper) {
        this.repository = repository;
        this.thongbaoMapper = thongbaoMapper;
    }

    public ThongbaoDto save(ThongbaoDto thongbaoDto) {
        Thongbao entity = thongbaoMapper.toEntity(thongbaoDto);
        return thongbaoMapper.toDto(repository.save(entity));
    }

    public Boolean saveAll(List<ThongbaoDto> lstThongbaoDto) {
        boolean rs = false;
        List<Thongbao> res = repository.saveAll(thongbaoMapper.toEntity(lstThongbaoDto));
        if(res.size()>0)
            rs = true;
        return rs;
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public ThongbaoDto findById(Long id) {
        return thongbaoMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<ThongbaoDto> findByCondition(@Filter Specification<Thongbao> spec, Pageable pageable) {
        Page<Thongbao> entityPage = repository.findAll(Specification.where(spec), pageable);
        List<Thongbao> entities = entityPage.getContent();
        return new PageImpl<>(thongbaoMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public List<ThongbaoDto> findBySpec(@Filter Specification<Thongbao> spec) {
//        List<Thongbao> entityPage = repository.findAll(Specification.where(spec), Sort.by(Sort.Direction.DESC, "id"));
        Page<Thongbao> entityPage = repository.findAll(Specification.where(spec), PageRequest.of(0, 10, Sort.by(Sort.Direction.DESC, "id")));
        List<Thongbao> entities = entityPage.getContent();
        return thongbaoMapper.toDto(entities);
    }

    public long getCount(@Filter Specification<Thongbao> spec) {
        return repository.count(Specification.where(spec));
    }

    public ThongbaoDto update(ThongbaoDto thongbaoDto, Long id) {
        ThongbaoDto data = findById(id);
        Thongbao entity = thongbaoMapper.toEntity(thongbaoDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(data);
    }
}