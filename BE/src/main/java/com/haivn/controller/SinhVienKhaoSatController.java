package com.haivn.controller;

import com.haivn.common_api.SinhVienKhaoSat;
import com.haivn.dto.KhaoSatDto;
import com.haivn.dto.SinhVienKhaoSatDto;
import com.haivn.mapper.SinhVienKhaoSatMapper;
import com.haivn.service.SinhVienKhaoSatService;
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

@RequestMapping("/api/sinh-vien-khao-sat")
@RestController
@Slf4j
@Api("sinh-vien-khao-sat")
public class SinhVienKhaoSatController {
    private final SinhVienKhaoSatService sinhVienKhaoSatService;

    public SinhVienKhaoSatController(SinhVienKhaoSatService sinhVienKhaoSatService) {
        this.sinhVienKhaoSatService = sinhVienKhaoSatService;
    }

    @PostMapping("/post")
    public ResponseEntity<Void> save(@RequestBody @Validated SinhVienKhaoSatDto sinhVienKhaoSatDto) {
        sinhVienKhaoSatService.save(sinhVienKhaoSatDto);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<SinhVienKhaoSatDto> findById(@PathVariable("id") Long id) {
        SinhVienKhaoSatDto sinhVienKhaoSat = sinhVienKhaoSatService.findById(id);
        return ResponseEntity.ok(sinhVienKhaoSat);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(sinhVienKhaoSatService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        sinhVienKhaoSatService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<SinhVienKhaoSat> spec,@PageableDefault(sort = "id", direction = Sort.Direction.DESC, size = 100000) Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<SinhVienKhaoSatDto> sinhVienKhaoSatPage = sinhVienKhaoSatService.findByCondition(spec, pageable);
            result.put("result", sinhVienKhaoSatPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Void> update(@RequestBody @Validated SinhVienKhaoSatDto sinhVienKhaoSatDto, @PathVariable("id") Long id) {
        sinhVienKhaoSatService.update(sinhVienKhaoSatDto, id);
        return ResponseEntity.ok().build();
    }
}