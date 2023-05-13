package com.haivn.mapper;

import com.haivn.common_api.KeHoachThucTap;
import com.haivn.dto.KeHoachThucTapDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface KeHoachThucTapMapper extends EntityMapper<KeHoachThucTapDto, KeHoachThucTap> {
}