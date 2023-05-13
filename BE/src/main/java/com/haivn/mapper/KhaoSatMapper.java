package com.haivn.mapper;

import com.haivn.common_api.KhaoSat;
import com.haivn.dto.KhaoSatDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface KhaoSatMapper extends EntityMapper<KhaoSatDto, KhaoSat> {
}