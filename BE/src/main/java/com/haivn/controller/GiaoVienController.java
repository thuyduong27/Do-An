package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.GiaoVien;
import com.haivn.common_api.KeHoachThucTap;
import com.haivn.dto.GiaoVienDto;
import com.haivn.dto.KeHoachThucTapDto;
import com.haivn.mapper.GiaoVienMapper;
import com.haivn.service.GiaoVienService;
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

@RequestMapping("/api/giao-vien")
@RestController
@Slf4j
@Api("giao-vien")
public class GiaoVienController {
    private final GiaoVienService giaoVienService;

    public GiaoVienController(GiaoVienService giaoVienService) {
        this.giaoVienService = giaoVienService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated GiaoVienDto giaoVienDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            GiaoVienDto item = giaoVienService.save(giaoVienDto);
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
            GiaoVienDto giaoVien = giaoVienService.findById(id);
            result.put("result",giaoVien);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(giaoVienService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        giaoVienService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<GiaoVien> spec,@PageableDefault(sort = "id", direction = Sort.Direction.DESC, size = 100000) Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<GiaoVienDto> giaoVienPage = giaoVienService.findByCondition(spec, pageable);
            result.put("result", giaoVienPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity< Map<String, Object>> update(@RequestBody @Validated GiaoVienDto giaoVienDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if (giaoVienDto.getIdNguoiDung()==null || giaoVienDto.getIdNguoiDung()<=0){
            result.put("result", "Thieu id nguoi dung");
            result.put("success", false);
        } else if (giaoVienDto.getIdKhtt()==null || giaoVienDto.getIdKhtt()<=0){
            result.put("result", "Thieu id ke hoach thuc tap");
            result.put("success", false);
        }else if (giaoVienDto.getStatus()==null || giaoVienDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else {
            try{
                giaoVienDto.setId(id);
                GiaoVienDto item = giaoVienService.update(giaoVienDto, id);
                result.put("result", item.getId());
                result.put("success",true);
            }
            catch (Exception e){
                result.put("result",e.getMessage());
                result.put("success",false);
            }
        }
        return ResponseEntity.ok(result);
    }
}