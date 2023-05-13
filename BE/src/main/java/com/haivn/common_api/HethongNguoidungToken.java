package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
//@Table(name = "hethong_nguoidung_token")
@Getter @Setter @DynamicUpdate
public class HethongNguoidungToken {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false)
    private Long id;

    @Column(name = "token")
    private String token;

    @Column(name = "tokenexpdate")
    private Timestamp tokenexpdate;

    @Column(name = "created_user", updatable = false)
    private Long createdUser;
}
