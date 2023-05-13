package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.DoanhNghiep;
import com.haivn.dto.DoanhNghiepDto;
import com.haivn.mapper.DoanhNghiepMapper;
import com.haivn.service.DoanhNghiepService;
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

@RequestMapping("/api/doanh-nghiep")
@RestController
@Slf4j
@Api("doanh-nghiep")
public class DoanhNghiepController {
    private final DoanhNghiepService doanhNghiepService;

    public DoanhNghiepController(DoanhNghiepService doanhNghiepService) {
        this.doanhNghiepService = doanhNghiepService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated DoanhNghiepDto doanhNghiepDto) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(doanhNghiepDto.getName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (doanhNghiepDto.getStatus()==null || doanhNghiepDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getAddress())){
            result.put("result", "Thieu dia chi");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getManager())){
            result.put("result", "Thieu nguoi quan ly");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getManagerSdt())){
            result.put("result", "Thieu sdt nguoi quan ly");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getManagerEmail())){
            result.put("result","Thieu email nguoi quan ly");
            result.put("success", false);
        }else if (doanhNghiepDto.getType()==null || doanhNghiepDto.getType()<0||doanhNghiepDto.getType()>2){
            result.put("result", "Thieu kia doanh nghiep");
            result.put("success", false);
        }else{
            try{
                DoanhNghiepDto item = doanhNghiepService.save(doanhNghiepDto);
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

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            DoanhNghiepDto doanhNghiep = doanhNghiepService.findById(id);
            result.put("result",doanhNghiep);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(doanhNghiepService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        doanhNghiepService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<DoanhNghiep> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<DoanhNghiepDto> doanhNghiepPage = doanhNghiepService.findByCondition(spec, pageable);
            result.put("result", doanhNghiepPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated DoanhNghiepDto doanhNghiepDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(doanhNghiepDto.getName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (doanhNghiepDto.getStatus()==null || doanhNghiepDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getAddress())){
            result.put("result", "Thieu dia chi");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getManager())){
            result.put("result", "Thieu nguoi quan ly");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getManagerSdt())){
            result.put("result", "Thieu sdt nguoi quan ly");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(doanhNghiepDto.getManagerEmail())){
            result.put("result","Thieu email nguoi quan ly");
            result.put("success", false);
        }else if (doanhNghiepDto.getType()==null || doanhNghiepDto.getType()<0||doanhNghiepDto.getType()>2){
            result.put("result", "Thieu kia doanh nghiep");
            result.put("success", false);
        }else{
            try{
                doanhNghiepDto.setId(id);
                DoanhNghiepDto item =  doanhNghiepService.update(doanhNghiepDto, id);
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