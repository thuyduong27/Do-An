package com.haivn.controller;
import com.google.common.base.Strings;
import com.haivn.common_api.DoanhNghiep;
import com.haivn.common_api.FileGvhdGuiSv;
import com.haivn.dto.DoanhNghiepDto;
import com.haivn.dto.FileGvhdGuiSvDto;
import com.haivn.service.DoanhNghiepService;
import com.haivn.service.FileGvhdGuiSvService;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/api/file-gvhd-gui-sv")
@RestController
@Slf4j
@Api("file-gvhd-gui-sv")
public class FileGvhdGuiSvController {
    private final FileGvhdGuiSvService fileGvhdGuiSvService;
    public FileGvhdGuiSvController(FileGvhdGuiSvService fileGvhdGuiSvService) {
        this.fileGvhdGuiSvService = fileGvhdGuiSvService;
    }
    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated FileGvhdGuiSvDto fileGvhdGuiSvDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            FileGvhdGuiSvDto item = fileGvhdGuiSvService.save(fileGvhdGuiSvDto);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated FileGvhdGuiSvDto fileGvhdGuiSvDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            fileGvhdGuiSvDto.setId(id);
            FileGvhdGuiSvDto item =  fileGvhdGuiSvService.update(fileGvhdGuiSvDto, id);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);

    }
    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(fileGvhdGuiSvService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        fileGvhdGuiSvService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            FileGvhdGuiSvDto doanhNghiep = fileGvhdGuiSvService.findById(id);
            result.put("result",doanhNghiep);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<FileGvhdGuiSv> spec,   Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<FileGvhdGuiSvDto> doanhNghiepPage = fileGvhdGuiSvService.findByCondition(spec, pageable);
            result.put("result", doanhNghiepPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}
