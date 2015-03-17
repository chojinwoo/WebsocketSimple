package com.websocket.chat.controller;

import com.websocket.chat.vo.ChatVo;
import com.websocket.common.util.Converter;
import com.websocket.user.vo.UserVo;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.lang.reflect.Field;
import java.security.Principal;
import java.text.SimpleDateFormat;
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

        /*시간 및 플래그 주입*/

        TimeZone tz = TimeZone.getTimeZone("Asia/Seoul");
        SimpleDateFormat sdf = new SimpleDateFormat("a h:m");
        sdf.setTimeZone(tz);
        String time = sdf.format(new Date());
        sdf = new SimpleDateFormat("M월 d일");
        sdf.setTimeZone(tz);
        String date = sdf.format(new Date());

        chatVo.setFlag("1");
        chatVo.setDate(date);
        chatVo.setTime(time);

        createRoom(chatVo);
        addMessage(chatVo);
        for(HashMap user: userList) {
            simpMessagingTemplate.convertAndSend("/user/" + user.get("email")+ "/topic/msg", chatVo);
        }
        simpMessagingTemplate.convertAndSend("/user/" + chatVo.getFrom()+ "/topic/msg", chatVo);
    }

    @RequestMapping(value="/chatInit", method = RequestMethod.POST)
    @ResponseBody
    public String chatInit(@RequestParam("to") String to, Principal principal) {
        JSONArray ja = new JSONArray();
        List<HashMap> roomList = (List) myRoomMap.get(principal.getName());

        if(roomList != null) {
            for(HashMap room : roomList) {
                String room_to = (String) room.get("to");
                if(room_to.equals(to)) {
                    String roomId = (String) room.get("room");
                    List<HashMap> msgList = (List) roomMap.get(roomId);
                    for(HashMap msg : msgList) {
                        if(!msg.get("from").equals(principal.getName())) {
                            msg.put("flag", "0");
                        }
                    }
                    ja.addAll(msgList);
                }
            }
        }

        return ja.toString();
    }

    @RequestMapping(value="/listInit", method = RequestMethod.POST)
    @ResponseBody
    public String listInit(Principal principal) {
        List newList = new LinkedList();

        System.out.println(myRoomMap.toString());
        System.out.println(roomMap.toString());
        JSONArray ja = new JSONArray();
        List<HashMap> roomList = (List) myRoomMap.get(principal.getName());
        if(roomList != null) {
            for(HashMap room : roomList) {
                HashMap newMap = new HashMap();
                int flagCnt = 0;
                newMap.put("name", room.get("name"));
                newMap.put("to", room.get("to"));
                newMap.put("room", room.get("room"));
                List<HashMap> msgList = (List) roomMap.get(room.get("room"));
                for(int i=0; i<msgList.size(); i++) {
                    HashMap msg = msgList.get(i);
                    if(msg.get("flag").equals("1")) {
                        if(!msg.get("from").equals(principal.getName())) {
                            ++flagCnt;
                        }

                    }
                    if(i == (msgList.size() -1)) {
                        HashMap lastMsg = msgList.get(msgList.size()-1);
                        newMap.put("msg", lastMsg.get("msg"));
                        newMap.put("date", lastMsg.get("date"));
                        newMap.put("flagCnt", flagCnt);
                    }
                }

                newList.add(newMap);
            }
        }
        ja.addAll(newList);
        return ja.toString();
    }

    public void createRoom(ChatVo chatVo) {
        if(chatVo.getRoom() == null || chatVo.getRoom() == "") {
            String uuid = UUID.randomUUID().toString();
            chatVo.setRoom(uuid);
            List<HashMap> userLIst = chatVo.getTo();

            HashMap map = null;
            List roomList = null;
            for (HashMap user : userLIst) {
                roomList = (List) myRoomMap.get(user.get("email"));
                if (roomList == null) {
                    roomList = new LinkedList();
                }
                map = new HashMap();
                map.put("to", chatVo.getFrom());
                map.put("name", chatVo.getFromName());
                map.put("room", uuid);
                roomList.add(map);
                myRoomMap.put(user.get("email"), roomList);

                roomList = (List) myRoomMap.get(chatVo.getFrom());
                if (roomList == null) {
                    roomList = new LinkedList();
                }

                map = new HashMap();
                map.put("to", user.get("email"));
                map.put("name", user.get("name"));
                map.put("room", uuid);
                roomList.add(map);
                myRoomMap.put(chatVo.getFrom(), roomList);
            }
        }
    }

    public void addMessage(ChatVo chatVo) {
        JSONObject jo = new JSONObject();
        List msgList = (List) roomMap.get(chatVo.getRoom());
        if(msgList == null) {
            msgList = new LinkedList<String>();
        }
        msgList.add(Converter.converObjectToMap(chatVo));
        roomMap.put(chatVo.getRoom(), msgList);
    }

}
