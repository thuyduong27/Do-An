package com.haivn.mapper;

import com.haivn.common_api.Diem;
import com.haivn.dto.DiemDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface DiemMapper extends EntityMapper<DiemDto, Diem> {
}