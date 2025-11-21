<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 상세 (관리자)</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/adminReserveDetail.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<div class="reservation-detail">
<h2>예약 상세 정보 (관리자)</h2>

    <ul>
        <li>예약번호: ${reserve.displayDno}</li>
        <li>유저번호: ${reserve.uno}</li>
        <li>회원이름: <a href="/touring/user/detail?uno=${reserve.uno }">${user.name}</a></li>
        <li>숙소번호: ${reserve.hno}</li>
        <li>숙소명: <a href="/touring/hotelAdmin/detailHotelAdmin?hno=${reserve.hno }">${reserve.hotelName}</a></li>
        <li>결제번호: ${reserve.pno }</li>
        <li>체크인: ${reserve.checkin}</li>
        <li>체크아웃: ${reserve.checkout}</li>
        <li>가격: ${reserve.dprice}</li>
    </ul>

    <div class="action-buttons">
        <a href="javascript:history.back();">검색 결과로 돌아가기</a>
        <a href="<c:url value='/reserveAdmin/updateForm?dno=${reserve.dno}'/>">예약 수정</a>

        <form action="<c:url value='cancel' />" method="get" style="display:inline;">
            <input type="hidden" name="dno" value="${reserve.dno}">
            <input type="submit" value="예약 취소"
                   onclick="if (!confirm('정말 예약을 취소하시겠습니까?')) return false; alert('취소되었습니다!');">
        </form>
    </div>
</div>


<jsp:include page="../include/footer.jsp"/>
</body>
</html>
