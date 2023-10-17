<%--
  Created by IntelliJ IDEA.
  User: unipoint
  Date: 2023-10-17
  Time: 오전 11:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>
<html>
<head>
    <title>Title</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
  <link rel="stylesheet" href="<c:url value='/css/comment.css'/>">
</head>
<body>

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

<div class="comment" id="commentList"> </div>

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

<script>
  let bno = 6;

  // 댓글 가져오기 함수
  let showList = function (bno) {
    $.ajax({
      type:'GET',       // 요청 메서드
      url: '/comments',
      // url: '/comments?bno=' + bno,  // 요청 url
      dataType : 'json', // 전송받을 데이터의 타입, 생략해도 됨: 기본이 json
      success : function(result) {
        // result가 오면 commentList에 담기
        // 댓글목록 가져온 것을 commmentList에 담게 됨
        // 들어오는 배열을 toHtml이라는 함수를 이용해서 <li>태그로 만든다음 그것을 commentList에 넣는다.
        $("#commentList").html(toHtml(result));
      },
      error   : function(){ alert("error from showList") } // 에러가 발생했을 때, 호출될 함수
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
        data : JSON.stringify({bno:bno, comment:comment}), // 전송할 데이터를 JSON으로!
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
      let tmp = "<div class='comment-rset'>";

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

    // $("#commentList").on("click", ".modBtn", function () {
    //     let cno = $(this).parent().attr("data-cno");
    //     let comment = $("span.comment", $(this).parent()).text();
    //
    //     //1. comment의 내용을 input에 뿌려주기
    //     $("text-comment-area").val(comment);
    //     //2. cno 번호를 전달하기
    //     $("#modBtn").attr("data-cno", cno);
    //
    // })
    //
    // $("#modBtn").click(function() {
    //     let comment = $("input[name=comment]").val();
    //     let cno = $(this).attr("data-cno");
    //
    //     if(comment.trim() == '') {
    //         alert("댓글을 입력해주세요");
    //         $("input[name=comment]").focus();
    //         return;
    //     }
    //
    //     // 쓰기
    //     $.ajax({
    //         type: 'PATCH',
    //         url: '/comments/' + cno,
    //         headers: {"content-type" : "application/json"},
    //         data : JSON.stringify({cno:cno, comment:comment}), // 전송할 데이터를 JSON으로!
    //         success : function (result) {
    //             alert(result);
    //             showList(bno); //  수정이 성공했을 때 보여줄꺼임
    //         },
    //         error : function () {alert("error from write comment")}
    //     });
    // });
  })

</script>


</body>
</html>
