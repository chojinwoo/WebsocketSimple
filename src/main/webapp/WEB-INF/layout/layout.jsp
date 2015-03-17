<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: jinwoo
  Date: 2015-03-15
  Time: 오후 3:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title></title>
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css">
    <link rel="stylesheet" href="/resources/css/font-awesome.min.css">
    <style>
        @import url(http://fonts.googleapis.com/earlyaccess/hanna.css);
        body > div {
            font-family: 'Hanna';
        }
    </style>
    <script type="text/javascript" src="/resources/js/jquery-2.1.3.min.js"></script>
    <%--<script type="text/javascript" src="/resources/js/jquery.mobile-1.4.5.min.js"></script>--%>
    <script type="text/javascript" src="//code.jquery.com/ui/1.11.3/jquery-ui.js"></script>
    <script type="text/javascript" src="/resources/js/bootstrap.js"></script>
    <script type="text/javascript" src="/resources/js/sockJs.js"></script>
    <script type="text/javascript" src="/resources/js/stomp.js"></script>

    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script>
        var stomp = null;
        $(document).ready(function() {
            var ws = new SockJS("/ws");
            stomp = Stomp.over(ws);
            stomp.connect([], function(frame) {
                console.log(frame);
                stomp.subscribe("/user/topic/msg", function(message) {
                    var json = JSON.parse(message.body);
                    $.receive(json);
                });

                stomp.subscribe("/user/queue/errors", function(message) {
                    alert(message);
                });

            })


        })
    </script>
    <style>
        .chat-body {
            padding-top: 60px;
            padding-bottom: 50px;
            position: absolute;
            width: 100%;
        }

        .chat-header {
            width:100%;
            height:50px;
            position:fixed;
            background-color:#a5d8c7;
            top:0px;
            border-radius: 5px;
            -moz-border-radius: 6px;
            padding:10px;
            z-index: 2;
        }

        .chat-header > span > .active {
            color:darkgreen;
        }

        .chat-header .fa {
            font-size:35px;
            margin-left:6px;
            margin-right: 6px;
        }
    </style>
</head>
<body>
    <div class="chat-header">
    <tiles:insertAttribute name="header"/>
    </div>
    <div class="chat-body">
    <tiles:insertAttribute name="body"/>
    </div>
<script>
    $(document).ready(function() {

        $('.chat-body').load("/resources/chat/user.jsp");

        $('.chat-header .fa-user').on('click' , function() {
            $('.chat-body').load("/resources/chat/user.jsp");
        })
    })
</script>
</body>
</html>
