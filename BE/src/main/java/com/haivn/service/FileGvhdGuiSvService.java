package com.haivn.service;

import com.haivn.common_api.FileGvhdGuiSv;
import com.haivn.dto.FileGvhdGuiSvDto;
import com.haivn.dto.KeHoachThucTapDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.FileGvhdGuiSvMapper;
import com.haivn.repository.FileGvhdGuiSvRepository;
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
public class FileGvhdGuiSvService {
    private final FileGvhdGuiSvRepository repository;
    private final FileGvhdGuiSvMapper fileGvhdGuiSvMapper;

    public FileGvhdGuiSvService(FileGvhdGuiSvRepository repository, FileGvhdGuiSvMapper fileGvhdGuiSvMapper) {
        this.repository = repository;
        this.fileGvhdGuiSvMapper = fileGvhdGuiSvMapper;
    }

    public FileGvhdGuiSvDto save(FileGvhdGuiSvDto fileGvhdGuiSvDto) {
        FileGvhdGuiSv entity = fileGvhdGuiSvMapper.toEntity(fileGvhdGuiSvDto);
        return fileGvhdGuiSvMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public FileGvhdGuiSvDto findById(Long id) {
        return fileGvhdGuiSvMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<FileGvhdGuiSvDto> findByCondition(@Filter Specification<FileGvhdGuiSv> spec, Pageable pageable) {
        Page<FileGvhdGuiSv> entityPage = repository.findAll(spec,pageable);
        List<FileGvhdGuiSv> entities = entityPage.getContent();
        return new PageImpl<>(fileGvhdGuiSvMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public FileGvhdGuiSvDto update(FileGvhdGuiSvDto fileGvhdGuiSvDto, Long id) {
        FileGvhdGuiSvDto data = findById(id);
        FileGvhdGuiSv entity = fileGvhdGuiSvMapper.toEntity(fileGvhdGuiSvDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(fileGvhdGuiSvMapper.toDto(entity));
    }
}