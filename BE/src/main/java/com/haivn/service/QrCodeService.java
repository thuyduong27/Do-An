package com.haivn.service;

import com.haivn.dto.QrCodeDto;
import com.haivn.upload_files.FilesStorageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.zxing.*;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.HybridBinarizer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Map;

@Service
@Slf4j
public class QrCodeService {
//    private final Path root = Paths.get("uploads");
    @Value("${qr.draw-style}")
    private String drawStyle;

    @Value("${qr.error-correction-level}")
    private String errorCorrectionLevel;

    @Value("${qr.url}")
    private String qrUrl;

    @Value("${qr.logo-name}")
    private String logoName;

    @Value("${qr.width}")
    private int qrWidth;

    @Value("${qr.height}")
    private int qrHeight;

    @Value("${qr.user-code.display}")
    private boolean displayUserCode;

    @Autowired
    FilesStorageService storageService;

    public ResponseEntity<?> read(final MultipartFile file) throws IOException, NotFoundException {
        BufferedImage bufferedImage = ImageIO.read(file.getInputStream());
        LuminanceSource luminanceSource = new BufferedImageLuminanceSource(bufferedImage);
        BinaryBitmap binaryBitmap = new BinaryBitmap(new HybridBinarizer(luminanceSource));
        Result result = new MultiFormatReader().decode(binaryBitmap);
        return ResponseEntity.ok(new ObjectMapper().readValue(result.getText(), QrCodeDto.class));
    }

    public Map<Integer, String> qrGenerate(final QrCodeDto qrCodeDto) {
        qrCodeDto.setDrawStyle(drawStyle);
        qrCodeDto.setErrorCorrectionLevel(errorCorrectionLevel);
        qrCodeDto.setUrl(qrUrl);
        qrCodeDto.setLogoName(logoName);
        qrCodeDto.setWidth(qrWidth);
        qrCodeDto.setHeight(qrHeight);
        qrCodeDto.setDisplayUserCode(displayUserCode);
        storageService.init();
        return storageService.qrGenerate(qrCodeDto);
    }

//    public Map<Integer, String> cicleGenerate(final QrCodeDto qrCodeDto) throws IOException, WriterException {
//        return Utils.cicleQrGenerator(qrCodeDto);
//    }
//
//    public Map<Integer, String> squareQrGenerator(final QrCodeDto qrCodeDto) throws IOException, WriterException {
//        return Utils.squareQrGenerator(qrCodeDto);
//    }
}
