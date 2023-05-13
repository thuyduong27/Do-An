package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "sinh_vien_khao_sat")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class SinhVienKhaoSat extends BaseEntity{
    @Column(name = "id_sv")
    private Long idSv;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_sv",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private SinhVienThucTap sinhVien;
    @Column(name = "id_khao_sat")
    private Long idKhaoSat;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_khao_sat",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private KhaoSat khaoSat;
}
