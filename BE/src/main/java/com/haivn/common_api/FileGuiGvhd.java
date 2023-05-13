package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "file_gui_gvhd")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class FileGuiGvhd extends BaseEntity{
    @Column(name = "tilte")
    private String tilte;
    @Column(name = "file_name")
    private String fileName;
    @Column(name = "mo_ta")
    private String moTa;
    @Column(name = "id_khtt")
    private Long idKhtt;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_khtt",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private KeHoachThucTap keHoachThucTap;
    @Column(name = "status")
    private Short status;
}
