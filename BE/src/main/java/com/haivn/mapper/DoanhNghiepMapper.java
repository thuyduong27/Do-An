package com.haivn.mapper;

import com.haivn.common_api.DoanhNghiep;
import com.haivn.dto.DoanhNghiepDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface DoanhNghiepMapper extends EntityMapper<DoanhNghiepDto, DoanhNghiep> {
}