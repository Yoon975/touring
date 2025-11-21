<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/updateUser.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<div class="container">
<form id="updateForm" action="<c:url value='/user/updateOk'/>" method="post">

<input type="hidden" name="uno" value="${loginSession.uno}">
<input type="hidden" name="admin" value="${loginSession.admin}">
<input type="hidden" name="regdate" value="${loginSession.regdate}">
<input type="hidden" name="pw" value="${loginSession.pw}">
<input type="hidden" name="id" value="${loginSession.id}">
  아이디 : ${loginSession.id }<br><br><br><br>
  이름 : <input type="text" name="name" id="name" value="${loginSession.name}">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	한글, 영문, 숫자만 입력 가능 (특수기호 사용불가)<br></p>
	
  이메일 : <input type="text" name="email" id="email" value="${loginSession.email}">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	ex) user@example.com 형식으로 입력<br></p>
	
  전화번호 : <input type="text" name="phone" id="phone" value="${loginSession.phone}">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	숫자만 입력 가능 (- 제외)<br></p>
<div class="button-group">
  <input type="submit" value="수정하기">
  <input type="reset" value="다시작성">
  <a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
</div>
</form>
</div>

<script>
  document.getElementById("updateForm").addEventListener("submit", function (e) {
    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const phone = document.getElementById("phone").value.trim();

    // 정규표현식
    const nameRegex = /^[가-힣a-zA-Z0-9]+$/;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const phoneRegex = /^[0-9]+$/;

    // 공백 체크
    if (!name || !email || !phone) {
      alert("모든 항목을 입력해주세요.");
      e.preventDefault();
      return;
    }

    if (!nameRegex.test(name)) {
  	  alert("이름은 한글, 영문, 숫자만 입력할 수 있습니다.");
  	  e.preventDefault();
  	  return;
 	}
    
    // 이메일 형식 검사
    if (!emailRegex.test(email)) {
      alert("올바른 이메일 형식을 입력해주세요. 예: user@example.com");
      e.preventDefault();
      return;
    }

    // 전화번호 숫자만 허용
    if (!phoneRegex.test(phone)) {
      alert("전화번호는 숫자만 입력해야 합니다.");
      e.preventDefault();
      return;
    }
    
    if (!confirm("수정하시겠습니까?")) {
        e.preventDefault();
        return;
    }

    alert("수정되었습니다!");
  });
</script>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>