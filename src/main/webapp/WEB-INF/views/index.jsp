<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>

<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/> <%-- login 상태면 login 메뉴를 logout으로 연결--%>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'LogOut'}"/>
<c:set var="mypageLink" value="${loginOut=='LogOut'?'/register/add' : 'mypage/info'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>
<c:set var="myPorSign" value="${loginOut=='LogOut'? 'My Page' : 'Sign in'}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bulletin Board Basic</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
    <link rel="stylesheet" href="<c:url value='/css/index.css'/>">

</head>
<body>
<!-- Navigation Bar Include -->
<%@include file="navbar.jsp" %>
<div class="all-main">
    <div class="title-area">
        <h1 class="center">Board Home</h1>
    </div>

    <div id="main-board-div">
<%--        <img src="/img/berry.jpg">--%>
    </div>
    <div class="center">
        <ul class="index-ul">
            <li class="index-li">
                <div class="c-div1">
                    <h1><a href="<c:url value='/board/list'/>"><i class="bi bi-clipboard-heart-fill" id="icon-color"></i></a></h1>
                    <h5>Board</h5>
                </div>
            </li>
            <li class="index-li">
                <div class="c-div2">
                    <h1><a href="<c:url value='/login/login'/>"><i class="bi bi-box-arrow-in-right" id="icon-color"></i></a></h1>
                    <h5>Log In</h5>
                </div>
            </li>
            <li class="index-li">
                <div class="c-div3">
                    <h1><a href="<c:url value='/register/add'/>"><i class="bi bi-person-check" id="icon-color"></i></a></h1>
                    <h5>Sign In</h5>
                </div>
            </li>
        </ul>
    </div>

</div>


</body>
</html>