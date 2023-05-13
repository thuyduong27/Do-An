package com.haivn.mapper;

import com.haivn.common_api.ThongBaoThucTap;
import com.haivn.dto.ThongBaoThucTapDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ThongBaoThucTapMapper extends EntityMapper<ThongBaoThucTapDto, ThongBaoThucTap> {
}