<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>Footer</title>
<link rel="stylesheet" href="${contextPath}/resources/css/footer.css" />
</head>
<body>
<div class="footer-spacer"></div>

<footer>
  <div class="footer-container">
    <div class="footer1">
      <p><b>(주) Touring</b></p>
      <p><b>팀장</b> | 정주혜</p>
      <p><b>팀원</b> | 김선희 윤영빈 이동현 임창혁 전기형 전민규 정원서</p>
      <p><b>주소</b> | 경상북도 경산시 진량읍 대구대로 201 (투어링)</p>
    </div>

    <div class="footer2">
      <p><a href="${pageContext.request.contextPath}/inquiry"><b>고객센터</b></a></p>
    </div>

  </div>

  <div>
    &copy; 2025 Daegu University project, Group 1
  </div>
</footer>



</body>
</html>
