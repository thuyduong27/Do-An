package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "thong_bao_thuc_tap")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class ThongBaoThucTap extends BaseEntity{
    @Column(name = "id_gvhd")
    private Long idGvhd;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_gvhd",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private GiaoVien giaoVien;
    @Column(name = "title")
    private String title;
    @Column(name = "content")
    private String content;
    @Column(name = "status")
    private Short status;
}
