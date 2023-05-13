package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "diem")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class Diem extends BaseEntity{

    @Column(name = "diem_one")
    private Short diemOne;

    @Column(name = "diem_one_one")
    private Short diemOneOne;

    @Column(name = "diem_one_three")
    private Short diemOneThree;

    @Column(name = "diem_one_two")
    private Short diemOneTwo;

    @Column(name = "diem_three")
    private Short diemThree;

    @Column(name = "diem_two")
    private Short diemTwo;

    @Column(name = "diem_two_one")
    private Short diemTwoOne;

    @Column(name = "diem_two_three")
    private Short diemTwoThree;

    @Column(name = "diem_two_two")
    private Short diemTwoTwo;

    @Column(name = "don_vi_one")
    private String donViOne;

    @Column(name = "don_vi_three")
    private String donViThree;

    @Column(name = "don_vi_two")
    private String donViTwo;

    @Column(name = "hoc_vi_one")
    private String hocViOne;

    @Column(name = "hoc_vi_three")
    private String hocViThree;

    @Column(name = "hoc_vi_two")
    private String hocViTwo;

    @Column(name = "id_sinh_vien")
    private Long idSinhVien;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_sinh_vien",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private SinhVienThucTap sinhVienThucTap;

    @Column(name = "nguoi_danh_gia_one")
    private String nguoiDanhGiaOne;

    @Column(name = "nguoi_danh_gia_three")
    private String nguoiDanhGiaThree;

    @Column(name = "nguoi_danh_gia_two")
    private String nguoiDanhGiaTwo;
}
