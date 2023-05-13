package com.haivn.dto;

import com.haivn.common_api.KeHoachThucTap;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class KhaoSatDto extends BaseDto {
    private Long idKhtt;
    private KeHoachThucTap keHoachThucTap;
    @Size(max = 255)
    private String tilte;
    @Size(max = 255)
    private String link;
    private Timestamp deadline;
    @Size(max = 255)
    private String file;
    private Integer soluongSV;
    private Integer soluongKS;
    private Short status;

    public KhaoSatDto() {
    }
}