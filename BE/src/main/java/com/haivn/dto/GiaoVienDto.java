package com.haivn.dto;

import com.haivn.common_api.KeHoachThucTap;
import com.haivn.common_api.NguoiDung;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

@ApiModel()
@Getter
@Setter
public class GiaoVienDto extends BaseDto {
    private Long idNguoiDung;
    private NguoiDung nguoiDung;
    private Long idKhtt;
    private KeHoachThucTap keHoachThucTap;
    private Integer soLuong;
    private Short status;

    public GiaoVienDto() {
    }
}