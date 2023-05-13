package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "khao_sat")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class KhaoSat extends BaseEntity{
    @Column(name = "id_khtt")
    private Long idKhtt;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_khtt",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private KeHoachThucTap keHoachThucTap;
    @Column(name = "tilte")
    private String tilte;
    @Column(name = "link")
    private String link;
    @Column(name = "deadline")
    private Timestamp deadline;
    @Column(name = "file")
    private String file;
    @Column(name = "status")
    private Short status;
}
