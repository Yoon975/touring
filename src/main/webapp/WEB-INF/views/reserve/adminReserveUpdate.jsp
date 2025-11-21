<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 수정</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/adminReserveUpdate.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<h2>예약 수정</h2>

<form action="update" method="post"
    onsubmit="if (!confirm('수정하시겠습니까?')) return false; alert('수정되었습니다!');"
    class="update-form">
    
    <input type="hidden" name="dno" value="${reserve.dno}">

    <div class="form-group">
        <label>숙소명:</label>
        <span>${reserve.hotelName}</span>
    </div>

    <div class="form-group">
        <label>체크인:</label>
        <input type="date" name="checkin" value="${reserve.checkin}" required>
    </div>

    <div class="form-group">
        <label>체크아웃:</label>
        <input type="date" name="checkout" value="${reserve.checkout}" required>
    </div>

    <div class="form-group">
        <label>가격:</label>
        <input type="text" name="dprice" value="${reserve.dprice}" readonly>
    </div>

    <div class="btn-group">
        <input type="submit" value="수정하기" class="btn-submit">
        <a href="javascript:history.back();" class="btn-back">뒤로가기</a>
    </div>
</form>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
