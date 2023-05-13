package com.haivn.upload_files;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequestMapping("/api")
@RestController
public class FilesController {
    @Autowired
    FilesStorageService storageService;

    @Value("${aam.upload.dir}")
    private String uploadPath;

    public FilesController(){
    }

    @Operation(summary = "Upload files")
    @PostMapping(value = "/upload", consumes = "multipart/form-data")
    public ResponseEntity<Map<Integer, String>> uploadFile(@RequestPart("file") MultipartFile file) {
        storageService.init();
        Map<Integer, String> res = new HashMap<>();
        try {
            res = storageService.save(file);
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            res.put(0, "Có lỗi xảy ra trong quá trình upload! " + e.getMessage());
            return ResponseEntity.ok(res);
        }
    }

    @Operation(summary = "Danh sách thông tin các files")
    @GetMapping("/files")
    public ResponseEntity<List<FileInfo>> getListFiles() {
        List<FileInfo> fileInfos = storageService.loadAll().map(path -> {
            String filename = path.getFileName().toString();
            String url = MvcUriComponentsBuilder
                    .fromMethodName(FilesController.class, "getFile", path.getFileName().toString()).build().toString();
            return new FileInfo(filename, url);
        }).collect(Collectors.toList());
        return ResponseEntity.status(HttpStatus.OK).body(fileInfos);
    }

    @Operation(summary = "Lấy thông tin 1 file theo tên")
    @GetMapping("/files/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        Resource file = storageService.load(filename);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }
}
