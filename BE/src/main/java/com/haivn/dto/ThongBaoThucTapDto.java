package com.haivn.dto;

import com.haivn.common_api.GiaoVien;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class ThongBaoThucTapDto extends BaseDto {
    private Long idGvhd;
    private GiaoVien giaoVien;
    @Size(max = 255)
    private String title;
    private String content;
    private Short status;

    public ThongBaoThucTapDto() {
    }
}