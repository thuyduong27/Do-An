package com.haivn.mapper;

import com.haivn.common_api.NhatKyThucTap;
import com.haivn.dto.NhatKyThucTapDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface NhatKyThucTapMapper extends EntityMapper<NhatKyThucTapDto, NhatKyThucTap> {
}