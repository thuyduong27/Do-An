package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ApiModel()
@Getter
@Setter
public class EmailDto {
    @Schema(description = "Email nhận")
    private String mailTo;
    @Schema(description = "Tiêu đề")
    private String title;
    @Schema(description = "Nội dung")
    private String content;
    @Schema(description = "Danh sách file đính kèm")
    private List<String> attachFiles;
    @Schema(description = "Tên Email template")
    private String templateName;
    private Map<String, Object> model = new HashMap<>();

    public EmailDto() {
    }
}
