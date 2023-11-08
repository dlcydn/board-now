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

<%-- session을 통해서 id를 controller와 주고 받을 수 있게 설정 --%>
<%-- To. controller : Login id : From. jsp --%>
<%@ page session="false" %>
<c:set var="loginId" value="${pageContext.request.getSession(false)==null ? '' : pageContext.request.session.getAttribute('id')}"/>

<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'LogOut'}"/>

<c:set var="myPorSign" value="${loginOut=='LogOut'? 'My Page' : 'Sign in'}"/>
<c:set var="mypageLink" value="${myPorSign=='My Page'?'/mypage' : '/register/add'}"/>  <%-- login 상태라면 mypage를 보여주고 아니면 sign up으로 연결 --%>

<fmt:formatDate var="reg" value="${user.reg_date}" pattern="yyyy-MM-dd" type="date"/>
<%-- 꼭 c:set 으로 시작하지 않더라도 위 처럼 var 옵션 주면 변수 지정 가능함. reg_date에서 date 형식 문제 발생x  --%>

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

<%--        기본 회원 정보 표시 창 화면  --%>
            <h3 class="title"> My Page </h3>

            <div class="card"  id="inform">
                <%--                <img src="..." class="card-img-top" alt="...">--%>
                <div class="card-body">
                    <h5 class="card-title">${user.id}님</h5>
                    <p id="reg-text" class="card-text">가입 하신 날짜는 ${reg} 입니다. </p>
                </div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item"> <label>ID</label> <span>${user.id}</span></li>
                    <li class="list-group-item"> <label>Password</label> <span>${user.pwd}</span></li>
                    <li class="list-group-item"> <label>Name</label> <span >${user.name}</span></li>
                    <li class="list-group-item"> <label>Email</label> <span >${user.email}</span></li>
                    <li class="list-group-item"> <label>Birth Day</label> <span ><fmt:formatDate value="${user.birth}" pattern="yyyy-MM-dd" type="date"/></span></li>
                    <li class="list-group-item"> <label>SNS</label> <span >${user.sns}</span></li>
                </ul>
                <div class="card-body">
                    <button type="button" class="btn btn-outline-warning" onclick="modifyUser()" > 회원 정보 수정</button>
                    <button type="button" class="btn btn-outline-danger" onclick="deleteUser()"> 회원 탈퇴 </button>
                </div>
            </div>


<%--        수정 내용 입력 창 화면  --%>
            <div class="card" id="modify" style="display : none">
                <%--                <img src="..." class="card-img-top" alt="...">--%>
                <div class="card-body">
                    <h5 class="card-title">회원 정보 수정</h5>
                    <p class="card-text"> id와 생년월일은 변경 불가합니다. </p>
                    <p id="msg" class="msg"></p>
                </div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item"> <label>ID</label> <input id="id" type="text" value="${user.id}" readonly></li>
                    <li class="list-group-item"> <label>Password</label> <input id="pwd" type="password" value="${user.pwd}" required></li>
                    <li class="list-group-item"> <label>Name</label> <input id="name" type="text" value="${user.name}" required></li>
                    <li class="list-group-item"> <label>Email</label> <input id="email" type="text" value="${user.email}" required></li>
                    <li class="list-group-item"> <label>Birth Day</label>
                        <input id="birth" type="text"
                               value="<fmt:formatDate value="${user.birth}" pattern="yyyy-MM-dd" type="date"/>" readonly>
                    </li>
                    <li class="list-group-item"> <label>SNS</label>
                        <span><input type="radio" name="sns" value="facebook"/>페이스북</span> <!-- facebook -->
                        <span><input type="radio" name="sns" value="kakaotalk"/>카카오톡</span> <!-- kakao -->
                        <span><input type="radio" name="sns" value="instagram"/>인스타그램</span> <!-- instargram -->
                        <span><input type="radio" name="sns" value="twitter"/>트위터</span> <!-- twitter -->
                    </li>
                </ul>
                <div class="card-body">
                    <button type="button" class="btn btn-outline-warning" id="updateBtn" onclick="validatePassword()" > 확인 </button>
                    <button type="button" class="btn btn-outline-danger" onclick="cancelModify()"> 취소 </button>
                </div>
            </div>

        </div> <!-- all container -->
    </body>

    <script>

        //수정 화면으로 전환
        function modifyUser() {
            // 모든 span 태그를 가져와서 input 태그로 바꾸고, 버튼 텍스트를 변경합니다.

            var userSnsValue = "${user.sns}";
            selectSnsRadioButton(userSnsValue);

            $("#inform").css("display","none");
            $("#modify").css("display","block");
        }

        //수정 취소
        function cancelModify() {
            // 현재의 input 태그를 다시 span 태그로 변경합니다.
            $("#inform").css("display", "block");
            $("#modify").css("display", "none");
            location.reload(); //취소 시 원래 설정한 value로 초기화 + 성공 후 화면 reload
        }

        //비밀번호 형식 확인 ? update 함수 호출 : setMessage 함수 호출
        function validatePassword() {

            var password = document.getElementById("pwd").value;
            var regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

            // 비밀번호 길이 검사
            if (password.length < 8 || password.length > 30) {
                setMessage('비밀번호는 8자 이상 30자 이하이어야 합니다.', document.getElementById("pwd"));
                return false;
            }

            if (!regex.test(password)) {
                setMessage('비밀번호는 알파벳과 숫자 조합이어야 합니다.', document.getElementById("pwd"));
                return false;
            }

            updateUser();
            return true;
        }

        function setMessage(msg, element) {
            document.getElementById("msg").innerHTML = '<i class="fa fa-exclamation-circle"></i> ' + msg ;

            if (element) {
                element.select();
            }
        }

        //회원 정보 수정
        function updateUser() {
            // 사용자가 입력한 값을 가져와서 User 객체에 할당
            var user = {
                id : "${user.id}",
                pwd: document.getElementById("pwd").value,
                name: document.getElementById("name").value,
                email: document.getElementById("email").value,
                birth: document.getElementById("birth").value,
                sns: document.querySelector('input[name="sns"]:checked').value,
                reg_date: "${reg}"
                //userDao 의 updateUser가 user 객체를 받아오므로, user의 모든 요소가 있어야함.
                //User 클래스로 아예 변환하는건 아니라서 수정하는 요소에 자료형이나 형식을 여기서 맞춰줘야함.
                //date는 형식 문제가 있음로 id 처럼 바로 받아올 수 없음.
                // -> id와 birth 는 수정 불가로 하여 readonly 설정 후 받아오면 되지만
                //reg_date는 input을 사용하지 않고 추가하더라도 display:none 하면 값을 못가져오므로, format 한 값을 변수에 저장해놓고 받아옴.
            };


            // updateUser 함수 호출
            $.ajax({
                type: "POST",
                url: "/updateUser", // updateUser 함수를 호출할 서버 엔드포인트
                data: JSON.stringify(user), // User 객체를 JSON으로 변환하여 전송
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    if (data === "success") {
                        alert("회원 정보가 성공적으로 수정되었습니다.");
                        cancelModify(); //원래 회원 정보 표시 화면으로 돌리고 값 반영한 화면으로 reload
                    } else {
                        alert("회원 정보 수정 중 오류가 발생했습니다.");
                    }
                }
            });
        }

        //회원의 sns 정보(Text)와 일치하는 value를 가진 radio 버튼을 선택 (from.inform - to.modify)
        function selectSnsRadioButton(snsValue) {
            var snsOptions = document.getElementsByName("sns");
            for (var i = 0; i < snsOptions.length; i++) { //radio버튼 돌면서 값을 확인
                if (snsOptions[i].value === snsValue) {
                    snsOptions[i].checked = true;
                    break; //찾으면 끝 (radio는 복수선택이 안돼서 가능하지만 checkbox로 할 경우 변경 必)
                }
            }
        }

        //회원 탈퇴
        function deleteUser() {
            if (confirm("정말로 회원 탈퇴하시겠습니까?")) {
                $.ajax({
                    type: "POST",
                    url: "/deleteUser",
                    success: function (data) {
                        if (data === "success") {
                            alert("회원 탈퇴가 완료되었습니다.");

                            // 로그아웃 처리 -> log out URL로 리다이렉트
                            window.location.href = "/login/logout";
                        } else {
                            alert(data);
                            alert("회원 탈퇴 중 오류가 발생했습니다.");
                        }
                    }
                }); //ajax
            } //if
        } //delete user

    // ------------------------------------------------------------------------
    </script>

</html>
