package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

@ApiModel()
@Getter
@Setter
public class OneSignalDto {
    private String title;
    private String message;
    private String url;
    private String bigImage;
}
