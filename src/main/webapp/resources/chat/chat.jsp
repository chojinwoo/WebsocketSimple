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
<sec:authentication property="principal.name" var="name"/>
<html>
<head>
    <title>Simple Web Chatting</title>
    <style>

        .file-btn {
            position: absolute;
            font-size: 30px;
            left: 3px;
            cursor:pointer;
        }

        .emo-btn {
            position: absolute;
            font-size: 30px;
            right: 53px;
            z-index: 2;
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
<style>
    .chat-detail > div {
        padding:12px
    }

    #toChat .content {
        background-color: #a5d8c7;
        padding: 5px;
        max-width: 70%;
    }

    #toChat .date {
        padding-left:15px;
        font-size:12px;
    }

    #fromChat .content {
        background-color: #a5d8c7;
        padding: 5px;
        max-width: 70%;
    }

    #fromChat .date {
        padding-right:15px;
        font-size:10px;
    }

    #fromChat .emoticon {
        text-align: right;
    }
</style>
<input type="hidden" id="room" name="room">
<div id="toChat" class="chat-detail hide">
    <div class="pull-left" style="  width: 40px;">
        <img src="/resources/img/face.png" style="width:40px;border-radius: 50%">
    </div>
    <div class="pull-left" style="margin-left:10px;width:95%;">
        <div>1</div>
        <div class="emoticon"></div>
        <div class="pull-left content"></div>
        <div class="pull-left date"></div>
    </div>
</div>
<div id="fromChat" class="chat-detail hide">
    <div class="pull-right" style="width:100%;">
        <div class="emoticon"></div>
        <div class="pull-right content"></div>
        <div class="pull-right date"></div>
    </div>
</div>
<div id="input" style="position:fixed; bottom: 0px;">
    <div class="emo-chat">
        <img src="">
        <span class="glyphicon glyphicon-remove-sign emo-cancel"></span>
    </div>
    <div class="input-group" style="background-color:#F0F0F0;height:42px;padding:4px 0px 4px 32px;">
        <span class="file-btn" aria-hidden="true"><i class="fa fa-plus"></i></span>
        <input type="text" id="msg" class="form-control" style="padding-right: 35px;">
        <span class="emo-btn" aria-hidden="true"><i class="fa fa-smile-o fa-smile"></i></span>
        <span class="input-group-addon btn btn-default send-btn">전송</span>
    </div>
</div>
<script>
    $(document).ready(function() {
        $.ajax({
            url:'/chatInit',
            dataType:'json',
            type:'post',
            data:'to=${param.get("to")}',
            success:function(data) {
                for(var i=0; i<data.length; i++) {
                    $.receive(data[i]);
                }
                $.listSet();
            }, error:function(xhr, status, error) {
                alert(error);
            }
        })
    })

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

    $.msgSend = function() {
        var msg = $('#msg').val();
        $('#msg').val('');
        var to = "${param.get("to")}";
        var name = "${param.get("name")}"
        var emoticon = $('.emo-chat > img').attr('src');
        var room = $('#room').val();
        var message = {"from":'${email}', "fromName":'${name}', 'to':[{'email':to, 'name':name}], 'msg':msg , 'room':room,'emoticon':emoticon};
        stomp.send("/app/msg", {}, JSON.stringify(message));
    }

    $.flagChk = function() {

    }

    $('.send-btn').on('click', function() {
        $.msgSend();
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
