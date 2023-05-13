package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "ke_hoach_thuc_tap")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class KeHoachThucTap extends BaseEntity{
    @Column(name = "tilte")
    private String tilte;
    @Column(name = "content")
    private String content;
    @Column(name = "statr_date")
    private Timestamp startDate;
    @Column(name = "han_dang_ky")
    private Timestamp hanDangKy;
    @Column(name = "ngay_di_tt")
    private Timestamp ngayDiTt;
    @Column(name = "ngay_ve_tt")
    private Timestamp ngayVeTt;
    @Column(name = "han_nop_bao_cao")
    private Timestamp hanNopBaoCao;
    @Column(name = "end_date")
    private Timestamp endDate;
    @Column(name = "file_danh_sach")
    private String fileDanhSach;
    @Column(name = "status")
    private Short status;
}
