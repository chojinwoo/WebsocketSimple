<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jinwoo
  Date: 2015-03-15
  Time: 오후 4:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<sec:authentication property="principal.email" var="email"/>
<sec:authentication property="principal.name" var="name"/>
<html>
<head>
    <title></title>
    <style>
        .chat-body > div > span, #chat-form > div > span {
            margin: 6px 12px 6px 12px;
        }

        .chat-body > .group {
            padding:5px 0px 5px 0px;
        }

        .user-view {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }

        .chat-body > .list, #chat-form > .list {
            border: 1px solid lightgrey;
            line-height: 56px;
            height: 56px;
            width: 100%;
        }

        .chat-icon {
            font-size: 30px;
            margin-top: 6px;
        }
    </style>
</head>
<body>
<div class="list hide">
    <input type="hidden" id="to" name="to" value="">
    <span><img class="user-view" src=""></span>
    <span></span>
    <span class="pull-right" style="height: 80%;"><i class="fa fa-weixin chat-icon"></i></span>
</div>
<div class="group"><span>나</span></div>
<div class="list">
    <span><img class="user-view" src="/resources/img/face.png"></span>
    <span>${name}</span>
</div>
<div class="group"><span>친구</span></div>
<script>
    $(document).ready(function() {
        $.ajax({
            url:'/user',
            dataType:'json',
            async:false,
            type:'post',
            success:function(data) {
                $.each(data.json, function() {
                    var clone = $('.chat-body .list:first').clone();
                    clone.removeClass('hide')
                    clone.find('input').val(this.email);
                    clone.find('span:first .user-view').attr('src', '/resources/img/face.png');
                    clone.find('span:eq(1)').text(this.name);
                    $('#room').val(this.room);
                    $('.chat-body').append(clone);
                })
            }, error:function(xhr, status, error) {
                alert(error);
            }
        })

        $('.chat-icon').on('click', function() {
            var to = $(this).closest('div').find('#to').val();
            var name = $(this).closest('div').find('span:eq(1)').text();
            $('.chat-header .fa').removeClass('active');
            $('.chat-body').load("/resources/chat/chat.jsp", {"to":to, "name":name});
        })

    })
</script>
</body>
</html>
