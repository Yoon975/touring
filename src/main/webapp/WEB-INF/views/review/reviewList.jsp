<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/reviewList.css'/>">
    
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<h2>리뷰 목록</h2>

<c:choose>
    <c:when test="${empty reviewList}">
        <p>등록된 리뷰가 없습니다.</p>
    </c:when>
    <c:otherwise>
        <table border="1">
            <tr>
                <th>리뷰 번호</th>
                <th>작성자</th>
                <th>내용</th>
                <th>평점</th>
                <th>작성일</th>
            </tr>
            <c:forEach var="review" items="${reviewList}">
                <tr>
                    <td>${review.rno}
                    	<input type="hidden" name="dno" value="${review.dno }">
                    </td>
                    <td>${review.name }</td>
                    <td>${review.content}</td>
                    <td>${review.rating}점</td>
                    <td>${review.createdAt}</td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>

<br>
<a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>
