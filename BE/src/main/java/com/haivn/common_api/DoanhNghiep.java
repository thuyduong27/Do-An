package com.haivn.common_api;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "doanh_nghiep")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class DoanhNghiep extends BaseEntity{
    @Column(name = "name")
    private String name;
    @Column(name = "type")
    private Short type;
    @Column(name = "mst")
    private String mst;
    @Column(name = "address")
    private String address;
    @Column(name = "manager")
    private String manager;
    @Column(name = "manager_sdt")
    private String managerSdt;
    @Column(name = "manager_email")
    private String managerEmail;
    @Column(name = "hop_dong")
    private Boolean hopDong;
    @Column(name = "file_hop_dong")
    private String fileHopDong;
    @Column(name = "so_luong_nhan")
    private Short soLuongNhan;
    @Column(name = "status")
    private Short status;
}
