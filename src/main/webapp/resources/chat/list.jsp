<%--
  Created by IntelliJ IDEA.
  User: jinwoo
  Date: 2015-03-17
  Time: 오후 9:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <style>
        .list-detail {
            padding: 12px;
            border: 1px solid lightgrey;
            position: relative;
            width: 100%;
            height: 70px;
        }
    </style>
</head>
<body>
<div class="list-detail hide">
    <input type="hidden" id="to" name="to" value="">
    <input type="hidden" id="name" name="name" value="">
    <input type="hidden" id="room" name="room" value="">
    <span class="pull-left"><img class="user-view" src=""></span>
    <span class="pull-left">
        <div class="list-name" style="padding-bottom:10px;font-weight:bold;"></div>
        <div class="list-content"></div>
    </span>
    <span class="pull-right">
        <div class="list-date" style="padding-bottom:10px;">
        </div>
        <div class="list-flag hide" style="float:right;width:22px;height:22px;background-color:orangered; text-align:center;color:white;border-radius: 50%">
        </div>
    </span>
</div>
<script>
    $.listSet = function() {
        $.ajax({
            url:'/listInit',
            dataType:'json',
            async:false,
            type:'post',
            success:function(data) {
                $('.chat-body').find('.list-detail:not(.hide)').empty();
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
                })
            }, error:function(xhr, status, error) {
                alert(error);
            }
        })
    }

    $(document).ready(function() {
        $.listSet();

        $('.list-detail').on('click', function() {
            var to = $(this).find('#to').val();
            var name = $(this).find('#name').val();
            var room = $(this).find('#room').val();
            $('.chat-body').load("/resources/chat/chat.jsp", {"to":to, "name":name});
        })
    })

</script>
</body>
</html>
