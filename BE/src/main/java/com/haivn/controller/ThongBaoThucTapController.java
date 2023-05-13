package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.ThongBaoThucTap;
import com.haivn.dto.DoanhNghiepDto;
import com.haivn.dto.ThongBaoThucTapDto;
import com.haivn.mapper.ThongBaoThucTapMapper;
import com.haivn.service.ThongBaoThucTapService;
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

@RequestMapping("/api/thong-bao-thuc-tap")
@RestController
@Slf4j
@Api("thong-bao-thuc-tap")
public class ThongBaoThucTapController {
    private final ThongBaoThucTapService thongBaoThucTapService;

    public ThongBaoThucTapController(ThongBaoThucTapService thongBaoThucTapService) {
        this.thongBaoThucTapService = thongBaoThucTapService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated ThongBaoThucTapDto thongBaoThucTapDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            ThongBaoThucTapDto item = thongBaoThucTapService.save(thongBaoThucTapDto);
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
            ThongBaoThucTapDto thongBaoThucTap = thongBaoThucTapService.findById(id);
            result.put("result",thongBaoThucTap);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(thongBaoThucTapService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        thongBaoThucTapService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<ThongBaoThucTap> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<ThongBaoThucTapDto> thongBaoThucTapPage = thongBaoThucTapService.findByCondition(spec, pageable);
            result.put("result", thongBaoThucTapPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity< Map<String, Object>> update(@RequestBody @Validated ThongBaoThucTapDto thongBaoThucTapDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            thongBaoThucTapDto.setId(id);
            ThongBaoThucTapDto item = thongBaoThucTapService.update(thongBaoThucTapDto, id);
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