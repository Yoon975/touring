<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/insertUser.css' />">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<div class="container">
<h2>회원가입</h2>
<form id="signupForm" action="<c:url value='/user/insertOk'/>" method="post">
    <!-- 아이디 + 중복 체크 -->
    <div class="id-check-group">
		* 아이디 : <input type="text" name="id" id="id" maxlength="20">
        <input type="button" value="중복체크" onclick="checkId()">
    </div>
    <p id="idCheckResult"></p>
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	공백 없이 5~20자 이내 영문 소문자, 숫자와 특수기호(-,_) 사용 가능<br></p>
	
    * 비밀번호: <input type="password" name="pw" id="pw">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	공백 없이 5~20자 이내 영문, 숫자, 특수문자 사용 가능<br></p>
    * 비밀번호 확인: <input type="password" id="pw2">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	비밀번호를 한 번 더 입력해주세요.<br></p>
    
    * 이름 : <input type="text" name="name" id="name">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	한글, 영문, 숫자만 입력 가능 (특수기호 사용불가)<br></p>
	
    * 이메일 : <input type="text" name="email" id="email">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	ex) user@example.com 형식으로 입력<br></p>
	
    * 전화번호 : <input type="text" name="phone" id="phone">
	<p class="small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	숫자만 입력 가능 (- 제외)<br></p>

    <!-- 버튼 영역 -->
    <div class="form-buttons">
        <input type="submit" value="가입하기">
        <input type="reset" value="다시작성">
    </div>
</form>
</div>

<script>
  let isIdChecked = false;

  // ID 중복 체크
function checkId() {
  const inputId = document.getElementById("id").value.trim();
  const resultText = document.getElementById("idCheckResult");

  if (inputId === "") {
    resultText.textContent = "아이디를 입력하세요.";
    resultText.style.color = "red";
    isIdChecked = false;
    return;
  }

  fetch("/touring/user/id-check?id=" + encodeURIComponent(inputId))
    .then(response => {
      if (!response.ok) {
        throw new Error("네트워크 응답이 정상적이지 않습니다: " + response.status);
      }
      return response.text();  // JSON 대신 text로 받음
    })
    .then(text => {
      // 응답이 "exists=true" 또는 "exists=false" 형식임을 가정
      console.log("서버 응답 텍스트:", text);
      const exists = text.split('=')[1] === 'true';

      if (exists) {
        resultText.textContent = "이미 사용 중인 아이디입니다.";
        resultText.style.color = "red";
        isIdChecked = false;
      } else {
        resultText.textContent = "사용 가능한 아이디입니다.";
        resultText.style.color = "green";
        isIdChecked = true;
      }
    })
    .catch(error => {
      console.error("오류:", error);
      resultText.textContent = "서버 오류가 발생했습니다.";
      resultText.style.color = "red";
      isIdChecked = false;
    });
}

  // 유효성 검사
  document.getElementById("signupForm").addEventListener("submit", function (e) {
    const id = document.getElementById("id").value.trim();
    const pw = document.getElementById("pw").value.trim();
    const pw2 = document.getElementById("pw2").value.trim();
    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const phone = document.getElementById("phone").value.trim();

    const idRegex = /^[a-z0-9-_]+$/;
    const nameRegex = /^[가-힣a-zA-Z0-9]+$/;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const phoneRegex = /^[0-9]+$/;
    
    if (id.includes(" ") || pw.includes(" ")) {
        alert("아이디와 비밀번호에는 공백을 포함할 수 없습니다.");
        e.preventDefault();
        return;
    }

    if (!id || !pw || !name || !email || !phone) {
      alert("모든 항목을 입력해주세요.");
      e.preventDefault();
      return;
    }

    if (id.length < 5) {
      alert("아이디는 5자 이상이어야 합니다.");
      e.preventDefault();
      return;
    }

    if (!idRegex.test(id)) {
        alert("아이디는 영문, 숫자, 특수기호(-,_)만 사용할 수 있습니다.");
        e.preventDefault();
        return;
    }
    
    if (pw.length < 5 || pw.length > 20) {
        alert("비밀번호는 5~20자 이내여야 합니다.");
        e.preventDefault();
        return;
    }

    if (pw !== pw2) {
        alert("비밀번호가 일치하지 않습니다.");
        e.preventDefault();
        return;
    }
    
    if (!nameRegex.test(name)) {
    	  alert("이름은 한글, 영문, 숫자만 입력할 수 있습니다.");
    	  e.preventDefault();
    	  return;
   	}
    
    if (!emailRegex.test(email)) {
      alert("올바른 이메일 형식을 입력해주세요. 예: user@example.com");
      e.preventDefault();
      return;
    }

    if (!phoneRegex.test(phone)) {
      alert("전화번호는 숫자만 입력해야 합니다.");
      e.preventDefault();
      return;
    }

    // ✅ 중복 체크 확인 여부 검사
    if (!isIdChecked) {
      alert("아이디 중복 체크를 먼저 해주세요.");
      e.preventDefault();
      return;
    }
    
    // 확인 창
    if (!confirm("가입하시겠습니까?")) {
        e.preventDefault();
        return;
    }

    alert("가입되었습니다!");
  });
</script>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>