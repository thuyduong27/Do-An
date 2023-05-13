package com.haivn.common_api;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;
import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "nguoi_dung")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class NguoiDung extends BaseEntity{
    @Column(name = "user_name")
    private String username;
    @Column(name = "password")
    private String password;
    @Column(name = "role")
    private Short role;
    @Column(name = "full_name")
    private String fullName;
    @Column(name = "ngay_sinh")
    private Timestamp ngaySinh;
    @Column(name = "gioi_tinh")
    private Boolean gioiTinh;
    @Column(name = "email")
    private String email;
    @Column(name = "address")
    private String address;
    @Column(name = "sdt")
    private String sdt;
    @Column(name = "avatar")
    private String avatar;
    @Column(name = "hoc_vi")
    private String hocVi;
    @Column(name = "don_vi")
    private String donVi;
    @Column(name = "maSv")
    private String maSv;
    @Column(name = "khoa")
    private String khoa;
    @Column(name = "nganh")
    private Short nganh;
    @Column(name = "lop")
    private String lop;
    @Column(name = "status")
    private Short status;
}
