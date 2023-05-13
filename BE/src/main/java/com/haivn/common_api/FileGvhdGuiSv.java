package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "file_gvhd_gui_sv")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class FileGvhdGuiSv extends BaseEntity{
    @Column(name = "id_gvhd")
    private Long idGvhd;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_gvhd",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private GiaoVien giaoVien;
    @Column(name = "title")
    private String title;
    @Column(name = "fileName")
    private String fileName;
    @Column(name = "mo_ta")
    private String moTa;
    @Column(name = "status")
    private Short status;
}
