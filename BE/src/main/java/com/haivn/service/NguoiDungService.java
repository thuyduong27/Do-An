package com.haivn.service;

import com.haivn.common_api.NguoiDung;
import com.haivn.dto.NguoiDungDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.NguoiDungMapper;
import com.haivn.repository.NguoiDungRepository;
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
public class NguoiDungService {
    private final NguoiDungRepository repository;
    private final NguoiDungMapper nguoiDungMapper;

    public NguoiDungService(NguoiDungRepository repository, NguoiDungMapper nguoiDungMapper) {
        this.repository = repository;
        this.nguoiDungMapper = nguoiDungMapper;
    }

    public NguoiDungDto save(NguoiDungDto nguoiDungDto) {
        NguoiDung entity = nguoiDungMapper.toEntity(nguoiDungDto);
        entity.setAddress(nguoiDungDto.getAddress());
        return nguoiDungMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public NguoiDung findById(Long id) {
        return repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        );
    }

    public Page<NguoiDung> findByCondition(@Filter Specification<NguoiDung> spec, Pageable pageable) {
        Page<NguoiDung> entityPage = repository.findAll(spec,pageable);
        List<NguoiDung> entities = entityPage.getContent();
        return new PageImpl<>(entities, pageable, entityPage.getTotalElements());
    }

    public NguoiDungDto update(NguoiDungDto nguoiDungDto, Long id) {
        NguoiDung data = findById(id);
        NguoiDung entity = nguoiDungMapper.toEntity(nguoiDungDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        entity.setAddress(nguoiDungDto.getAddress());
        return save(nguoiDungDto);
    }
    public NguoiDungDto findByEmail(String email){
        NguoiDung entity = repository.findByEmail(email);
        NguoiDungDto tblUserDto = nguoiDungMapper.toDto(entity);
        return tblUserDto;
    }
    public List<NguoiDungDto> findByRole(Short role){
        List<NguoiDung> entity = repository.findByRole(role);
        List<NguoiDungDto> tblUserDto = nguoiDungMapper.toDto(entity);
        return tblUserDto;
    }
}