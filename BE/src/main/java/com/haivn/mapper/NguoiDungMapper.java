package com.haivn.mapper;

import com.haivn.common_api.NguoiDung;
import com.haivn.dto.NguoiDungDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface NguoiDungMapper extends EntityMapper<NguoiDungDto, NguoiDung> {
}