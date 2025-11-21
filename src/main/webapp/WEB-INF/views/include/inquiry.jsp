<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>고객센터</title>

    <!-- 외부 CSS -->
    <link rel="stylesheet" href="${contextPath}/resources/css/header.css"/>
    <link rel="stylesheet" href="${contextPath}/resources/css/Inquiry.css"/>
</head>
<body>

<!-- 공통 헤더/네비게이션 include -->
<jsp:include page="header.jsp"/>
<jsp:include page="nav.jsp"/>

<div class="container">
  <!-- 문의 로고 -->
  <div class="inquiry-logo">
    <a href="https://discord.gg/NUb9tbBh" target="_blank">
      <img src="<c:url value='/fileData/discord.png'/>" alt="로고">
    </a>
  </div>

  <div class="contact-text">
    관리자에게 문의하려면 ▲ 이미지를 클릭해주세요.
  </div>

  <div class="qna">
    <p>자주 묻는 QnA</p>

    <div class="qna-item">
      <div class="question">📢 ID|PW를 잊으셨나요?</div>
      <div class="answer">
        현재 사이트에서는 ID|PW 찾기를 지원하지 않습니다.<br>
        관리자에게 문의를 남겨주세요.
      </div>
    </div>

    <div class="qna-item">
      <div class="question">📢 예약이 등록되지 않아요.</div>
      <div class="answer">
        일시적인 오류일 수도 있습니다.<br>
        잠시 후 새로고침하시거나 다시 시도해주세요.
      </div>
    </div>
    
    <div class="qna-item">
      <div class="question">📢 사이트 이용이 원활하지 않아요.</div>
      <div class="answer">
        브라우저 캐시를 삭제하시거나, 다른 브라우저로 접속해보세요.
      </div>
    </div>
    
    <div class="qna-item">
      <div class="question">📢 회원 탈퇴 후 다시 가입할 수 있나요?</div>
      <div class="answer">
        회원 탈퇴 시 모든 개인정보는 즉시 삭제됩니다.<br>
        단, 아이디는 중복 가입 방지를 위해 보존되므로 같은 아이디로 재가입은 불가능합니다.
      </div>
    </div>    
    
  </div>
</div>

<!-- 외부 JS -->
<script src="${contextPath}/resources/js/Inquirysc.js"></script>

<!-- 공통 푸터 include -->
<jsp:include page="footer.jsp"/>

</body>
</html>
