package com.haivn.service;

import com.haivn.dto.EmailDto;
import freemarker.core.ParseException;
import freemarker.template.Configuration;
import freemarker.template.MalformedTemplateNameException;
import freemarker.template.Template;
import freemarker.template.TemplateNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.Map;

@Service
@Slf4j
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${aam.templates.path}")
    private String basePackagePath;

    @Autowired
    Configuration templateConfiguration;

    @Value("${spring.mail.username}")
    private String fromMail;

    @Value("${mail.common}")
    private String commonEmail;

    @Value("${mail.activity}")
    private boolean activityMail;

    @Value("${aam.upload.dir}")
    private String uploadPath;

    @Autowired
    @Qualifier("messageSource")
    MessageSource msg;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public String sendMimeMail(EmailDto emailDto) {
        MimeMessage message = mailSender.createMimeMessage();
        try{
            MimeMessageHelper helper = new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());
            helper.setFrom(fromMail);
            helper.setTo(emailDto.getMailTo());
            helper.setSubject(emailDto.getTitle());
            if(emailDto.getTemplateName() != null && !StringUtils.isEmpty(emailDto.getTemplateName())) {
                emailDto.setContent(getContentFromTemplate(emailDto.getModel(), emailDto.getTemplateName()));
            }
            helper.setText(emailDto.getContent(), true);
            if(null != emailDto.getAttachFiles() && emailDto.getAttachFiles().size()>0) {
                for (String fileName : emailDto.getAttachFiles()) {
                    File atf = Paths.get(uploadPath).resolve(fileName).toFile();
                    if (atf.exists()) {
                        FileSystemResource file = new FileSystemResource(atf);
                        helper.addAttachment(fileName, file);
                    }
                }
            }
        }catch (MessagingException e) {
            return "Có lỗi trong quá trình xử lý! " + e.getMessage();
        } catch (TemplateNotFoundException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (MalformedTemplateNameException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        mailSender.send(message);
        return "Gửi email thành công!";
    }

    public String sendMulti(EmailDto emailDto) {
        MimeMessage message = mailSender.createMimeMessage();
        try{
            MimeMessageHelper helper = new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());
            helper.setFrom(fromMail);
            helper.setTo(emailDto.getMailTo().split(","));
            helper.setSubject(emailDto.getTitle());
            if(emailDto.getTemplateName() != null && !StringUtils.isEmpty(emailDto.getTemplateName())) {
                emailDto.setContent(getContentFromTemplate(emailDto.getModel(), emailDto.getTemplateName()));
            }
//            helper.addInline("logo.png", new ClassPathResource("logo.png"));

            helper.setText(emailDto.getContent(), true);
            if(null != emailDto.getAttachFiles() && emailDto.getAttachFiles().size()>0) {
                for (String fileName : emailDto.getAttachFiles()) {
                    File atf = Paths.get(uploadPath).resolve(fileName).toFile();
                    if (atf.exists()) {
                        FileSystemResource file = new FileSystemResource(atf);
                        helper.addAttachment(fileName, file);
                    }
                }
            }
        }catch (MessagingException e) {
            return "Có lỗi trong quá trình xử lý! " + e.getMessage();
        } catch (TemplateNotFoundException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (MalformedTemplateNameException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        mailSender.send(message);
        return "Gửi email thành công!";
    }

    public String getContentFromTemplate(Map<String, Object> model, String templateName) throws IOException {
        StringBuffer content = new StringBuffer();
        templateConfiguration.setClassForTemplateLoading(getClass(), basePackagePath);
        Template template = templateConfiguration.getTemplate(templateName);
        try {
            content.append(FreeMarkerTemplateUtils.processTemplateIntoString(template, model));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return content.toString();
    }
}
