<%--
  Created by IntelliJ IDEA.
  User: unipoint
  Date: 2023-11-03
  Time: 오전 9:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false" %>
<%--<c:set var="loginId" value="${sessionScope.id}"/>--%>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'LogOut'}"/>

<c:set var="myPorSign" value="${loginOut=='LogOut'? 'My Page' : 'Sign in'}"/>
<c:set var="mypageLink" value="${myPorSign=='My Page'?'/mypage' : '/register/add'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bulletine Board Basic</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
        <link rel="stylesheet" href="<c:url value='/css/mypage.css'/>">
    </head>
    <body>

        <!-- Navigation Bar Include -->
        <%@include file="navbar.jsp"%>

        <div id="all-items">
            <h3 class="title"> My Page </h3>

            <div class="card">
                <div class="card-header">
                    User Inform
                </div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item"><label>ID</label> <span>${user.id}</span> </li>
                    <li class="list-group-item"><label>PWD</label> <span>${user.pwd}</span>
                            <button class="btn btn-outline-warning"> 비밀번호 변경</button>
                    </li>
                    <li class="list-group-item"><label>Name</label> <span>${user.name}</span> </li>
                    <li class="list-group-item"><label>Email</label> <span>${user.email}</span> </li>
                    <li class="list-group-item"><label>Birth</label> <span><fmt:formatDate value="${user.birth}" pattern="HH:mm" type="time"/></span> </li>
                    <li class="list-group-item"><label>SNS</label> <span>${user.sns}</span> </li>
                </ul>
            </div>
            <div>
                <button> 회원 탈퇴 </button>
            </div>
        </div>
    </body>
</html>
