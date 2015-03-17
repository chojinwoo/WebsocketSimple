package com.websocket.chat.vo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by jinwoo on 2015-03-15.
 */
@Controller
public class ChatVo {
    private String from;
    private String fromName;
    private List to;
    private String msg;
    private String emoticon;
    private String roomId;
    private String date;
    private String time;
    private String flag;

    public ChatVo() {
    }

    public ChatVo(String from, String fromName, List to, String msg, String emoticon, String roomId, String date, String time, String flag) {
        this.from = from;
        this.fromName = fromName;
        this.to = to;
        this.msg = msg;
        this.emoticon = emoticon;
        this.roomId = roomId;
        this.date = date;
        this.time = time;
        this.flag = flag;
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getFromName() {
        return fromName;
    }

    public void setFromName(String fromName) {
        this.fromName = fromName;
    }

    public List getTo() {
        return to;
    }

    public void setTo(List to) {
        this.to = to;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getEmoticon() {
        return emoticon;
    }

    public void setEmoticon(String emoticon) {
        this.emoticon = emoticon;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }
}
