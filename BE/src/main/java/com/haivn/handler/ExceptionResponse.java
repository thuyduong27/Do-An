package com.haivn.handler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;

@ControllerAdvice
@Slf4j
public class ExceptionResponse {
    @ExceptionHandler(Exception.class)
    public final ResponseEntity<Object> handleNullPointerException(Exception ex,
                                                                   HttpServletRequest request, HttpServletResponse response) {
//        log.info("Entering into the handleAllException method");
//        System.out.println("Exception is : " + ex.getClass());
        ResponseMessage error = new ResponseMessage();
        if(ex.getLocalizedMessage().contains("ConstraintViolationException")) {
            String errorMsg = "Không thể thực hiện yêu cầu. Bản ghi này có lỗi về ràng buộc dữ liệu. " + ex.getLocalizedMessage();
            error.setMessage(errorMsg);
        }
        else
            error.setMessage(HttpStatus.BAD_REQUEST + " | " + ex.getLocalizedMessage() + " | " + LocalDateTime.now());
        return new ResponseEntity(error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
