package com.haivn.controller;

import com.haivn.dto.EmailDto;
import com.haivn.handler.ExcelToJsonConverter;
import com.haivn.handler.Utils;
import com.haivn.service.EmailService;
import com.haivn.upload_files.FilesStorageService;
import com.fasterxml.jackson.databind.JsonNode;
import io.swagger.v3.oas.annotations.Operation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@RequestMapping("/api/utils")
@RestController
@Slf4j
public class UtilsController {
    private final EmailService emailService;

    @Value("${aam.company.name}") private String companyName;

    @Value("${aam.company.info}") private String companyInfo;

    @Value("${aam.company.address}") private String companyAddress;

    @Value("${aam.company.email}") private String companyEmail;

    @Value("${aam.company.phone}") private String companyPhone;

    @Value("${aam.company.fax}") private String companyFax;

    @Value("${aam.company.registration_no}") private String companyRegNo;

    @Value("${aam.company.work_no}") private String companyWorkNo;

    @Value("${aam.company.facebook}") private String facebook;

    @Value("${aam.company.twitter}") private String twitter;

    @Value("${aam.company.skype}") private String skype;

    @Value("${aam.company.youtube}") private String youtube;

    @Value("${aam.upload.dir}") private String uploadPath;

    @Autowired
    FilesStorageService storageService;

    public UtilsController(EmailService emailService) {
        this.emailService = emailService;
    }

    @Operation(summary = "Gửi email (hỗ trợ định dạng html và file đính kèm)")
    @PostMapping("/post/mail")
    public String sendMail(@RequestBody @Validated EmailDto emailDto) {
        if(StringUtils.isEmpty(emailDto.getMailTo())){
            return "Email nhận không được để trống!";
        }
        if(StringUtils.isEmpty(emailDto.getTitle())){
            return "Tiêu đề không được để trống!";
        }
        if(StringUtils.isEmpty(emailDto.getContent()) || emailDto.getContent().length() < 6){
            return "Nội dung phải có ít nhất từ 6 ký tự trở lên!";
        }
        String success = emailService.sendMimeMail(emailDto);
        return success;
    }

//    @Operation(summary = "Tạo file zip.")
//    @PostMapping(value="/files/zip", produces="application/zip")
//    public ResponseEntity<StreamingResponseBody> zipFiles(@RequestBody List<String> srcFiles) {
//        String zipFile = "file_" + Utils.getRandomString(6)+".zip";
//        return ResponseEntity
//                .ok()
//                .header("Content-Disposition", "attachment; filename="+zipFile)
//                .body(out -> {
//                    var zipOutputStream = new ZipOutputStream(out);
//
//                    // create a list to add files to be zipped
//                    for (String srcFile : srcFiles) {
//                        File atf = Paths.get(uploadPath).resolve(srcFile).toFile();
//                        if (atf.exists()) {
//                            zipOutputStream.putNextEntry(new ZipEntry(atf.getName()));
//                            FileInputStream fileInputStream = new FileInputStream(atf);
//                            IOUtils.copy(fileInputStream, zipOutputStream);
//                            fileInputStream.close();
//                            zipOutputStream.closeEntry();
//                        }
//                    }
//                    zipOutputStream.close();
//                });
//    }

    @Operation(summary = "Chuyển đổi thông tin file excel sang Json")
    @PostMapping(value="/post/excel2json", consumes = "multipart/form-data")
    public ResponseEntity<Map<String, JsonNode>> convertExcelToJson(@RequestPart("file") MultipartFile file) {
        Map<String, JsonNode> res = new HashMap<>();
        String fileName = storageService.saveFile(file);
        ExcelToJsonConverter converter = new ExcelToJsonConverter();

        res.put(fileName, converter.excelToJson(file));
        return ResponseEntity.ok(res);
    }
}
