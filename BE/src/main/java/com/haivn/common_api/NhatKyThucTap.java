package com.haivn.common_api;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;
import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "nhat_ky_thuc_tap")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class NhatKyThucTap extends BaseEntity{
    @Column(name = "id_sv")
    private Long idSv;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_sv",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private SinhVienThucTap sinhVienThucTap;
    @Column(name = "name")
    private String name;
    @Column(name = "statr_date")
    private Timestamp startDate;
    @Column(name = "end_date")
    private Timestamp endDate;
    @Column(name = "content")
    private String content;
    @Column(name = "ghi_chu")
    private String ghiChu;
    @Column(name = "ket_qua")
    private String ketQua;
    @Column(name = "file")
    private String file;
    @Column(name = "status")
    private Short status;
}
