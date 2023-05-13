package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.NguoiDung;
import com.haivn.common_api.UserLogin;
import com.haivn.dto.EmailDto;
import com.haivn.dto.NguoiDungDto;
import com.haivn.dto.SinhVienThucTapDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.NguoiDungMapper;
import com.haivn.repository.NguoiDungRepository;
import com.haivn.service.EmailService;
import com.haivn.service.NguoiDungService;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import com.llq.springfilter.boot.Filter;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityNotFoundException;
import java.nio.file.FileSystemNotFoundException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RequestMapping("/api/nguoi-dung")
@RestController
@Slf4j
@Api("nguoi-dung")
public class NguoiDungController {
    private final NguoiDungService nguoiDungService;
    private final NguoiDungRepository repository;
    private final NguoiDungMapper nguoiDungMapper;
    private final EmailService emailService;

    public NguoiDungController(NguoiDungService nguoiDungService,NguoiDungRepository repository,NguoiDungMapper nguoiDungMapper,EmailService emailService) {
        this.nguoiDungService = nguoiDungService;
        this.repository = repository;
        this.nguoiDungMapper = nguoiDungMapper;
        this.emailService = emailService;
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> loginPass(@RequestBody @Validated UserLogin userLogin) {
        Map<String, Object> result =new HashMap<String, Object>();
        try {
            NguoiDung nguoiDung = repository.findByUsername(userLogin.getUsername());
            Boolean checkPass = BCrypt.checkpw(userLogin.getPassword(), nguoiDung.getPassword());
            if(checkPass){
                nguoiDung.setPassword("");
                result.put("result", nguoiDung);
                result.put("success", true);
            }else {
                result.put("result", "Tài khoản / mật khẩu không đúng");
                result.put("success", false);
            }
        }catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated NguoiDungDto nguoiDungDto) {
        Map<String, Object> result =new HashMap<String, Object>();
        EmailDto emailDto = new EmailDto();
        String messErr = "";
        if(messErr != ""){
            messErr = "Không được bỏ trống " + messErr;
            result.put("result", messErr);
            result.put("success",false);
        }
        else{
            NguoiDungDto tblUser = nguoiDungService.findByEmail(nguoiDungDto.getEmail());
            if(tblUser == null){
                try{
                    NguoiDung user = nguoiDungMapper.toEntity(nguoiDungDto);
                    user.setUsername(nguoiDungDto.getEmail());
                    user.setPassword(Utils.getBCryptedPassword("123456"));
                    user.setAddress(nguoiDungDto.getAddress());
                    user.setMaSv(nguoiDungDto.getMaSv());
                    user.setNganh(nguoiDungDto.getNganh());
                    NguoiDung userLogin=  repository.save(user);
                    emailDto.setMailTo(user.getUsername());
                    emailDto.setTitle("Hệ thống quản lý thực tập - Khoa CNTT - ĐH Công nghiệp Hà Nội");
                    if(user.getRole()==0){
                        emailDto.setContent("<div>Quyền: Cán bộ khoa/TTDT</div><div>Tài khoản: "+user.getUsername()+"</div><div>Mật khẩu: 123456</div><div>Chú ý: Đổi mật khẩu trong lần đăng nhập đầu tiên</div>\"");
                    }else if(user.getRole()==1){
                        emailDto.setContent("<div>Quyền: Giảng viên</div><div>Tài khoản: "+user.getUsername()+"</div><div>Mật khẩu: 123456</div><div>Chú ý: Đổi mật khẩu trong lần đăng nhập đầu tiên</div>\"");
                    }else {
                        emailDto.setContent("<div>Quyền: Sinh viên</div><div>Tài khoản: "+user.getUsername()+"</div><div>Mật khẩu: 123456</div><div>Chú ý: Đổi mật khẩu trong lần đăng nhập đầu tiên</div>\"");
                    }
                    emailService.sendMimeMail(emailDto);
                    result.put("result", userLogin.getId());
                    result.put("success", true);
                }catch (Exception e){
                    result.put("result",e.getMessage());
                    result.put("success", false);
                }
            }
            else{
                result.put("result",tblUser.getId());
                result.put("success", true);
            }

        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            NguoiDung nguoiDung = nguoiDungService.findById(id);
            result.put("result",nguoiDung);
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
            NguoiDung nguoiDung = nguoiDungService.findById(id);
            nguoiDung.setDeleted(true);
            NguoiDungDto nguoiDungDto = nguoiDungMapper.toDto(nguoiDung);
            nguoiDungService.update(nguoiDungDto, id);
        }catch (Exception e){
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<NguoiDung> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<NguoiDung> nguoiDungPage = nguoiDungService.findByCondition(spec, pageable);
            result.put("result", nguoiDungPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
    @PostMapping("/change-pass/{id}")
    public ResponseEntity<Map<String, Object>> changePass(@RequestBody @Validated UserLogin userLogin,@PathVariable("id") Long id) {
        Map<String, Object> result =new HashMap<String, Object>();
        try {
            NguoiDung nguoiDung =  repository.findById(id).orElseThrow(()
                    -> new EntityNotFoundException("Item Not Found! ID: " + id)
            );
            nguoiDung.setPassword(Utils.getBCryptedPassword(userLogin.getPassword()));
            NguoiDung item= repository.save(nguoiDung);
            result.put("result",item.getId());
            result.put("success", true);
        }catch (Exception e){
            result.put("result", "Tài khoản / mật khẩu không đúng");
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated NguoiDungDto nguoiDungDto, @PathVariable("id") Long id) {
        Map<String, Object> result =new HashMap<String, Object>();
        String messErr = "";
        if(Strings.isNullOrEmpty(nguoiDungDto.getFullName())){
            messErr += "tên người dùng";
        }
        if (Strings.isNullOrEmpty(nguoiDungDto.getEmail())){
            if(messErr != ""){
                messErr += ", email";
            }
            else{
                messErr += "email";
            }
        }
        if (Strings.isNullOrEmpty(nguoiDungDto.getSdt())){
            if(messErr != ""){
                messErr += ", sdt";
            }
            else{
                messErr += "sdt";
            }
        }
        if (nguoiDungDto.getGioiTinh()==null){
            if(messErr != ""){
                messErr += ", giới tính";
            }
            else{
                messErr += "Giới tính";
            }
        }
        if (nguoiDungDto.getNgaySinh()==null){
            if(messErr != ""){
                messErr += ", ngày sinh";
            }
            else{
                messErr += "ngày sinh";
            }
        }
        if (nguoiDungDto.getStatus()==null){
            if(messErr != ""){
                messErr += ", trạng thái";
            }
            else{
                messErr += "trạng thái";
            }
        }
        if(messErr != ""){
            messErr = "Không được bỏ trống " + messErr;
            result.put("result", messErr);
            result.put("success",false);
        }
        try{
            nguoiDungDto.setId(id);
            NguoiDungDto item=  nguoiDungService.update(nguoiDungDto, id);
            result.put("result",item.getId());
            result.put("success", true);
        }catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success", false);
        }

        return ResponseEntity.ok(result);

    }

    @PostMapping("/sendEmail")
    public ResponseEntity<Map<String, Object>> sendEmail(@RequestBody @Validated EmailDto emailDto) {
        Map<String, Object> result = new HashMap<>();
        try{
          String abc=  emailService.sendMimeMail(emailDto);
            result.put("result",abc);
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }

        return ResponseEntity.ok(result);
    }
}