package com.haivn.dto;

import com.haivn.common_api.KhaoSat;
import com.haivn.common_api.SinhVienThucTap;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

@ApiModel()
@Getter
@Setter
public class SinhVienKhaoSatDto extends BaseDto {
    private Long idSv;
    private SinhVienThucTap sinhVien;
    private Long idKhaoSat;
    private KhaoSat khaoSat;
    public SinhVienKhaoSatDto() {
    }
}