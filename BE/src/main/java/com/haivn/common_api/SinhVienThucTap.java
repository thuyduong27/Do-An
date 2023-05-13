package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "sinh_vien_thuc_tap")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class SinhVienThucTap extends BaseEntity{
    @Column(name = "id_nguoi_dung")
    private Long idNguoiDung;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_nguoi_dung",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private NguoiDung nguoiDung;
    @Column(name = "id_khtt")
    private Long idKhtt;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_khtt",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private KeHoachThucTap keHoachThucTap;
    @Column(name = "id_gvhd")
    private Long idGvhd;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_gvhd",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private GiaoVien giaoVien;
    @Column(name = "id_doanh_nghiep")
    private Long idDoanhNghiep;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_doanh_nghiep",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private DoanhNghiep doanhNghiep;
    @Column(name = "de_tai")
    private String deTai;
    @Column(name = "file_bao_cao")
    private String fileBaoCao;
    @Column(name = "diem")
    private String diem;
    @Column(name = "status")
    private Short status;

}
