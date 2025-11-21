<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/listUser.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<div class="container">
<h2>회원목록</h2>
<table>
    <tr>
        <th>번호</th>
        <th>ID</th>
        <th>이름</th>
        <th>관리자</th>
    </tr>
    <c:forEach items="${userList}" var="user">
        <tr>
            <td>${user.uno}</td>
            <td><a href="<c:url value='/user/detail?uno=${user.uno}'/>">${user.id}</a></td>
            <td>${user.name}</td>
            <td>
            <c:if test="${user.admin eq '0'}">일반회원</c:if>
            <c:if test="${user.admin eq '1'}">관리자</c:if>
        	<c:if test="${user.admin eq '2'}">
        		<a href="<c:url value='/user/adminTryOk?uno=${user.uno}'/>"
        		onclick="if (!confirm('${user.id}님의 관리자 권한 요청을 승인하시겠습니까?')) return false;
        			alert('처리되었습니다!');">승인</a>
        		<a href="<c:url value='/user/adminTryNo?uno=${user.uno}'/>"
        		onclick="if (!confirm('${user.id}님의 관리자 권한 요청을 거부하시겠습니까?')) return false;
        			alert('처리되었습니다!');">거부</a>
        	</c:if>
            </td>
        </tr>
    </c:forEach>
</table>
</div>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>