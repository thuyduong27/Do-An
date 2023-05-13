package com.haivn.dto;

import com.haivn.common_api.DoanhNghiep;
import com.haivn.common_api.GiaoVien;
import com.haivn.common_api.KeHoachThucTap;
import com.haivn.common_api.NguoiDung;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class SinhVienThucTapDto extends BaseDto {
    private Long idNguoiDung;
    private NguoiDung nguoiDung;
    private Long idKhtt;
    private KeHoachThucTap keHoachThucTap;
    private Long idGvhd;
    private GiaoVien giaoVien;
    private Long idDoanhNghiep;
    private DoanhNghiep doanhNghiep;
    @Size(max = 255)
    private String deTai;
    @Size(max = 255)
    private String fileBaoCao;
    @Size(max = 255)
    private String diem;
    private Integer countNTT;
    private Short status;

    public SinhVienThucTapDto() {
    }
}