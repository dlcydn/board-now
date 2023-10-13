<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID:'+=loginId}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Bulletine Board Basic</title>
<%--  <link rel="stylesheet" href="<c:url value='/css/menu.css'/>">--%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
  <link rel="stylesheet" href="<c:url value='/css/boardList.css'/>">

</head>
<body>
<!-- Navigation Bar Include -->
<%@include file="navbar.jsp"%>
<script>
  let msg = "${msg}";
  if(msg=="LIST_ERR")  alert("게시물 목록을 가져오는데 실패했습니다. 다시 시도해 주세요."); //load list failed
  if(msg=="READ_ERR")  alert("삭제되었거나 없는 게시물입니다."); //don't exist or deleted
  if(msg=="DEL_ERR")   alert("삭제되었거나 없는 게시물입니다."); //don't exist or deleted

  if(msg=="DEL_OK")    alert("성공적으로 삭제되었습니다."); //removed successfully
  if(msg=="WRT_OK")    alert("성공적으로 등록되었습니다."); //registered successfully
  if(msg=="MOD_OK")    alert("성공적으로 수정되었습니다."); //modified successfully
</script>

<div style="text-align:center">
  <div class="page-title-area">
    <h1> Board List </h1>
  </div>
  <div class="board-container">

    <div class="search-container">
      <form action="<c:url value="/board/list"/>" class="search-form" method="get">
        <select class="search-option" name="option">
          <option value="A" ${ph.sc.option=='A' || ph.sc.option=='' ? "selected" : ""}>제목+내용</option> <!--title + content -->
          <option value="T" ${ph.sc.option=='T' ? "selected" : ""}>제목</option> <!-- only title -->
          <option value="W" ${ph.sc.option=='W' ? "selected" : ""}>작성자</option> <!-- writer -->
        </select>

        <input type="text" name="keyword" class="search-input" type="text" value="${ph.sc.keyword}" placeholder="검색어를 입력해주세요"> <!-- enter the search keyword -->
        <input type="submit" class="search-button" value="검색"> <!-- search -->
      </form>
    </div>
    <!-- search -->

    <table class="table table-hover">
      <thead>
        <tr>
          <th class="no">번호</th> <!-- number -->
          <th class="title">제목</th> <!-- title -->
          <th class="writer">이름</th> <!-- name -->
          <th class="regdate">등록일</th> <!-- register date -->
          <th class="viewcnt">조회수</th> <!-- view count -->
        </tr>
      </thead>
      <c:forEach var="boardDto" items="${list}" varStatus="status">
        <tr>
<%--          <td class="no">${boardDto.bno}</td>--%>
          <td class="no"> ${status.count} </td>
          <td class="title"><a href="<c:url value="/board/read${ph.sc.queryString}&bno=${boardDto.bno}"/>">${boardDto.title}</a></td>
          <td class="writer">${boardDto.writer}</td>
          <c:choose>
            <c:when test="${boardDto.reg_date.time >= startOfToday}">
              <td class="regdate"><fmt:formatDate value="${boardDto.reg_date}" pattern="HH:mm" type="time"/></td>
            </c:when>
            <c:otherwise>
              <td class="regdate"><fmt:formatDate value="${boardDto.reg_date}" pattern="yyyy-MM-dd" type="date"/></td>
            </c:otherwise>
          </c:choose>
          <td class="viewcnt">${boardDto.view_cnt}</td>
        </tr>
      </c:forEach>
    </table>
    <button id="writeBtn" class="btn-write" onclick="location.href='<c:url value="/board/write"/>'"><i class="fa fa-pencil"></i> 글쓰기</button> <!-- write -->

    <br>
    <div class="paging-container">
      <div class="paging">
        <c:if test="${totalCnt==null || totalCnt==0}">
          <div> 게시물이 없습니다. </div> <!-- noting exist -->
        </c:if>
        <c:if test="${totalCnt!=null && totalCnt!=0}">
          <c:if test="${ph.showPrev}">
            <a class="page" href="<c:url value="/board/list${ph.sc.getQueryString(ph.beginPage-1)}"/>">&lt;</a>
          </c:if>
          <c:forEach var="i" begin="${ph.beginPage}" end="${ph.endPage}">
            <a class="page ${i==ph.sc.page? "paging-active" : ""}" href="<c:url value="/board/list${ph.sc.getQueryString(i)}"/>">${i}</a>
          </c:forEach>
          <c:if test="${ph.showNext}">
            <a class="page" href="<c:url value="/board/list${ph.sc.getQueryString(ph.endPage+1)}"/>">&gt;</a>
          </c:if>
        </c:if>
      </div>
    </div>
  </div>
</div>
</body>
</html>