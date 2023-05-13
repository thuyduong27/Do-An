package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.DoanhNghiep;
import com.haivn.common_api.KeHoachThucTap;
import com.haivn.common_api.NguoiDung;
import com.haivn.dto.DoanhNghiepDto;
import com.haivn.dto.GiaoVienDto;
import com.haivn.dto.KeHoachThucTapDto;
import com.haivn.dto.NguoiDungDto;
import com.haivn.mapper.KeHoachThucTapMapper;
import com.haivn.repository.KeHoachThucTapRepository;
import com.haivn.service.KeHoachThucTapService;
import com.haivn.service.NguoiDungService;
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

@RequestMapping("/api/ke-hoach-thuc-tap")
@RestController
@Slf4j
@Api("ke-hoach-thuc-tap")
public class KeHoachThucTapController {
    private final KeHoachThucTapService keHoachThucTapService;
    private final KeHoachThucTapRepository repository;
    private final NguoiDungService nguoiDungService;
    private final GiaoVienController giaoVienController;


    public KeHoachThucTapController(KeHoachThucTapRepository repository, KeHoachThucTapService keHoachThucTapService,NguoiDungService nguoiDungService,GiaoVienController giaoVienController) {
        this.keHoachThucTapService = keHoachThucTapService;
        this.repository = repository;
        this.nguoiDungService =nguoiDungService;
        this.giaoVienController = giaoVienController;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object> > save(@RequestBody @Validated KeHoachThucTapDto keHoachThucTapDto) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(keHoachThucTapDto.getTilte())){
            result.put("result", "Thiếu tieu de");
            result.put("success", false);
        } else if (keHoachThucTapDto.getStatus()==null || keHoachThucTapDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (keHoachThucTapDto.getStartDate()==null){
            result.put("result", "Thieu ngay bat dau");
            result.put("success", false);
        }else if (keHoachThucTapDto.getEndDate()==null){
            result.put("result", "Thieu ngay ket thuc");
            result.put("success", false);
        }else{
            try{
                KeHoachThucTapDto item = keHoachThucTapService.save(keHoachThucTapDto);
                Short role=1;
                List<NguoiDungDto> lisGiaoVien=nguoiDungService.findByRole(role);
                lisGiaoVien.forEach(element ->{
                    Short status=1;
                    GiaoVienDto data = new GiaoVienDto();
                    data.setIdKhtt(item.getId());
                    data.setIdNguoiDung(element.getId());
                    data.setStatus(status);
                    giaoVienController.save(data);
                });
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
            KeHoachThucTapDto keHoachThucTap = keHoachThucTapService.findById(id);
            result.put("result",keHoachThucTap);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(keHoachThucTapService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        keHoachThucTapService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity< Map<String, Object>> pageQuery(@Filter Specification<KeHoachThucTap> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<KeHoachThucTap> keHoachThucTapPage = keHoachThucTapService.findByCondition(spec, pageable);
            result.put("result", keHoachThucTapPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated KeHoachThucTapDto keHoachThucTapDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            keHoachThucTapDto.setId(id);
            KeHoachThucTapDto item = keHoachThucTapService.update(keHoachThucTapDto, id);
            result.put("result", item);
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}