<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Bulletine Board Basic</title>
<%--  <link rel="stylesheet" href="<c:url value='/css/menu.css'/>">--%>
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
        <%--      <div id="t" class="head-title"><h4>게시판 ${mode=="new" ? "글쓰기" : "읽기"}</h4></div>--%>

        <input name="title" type="text" class="title-input" value="${boardDto.title}" placeholder="  제목을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}><br>

        <div id="contents-d">
          <span><i class="bi bi-person"></i> ${boardDto.writer}</span>
          <span><i class="bi bi-calendar-check"></i> <fmt:formatDate value="${boardDto.reg_date}" pattern="yyyy-MM-dd" type="date"/></span>
        </div>
        <div class="right-side">
          <span><i class="bi bi-arrow-clockwise"></i> <fmt:formatDate value="${boardDto.up_date}" pattern="yyyy-MM-dd" type="date"/></span>
          <span><i class="bi bi-eye"></i> ${boardDto.view_cnt}</span>
          <span><i class="bi bi-chat-left-text"></i> ${boardDto.comment_cnt}</span>
        </div>
      </div> <!-- title area -->

      <br>
      <hr id="line"> <!-- ---------------------------------------------- -->

      <input type="hidden" name="bno" value="${boardDto.bno}">
                                                                          <%-- please enter the title --%>
    <textarea class="text-area" name="content" rows="20" placeholder=" 내용을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}>${boardDto.content}</textarea><br>
                                                                <%-- please enter the content --%>
<%--    <div class="btn-group">--%>
        <c:if test="${mode eq 'new'}">
          <button type="button" id="writeBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 등록</button>  <!-- ok -->
        </c:if>

<%--        <c:if test="${mode ne 'new'}">--%>
<%--          <button type="button" id="writeNewBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 글쓰기</button> <!-- post -->--%>
<%--        </c:if>--%>

        <c:if test="${boardDto.writer eq loginId}">
          <button type="button" id="modifyBtn" class="btn btn-modify"><i class="fa fa-edit"></i> 수정</button> <!-- modify -->
          <button type="button" id="removeBtn" class="btn btn-remove"><i class="fa fa-trash"></i> 삭제</button> <!-- remove -->
        </c:if>
        <button type="button" id="listBtn" class="btn btn-list"><i class="fa fa-bars"></i> 목록</button> <!-- list -->
<%--    </div>--%>
        <br>
  </form>

<hr id="line"> <%-- ------------------------------Comments-------------------------------- --%>



<div class="comment">
    <div class="comment-wset">
        <div id="c-username"><span><i class="bi bi-chat-left-dots"></i> ${boardDto.writer}</span></div>
        <div class="input-group">
            <span class="input-group-text">댓글 쓰기</span>
            <textarea class="form-control" aria-label="With textarea" id="text-comment-area" rows="3" placeholder="내용을 입력하세요."></textarea>
            <button class="btn btn-outline-secondary" type="button" id="commentSendBtn">등록</button>
        </div>
    </div>
</div>
<hr>

<div class="comment">

    <div id="commentList"></div>

</div>
<br>

<%--    <div class="comment-rset" >--%>
<%--        <div id="c-username">너구리</div>--%>
<%--        <div><p>너구리 답글 내용</p></div>--%>
<%--        <div>--%>
<%--            <p class="btns-l">2023.09.09</p>--%>
<%--            <p><a class="btns-l" id="write-comment-btn">답글 달기</a></p>--%>
<%--        </div>--%>
<%--        <br>--%>
<%--    </div>--%>

<%--    <div class="comment-reply" >--%>
<%--        <div id="c-username"><i class="bi bi-reply"></i> 여우</div>--%>
<%--        <div><p>여우 답글 내용 </p></div>--%>
<%--        <div>--%>
<%--            <p class="btns-l">2023.09.15</p>--%>
<%--            <p><a class="btns-l">삭제</a></p>--%>
<%--        </div>--%>
<%--        <br>--%>
<%--    </div>--%>



<%-- -------------------------------------------------------------------------------------------------------------------------- --%>

<script>
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
      if(formCheck())
        form.submit();
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
  });

</script>

<%-- ------------------------------Comments-------------------------------- --%>

<script>
    let bno = 6;

    // 댓글 가져오기 함수
    let showList = function (bno, page) {
        $.ajax({
            type:'GET',       // 요청 메서드
            url: '/comments?bno' + bno,  // 요청 url
            dataType : 'json', // 전송받을 데이터의 타입, 생략해도 됨: 기본이 json
            success : function(result) {
                // result가 오면 commentList에 담기
                // 댓글목록 가져온 것을 commmentList에 담게 됨
                // 들어오는 배열을 toHtml이라는 함수를 이용해서 <li>태그로 만든다음 그것을 commentList에 넣는다.
                $("#commentList").html(toHtml);
            },
            error : function(){ alert("error from showList") } // 에러가 발생했을 때, 호출될 함수
        }); // $.ajax()

    }

    // document 시작
    $(document).ready(function(){
        showList(bno);

        $("commentSendBtn").click(function() {
            let comment = $("text-comment-area").val();

            if(comment.trim() == '') {
                alert("댓글을 입력해주세요");
                $("text-comment-area").focus();
                return;
            }

            // 쓰기
            $.ajax({
                type: 'POST',
                url: '/comments?bno=' + bno,
                headers: {"content-type" : "application/json"},
                data : JSON.stringify({bno:bno, comment:comment}),
                success : function (result) {
                    alert(result);
                    showList(bno); //  쓰기가 성공했을 때 보여 줄 리스트
                },
                error : function () {alert("error from post-comment")}
            });
        });

        // $(".delBtn").click(function () {
        $("#commentList").on("click", ".delBtn", function () {
            // li가 버튼의 부모
            let cno = $(this).parent().attr("data-cno");
            let bno = $(this).parent().attr("data-bno");

            $.ajax({
                type: 'DELETE',
                <%--url :'<c:url value="/comments/"/>',--%>
                url: '/comments/' + cno + '?bno=' + bno,
                success : function (result) {
                    alert(result)
                    // 삭제된 다음에 새로 갱신되어야 함
                    showList(bno);
                }
            });
        });


        let toHtml = function (comments) {
            var tmp = "<div class='comment-rset'>";

            // 댓글 하나하나 들고와서 tmp에 쌓는다.
            comments.forEach(function (comment) {
                tmp += '<p data-cno=' + comment.cno
                tmp += ' data-pcno=' + comment.pcno
                tmp += ' data-bno=' + comment.bno + '/p>'

                // span태그에 넣어야 나중에 작성자만 따로 읽어오기 쉽다.
                tmp += '<div id="c-username" class="commenter"><i class="bi bi-reply"></i>' + comment.commenter + '</div>'
                tmp += '<div class="comment"><p>' + comment.comment + '</p></div>'
                tmp += '<div><p class="btns-l">' + comment.up_date + '</p>'
                tmp += '<p><a class="btns-l" id="write-comment-btn"> 답글달기 </a></p>'
                tmp += '<br>'
            })

        return tmp + "</div>"; // div html로 반환한다.
        }

    })

</script>

</body>
</html>