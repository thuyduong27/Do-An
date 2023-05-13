package com.haivn.mapper;

import com.haivn.common_api.GiaoVien;
import com.haivn.dto.GiaoVienDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface GiaoVienMapper extends EntityMapper<GiaoVienDto, GiaoVien> {
}