package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@ApiModel()
@Getter
@Setter
public class ThongbaoDto extends BaseDto {
    @Schema(description = "Tiêu đề")
    private String title;
    @Schema(description = "Nội dung thông báo", required = true)
    private String message;
    @Schema(description = "Đường dẫn URL")
    private String url;
    @Schema(description = "Đường dẫn ảnh")
    private String image;
    @Schema(description = "Tên thẻ xác định đối tượng gửi", required = true)
    private String tagName;
    @Schema(description = "Giá trị thẻ của đối tượng gửi", required = true)
    private String tagValue;
    @Schema(description = "Cấp độ nhận thông báo theo vị trí")
    private int level = 0;

    public ThongbaoDto() {
    }
}