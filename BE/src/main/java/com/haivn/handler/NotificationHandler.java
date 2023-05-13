package com.haivn.handler;

import org.json.JSONObject;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class NotificationHandler extends TextWebSocketHandler {
    private static final Map<String, WebSocketSession> lstActiveSession = new ConcurrentHashMap<>();

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws IOException {
        System.out.println(message.getPayload());

        String payload = message.getPayload();
        JSONObject jsonObject = new JSONObject(payload);
        for (Map.Entry<String, WebSocketSession> otherSession : lstActiveSession.entrySet()) {
//            if (otherSession.getKey().equals(session.getId())) continue;
            otherSession.getValue().sendMessage(new TextMessage(jsonObject.get("content").toString()));
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        lstActiveSession.put(session.getId(), session);
        super.afterConnectionEstablished(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        lstActiveSession.remove(session.getId());
        super.afterConnectionClosed(session, status);
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) {
        System.out.println("_________" + session);
        exception.printStackTrace();
    }
}
