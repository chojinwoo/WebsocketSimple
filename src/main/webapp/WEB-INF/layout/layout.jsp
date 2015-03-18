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
<sec:authentication property="principal.email" var="email"/>
<sec:authentication property="principal.name" var="name"/>
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

        /*대화방 리스트 정의*/
        $.listSet = function() {
            $.ajax({
                url:'/listInit',
                dataType:'json',
                async:false,
                type:'post',
                success:function(data) {
                    $('.chat-body').find('.list-detail:not(.hide)').remove();
                    var flagTotal = 0;
                    $.each(data, function() {
                        var clone = $('.list-detail.hide').clone().removeClass('hide');
                        clone.find('.list-name').text(this.name);
                        clone.find('.list-content').text(this.msg);
                        clone.find('.list-date').text(this.date);
                        clone.find('#to').val(this.to);
                        clone.find('#name').val(this.name);
                        if(this.flagCnt != 0) {
                            clone.find('.list-flag').removeClass('hide').text(this.flagCnt);
                        }
                        $('.chat-body').append(clone);
                        flagTotal = flagTotal + this.flagCnt;
                    })
                    if(flagTotal == '0') {
                        $('.header-badge').addClass('hide');
                    } else {
                        $('.header-badge').removeClass('hide').text(flagTotal);
                    }

                }, error:function(xhr, status, error) {
                    alert(error);
                }
            })
        }

        /* 받은 메시지 정의 */
        $.receive = function(json) {
            var clone = '';
            if(json.from == '${email}') {
                clone = $('#fromChat').clone().removeClass('hide');
            } else {
                clone =$('#toChat').clone().removeClass('hide');
            }
            if(json.emoticon != '') {
                var img = $('<img>').attr('src', json.emoticon).css('width', '100px');
                clone.find('.emoticon').append(img);
            }
            if(json.msg == '') {
                clone.find('.content').addClass('hide');
            } else {
                clone.find('.content').text(json.msg);
            }

            $('#room').val(json.room);
            clone.find('.date').text(json.time);
            $('.chat-body').append(clone);
        }

        var stomp = null;
        $(document).ready(function() {
            var ws = new SockJS("/ws");
            stomp = Stomp.over(ws);
            stomp.connect([], function(frame) {
                console.log(frame);
                stomp.subscribe("/user/topic/msg", function(message) {
                    var json = JSON.parse(message.body);
                    if($('.chat-body #emoModal').index()> -1) {
                        $.receive(json);
                    }
                    $.listSet();
                });

                stomp.subscribe("/user/queue/errors", function(message) {
                    alert(message);
                });
            })
        })
    </script>
    <style>
        .chat-body {
            padding-top: 50px;
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
        $.listSet();
        $('.chat-body').load("/resources/chat/user.jsp");

        $('.chat-header .fa-user').on('click' , function() {
            $('.chat-header .fa').removeClass('active');
            $(this).addClass('active');
            $('.chat-body').load("/resources/chat/user.jsp");
        })
        $('.chat-header .fa-weixin').on('click' , function() {
            $('.chat-header .fa').removeClass('active');
            $(this).addClass('active');
            $('.chat-body').load("/resources/chat/list.jsp");
        })
    })
</script>
</body>
</html>
