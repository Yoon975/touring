<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 수정</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/reviewUpdate.css' />">
    
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<h2>리뷰 수정하기</h2>
<form action="<c:url value='/review/updateOk' />" method="post"
	onsubmit="if (!confirm('리뷰를 수정하시겠습니까?')) return false; alert('리뷰가 수정되었습니다!');">
<input type="hidden" name="rno" value="${review.rno}" />
<input type="hidden" name="dno" value="${review.dno}" />

<table border="1">
    <tr>
        <th>숙소명</th>
        <td>
            ${review.hname}
        </td>
    </tr>
    <tr>
        <th>내용</th>
        <td>
            <textarea name="content" rows="5" cols="50">${review.content}</textarea>
        </td>
    </tr>
    <tr>
        <th>평점</th>
        <td>
            <select name="rating">
                <option value="1" ${review.rating == 1 ? 'selected' : ''}>1점</option>
                <option value="2" ${review.rating == 2 ? 'selected' : ''}>2점</option>
                <option value="3" ${review.rating == 3 ? 'selected' : ''}>3점</option>
                <option value="4" ${review.rating == 4 ? 'selected' : ''}>4점</option>
                <option value="5" ${review.rating == 5 ? 'selected' : ''}>5점</option>
            </select>
        </td>
    </tr>
    <tr>
        <th>작성일</th>
        <td>${review.createdAt}</td>
    </tr>
</table>

<br>
<input type="submit" value="수정하기">
<input type="button" value="뒤로가기" onclick="history.back();">
</form>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
