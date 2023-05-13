package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "giao_vien")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class GiaoVien extends BaseEntity{
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
    @Column(name = "status")
    private Short status;
}
