package com.haivn.dto;

import com.haivn.common_api.BaseEntity;
import com.haivn.common_api.SinhVienThucTap;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class NhatKyThucTapDto extends BaseEntity {
    private Long idSv;
    private SinhVienThucTap sinhVienThucTap;
    private String name;
    private Timestamp startDate;
    private Timestamp endDate;
    private String content;
    private String ghiChu;
    private String ketQua;
    private String file;
    private Short status;

    public NhatKyThucTapDto() {
    }
}