package com.haivn.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.haivn.common_api.DoanhNghiep;
import com.haivn.common_api.NguoiDung;
import com.haivn.common_api.SinhVienThucTap;
import com.haivn.dto.DoanhNghiepDto;
import com.haivn.dto.EmailDto;
import com.haivn.dto.NguoiDungDto;
import com.haivn.dto.SinhVienThucTapDto;
import com.haivn.handler.ExcelToJsonConverter;
import com.haivn.handler.Utils;
import com.haivn.mapper.NguoiDungMapper;
import com.haivn.mapper.SinhVienThucTapMapper;
import com.haivn.repository.NguoiDungRepository;
import com.haivn.service.EmailService;
import com.haivn.service.NguoiDungService;
import com.haivn.service.SinhVienThucTapService;
import com.haivn.upload_files.FilesStorageService;
import com.llq.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import io.swagger.v3.oas.annotations.Operation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.FileSystemNotFoundException;
import java.sql.Array;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

@RequestMapping("/api/sinh-vien-thuc-tap")
@RestController
@Slf4j
@Api("sinh-vien-thuc-tap")
public class SinhVienThucTapController {
    private final SinhVienThucTapService sinhVienThucTapService;
    private final NguoiDungService nguoiDungService;
    private final NguoiDungMapper nguoiDungMapper;
    private final NguoiDungRepository repository;
    private final EmailService emailService;

    public SinhVienThucTapController(SinhVienThucTapService sinhVienThucTapService,NguoiDungService nguoiDungService,NguoiDungMapper nguoiDungMapper,NguoiDungRepository repository,EmailService emailService) {
        this.sinhVienThucTapService = sinhVienThucTapService;
        this.nguoiDungService = nguoiDungService;
        this.nguoiDungMapper = nguoiDungMapper;
        this.repository = repository;
        this.emailService = emailService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated SinhVienThucTapDto sinhVienThucTapDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            SinhVienThucTapDto item = sinhVienThucTapService.save(sinhVienThucTapDto);
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
            SinhVienThucTapDto sinhVienThucTap = sinhVienThucTapService.findById(id);
            result.put("result",sinhVienThucTap);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        try {
            SinhVienThucTapDto sinhVienThucTap = sinhVienThucTapService.findById(id);
            sinhVienThucTap.setDeleted(true);
            sinhVienThucTapService.update(sinhVienThucTap, id);
        }catch (Exception e){
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<SinhVienThucTap> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<SinhVienThucTapDto> sinhVienThucTapPage = sinhVienThucTapService.findByCondition(spec, pageable);
            result.put("result", sinhVienThucTapPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated SinhVienThucTapDto sinhVienThucTapDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            sinhVienThucTapDto.setId(id);
            SinhVienThucTapDto item = sinhVienThucTapService.update(sinhVienThucTapDto, id);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
    @Operation(summary = "Chuyển đổi thông tin file excel")
    @PostMapping("/up-file-danh-sach/{id}")
    public ResponseEntity<Map<String, Object>> updfileDanhSach(@RequestPart("file") MultipartFile file, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            List<SinhVienThucTapDto> myListA = new ArrayList<>();
            myListA = sinhVienThucTapService.findByIdKhtt(id);
            myListA.forEach(element ->{
                delete(element.getId());
            });
            List<Object> myList = new ArrayList<>();
            ExcelToJsonConverter converter = new ExcelToJsonConverter();
            JsonNode resultJson =  converter.excelToJson(file);
            resultJson.forEach(element->{
                NguoiDungDto nguoiDungDto = new NguoiDungDto();
                if (element.get("map").isEmpty()) {
                }else {
                    Short role =2;
                    Short status =1;
                    nguoiDungDto.setRole(role);
                    String maSVFirst = element.get("map").get("Mã sv").textValue();
                    String maSVEnd = maSVFirst.substring(0,maSVFirst.length()-2);
                    if(maSVEnd.length()==11){nguoiDungDto.setMaSv(maSVEnd.replace(".",""));} else {nguoiDungDto.setMaSv(maSVEnd.replace(".","")+"0");}
                    nguoiDungDto.setFullName(element.get("map").get("Họ tên ").textValue());
                    String str = element.get("map").get("Ngày sinh ").textValue()+" 12:34:56.789";
                    Timestamp timestamp = Timestamp.valueOf(str);
                    nguoiDungDto.setNgaySinh(timestamp);
                    nguoiDungDto.setLop(element.get("map").get("Lớp").textValue());
                    String substr = element.get("map").get("Lớp").textValue().substring(4);
                    String substrEnd=substr.substring(0,substr.length()-2);
                    if(substrEnd.equals("DHCNTT")){
                        Short nganh =0;
                        nguoiDungDto.setNganh(nganh);
                    }else if ( substrEnd.equals("DHKTPM")){
                        Short nganh =1;
                        nguoiDungDto.setNganh(nganh);
                    }else if ( substrEnd.equals("DHHTTT")){
                        Short nganh =2;
                        nguoiDungDto.setNganh(nganh);
                    }
                    else if ( substrEnd.equals("DHKHMT")){
                        Short nganh =3;
                        nguoiDungDto.setNganh(nganh);
                    }else if ( substrEnd.equals("DHCNDPT")){
                        Short nganh =4;
                        nguoiDungDto.setNganh(nganh);
                    }
                    nguoiDungDto.setKhoa(element.get("map").get("Khóa").textValue());
                    nguoiDungDto.setSdt(element.get("map").get("Số điện thoại ").textValue());
                    nguoiDungDto.setEmail(element.get("map").get("Email ").textValue());
                    nguoiDungDto.setStatus(status);
                    NguoiDungDto tblUser = nguoiDungService.findByEmail(nguoiDungDto.getEmail());
                    if(tblUser == null){
                        NguoiDung user = nguoiDungMapper.toEntity(nguoiDungDto);
                        user.setUsername(nguoiDungDto.getEmail());
                        user.setPassword(Utils.getBCryptedPassword("123456"));
                        user.setNganh(nguoiDungDto.getNganh());
                        user.setMaSv(nguoiDungDto.getMaSv());
                        user.setStatus(nguoiDungDto.getStatus());
                        NguoiDung userLogin=  repository.save(user);
                        EmailDto emailDto = new EmailDto();
                        emailDto.setMailTo(user.getUsername());
                        emailDto.setTitle("Hệ thống quản lý thực tập - Khoa CNTT - ĐH Công nghiệp Hà Nội");
                        emailDto.setContent("<div>Quyền: Sinh viên</div><div>Tài khoản: "+user.getUsername()+"</div><div>Mật khẩu: 123456</div><div>Chú ý: Đổi mật khẩu trong lần đăng nhập đầu tiên</div>\"");
                        emailService.sendMimeMail(emailDto);
                        myList.add(userLogin.getId());

                        SinhVienThucTapDto sinhVienThucTapDto = new  SinhVienThucTapDto();
                        sinhVienThucTapDto.setIdNguoiDung(userLogin.getId());
                        sinhVienThucTapDto.setIdKhtt(id);
                        Short statusSV = 0 ;
                        sinhVienThucTapDto.setStatus(statusSV);
                        sinhVienThucTapService.save(sinhVienThucTapDto);
                    }
                    else{
                        myList.add(tblUser.getId());

                        SinhVienThucTapDto sinhVienThucTapDto = new  SinhVienThucTapDto();
                        sinhVienThucTapDto.setIdNguoiDung(tblUser.getId());
                        sinhVienThucTapDto.setIdKhtt(id);
                        Short statusSV = 0 ;
                        sinhVienThucTapDto.setStatus(statusSV);
                        sinhVienThucTapService.save(sinhVienThucTapDto);
                    }
                }
            });
            result.put("result",myList);
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}