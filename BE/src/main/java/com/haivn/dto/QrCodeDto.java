package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class QrCodeDto {
    @Schema(description = "Mã người dùng-id", required = true, example = "AAM.TTS.0000001-102")
    @NotBlank(message = "Mã người dùng không được để trống")
    @Size(max = 30, message = "Mã người dùng không được > 30 kí tự.")
    private String userId;

    @Schema(description = "Kiểu QrCode [normal,cicle_cicle,square_cicle]", required = true, example = "square_cicle")
    @NotBlank(message = "Kiểu QrCode không được để trống")
    @Size(max = 50, message = "Kiểu QrCode không được > 100 kí tự.")
    private String drawStyle="square_cicle";

    @Schema(description = "Mức sửa lỗi, L = ~7% correction,M = ~15% correction,Q = ~25% correction,H = ~30% correction")
    @NotBlank(message = "Số điện thoại không được để trống")
    private String errorCorrectionLevel = "M";

    @Schema(description = "Đường dẫn kiểm tra QrCode", required = true)
    private String url;

    @Schema(description = "Tên logo [logo.png,logoB.png]", example = "logoB.png")
    private String logoName = "logoB.png";

    @Schema(description = "Chiều rộng")
    private int width = 500;

    @Schema(description = "Chiều dài")
    private int height = 500;

    @Schema(description = "Hiển trị mã người dùng")
    private boolean displayUserCode = true;

    public QrCodeDto(){}
}
