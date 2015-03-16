package com.websocket.user.controller;

import com.websocket.user.service.UserService;
import com.websocket.user.vo.UserVo;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

	@RequestMapping(value="/")
	public String printWelcome(ModelMap model) {
		model.addAttribute("message", "Hello world!");
		return "login";
	}

    @RequestMapping(value="/main", method = RequestMethod.GET)
    public String main(Principal principal, Model model) {
        return "room.tiles";
    }

    @RequestMapping(value="/user", method=RequestMethod.POST)
    @ResponseBody
    public String user(Principal principal) {
        List list = this.userService.users(principal.getName());
        JSONObject jo = new JSONObject();
        jo.put("json", list);
        System.out.println(jo.toString());
        return jo.toString();
    }

    @RequestMapping(value="/register", method = RequestMethod.POST)
    @ResponseBody
    public int register(@ModelAttribute("command")UserVo userVo) {
        return this.userService.register(userVo);
    }

}