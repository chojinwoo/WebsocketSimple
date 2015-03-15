<%--
  Created by IntelliJ IDEA.
  User: jinwoo
  Date: 2015-03-15
  Time: 오후 3:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <style>
        .chat-header {
            width:100%;
            height:60px;
            position:fixed;
            background-color:#a5d8c7;
            top:0px;
            border-radius: 5px;
            -moz-border-radius: 6px;
            padding:10px;
        }

        .chat-header > span > .active {
            color:darkgreen;
        }

        .chat-header .fa {
            font-size:40px;
            margin-left:6px;
            margin-right: 6px;
        }
    </style>
</head>
<body>
<div class="chat-header">
    <span><i class="fa fa-user active"></i></span>
    <span><i class="fa fa-weixin"></i></span>
    <span class="pull-right"><i class="fa fa-users"></i></span>
</div>
</body>
</html>
