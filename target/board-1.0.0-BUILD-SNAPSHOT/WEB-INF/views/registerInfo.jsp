<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="Login"/>
<c:set var="myPorSign" value="Sign in"/>
<c:set var="mypageLink" value="${myPorSign=='My Page'?'/mypage' : '/register/add'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <style>
        .title{
            text-align: center;
            margin : 10% 0 5% 0;
        }
        .inform{
            text-align: center;
            padding : 0 0 10% 0;
        }

    </style>
</head>
<body>
<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>

<div class="title">
    <h1> Welcome </h1>
</div>
<div class="inform">
    <h3>${user.id}</h3><br>
    <h5> Thank you for sign up</h5>
</div>

</body>

<script>

    // let birth = '';
    //
    // function birthDay(fieldName) {
    //     var element = document.getElementById(fieldName);
    //     var date = new Date(element.value);
    //
    //     if(!isNaN(date.getTime())) {
    //         var year = date.getFullYear();
    //         var month = (date.getMonth() + 1).toString().padStart(2, '0');
    //         var day = date.getDate().toString().padStart(2, '0');
    //         const d = year + '-' + month + '-' + day;
    //         birth = d;
    //     }
    //
    // }

</script>


</html>