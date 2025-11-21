<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/detailUser.css' />">

<script>
function delOk(uno, id) {
    if(confirm(id + " 회원을 정말 삭제하시겠습니까?")) {
        alert("삭제되었습니다!");
        location.href = "${pageContext.request.contextPath}/user/delete?uno=" + uno;
    }
}
</script>
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<div class="container">
<h2>회원 상세 정보 (관리자)</h2>
<table border="1">
    <tr>
        <th>Id</th>
        <td>${user.id}</td>
    </tr>
    <tr>
        <th>이름</th>
        <td>${user.name}</td>
    </tr>
    <tr>
        <th>이메일</th>
        <td>${user.email}</td>
    </tr>   
    <tr>
        <th>전화번호</th>
        <td>${user.phone}</td>
    </tr>
    <tr>
        <th>관리자</th>
        <td>
        <c:if test="${user.admin eq '0'}">일반회원</c:if>
        <c:if test="${user.admin eq '1'}">관리자</c:if>
        <c:if test="${user.admin eq '2'}">검토중</c:if>
        </td>
    </tr>
    <tr>
        <th>가입일</th>
        <td>${user.regdate}</td>
    </tr>
    <tr>
    <td colspan="2">
		<a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
        <input type="button" value="탈퇴" onclick="delOk(${user.uno},'${user.id }')">
    </td>
    </tr>
</table>
</div>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>