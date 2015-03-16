package com.websocket.chat.controller;

import com.websocket.chat.vo.ChatVo;
import com.websocket.common.util.Converter;
import org.json.simple.JSONObject;
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

import java.lang.reflect.Field;
import java.security.Principal;
import java.util.*;

@Controller
public class ChatController {
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
    private Map roomMap;
    private Map myRoomMap;

    public ChatController() {
        roomMap = new HashMap();
        myRoomMap = new HashMap();
    }

    @MessageMapping("/msg")
    public void msg(Principal principal, @Payload ChatVo chatVo) {
        List<HashMap> userList = chatVo.getTo();

        createRoom(chatVo);
        addMessage(chatVo);
        for(HashMap user: userList) {
            simpMessagingTemplate.convertAndSend("/user/" + user.get("email")+ "/topic/msg", chatVo);
        }
        simpMessagingTemplate.convertAndSend("/user/" + chatVo.getFrom()+ "/topic/msg", chatVo);
        System.out.println(myRoomMap);
        System.out.println(roomMap.toString());
    }

    public void createRoom(ChatVo chatVo) {
        if(chatVo.getRoomId() == null) {
            String uuid = UUID.randomUUID().toString();
            chatVo.setRoomId(uuid);
            List<HashMap> userLIst = chatVo.getTo();

            List roomList = null;
            for (HashMap user : userLIst) {
                roomList = (List) myRoomMap.get(user.get("email"));
                if (roomList == null) {
                    roomList = new LinkedList();
                }
                roomList.add(uuid);
                myRoomMap.put(user.get("email"), roomList);
            }
            myRoomMap.put(chatVo.getFrom(), roomList);
        }
    }

    public void addMessage(ChatVo chatVo) {
        JSONObject jo = new JSONObject();
        List msgList = (List) roomMap.get(chatVo.getRoomId());
        if(msgList == null) {
            msgList = new LinkedList<String>();
        }
        msgList.add(Converter.converObjectToMap(chatVo));
        roomMap.put(chatVo.getRoomId(), msgList);
    }

}
