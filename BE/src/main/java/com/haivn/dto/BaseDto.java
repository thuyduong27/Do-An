package com.haivn.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
public class BaseDto<E> {
    @Schema(description = "ID (tự tăng)", required = true)
    private Long id;
    @Schema(description = "ID người sửa")
    private Long modifiedUser;
    @Schema(description = "Ngày sửa")
    private Timestamp modifiedDate;
    @Schema(description = "ID người tạo")
    private Long createdUser;
    @Schema(description = "Ngày tạo")
    private Timestamp createdDate;
    @Schema(description = "Đánh dấu đã xóa")
    private boolean deleted = Boolean.FALSE;
}