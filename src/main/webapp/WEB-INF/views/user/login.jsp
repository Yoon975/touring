<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="<c:url value='/resources/css/login.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<div class="container">
    <h2>로그인</h2>
    <p class="sub-text">touring 계정으로 로그인하여 서비스를 이용하실 수 있습니다.</p>

    <form action="<c:url value='/user/loginOk'/>" method="post" class="login-form">
        <label for="id">아이디</label>
        <input type="text" id="id" name="id" placeholder="아이디를 입력해주세요" required>

        <label for="pw">비밀번호</label>
        <input type="password" id="pw" name="pw" placeholder="비밀번호를 입력해주세요" required>

        <input type="submit" value="로그인" class="btn-login">
    </form>
</div>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
