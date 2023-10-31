
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
<form:form modelAttribute="user" reset="false">
    <div class="title">Sign Up</div>

    <label for="" id="top-label">아이디</label> <!-- id -->
    <input class="input-field" type="text" name="id" id="id" placeholder="5~12 자리의 영문" value="<c:out value='${user.id}'/>"> <!-- shuffle int and String for 8~12 length -->
    <div id="msg" class="msg">
        <form:errors path="id" cssClass="error" element="div"/>
        <hr>
        <br>
    </div>

    <label for="">비밀번호</label>  <!-- pwd -->
    <input class="input-field" type="text" name="pwd" id="pwd" placeholder="8~20자리의 영대소문자와 숫자 조합" value="<c:out value='${user.pwd}'/>"> <!-- shuffle int and String for 8~12 length-->
    <div id="msg" class="msg">
        <form:errors path="pwd" cssClass="error" element="div"/>
        <hr>
        <br>
    </div>
    <br>
    <label for="">이름</label> <!-- name -->
    <input class="input-field" type="text" name="name" id="name" placeholder="홍길동" value="<c:out value='${user.name}'/>">
    <div id="msg" class="msg">
        <form:errors path="name" cssClass="error" element="div"/>
        <hr>
        <br>
    </div>

    <label for="">이메일</label> <!-- email -->
    <input class="input-field" type="text" name="email" id="email" placeholder="example@fastcampus.co.kr" value="<c:out value='${user.email}'/>">
    <div id="msg" class="msg">
        <form:errors path="email" cssClass="error" element="div"/>
        <hr>
        <br>
    </div>

    <label for="">생일</label> <!-- birth day -->
    <input class="input-field" type="text" name="birth" id="birth" placeholder="20201203" value="<c:out value='${user.birth}'/>" onkeyup="formatDate(this)" >
    <div id="msg" class="msg">
        <form:errors path="birth" cssClass="error" element="div"/>
        <hr>
        <br>
    </div>

    <div class="sns-chk">
        <span><input type="checkbox" name="sns" value="facebook"/>페이스북</span> <!-- facebook -->
        <span><input type="checkbox" name="sns" value="kakaotalk"/>카카오톡</span> <!-- kakao -->
        <span><input type="checkbox" name="sns" value="instagram"/>인스타그램</span> <!-- instargram -->
    </div>

    <br>

    <button class="sign-btn">회원가입</button> <!-- sign up -->
</form:form>

<script>

    let dateInit = '';

        //birth의 입력값이 무조건 yyyy-MM-dd 의 형식으로 맞춰주기 위한 함수
    function formatDate(input) {
        // 입력값에서 하이픈(-) 제외
        var value = input.value.replace(/-/g, '');

        // 날짜 형식이 "yyyyMMdd"이고 숫자로만 구성되어 있는지 확인
        if (/^\d{8}$/.test(value)) {
            // "yyyyMMdd"를 "yyyy-MM-dd" 형식으로 변경
            var formattedDate = value.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            input.value = formattedDate;

            dateInit = formattedDate;
            alert(dateInit + ' : format');

            setInitialValue('birth');
            return false;
        }
    }


    //필드 값 리셋 방지
    <%--var idValue = '<c:out value="${user.id}"/>';--%>
    <%--document.getElementById("id").value = idValue;--%>

    // function formatDateToISODateString(inputValue) {
    //     var date = new Date(inputValue);
    //     alert(date);
    //     if (!isNaN(date.getTime())) {
    //         alert(date.toISOString().slice(0, 10));
    //         return date.toISOString().slice(0, 10); // "yyyy-MM-dd" 형식으로 변환
    //     }
    //     return '';
    // }

    function setInitialValue(fieldName) {
        var element = document.getElementById(fieldName);
        var initialValue = element.getAttribute('value');

        if (fieldName === 'birth') {
            alert(dateInit + ' birth');

            var date =  new Date(dateInit);
            alert(date + ' : dateInit to Date')
            if (!isNaN(date.getTime())) {
                var year = date.getFullYear();
                        alert(year+ ' : birth year');
                        var month = (date.getMonth() + 1).toString().padStart(2, '0');
                        alert(month+ ' : birth month');
                        var day = date.getDate().toString().padStart(2, '0');
                        alert(day+ ' : birth day');
                        const d = year + '-' + month + '-' + day;
                        alert(d + 'if');
                        element.value(d);
            }
            //     element.value = (String)dateInit; // "yyyy-MM-dd" 형식으로 설정


        } else {
            element.value = initialValue;
        }

        // if (fieldName === 'birth') {
        //     // 원본 날짜를 "yyyy-MM-dd" 형식으로 변환
        //     var date = new Date(initialValue);
        //     alert(initialValue + ' : birth if');
        //
        //     if (!isNaN(date.getTime())) {
        //         var year = date.getFullYear();
        //         alert(year+ ' : birth year');
        //         var month = (date.getMonth() + 1).toString().padStart(2, '0');
        //         alert(month+ ' : birth month');
        //         var day = date.getDate().toString().padStart(2, '0');
        //         alert(day+ ' : birth day');
        //         element.value = year + '-' + month + '-' + day;
        //         alert(element.value + 'if');
        //     }
        //
        // } else {
        //     element.value = initialValue;
        // }
    }
    // function setInitialDate(fieldName) {
    //     var element = document.getElementById(fieldName);
    //     var initialValue = element.getAttribute('data-value'); // 사용자 입력값의 초기값을 가져오는 속성 이름을 data-value로 가정
    //     if (fieldName === 'birth') {
    //         // birth 필드의 초기 값을 "yyyy-MM-dd" 형식으로 변환
    //         element.value = initialValue;
    //     } else {
    //         element.value = initialValue;
    //     }
    // }


    // 함수 호출
    setInitialValue('id'); // 예시: id 필드의 초기 값을 가져와 설정
    setInitialValue('pwd');
    setInitialValue('name');
    setInitialValue('email');

    // btn에서 onclick="formCheck(this.form)" 를 적용할 경우 작동됨 (error message를 출력하기 위한 코드 : userValidator 과 겹치므로 주석
    <%--function formCheck(frm) {--%>
    <%--    let msg ='';--%>

    <%--    if(frm.id.value.length<3) {--%>
    <%--        setMessage('id의 길이는 3이상이어야 합니다.', frm.id); //must have 3 more length--%>
    <%--        return false;--%>
    <%--    }--%>

    <%--    return true;--%>
    <%--}--%>

    <%--function setMessage(msg, element){--%>
    <%--    document.getElementById("msg").innerHTML = `<i class="fa fa-exclamation-circle"> ${'${msg}'}</i>`;--%>

    <%--    if(element) {--%>
    <%--        element.select();--%>
    <%--    }--%>
    <%--}--%>

</script>
</body>


</html>