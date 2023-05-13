package com.haivn.upload_files;

import com.haivn.dto.QrCodeDto;
import com.haivn.handler.Utils;
import com.github.hui.quick.plugin.qrcode.wrapper.QrCodeGenWrapper;
import com.github.hui.quick.plugin.qrcode.wrapper.QrCodeOptions;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.google.zxing.qrcode.encoder.ByteMatrix;
import com.google.zxing.qrcode.encoder.Encoder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;

@Service
@Slf4j
public class FilesStorageServiceImpl implements FilesStorageService {
//    private final Path root = Paths.get("uploads");
    @Value("${aam.upload.dir}")
    private String uploadPath;

    @Value("${aam.upload.qrcode.dir}")
    private String uploadPathQR;

    @Value("${aam.upload.cccd.dir}")
    private String uploadPathCCCD;

//    Path root = Paths.get(uploadPath);

    @Override
    public void init() {
        Utils.mkdirs(uploadPath);
        Utils.mkdirs(uploadPathQR);
        Utils.mkdirs(uploadPathCCCD);
//            Files.createDirectory(Paths.get(uploadPath));
//            Files.createDirectory(Paths.get(uploadPathQR));
//            Files.createDirectory(Paths.get(uploadPathCCCD));
    }

    @Override
    public Map<Integer, String> save(MultipartFile file) {
        Map<Integer, String> res = new HashMap<>();
        try {
            if (null == file || !isSupportedContentType(file.getContentType().toLowerCase())) {
                res.put(0, "File upload không hợp lệ!");
                return res;
            }
            String fileName = "file_" + Utils.getRandomString(12)+getFileExtension(file.getOriginalFilename());
            Files.copy(file.getInputStream(), Paths.get(uploadPath).resolve(fileName));
            res.put(1, fileName);
        } catch (Exception e) {
            throw new RuntimeException("Xảy ra lỗi trong quá trình xử lý. Error: " + e.getMessage());
        }
        return res;
    }

    @Override
    public Map<Integer, String> saveCCCD(MultipartFile file) {
        Map<Integer, String> res = new HashMap<>();
        try {
            if (null == file || !isSupportedContentType(file.getContentType().toLowerCase())) {
                res.put(0, "File upload không hợp lệ!");
                return res;
            }
            String fileName = "file_" + Utils.getRandomString(12)+getFileExtension(file.getOriginalFilename());
            Files.copy(file.getInputStream(), Paths.get(uploadPathCCCD).resolve(fileName));
            res.put(1, fileName);
        } catch (Exception e) {
            throw new RuntimeException("Xảy ra lỗi trong quá trình xử lý. Error: " + e.getMessage());
        }
        return res;
    }

    public String saveFile(MultipartFile file) {
        String fileName = "";
        try {
            if (null == file || !isSupportedContentType(file.getContentType().toLowerCase())) {
                return "File upload không hợp lệ!";
            }
            fileName = "file_" + Utils.getRandomString(12)+getFileExtension(file.getOriginalFilename());
            Files.copy(file.getInputStream(), Paths.get(uploadPath).resolve(fileName));
        } catch (Exception e) {
            throw new RuntimeException("Xảy ra lỗi trong quá trình xử lý. Error: " + e.getMessage());
        }
        return fileName;
    }

    @Override
    public Resource load(String filename) {
        try {
            File dir = new File(uploadPath);
            File f = Utils.searchFile(dir, filename);
            if (f != null) {
                Path path = f.toPath();
                return new UrlResource(path.toUri());
            }else {
                throw new RuntimeException("File not found!");
            }
        } catch (MalformedURLException e) {
            throw new RuntimeException("Error: " + e.getMessage());
        }
    }

    @Override
    public Stream<Path> loadAll() {
        try {
            return Files.walk(Paths.get(uploadPath), 1).filter(path -> !path.equals(Paths.get(uploadPath))).map(Paths.get(uploadPath)::relativize);
        } catch (IOException e) {
            throw new RuntimeException("Không thể lấy danh sách files!");
        }
    }

//    @Override
//    public void deleteAll() {
//        FileSystemUtils.deleteRecursively(root.toFile());
//    }

    private boolean isSupportedContentType(String contentType) {
        return contentType.equals("text/xml")
                || contentType.equals("text/plain")
                || contentType.equals("image/png")
                || contentType.equals("image/jpg")
                || contentType.equals("image/jpeg")
                || contentType.equals("image/gif")
                || contentType.equals("application/pdf")
                || contentType.equals("application/msword")
                || contentType.equals("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
                || contentType.equals("application/vnd.ms-excel")
                || contentType.equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                || contentType.equals("application/vnd.ms-powerpoint")
                || contentType.equals("application/vnd.openxmlformats-officedocument.presentationml.presentation")
                || contentType.equals("application/vnd.ms-access")
                || contentType.equals("audio/mpeg") //mp3
                || contentType.equals("audio/ogg")
                || contentType.equals("video/3gpp")
                || contentType.equals("video/x-msvideo")
                || contentType.equals("video/ogg")
                || contentType.equals("application/mp4")
                || contentType.equals("application/x-7z-compressed")
                || contentType.equals("application/zip")
                || contentType.equals("application/x-rar-compressed")
                || contentType.equals("application/octet-stream");
    }

    public String getFileExtension(String filename) {
//        String name = file.getName();
        int lastIndexOf = filename.lastIndexOf(".");
        if (lastIndexOf == -1) {
            return ""; // empty extension
        }
        return filename.substring(lastIndexOf);
    }

    @Override
    public Map<Integer, String> qrGenerate(QrCodeDto qrCodeDto) {
        Map<Integer, String> res = new HashMap<>();
        try {
            switch (qrCodeDto.getDrawStyle()) {
                case "cicle_cicle":
                    res = cicleQrGenerator(qrCodeDto);
                    break;
                case "square_cicle":
                    res = squareQrGenerator(qrCodeDto);
                    break;
                case "normal":
                default:
                    res = qrNormalGenerator(qrCodeDto);
                    break;
            }
        }
        catch (Exception e){
            String msg = "Tạo Qr Code không thành công.";
            res.put(0, msg);
        }
        return res;
    }

    private Map<Integer, String> squareQrGenerator(QrCodeDto qrCodeDto) {
        Map<Integer, String> res = new HashMap<>();
        String fileType = "png";
        String fileSuffix = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String fileName = "qrcode_"+qrCodeDto.getUserId().trim().toLowerCase().replace(".","_")+fileSuffix;
        try {
            Resource resource = new ClassPathResource(qrCodeDto.getLogoName());
            BufferedImage logoImage = ImageIO.read(resource.getInputStream());

//            Resource resDetect = new ClassPathResource("logo.png");
//            BufferedImage detectImage = ImageIO.read(resDetect.getInputStream());

            String qrContent = qrCodeDto.getUrl() + "?code=" + qrCodeDto.getUserId();
            BufferedImage image = QrCodeGenWrapper.of(qrContent)
                    .setW(qrCodeDto.getWidth())
                    .setH(qrCodeDto.getHeight())
                    .setDrawEnableScale(true) //partern scale to nhỏ
                    .setDrawStyle(QrCodeOptions.DrawStyle.CIRCLE) //dạng partern
                    .setLogo(logoImage)
//                .setLogoBgColor(Color.decode("#009c87"))
                    .setLogoBorder(true)
                    .setLogoStyle(QrCodeOptions.LogoStyle.ROUND)
//                    .setDetectImg(detectImage)
                    .setDetectOutColor(Color.decode("#009c87"))
                    .setDetectInColor(Color.decode("#f97918"))
                    .setDrawPreColor(Color.decode("#009c87")) //màu partern
                    .setDetectSpecial()
                    .setQrStyle(QrCodeOptions.ImgStyle.ROUND)
                    .setErrorCorrection(getErrorCorrectionLevel(qrCodeDto.getErrorCorrectionLevel()))
                    .asBufferedImage();

            if(qrCodeDto.isDisplayUserCode()) {
                Graphics2D graphics = (Graphics2D) image.getGraphics();
                graphics.setFont(new Font("Arial", Font.BOLD, 15));
                graphics.setColor(Color.decode("#009c87"));
                graphics.drawString(qrCodeDto.getUserId(), (qrCodeDto.getWidth() / 2) - 60, qrCodeDto.getHeight() - 5);
                graphics.dispose();
            }

            File mFile = File.createTempFile(fileName, "." + fileType);
            ImageIO.write(image, fileType, mFile);
            InputStream inputStream = new FileInputStream(mFile);
            Files.copy(inputStream, Paths.get(uploadPathQR).resolve(fileName + "." + fileType));
            res.put(1, fileName + "." + fileType);
        }
        catch (Exception e){
            String msg = "Tạo Qr Code không thành công.";
            res.put(0, msg);
        }
        return res;
    }

    private Map<Integer, String> cicleQrGenerator(QrCodeDto qrCodeDto) {
        Map<Integer, String> res = new HashMap<>();
        String fileType = "png";
        String fileSuffix = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String fileName = "qrcode_"+qrCodeDto.getUserId().trim().toLowerCase().replace(".","_")+fileSuffix;
        String qrContent = qrCodeDto.getUrl() + "?code="+qrCodeDto.getUserId();
        try {
            final Map<EncodeHintType, Object> encodingHints = new HashMap<>();
            encodingHints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            com.google.zxing.qrcode.encoder.QRCode code = Encoder.encode(qrContent, getErrorCorrectionLevel(qrCodeDto.getErrorCorrectionLevel()), encodingHints);
            BufferedImage image = renderQRImage(code, qrCodeDto.getWidth(), qrCodeDto.getHeight(), 2);

            Resource resource = new ClassPathResource(qrCodeDto.getLogoName());
            BufferedImage logoImage = ImageIO.read(resource.getInputStream());

            // Calculate the delta height and width between QR code and logo
            int deltaHeight = image.getHeight() - logoImage.getHeight();
            int deltaWidth = image.getWidth() - logoImage.getWidth();

            BufferedImage combinedImage = new BufferedImage(image.getHeight(), image.getWidth(), BufferedImage.TYPE_INT_ARGB);
            Graphics2D graphics = (Graphics2D) combinedImage.getGraphics();
            // Write QR code to new image at position 0/0
            graphics.drawImage(image, 0, 0, null);
            graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1f));
            graphics.drawImage(logoImage, Math.round(deltaWidth / 2), Math.round(deltaHeight / 2), null);
            Shape shape = new RoundRectangle2D.Float(Math.round(deltaWidth / 2), Math.round(deltaHeight / 2), logoImage.getWidth(), logoImage.getHeight(), 5, 5);
            BasicStroke basicStroke = new BasicStroke(2, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
            graphics.setStroke(basicStroke);
            graphics.draw(shape);
            if(qrCodeDto.isDisplayUserCode()) {
                graphics.setFont(new Font("Arial", Font.BOLD, 15));
                graphics.setColor(Color.decode("#009c87"));
                graphics.drawString(qrCodeDto.getUserId(), (qrCodeDto.getWidth() / 2) - 60, qrCodeDto.getHeight() - 5);
            }
            graphics.dispose();
            image.flush();
            logoImage.flush();


            File mFile = File.createTempFile(fileName, "." + fileType);
            ImageIO.write(combinedImage, fileType, mFile);
            InputStream inputStream = new FileInputStream(mFile);
            Files.copy(inputStream, Paths.get(uploadPathQR).resolve(fileName + "." + fileType));
            res.put(1, fileName + "." + fileType);
        }catch (Exception e){
            String msg = "Tạo Qr Code không thành công.";
            res.put(0, msg);
        }
        return res;
    }

    public Map<Integer, String> qrNormalGenerator(QrCodeDto qrCodeDto) {
        Map<Integer, String> res = new HashMap<>();
//        int size = 300;
        String fileType = "png";
        String fileSuffix = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String fileName = "qrcode_"+qrCodeDto.getUserId().toLowerCase().replace(".","_")+fileSuffix;
        String qrContent = qrCodeDto.getUrl() + "?code="+qrCodeDto.getUserId();
        try {
            Map<EncodeHintType, Object> hintMap = createHintMap();
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(qrContent, BarcodeFormat.QR_CODE, qrCodeDto.getWidth(), qrCodeDto.getHeight(), hintMap);
            MatrixToImageConfig config = new MatrixToImageConfig(MatrixToImageConfig.BLACK, MatrixToImageConfig.WHITE);

            // Load QR image
            BufferedImage image = MatrixToImageWriter.toBufferedImage(bitMatrix, config);

            // Load logo image
            Resource resource = new ClassPathResource(qrCodeDto.getLogoName());
            BufferedImage logoImage = ImageIO.read(resource.getInputStream());
            // Calculate the delta height and width between QR code and logo
            int deltaHeight = image.getHeight() - logoImage.getHeight();
            int deltaWidth = image.getWidth() - logoImage.getWidth();

            // Initialize combined image
            BufferedImage combined = new BufferedImage(image.getHeight(), image.getWidth(), BufferedImage.TYPE_INT_ARGB);

            Graphics2D graphics = (Graphics2D) combined.getGraphics();
            // Write QR code to new image at position 0/0
            graphics.drawImage(image, 0, 0, null);
            graphics.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1f));
            graphics.drawImage(logoImage, Math.round(deltaWidth / 2), Math.round(deltaHeight / 2), null);
            if(qrCodeDto.isDisplayUserCode()) {
                graphics.setFont(new Font("Arial", Font.BOLD, 15));
                graphics.setColor(Color.black);
                graphics.drawString(qrCodeDto.getUserId(), (qrCodeDto.getWidth() / 2) - 60, qrCodeDto.getHeight() - 5);
            }
//            Shape shape = new RoundRectangle2D.Float(Math.round(deltaWidth / 2), Math.round(deltaHeight / 2), logoImage.getWidth(), logoImage.getHeight(), 5, 5);
//            BasicStroke basicStroke = new BasicStroke(2, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
//            graphics.setStroke(basicStroke);
//            graphics.draw(shape);
            graphics.dispose();

            File myFile = File.createTempFile(fileName, "." + fileType);
            ImageIO.write(combined, fileType, myFile);
            InputStream inputStream = new FileInputStream(myFile);
            Files.copy(inputStream, Paths.get(uploadPathQR).resolve(fileName+"."+fileType));
            res.put(1, fileName+"."+fileType);
        } catch (WriterException | IOException e) {
            String msg = "Tạo Qr Code không thành công.";
            res.put(0, msg);
        }
        return res;
    }

    private static Map<EncodeHintType, Object> createHintMap() {
        Map<EncodeHintType, Object> hintMap = new EnumMap<>(EncodeHintType.class);
        hintMap.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hintMap.put(EncodeHintType.MARGIN, 1);
        hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
        return hintMap;
    }

    private BufferedImage renderQRImage(com.google.zxing.qrcode.encoder.QRCode code, int width, int height, int quietZone) throws WriterException {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D graphics = image.createGraphics();

        graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        graphics.setBackground(Color.white);
        graphics.clearRect(0, 0, width, height);
        //Màu partern chính
        graphics.setColor(Color.decode("#009c87"));

        ByteMatrix input = code.getMatrix();
        if (input == null) {
            throw new IllegalStateException();
        }
        int inputWidth = input.getWidth();
        int inputHeight = input.getHeight();
        int qrWidth = inputWidth + (quietZone * 2);
        int qrHeight = inputHeight + (quietZone * 2);
        int outputWidth = Math.max(width, qrWidth);
        int outputHeight = Math.max(height, qrHeight);

        int multiple = Math.min(outputWidth / qrWidth, outputHeight / qrHeight);
        int leftPadding = (outputWidth - (inputWidth * multiple)) / 2;
        int topPadding = (outputHeight - (inputHeight * multiple)) / 2;
        final int FINDER_PATTERN_SIZE = 7;
        final float CIRCLE_SCALE_DOWN_FACTOR = 21f/30f;
        int circleSize = (int) (multiple * CIRCLE_SCALE_DOWN_FACTOR);

        for (int inputY = 0, outputY = topPadding; inputY < inputHeight; inputY++, outputY += multiple) {
            for (int inputX = 0, outputX = leftPadding; inputX < inputWidth; inputX++, outputX += multiple) {
                if (input.get(inputX, inputY)==1) {
                    if (!(inputX <= FINDER_PATTERN_SIZE && inputY <= FINDER_PATTERN_SIZE ||
                            inputX >= inputWidth - FINDER_PATTERN_SIZE && inputY <= FINDER_PATTERN_SIZE ||
                            inputX <= FINDER_PATTERN_SIZE && inputY >= inputHeight - FINDER_PATTERN_SIZE)) {
                        graphics.fillOval(outputX, outputY, circleSize, circleSize);
                    }
                }
            }
        }

        int circleDiameter = multiple * FINDER_PATTERN_SIZE;
        drawFinderPatternCircleStyle(graphics, leftPadding, topPadding, circleDiameter);
        drawFinderPatternCircleStyle(graphics, leftPadding + (inputWidth - FINDER_PATTERN_SIZE) * multiple, topPadding, circleDiameter);
        drawFinderPatternCircleStyle(graphics, leftPadding, topPadding + (inputHeight - FINDER_PATTERN_SIZE) * multiple, circleDiameter);

        return image;
    }

    private void drawFinderPatternCircleStyle(Graphics2D graphics, int x, int y, int circleDiameter) {
        final int WHITE_CIRCLE_DIAMETER = circleDiameter*5/7;
        final int WHITE_CIRCLE_OFFSET = circleDiameter/7;
        final int MIDDLE_DOT_DIAMETER = circleDiameter*3/7;
        final int MIDDLE_DOT_OFFSET = circleDiameter*2/7;

        //Màu mắt ngoài cùng
        graphics.setColor(Color.decode("#009c87"));
        graphics.fillOval(x, y, circleDiameter, circleDiameter);
        //Màu mắt giữa
        graphics.setColor(Color.white);
        graphics.fillOval(x + WHITE_CIRCLE_OFFSET, y + WHITE_CIRCLE_OFFSET, WHITE_CIRCLE_DIAMETER, WHITE_CIRCLE_DIAMETER);
        //Màu mắt trong
        graphics.setColor(Color.decode("#f97918"));
        graphics.fillOval(x + MIDDLE_DOT_OFFSET, y + MIDDLE_DOT_OFFSET, MIDDLE_DOT_DIAMETER, MIDDLE_DOT_DIAMETER);
    }

    private ErrorCorrectionLevel getErrorCorrectionLevel(String level){
        switch (level){
            case "L":
                return ErrorCorrectionLevel.L;
            case "M":
                return ErrorCorrectionLevel.M;
            case "Q":
                return ErrorCorrectionLevel.Q;
            case "H":
            default:
                return ErrorCorrectionLevel.H;
        }
    }
}
