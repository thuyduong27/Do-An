package com.haivn.dto;

import com.haivn.annotation.CheckEmail;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class NguoiDungDto extends BaseDto {
    @Size(max = 255)
    private String username;
    @Size(max = 255)
    private String password;
    private Short role;
    @Size(max = 255)
    private String fullName;
    private Timestamp ngaySinh;
    private Boolean gioiTinh;
    @CheckEmail
    @Size(max = 255)
    private String email;
    @Size(max = 255)
    private String sdt;
    @Size(max = 255)
    private String avatar;
    @Size(max = 255)
    private String hocVi;
    @Size(max = 255)
    private String donVi;
    @Size(max = 255)
    private String maSv;
    @Size(max = 255)
    private String khoa;
    private Short nganh;
    @Size(max = 255)
    private String lop;
    private Short status;
    private String address;

    public NguoiDungDto() {
    }
}