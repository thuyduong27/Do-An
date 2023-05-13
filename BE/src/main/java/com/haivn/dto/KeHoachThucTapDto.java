package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class KeHoachThucTapDto extends BaseDto {
    private String tilte;
    private String content;
    private Timestamp startDate;
    private Timestamp hanDangKy;
    private Timestamp ngayDiTt;
    private Timestamp ngayVeTt;
    private Timestamp hanNopBaoCao;
    private Timestamp endDate;
    @Size(max = 255)
    private String fileDanhSach;
    private Short status;

    public KeHoachThucTapDto() {
    }
}