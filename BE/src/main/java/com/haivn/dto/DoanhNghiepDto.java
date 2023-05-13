package com.haivn.dto;

import com.haivn.annotation.CheckEmail;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class DoanhNghiepDto extends BaseDto {
    private Long id;
    @Size(max = 255)
    private String name;
    private Short type;
    @Size(max = 255)
    private String mst;
    @Size(max = 255)
    private String address;
    @Size(max = 255)
    private String manager;
    @Size(max = 255)
    private String managerSdt;
    @CheckEmail
    @Size(max = 255)
    private String managerEmail;
    private Boolean hopDong;
    @Size(max = 255)
    private String fileHopDong;
    private Short soLuongNhan;
    private Short status;

    public DoanhNghiepDto() {
    }
}