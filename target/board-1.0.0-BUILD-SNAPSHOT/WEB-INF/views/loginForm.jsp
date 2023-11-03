<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<c:set var="loginId" value="${pageContext.request.getSession(false) == null ? '' : pageContext.request.getSession.getAttribute('id')}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'LogOut'}"/>
<c:set var="myPorSign" value="Sign in"/>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Bulletine Board Basic</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
	<link rel="stylesheet" href="<c:url value='/css/login.css'/>">

</head>
<body>
<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>
<form action="<c:url value="/login/login"/>" method="post" onsubmit="return formCheck(this);">
	<h3 id="title">Login</h3>
	<div id="msg">
		<c:if test="${not empty param.msg}">
			<i class="fa fa-exclamation-circle"> ${URLDecoder.decode(param.msg)}</i>
		</c:if>
	</div>
	<div class="leftside">
	<input type="text" name="id" value="${cookie.id.value}" placeholder="아이디 입력" autofocus> <!-- enter email -->
	<input type="password" name="pwd" placeholder="비밀번호"> <!-- pwd -->
	<input type="hidden" name="toURL" value="${param.toURL}"><label class="remember-btn"><input type="checkbox" name="rememberId" value="on" ${empty cookie.id.value ? "":"checked"}> 아이디 기억</label> <!-- remember id -->

	<button class="login-button">로그인</button>
	<br>
		<a href="" id="ll">비밀번호 찾기</a> <!-- find pwd -->
		<a href="" >회원가입</a> <!-- sign up -->
	</div>
	<script>
		function formCheck(frm) {
			let msg ='';
			if(frm.id.value.length==0) {
				setMessage('id를 입력해주세요.', frm.id); // enter id
				return false;
			}
			if(frm.pwd.value.length==0) {
				setMessage('password를 입력해주세요.', frm.pwd); //enter pwd
				return false;
			}
			return true;
		}
		function setMessage(msg, element){
			document.getElementById("msg").innerHTML = ` ${'${msg}'}`;
			if(element) {
				element.select();
			}
		}
	</script>
</form>
</body>
</html>