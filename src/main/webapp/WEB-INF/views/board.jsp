<%@ page import="com.unipoint.board.domain.BoardDto" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'LogOut'}"/>
<c:set var="mypageLink" value="${loginOut=='LogOut'?'/register/add' : 'mypage/info'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>
<c:set var="myPorSign" value="${loginOut=='LogOut'? 'My Page' : 'Sign in'}"/>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bulletine Board Basic</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/post.css'/>">

</head>
<body>
<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>

<script>
    let msg = "${msg}";
    if(msg=="WRT_ERR") alert("게시물 등록에 실패하였습니다. 다시 시도해 주세요."); //error occured to save the post. pls retry
    if(msg=="MOD_ERR") alert("게시물 수정에 실패하였습니다. 다시 시도해 주세요."); //error occured to modify the post. pls retry
</script>

<form id="form" class="frm" action="" method="post">

    <div class="container">
        <div>
            <input name="title" type="text" class="title-input" value="${boardDto.title}" placeholder="  제목을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}><br>
            <c:choose>
                <c:when test="${mode eq 'new'}"></c:when>
                <c:otherwise>
                    <div id="contents-d">
                        <span><i class="bi bi-person"></i> ${boardDto.writer}</span>
                        <span><i class="bi bi-calendar-check"></i> <fmt:formatDate value="${boardDto.reg_date}" pattern="yyyy-MM-dd" type="date"/></span>
                    </div>
                    <div class="right-side">
<%--                        <span><i class="bi bi-arrow-clockwise"></i>${boardDto.up_date}</span>--%>
                        <span><i class="bi bi-arrow-clockwise"></i> <fmt:formatDate value="${boardDto.up_date}" pattern="yyyy-MM-dd" type="date"/></span>
                        <span><i class="bi bi-eye"></i> ${boardDto.view_cnt}</span>
                        <span><i class="bi bi-chat-left-text"></i> ${boardDto.comment_cnt}</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div> <!-- title area -->

        <br>
        <hr id="line"> <!-- ---------------------------------------------- -->

        <input type="hidden" name="bno" value="${boardDto.bno}">
        <textarea class="text-area" name="content" rows="20" placeholder=" 내용을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}>${boardDto.content}</textarea><br>
        <c:if test="${mode eq 'new'}">
        <button type="button" id="writeBtn" class="btn btn-outline-info btn-sm"><i class="fa fa-pencil"></i> 등록</button>  <!-- ok -->
        </c:if>

        <c:if test="${boardDto.writer eq loginId}">
        <button type="button" id="modifyBtn" class="btn btn-outline-warning btn-sm"><i class="fa fa-edit"></i> 수정</button> <!-- modify -->
        <button type="button" id="removeBtn" class="btn btn-outline-danger btn-sm"><i class="fa fa-trash"></i> 삭제</button> <!-- remove -->
        </c:if>
        <button type="button" id="listBtn" class="btn btn-outline-secondary btn-sm"><i class="fa fa-bars"></i> 목록</button> <!-- list -->
    </div>
    <br>
</form>

 <%-- ------------------------------Comments-------------------------------- --%>


<%-- 댓글 입력 창 구간 --%>
<div class="container">
    <hr id="line">
    <div class="comment">
        <div class="comment-wset">
            <div class="c-username"><span><i class="bi bi-chat-left-dots"></i></span><span class="commenter-area">${loginId}</span></div>
            <div class="input-group">
                <span class="input-group-text">댓글 쓰기</span>
                <textarea class="form-control" aria-label="With textarea" id="text-comment-area" name="commentArea" placeholder="내용을 입력하세요."></textarea>
                <button class="btn btn-outline-info btn-sm" type="button" id="commentSendBtn">등록</button>
            </div>
        </div>
    </div>
    <hr>

    <%-- 댓글 표시 구간 --%>
        <div id="commentList"></div>

<%--    댓글 수정 입력창 표시 구간 --%>
    <div id ="modifyText" style="display : none">
        <textarea name="modifyContent" class="appearText" rows="2"></textarea>
        <br>
        <button id="modConfirmBtn" type="button" class="btn btn-outline-info btn-sm">수정 등록</button>
        <button id="cancle-comment" class="btn btn-outline-danger btn-sm" type="button">취소</button>
        <br>
        <hr>
        <br>
    </div>

    <%-- 답글 등록 및 표시 구간 --%>
    <div id="replyForm" style="display: none">
        <hr>
        <div class="comment-reply" >
            <div class="c-username"><span><i class="bi bi-chat-left-dots"></i></span><span class="commenter-area">${loginId}</span></div>
            <div><textarea type="text" name="replyText" class="appearText"></textarea></div>

            <div class="appearBtn">  <%-- button div --%>
                <buttton id="replyConfirmBtn" type="button" class="btn btn-outline-info btn-sm">답글 등록</buttton>
                <button id="cancle-reply" class="btn btn-outline-danger btn-sm" rows="2">취소</button>
                <br>
            </div>
        </div>
    </div>
<%--    <br>--%>
</div>



<%-- -------------------------------------------------------------------------------------------------------------------------- --%>

<script>
    //가능하면 하나 안에 전부 작성!
    //document ready는 처음 화면 띄울 때 함수 전부 가지고 오므로 전체에서 한번만 사용하거나
    //script 전체에서 변수명으로 함수 선언해서 사용 하는 식으로 해야함.

    let bno = "${boardDto.bno}";

    let showList = function (bno) {

        $.ajax({
            type:'GET',       // 요청 메서드
            url: '/comments?bno='+bno,  // 요청 url
            dataType : 'json', // 전송받을 데이터의 타입, 생략해도 됨: 기본이 json
            success : function(result) {
                // result가 오면 commentList에 담기
                // 댓글목록 가져온 것을 commmentList에 담게 됨
                // 들어오는 배열을 toHtml이라는 함수를 이용해서 태그 만든 다음 commentList에 넣는다.
                $("#commentList").html(toHtml(result, "${loginId}"));
            },
            error : function(){
                // alert(bno + " : showList bno");
                alert(bno + " : showList Bno");
                // alert(cbno);
                alert("error from showList");
            } // 에러가 발생했을 때, 호출될 함수
        }); // $.ajax()
    } //showList

    //댓글 부분 띄워주기 위한 내용
    let toHtml = function (comments, loginId) {
        var tmp = "<br><div class='comment-rset'>";

        // 댓글 하나하나 들고와서 tmp에 쌓는다.
        comments.forEach(function (comment) {
            tmp += '<div data-cno=' + comment.cno
            tmp += ' data-pcno=' + comment.pcno
            tmp += ' data-bno=' + comment.bno
            tmp += '>'

            if(comment.cno != comment.pcno) { //댓글의 답글일 경우
                tmp += '<div class="c-username" class="commenter"><i class="bi bi-reply" style="padding-left: 100px;"></i> ' + comment.commenter
                tmp += '<p class="date">' + formatDateString(comment.up_date) + '</p></div>'
                tmp += '<div class="comment" id="textComment" style="display: block; padding-left: 150px;"><span id="commentContents" class="comments">'
                    + comment.comment + '</span></div>'

                if (loginId === comment.commenter) {
                    tmp += '<button type="button" id="delCommentBtn" class="btn btn-outline-danger btn-sm" >삭제</button>'
                }
                tmp += '<button type="button" id="wriReplyBtn" class="btn btn-outline-info btn-sm"> 답글달기 </button><br>'
                tmp += '</div>' //each
                tmp += '<hr>'
                tmp += '<br>'

            } else { //일반 댓글
                // span태그에 넣어야 나중에 작성자만 따로 읽어오기 쉽다.
                tmp += '<div class="c-username" class="commenter"><i class="bi bi-reply"></i> ' + comment.commenter
                tmp += '<p class="date">' + formatDateString(comment.up_date) + '</p>'
                tmp += '</div>' //commenter div

                tmp += '<div class="comment" id="textComment" ><span id="commentContents" class="comments" style="display: block">'
                    + comment.comment + '</span></div>'


                if (loginId === comment.commenter) {
                    tmp += '<button type="button" id="delCommentBtn" class="btn btn-outline-danger btn-sm">삭제</button>'
                    tmp += '<button type="button" id="modCommentBtn" class="btn btn-outline-warning btn-sm">수정</button>'
                }

                tmp += '<button type="button" id="wriReplyBtn" class="btn btn-outline-info btn-sm" > 답글달기 </button>'
                tmp += '<br></div>' //each
                tmp += '<div id="wtf"></div>'
                tmp += '<hr>'
                // tmp += '<div id="wtf"></div>'

                tmp += '<br>'
            }

        }); //each
        tmp += '</div>' //comment all set
        tmp += '<br>'
        return tmp; // div html로 반환한다.
    } //toHtml

    //댓글 및 답글의 날짜 표시 형식 조정
    function formatDateString (dataString) {
        const date = new Date(dataString);
        const year = date.getFullYear();
        const month = String(date.getMonth()+1).padStart(2,'0');
        const day = String(date.getDate()).padStart(2,'0');
        let all = year + "-" + month + "-" + day;
        return all;
    }

    $(document).ready(function(){

        let formCheck = function() {
            let form = document.getElementById("form");
            if(form.title.value=="") {
                alert("제목을 입력해 주세요."); //enter the title
                form.title.focus();
                return false;
            }

            if(form.content.value=="") {
                alert("내용을 입력해 주세요."); //enter the content
                form.content.focus();
                return false;
            }
            return true;
        }

        $("#writeNewBtn").on("click", function(){
            alert("new write btn!");
            location.href="<c:url value='/board/write'/>";
        });

        $("#writeBtn").on("click", function(){
            let form = $("#form");
            form.attr("action", "<c:url value='/board/write'/>");
            form.attr("method", "post");

            if(formCheck())
                form.submit();
        });

        $("#modifyBtn").on("click", function(){
            let form = $("#form");
            let isReadonly = $("input[name=title]").attr('readonly');

            // 1. 읽기 상태이면, 수정 상태로 변경 // 1. if read mode, then turn to modify
            if(isReadonly=='readonly') {
                $(".writing-header").html("게시판 수정");
                $("input[name=title]").attr('readonly', false);
                $("textarea").attr('readonly', false);
                $("#modifyBtn").html("<i class='fa fa-pencil'></i> 등록");
                return;
            }

            // 2. 수정 상태이면, 수정된 내용을 서버로 전송 // 2. if the modify mode, then send the content to server
            form.attr("action", "<c:url value='/board/modify${searchCondition.queryString}'/>");
            form.attr("method", "post");
            if(formCheck()) {
                form.submit();
            }
        });

        $("#removeBtn").on("click", function(){
            if(!confirm("정말로 삭제하시겠습니까?")) return; //delete this post?

            let form = $("#form");
            form.attr("action", "<c:url value='/board/remove${searchCondition.queryString}'/>");
            form.attr("method", "post");
            form.submit();
        });

        $("#listBtn").on("click", function(){
            location.href="<c:url value='/board/list${searchCondition.queryString}'/>";
        });


        // ------------------------------------------------------------------------------------------------------------
        // -------------------------------------------------- comments ------------------------------------------------
        // ------------------------------------------------------------------------------------------------------------

        showList(bno);

        // 수정 등록 버튼
        $("#modConfirmBtn").on("click", function() {
            let cno = $(this).attr("data-cno");
            let comment = $("textarea[name=modifyContent]").val();

            if(comment.trim()==''){
                alert("댓글을 입력하세요");
                $("textarea[name=modifyContent]").focus();
                return;
            }

            $.ajax({
                type:'PATCH',       // 요청 메서드
                url: '/comments/'+cno,  // 요청 URI
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({cno:cno, comment:comment}),// 서버로 전송할 데이터. stringify()로 직렬화 필요.
                success : function(result){
                    alert(result);
                    showList(bno);
                },
                error   : function(){
                    alert(cno + ' : cno ajax');
                    alert(comment + ': comment ajax');
                    alert("error from modify");
                } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()

            //수정내용을 등록한 이후
            $("#modifyText").css("display", "none"); //disappear
            $("textarea[name=modifyContent]").val('');
            $("#commentContents").css("display","block");
            $("#modifyText").appendTo("body"); //back

        }); //modify btn

        // 수정 버튼
        $("#commentList").on("click", "#modCommentBtn", function () {

            let cno = $(this).parent().attr("data-cno");
            let bno = $(this).parent().attr("data-bno");
            let comment = $("span.comments", $(this).parent()).text();

            //수정 이전 창을 표시
            $("#modifyText").appendTo($("div.comment", $(this).parent())); //come
            // $("#modifyText").appendTo($(this).find("#commentContents").parent()); //come

            // $("#commentContents").css("display","none");
            $("span#commentContents", $(this).parent()).css("display", "none");
            $("#modifyText").css("display", "block"); //appear

            $("textarea[name=modifyContent]").val(comment); // 1. 수정 버튼을 comment의 내용을 input태그에 뿌려주기
            $("#modConfirmBtn").attr("data-cno", cno); // 2. cno 전달하기

        }); //move cursor to modify


        // 댓글 수정 취소
        $("#cancle-comment").on("click", function (){
            $("#modifyText").css("display", "none");
            $("#modifyText").appendTo("body");
            $("span#commentContents", $(this).parent().parent()).css("display", "block");

        });

        //답글 쓰기 취소
        $("#cancle-reply").on("click", function (){
            $("#replyForm").css("display", "none");
            $("#modifyText").appendTo("body"); //back

        });

        //댓글 쓰기 insert 부분
        // alert 로 이벤트 작동하는지 확인해보는 것도 좋음.
        $("#commentSendBtn").on("click",function() {
            let comment = $("#text-comment-area").val();

            if(comment.trim() === '') {
                alert("댓글을 입력해주세요");
                $("#text-comment-area").focus();
                return;
            }

            $.ajax({
                type: 'POST',
                url: '/comments?bno='+bno,
                headers: {"content-type" : "application/json"},
                data : JSON.stringify({bno: bno, comment:comment}),
                success : function (result) {
                    alert(result);
                    showList(bno); //  쓰기가 성공했을 때 보여 줄 리스트
                },
                error : function () {
                    alert("error from post-comment");
                }
            });

            $("#text-comment-area").val('');
        }); //write comment

        // 댓글 삭제
        $("#commentList").on("click", "#delCommentBtn", function () {
            if(!confirm("정말로 삭제하시겠습니까?")) return;

            let cno = $(this).parent().attr("data-cno");
            let bno = $(this).parent().attr("data-bno");

            $.ajax({
                type: 'DELETE',
                url: '/comments/' + cno,
                data: 'bno=' + bno,
                success: function (result) {
                    alert(result);
                    showList(bno);
                },
                error : function () {
                    alert("error from delete Comment");
                }
            }); //delete comment
        });

// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------

        //답글 등록
        $("#replyConfirmBtn").on("click", function() {

            let comment = $("textarea[name=replyText]").val();
            let pcno = $(this).attr("data-pcno");

            if(comment.trim()==''){
                alert("댓글을 입력하세요");
                $("textarea[name=replyText]").focus();
                return;
            }

            $.ajax({
                type:'POST',       // 요청 메서드
                url: '/comments?bno=' +bno,  // 요청 URI
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({pcno:pcno, bno:bno, comment:comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                success : function(result){
                    alert(result);
                    showList(bno);
                },
                error   : function(){
                    alert("error from reply");
                } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()

            //내용 지우고 원래 자리로
            $("#replyForm").css("display", "none");
            $("textarea[name=replyText]").val('');
            $("#replyForm").appendTo("body");

        });

        // 답글 입력 창 표시
        $("#commentList").on("click", "#wriReplyBtn", function(){
            let pcno = $(this).parent().attr("data-pcno");

            // 1. replyForm을 댓글 아래위치에 옮기고
            $("#replyForm").appendTo($(this).parent());
            // 2. 답글을 입력할 폼을 보여준다.
            $("#replyForm").css("display", "block");
            $("#replyConfirmBtn").attr("data-pcno", pcno);

        });

    }); //document ready

</script>

</body>
</html>