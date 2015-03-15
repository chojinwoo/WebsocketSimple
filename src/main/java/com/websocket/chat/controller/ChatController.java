package com.websocket.chat.controller;

import com.websocket.chat.vo.ChatVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.List;

/**
 * Created by jinwoo on 2015-03-15.
 */
@Controller
public class ChatController {
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @MessageMapping("/msg/{to}")
    public void secretMsg(Principal principal, @DestinationVariable("to")String to, @Payload ChatVo chatVo) {
        List<String> userList = chatVo.getTo();
        for(String userTo : userList) {
            simpMessagingTemplate.convertAndSend("/user/" + userTo+ "/topic/msg", chatVo);
        }

    }
}
