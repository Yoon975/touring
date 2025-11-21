<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/loginErr.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<div class="container">
<h1>아이디 혹은 비밀번호가 일치하지 않습니다.</h1>
	<form action="<c:url value='/user/loginOk'/>" method="post">
	아이디	: <input type="text" name="id" placeholder="아이디를 입력해주세요"><br>
	비밀번호	: <input type="password" name="pw" placeholder="비밀번호를 입력해주세요"><br>
	<input type="submit" value="로그인">
	</form>
</div>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>
