package com.haivn.mapper;

import com.haivn.common_api.Thongbao;
import com.haivn.dto.ThongbaoDto;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ThongbaoMapper extends EntityMapper<ThongbaoDto, Thongbao> {
}