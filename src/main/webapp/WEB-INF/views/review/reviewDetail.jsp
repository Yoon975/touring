<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/reviewDetail.css' />">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<h2>리뷰 상세보기</h2>
<table border="1">
	<tr>
		<th>예약번호</th>
		<td><a href="${pageContext.request.contextPath}/reserve/detail?dno=${review.dno}">${review.dno}</a></td>
	</tr>
    <tr>
        <th>숙소명</th>
		<td><a href="${pageContext.request.contextPath}/hotelUser/detailHotelUser?hno=${review.hno}">${review.hname}</a></td>
    </tr>
    <tr>
        <th>내용</th>
        <td>${review.content}</td>
    </tr>
    <tr>
        <th>평점</th>
        <td>${review.rating}점</td>
    </tr>
    <tr>
        <th>작성일</th>
        <td>${review.createdAt}</td>
    </tr>
</table>
<br>
<c:choose>
    <c:when test="${review.canUpdateReview}">
        <input type="button" value="수정하기"
               onclick="location.href='<c:url value='/review/update?rno=${review.rno}' />'">
    </c:when>
    <c:otherwise>
        <input type="button" value="수정 불가" onclick="alert('체크아웃 이후 7일이 지난 리뷰는 수정할 수 없습니다.');">
    </c:otherwise>
</c:choose>
<a href="delete?rno=${review.rno }"
	onclick="if (!confirm('리뷰를 삭제하시겠습니까?')) return false; alert('리뷰가 삭제되었습니다!');">
		<input type="button" value="삭제하기"></a>
<a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>
