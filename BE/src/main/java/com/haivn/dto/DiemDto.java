package com.haivn.dto;

import com.haivn.common_api.SinhVienThucTap;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class DiemDto extends BaseDto {
    private Short diemOne;
    private Short diemOneOne;
    private Short diemOneThree;
    private Short diemOneTwo;
    private Short diemThree;
    private Short diemTwo;
    private Short diemTwoOne;
    private Short diemTwoThree;
    private Short diemTwoTwo;
    @Size(max = 255)
    private String donViOne;
    @Size(max = 255)
    private String donViThree;
    @Size(max = 255)
    private String donViTwo;
    @Size(max = 255)
    private String hocViOne;
    @Size(max = 255)
    private String hocViThree;
    @Size(max = 255)
    private String hocViTwo;
    private Long idSinhVien;
    private SinhVienThucTap sinhVienThucTap;
    @Size(max = 255)
    private String nguoiDanhGiaOne;
    @Size(max = 255)
    private String nguoiDanhGiaThree;
    @Size(max = 255)
    private String nguoiDanhGiaTwo;

    public DiemDto() {
    }
}