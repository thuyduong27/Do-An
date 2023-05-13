package com.haivn.handler;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResponseMessage {
    private String message;
    public ResponseMessage(){

    }
    public ResponseMessage(String message) {
        this.message = message;
    }
}
