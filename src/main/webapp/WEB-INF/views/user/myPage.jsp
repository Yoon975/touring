<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/myPage.css'/>">
<script>
function delOk(uno) {
	  let result = confirm("정말 탈퇴하시겠습니까?\n\n※ 탈퇴 시 유의사항 ※\n- 이미 예약된 숙소에 대한 책임은 지지 않습니다.\n- 결제된 금액은 환불되지 않습니다.");
	  
	  if (result) {
		alert("탈퇴되었습니다.");
	    location.href = "delete?uno=" + uno;
	  }
}
function adminTry(uno) {
	  let result = confirm("관리자 권한을 신청하시겠습니까?\n\n관리자가 되면 숙소 등록, 수정, 삭제 및 회원 관리를 할 수 있습니다.\n관리자 권한 승인은 검토 후 처리되며, 시간이 소요될 수 있습니다.");
	  if (result) {
	    location.href = "adminTry?uno=" + uno;
	  }
}
</script>

</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<div class="container">
<h2>마이페이지</h2>
<div class="mypage-top-links">
	    <a href="<c:url value='/user/updatePw'/>" class="button-link">비밀번호변경</a>
	    <a href="<c:url value='/user/update?uno=${loginSession.uno}'/>" class="button-link">회원정보수정</a>
	    <a href="#" class="button-link" onclick="delOk(${loginSession.uno})">탈퇴</a>
	</div>
<table border="1">
    <tr>
        <th>Id</th>
        <td>${loginSession.id}      	
			<input type="hidden" name="uno" value="${loginSession.uno }">
		</td>
    </tr>
    <tr>
        <th>이름</th>
        <td>${loginSession.name}</td>
    </tr>
    <tr>
        <th>이메일</th>
        <td>${loginSession.email}</td>
    </tr>   
    <tr>
        <th>전화번호</th>
        <td>${loginSession.phone}</td>
    </tr>
    <tr>
        <th>가입일</th>
        <td>${loginSession.regdate}</td>
    </tr>
</table>

<br>
	<div class="mypage-links">
	    <c:choose>
	        <c:when test="${loginSession.admin eq '1'}"></c:when>
	        <c:otherwise>
	            <c:if test="${loginSession.admin eq '0'}">
	                <a href="#" class="button-link" onclick="adminTry(${loginSession.uno})">관리자 권한 신청</a>
	            </c:if>
	            <c:if test="${loginSession.admin eq '2'}">
	                <span class="admin-status">관리자 권한 (검토중)</span>
	                <a href="<c:url value='/user/adminTryNo?uno=${loginSession.uno}'/>" 
	                   class="button-link"
	                   onclick="if (!confirm('관리자 권한 요청을 취소하시겠습니까?')) return false; alert('취소되었습니다!');">
	                   취소
	                </a>
	            </c:if>
	        </c:otherwise>
	    </c:choose>
	
	    <a href="<c:url value='/user/mylike'/>" class="button-link">찜 목록</a>
	    <a href="<c:url value='/reserve/list'/>" class="button-link">예약내역</a>
	    <a href="<c:url value='/review/myReview'/>" class="button-link">나의리뷰</a>
	    
	</div>
</div>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>