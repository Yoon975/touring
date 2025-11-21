<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/reviewInsert.css' />">
    
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
    <h2>리뷰 작성</h2>
    <form action="<c:url value='/review/insertOk' />" method="post"
    	onsubmit="if (!confirm('리뷰를 등록하시겠습니까?')) return false; alert('리뷰가 등록되었습니다!');">
        <input type="hidden" name="dno" value="${param.dno}" />
        <label>내용: </label><br>
        <textarea name="content" rows="5" cols="50" maxlength="100" placeholder="100자까지 입력 가능합니다."></textarea><br>
        <label>평점:</label>
        <select name="rating">
            <option value="1">1점</option>
            <option value="2">2점</option>
            <option value="3">3점</option>
            <option value="4">4점</option>
            <option value="5">5점</option>
        </select><br><br>
        <input type="submit" value="리뷰 등록">
		<input type="button" value="뒤로가기" onclick="history.back();">
    </form>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>
