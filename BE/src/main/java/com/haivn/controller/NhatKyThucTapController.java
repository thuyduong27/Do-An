package com.haivn.controller;

import com.haivn.common_api.NhatKyThucTap;
import com.haivn.dto.NhatKyThucTapDto;
import com.haivn.dto.ThongBaoThucTapDto;
import com.haivn.mapper.NhatKyThucTapMapper;
import com.haivn.service.NhatKyThucTapService;
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

@RequestMapping("/api/nhat-ky-thuc-tap")
@RestController
@Slf4j
@Api("nhat-ky-thuc-tap")
public class NhatKyThucTapController {
    private final NhatKyThucTapService nhatKyThucTapService;

    public NhatKyThucTapController(NhatKyThucTapService nhatKyThucTapService) {
        this.nhatKyThucTapService = nhatKyThucTapService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated NhatKyThucTapDto nhatKyThucTapDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            NhatKyThucTapDto item = nhatKyThucTapService.save(nhatKyThucTapDto);
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
            NhatKyThucTapDto nhatKyThucTap = nhatKyThucTapService.findById(id);
            result.put("result",nhatKyThucTap);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(nhatKyThucTapService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        nhatKyThucTapService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<NhatKyThucTap> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<NhatKyThucTapDto> nhatKyThucTapPage = nhatKyThucTapService.findByCondition(spec, pageable);
            result.put("result", nhatKyThucTapPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated NhatKyThucTapDto nhatKyThucTapDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            nhatKyThucTapDto.setId(id);
            NhatKyThucTapDto item = nhatKyThucTapService.update(nhatKyThucTapDto, id);
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