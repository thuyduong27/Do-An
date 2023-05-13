package com.haivn.mapper;

import com.haivn.common_api.SinhVienKhaoSat;
import com.haivn.dto.SinhVienKhaoSatDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface SinhVienKhaoSatMapper extends EntityMapper<SinhVienKhaoSatDto, SinhVienKhaoSat> {
}