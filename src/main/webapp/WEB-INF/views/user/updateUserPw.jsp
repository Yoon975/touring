<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<link rel="stylesheet" href="<c:url value='/resources/css/updateUserPw.css'/>">
</head>
<body>
<script src="<c:url value='/resources/js/updateUserPw.js'/>"></script>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<div class="container">
  <form id="updateForm" action="<c:url value='/user/updatePwOk'/>" method="post">
    아이디 : <input type="text" name="id" id="userId" value="${loginSession.id}" readonly><br>

    현재 비밀번호 :
    <input type="password" id="pw1">
    <button type="button" id="checkPwBtn">확인</button>
    <span id="pwCheckResult"></span><br><br>

    <div id="newPwFields" style="display: none;">
      새비밀번호 : <input type="password" id="pw2" name="pw2">
      <p class="small">공백 없이 5~20자 이내 영문, 숫자, 특수문자 사용 가능</p>
      새비밀번호 확인 : <input type="password" id="pw3">
      <p class="small">비밀번호를 한 번 더 입력해주세요.</p>
      
      <div class="btn-area">
        <input type="submit" value="변경하기">
        <input type="button" value="뒤로가기" onclick="history.back()">
      </div>
    </div>

    <div id="onlyBackBtn">
      <input type="button" value="뒤로가기" onclick="history.back()">
    </div>
  </form>
</div>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>
