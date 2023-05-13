package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "thong_bao")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class Thongbao extends BaseEntity{
//    @Column(name = "id_giang_vien")
//    private Long idGiangVien;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name="id_giang_vien",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
//    private GiaoVien giaoVien;

    @Column(name = "noi_dung")
    private String noiDung;

    @Column(name = "status")
    private Short status;
}
