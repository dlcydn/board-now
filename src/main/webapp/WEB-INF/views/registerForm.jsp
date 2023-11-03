
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginId" value="${pageContext.request.getSession(false) == null ? '' : pageContext.request.getSession.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>
<c:set var="mypageLink" value="${loginOut=='LogOut'?'/register/add' : '/mypage/userInfo'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>
<c:set var="myPorSign" value="${loginOut=='LogOut'? 'Sign in' : 'My Page'}"/>


<%@ page import="java.net.URLDecoder"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
    <link rel="stylesheet" href="<c:url value='/css/register.css'/>">
    <title>Register</title>
</head>
<body>

<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>

<!-- form action="<c:url value="/register/save"/>" method="POST" onsubmit="return formCheck(this)"-->
<form:form modelAttribute="user" reset="false">
    <div class="title">Sign Up</div>
    <div id="msg" class="msg">
        <form:errors path="id" cssClass="error" element="div"/>
        <form:errors path="pwd" cssClass="error" element="div"/>
        <form:errors path="birth" cssClass="error" element="div"/>

        <hr>
        <br>
    </div>


        <label for="" id="top-label">아이디 <span class="star">*</span></label>
        <input class="input-field" type="text" name="id" id="id" placeholder="5~12 자리의 영문" required>

        <label for="" >비밀번호 <span class="star">*</span></label>  <!-- pwd -->
        <input class="input-field" type="password" name="pwd" id="pwd" placeholder="8~20자리의 영대소문자와 숫자 조합" required>

    <br>

        <label for="">이름 <span class="star">*</span></label> <!-- name -->
        <input class="input-field" type="text" name="name" id="name" placeholder="홍길동" required>

        <label for="">이메일 <span class="star">*</span></label> <!-- email -->
        <input class="input-field" type="text" name="email" id="email" placeholder="example@fastcampus.co.kr" required>

    <label for="">생일 <span class="star">*</span></label> <!-- birth day -->
    <input class="input-field" type="text" name="birth" id="birth" placeholder="20201203" onkeyup="formatDate(this)" required>


    <div class="sns-chk">
        <label for="">SNS</label><br>
        <span><input type="checkbox" name="sns" value="facebook"/>페이스북</span> <!-- facebook -->
        <span><input type="checkbox" name="sns" value="kakaotalk"/>카카오톡</span> <!-- kakao -->
        <span><input type="checkbox" name="sns" value="instagram"/>인스타그램</span> <!-- instargram -->
    </div>
    <br>

    <button class="sign-btn">회원가입</button> <!-- sign up -->
</form:form>

<script>
    //birth의 입력이 무조건 [yyyy-MM-dd] 형식으로 - 를 삽입하여 입력
    function formatDate(input) {
        // 입력값에서 하이픈(-) 제외
        var value = input.value.replace(/-/g, '');

        if (/^\d{8}$/.test(value)) {
            // "yyyyMMdd"를 "yyyy-MM-dd" 형식으로 변경
            var formattedDate = value.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            input.value = formattedDate;
        }
    }

</script>
</body>


</html>