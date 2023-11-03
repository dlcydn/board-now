<%--
  Created by IntelliJ IDEA.
  User: unipoint
  Date: 2023-11-03
  Time: 오전 9:36
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginId" value="${pageContext.request.getSession(false) == null ? '' : pageContext.request.getSession.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>
<c:set var="mypageLink" value="${loginOut=='LogOut'?'/register/add' : '/mypage/userInfo'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>
<c:set var="myPorSign" value="${loginOut=='LogOut'? 'My Page' : 'Sign in'}"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bulletine Board Basic</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
</head>
<body>

<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>

<div>
    <h5> My Page </h5>
    <div class="card" style="width: 18rem;">
        <div class="card-header">
            User Inform
        </div>
        <ul class="list-group list-group-flush">
            <li class="list-group-item"><label>ID</label> ididid</li>
            <li class="list-group-item">PWD <a href="#" class="btn btn-outline-warning">Go somewhere</a></li>
            <li class="list-group-item">Name</li>
            <li class="list-group-item">Email</li>
            <li class="list-group-item">Birth</li>
            <li class="list-group-item">SNS</li>
        </ul>
    </div>



</div>




</body>
</html>
