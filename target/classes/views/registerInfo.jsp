<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginId" value="${pageContext.request.getSession(false) == null ? '' : pageContext.request.getSession.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <style>
        .title{
            text-align: center;
        }
        .inform{
            border: 1px solid #FC79A5;
            color: #3C2925;
        }

    </style>
</head>
<body>
<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>

<div class="title">
    <h1> Welcome </h1>
    <h5> Thank you for sign up</h5>
</div>
<div class="inform">
    <h3>id : ${user.id}</h3>
    <h3>pwd : ${user.pwd}</h3>
    <h3>name : ${user.name}</h3>
    <h3>email : ${user.email}</h3>
    <h3>birth : ${user.birth}</h3>
    <h3>sns : ${user.sns}</h3>
</div>

</body>
</html>