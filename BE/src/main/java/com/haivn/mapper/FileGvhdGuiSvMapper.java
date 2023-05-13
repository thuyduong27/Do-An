package com.haivn.mapper;

import com.haivn.common_api.FileGvhdGuiSv;
import com.haivn.dto.FileGvhdGuiSvDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface FileGvhdGuiSvMapper extends EntityMapper<FileGvhdGuiSvDto, FileGvhdGuiSv> {
}