<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: jinwoo
  Date: 2015-03-15
  Time: 오후 12:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<sec:authentication property="principal.email" var="email"/>
<html>
<head>
    <title>Simple Web Chatting</title>
    <style>

        .file-btn {
            position: absolute;
            font-size: 30px;
            left: 3px;
            bottom: 5px;
            cursor:pointer;
        }

        .emo-btn {
            position: absolute;
            font-size: 30px;
            right: 53px;
            z-index: 2;
            bottom: 5px;
            cursor:pointer;
        }

        .emo-chat {
            position: fixed;
            width: 100%;
            bottom: 42px;
            right: 0px;
            background: rgba(165, 216, 199, 0.5);
            text-align: right;
            display: none;
        }

        .emo-cancel {
            position: relative;
            top: -50px;
            right: 20px;
            font-size:20px;
            cursor:pointer;
        }

        .emo-preview {
            width:25px;
            height:25px;
        }

        .emo-paging > .active {
            background-color: darkgray;
            border-radius: 50%;
        }

        #emoKind {
            text-align:center;
        }

        .emo-paging {
            width: 100%;
            text-align: center;
            padding-top:10px;
        }

        .chat-detail {
            padding: 12px;
            height: 100px;
        }

        .chat-detail .chat-date {
            position: relative;
            bottom: 50px;
            left: 85%;
        }

        .chat-detail .chat-content {
            position: relative;
            right: 25px;
            background-color: #a5d8c7;
            padding: 7px;
            bottom: 20px;
            left: 50px;
            width: 65%;
        }

        .chat-detail .chat-name {
            position: relative;
            bottom: 15px;
            padding-left:8px;
        }

        .chat-detail .chat-face img {
            width: 40px;
            height: 40px;
            border-radius: 50%
        }
    </style>
</head>
<body>
<%-- emoticon emodal --%>
<!-- Modal -->
<div class="modal fade" id="emoModal" style="z-index:1050;" tabindex="-1" role="dialog" aria-labelledby="emoModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="padding:0px; border-bottom:0px">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true" style="  position: relative; top: 18px;right: 18px;">&times;</span></button>
                <ul class="nav nav-tabs" id="emoKind">
                    <li role="presentation" class="active"><a href="#" page="/resources/emoticon/sinjjang/sinjjang.jsp" ><img src="/resources/emoticon/mainImage/sinjjang.png" class="emo-preview"></a></li>
                    <li role="presentation"><a href="#" page="/resources/emoticon/sinjjang2/sinjjang2.jsp" ><img src="/resources/emoticon/mainImage/sinjjang2.png" class="emo-preview"></a></li>
                    <li role="presentation"><a href="#" page="/resources/emoticon/prodoAndNeo/prodoAndNeo.jsp"><img src="/resources/emoticon/mainImage/prodoAndNeo.png" class="emo-preview"></a></li>
                    <li role="presentation"><a href="#" page="/resources/emoticon/poi/poi.jsp"><img src="/resources/emoticon/mainImage/poi.png" class="emo-preview"></a></li>
                    <%--<li role="presentation"><a href="#">Messages</a></li>--%>
                </ul>
                <div class="emo-paging">
                    <i class="fa fa-circle-thin active"></i>
                    <i class="fa fa-circle-thin"></i>
                    <i class="fa fa-circle-thin"></i>
                    <i class="fa fa-circle-thin"></i>
                </div>
            </div>
            <div class="modal-body emo-body">
            </div>
        </div>
    </div>
</div>
<%-- end --%>
<div class="chat-body">
    <div id="chat" style="width:100%; height:91.9%">
        <div class="chat-detail">
            <span class="chat-face">
                <img src="/resources/img/face.png">
            </span>
            <span class="chat-name">
                승연
            </span>
            <p class="chat-content">안녕하세요 조진우입니다. 잘지내시죠??? 알겠습니다.</p>
            <span class="chat-date">22:20</span>
        </div>
        <div class="chat-detail">
            <span class="chat-face">
                <img src="/resources/img/face.png">
            </span>
            <span class="chat-name">
                승연
            </span>
            <p class="chat-content">안녕하세요</p>
            <span class="chat-date">22:20</span>
        </div>
    </div>
    <div id="input" style="position:absolute; margin:3px">
        <div class="emo-chat">
            <img src="/resources/emoticon/sinjjang/1.gif">
            <span class="glyphicon glyphicon-remove-sign emo-cancel"></span>
        </div>
        <div class="input-group" style="background-color:#F0F0F0;height:42px;padding:4px 0px 4px 32px;">
            <span class="file-btn" aria-hidden="true"><i class="fa fa-plus"></i></span>
            <input type="text" id="msg" class="form-control" style="padding-right: 35px;">
            <span class="emo-btn" aria-hidden="true"><i class="fa fa-smile-o fa-smile"></i></span>
            <span class="input-group-addon btn btn-default send-btn">전송</span>
        </div>
    </div>
</div>
<script>
    $.emoticonChange = function() {
        var emoPage = $('#emoKind > .active > a').attr('page');
        var emoLength = $(".emo-paging > .active").index();
        $('.emo-body').load(emoPage+" #emoPage"+emoLength, function() {
            $('.emoticon').on('click', function() {
                var src = $(this).attr("src");
                $('.emo-chat > img').attr('src', src);
                $('.emo-chat').show('slide', 300);
            })
        });
    }

    $('.send-btn').on('click', function() {
        var msg = $('#msg').val();
        $('#msg').val('');
        var to = "${param.get("to")}";
        var message = {"from":'${email}', 'to':['${email}', to], 'msg':msg};
        stomp.send("/app/msg/"+ to, {}, JSON.stringify(message));
    })

    $('.emo-cancel').on('click', function() {
        $('.emo-chat').hide('slide', 300);
    })


    $('.fa-smile').on('click', function() {
        $.emoticonChange();
        $('#emoModal').modal('show');
    })

    $('#emoKind > li').on('click' ,function() {
        $('#emoKind > li').removeClass("active");
        $(this).addClass('active');
        $.emoticonChange();
    })

    $('.emo-paging > i').on('click', function() {
        $('.emo-paging > i').removeClass("active");
        $(this).addClass("active");
        $.emoticonChange();
    })
</script>
</body>
</html>
