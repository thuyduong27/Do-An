package com.haivn.mapper;

import com.haivn.common_api.SinhVienThucTap;
import com.haivn.dto.SinhVienThucTapDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface SinhVienThucTapMapper extends EntityMapper<SinhVienThucTapDto, SinhVienThucTap> {
}