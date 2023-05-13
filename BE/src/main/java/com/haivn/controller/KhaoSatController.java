package com.haivn.controller;

import com.haivn.common_api.KhaoSat;
import com.haivn.common_api.SinhVienThucTap;
import com.haivn.dto.KhaoSatDto;
import com.haivn.dto.SinhVienThucTapDto;
import com.haivn.mapper.KhaoSatMapper;
import com.haivn.repository.KhaoSatRepository;
import com.haivn.service.KhaoSatService;
import com.haivn.service.SinhVienKhaoSatService;
import com.haivn.service.SinhVienThucTapService;
import com.llq.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.nio.file.FileSystemNotFoundException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RequestMapping("/api/khao-sat")
@RestController
@Slf4j
@Api("khao-sat")
public class KhaoSatController {
    private final KhaoSatService khaoSatService;
    private final KhaoSatRepository repository;
    private final KhaoSatMapper khaoSatMapper;


    public KhaoSatController(KhaoSatService khaoSatService, KhaoSatRepository repository, KhaoSatMapper khaoSatMapper) {
        this.khaoSatService = khaoSatService;
        this.repository = repository;
        this.khaoSatMapper = khaoSatMapper;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated KhaoSatDto khaoSatDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            KhaoSatDto item =  khaoSatService.save(khaoSatDto);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            KhaoSatDto khaoSat = khaoSatService.findById(id);
            result.put("result",khaoSat);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(khaoSatService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        khaoSatService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<KhaoSat> spec,@PageableDefault(sort = "id", direction = Sort.Direction.DESC, size = 100000) Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<KhaoSatDto> khaoSatPage = khaoSatService.findByCondition(spec, pageable);
            result.put("result", khaoSatPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated KhaoSatDto khaoSatDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            KhaoSat entity = khaoSatMapper.toEntity(khaoSatDto);
            entity.setId(id);
            KhaoSat item = repository.save(entity);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}