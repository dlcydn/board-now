<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>
<%--<c:set var="loginId" value="${pageContext.request.getSession(false) == null ? '' : pageContext.request.getSession.getAttribute('id')}"/>--%>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'LogOut'}"/>
<c:set var="myPorSign" value="Sign in"/>
<c:set var="mypageLink" value="${myPorSign=='My Page'?'/mypage' : '/register/add'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bulletine Board Basic</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
    <link rel="stylesheet" href="<c:url value='/css/login.css'/>">

    <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.4.0/kakao.min.js"
            integrity="sha384-mXVrIX2T/Kszp6Z0aEWaA8Nm7J6/ZeWXbL8UpGRjKwWe56Srd/iyNmWMBhcItAjH" crossorigin="anonymous"></script>
    <script>
        Kakao.init('1d7069328a9f9638d7947c5764687f06'); // 사용하려는 앱의 JavaScript 키 입력
        Kakao.isInitialized();
    </script>
</head>
<body>
<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>
<form action="<c:url value="/login/login"/>" method="post" name="login_frm" id="loginForm" onsubmit="return formCheck(this);">
    <h3 id="title">Login</h3>
    <div id="msg">
        <c:if test="${not empty param.msg}">
            <i class="fa fa-exclamation-circle"> ${param.msg}</i>
        </c:if>
    </div>
    <div class="leftside">
        <input type="text" name="id" value="${cookie.id.value}" placeholder="아이디 입력" autofocus> <!-- enter email -->
        <input type="password" name="pwd" placeholder="비밀번호"> <!-- pwd -->
        <input type="hidden" name="toURL" value="${param.toURL}"><label class="remember-btn"><input type="checkbox" name="rememberId" value="on" ${empty cookie.id.value ? "":"checked"}> 아이디 기억</label> <!-- remember id -->

        <button class="login-button">로그인</button>
        <div class="kakaoBtn">
            <input type="hidden" name="kakaoemail" id="kakaoemail"/>
            <a href="javascript:kakaoLogin()">
                <img src="/img/kakao_login_medium.png"/>
            </a>
        </div>
        <%--	<br>--%>
        <%--		<a href="" id="ll">비밀번호 찾기</a> <!-- find pwd -->--%>
        <%--		<a href="" >회원가입</a> <!-- sign up -->--%>
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

<%--    ============ kakao Login ============= --%>
    <script type="text/javascript">

        //인증 코드 요청
        function kakaoLogin() {
            Kakao.Auth.authorize({
                redirectUri: 'http://localhost:80/login/kakao'
            });
        }
        //kakao btn activated

        $(document).ready(function() {
            //할당받은 토큰을 설정
            var ACCESS_TOKEN= "${accessToken}";
            Kakao.Auth.setAccessToken(ACCESS_TOKEN);
            // console.log(Kakao.Auth.getAccessToken());
        });

        var kakao_message = new Object();

        //카카오 회원 정보를 가져오기
        Kakao.API.request({
            url: '/v2/user/me',
        })
            .then(function(res) {
                // alert(JSON.stringify(res));
                console.log(JSON.stringify(res));

                kakao_message['id'] = res.id;
                kakao_message['email'] = res.kakao_account.email;
                kakao_message['nickname'] = res.kakao_account.profile.nickname;

                $.ajax({
                    type: 'POST',
                    url: '/login/kakaoConnect',
                    contentType: 'application/json',
                    data: JSON.stringify(kakao_message),
                    success: function (response) {
                        alert(response);
                        window.location.href = "/board/list";
                    },
                    error: function (error) {
                        alert("kakao login failed.");
                        console.log(error);
                    }
                })
            })
            .catch(function(err) {
                alert(
                    // 'failed to request user information: ' + JSON.stringify(err) +
                    "retry please"
                );
            });
    </script>

</form>
</body>
</html>