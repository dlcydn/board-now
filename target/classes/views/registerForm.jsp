
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginId" value="${pageContext.request.getSession(false) == null ? '' : pageContext.request.getSession.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>

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
<form:form modelAttribute="user">
    <div class="title">Sign Up</div>
    <div id="msg" class="msg"><form:errors path="id"/></div>
    <label for="" id="top-label">아이디</label> <!-- id -->
    <input class="input-field" type="text" name="id" placeholder="8~12자리의 영대소문자와 숫자 조합"> <!-- shuffle int and String for 8~12 length -->
    <label for="">비밀번호</label>  <!-- pwd -->
    <input class="input-field" type="text" name="pwd" placeholder="8~12자리의 영대소문자와 숫자 조합"> <!-- shuffle int and String for 8~12 length-->
    <label for="">이름</label> <!-- name -->
    <input class="input-field" type="text" name="name" placeholder="홍길동">
    <label for="">이메일</label> <!-- email -->
    <input class="input-field" type="text" name="email" placeholder="example@fastcampus.co.kr">
    <label for="">생일</label> <!-- birth day -->
    <input class="input-field" type="text" name="birth" placeholder="2020-12-31">
    <div class="sns-chk">
        <span><input type="checkbox" name="sns" value="facebook"/>페이스북</span> <!-- facebook -->
        <span><input type="checkbox" name="sns" value="kakaotalk"/>카카오톡</span> <!-- kakao -->
        <span><input type="checkbox" name="sns" value="instagram"/>인스타그램</span> <!-- instargram -->
    </div>
    <button class="sign-btn">회원가입</button> <!-- sign up -->
</form:form>
<script>
    function formCheck(frm) {
        let msg ='';

        if(frm.id.value.length<3) {
            setMessage('id의 길이는 3이상이어야 합니다.', frm.id); //must have 3 more length
            return false;
        }

        return true;
    }

    function setMessage(msg, element){
        document.getElementById("msg").innerHTML = `<i class="fa fa-exclamation-circle"> ${'${msg}'}</i>`;

        if(element) {
            element.select();
        }
    }
</script>
</body>
</html>