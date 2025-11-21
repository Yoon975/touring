<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 디테일</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/reserveInsert.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>

<c:if test="${not empty payment}">
<div class="reserve-insert">
<h2>결제 상세 정보</h2>
</div>

	<form>
	<p><label>결제번호: ${payment.pno}</label><br></p>
	<p><label>호텔명: ${payment.hname}</label><br></p>
	<p><label>체크인: ${payment.checkin}</label><br></p>
	<p><label>체크아웃: ${payment.checkout}</label><br></p>
	<p><label>금액: ${payment.hprice}원</label><br></p>
	<p><label>상태: ${payment.status}</label><br></p>
	<p style="text-align: center;">
		<a href="${pageContext.request.contextPath}/reserve/list">
			<button type="button" class="btn btn-primary">예약 내역</button></a>
		<a href="${pageContext.request.contextPath}/">
			<button type="button" class="btn btn-primary">홈으로</button></a>
	</p>
	</form>
</c:if>

<jsp:include page="../include/footer.jsp"/>

</body>
</html>
