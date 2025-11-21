<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 상세</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/reserveDetail.css'/>">
<script>
function delOk(dno) {
	  let result = confirm("정말 예약을 취소하시겠습니까?\n\n※ 취소 전 유의사항 ※\n- 예약 취소 시 해당 예약 정보는 복구가 불가능합니다.\n- 환불 금액은 관리자 확인 후 2~3일 이내 지급됩니다.\n- 숙소 이용 예정일이 임박한 경우, 환불이 제한될 수 있습니다.");
	  
	  if (result) {
		alert("예약이 취소되었습니다.");
	    location.href = "cancel?dno=" + dno;
	  }
}
</script>
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<h2>예약 상세</h2>

<div class="reserve-container">
    <ul class="reserve-info">
        <li><strong>예약번호:</strong> ${reserve.displayDno}</li>
        <li><strong>숙소명:</strong> 
            <a href="/touring/hotelUser/detailHotelUser?hno=${reserve.hno }">${reserve.hotelName}</a>
        </li>
        <li><strong>체크인:</strong> ${reserve.checkin}</li>
        <li><strong>체크아웃:</strong> ${reserve.checkout}</li>
        <li><strong>가격:</strong> ${reserve.dprice}원</li>
    </ul>

    <div class="btn-group">
        <c:if test="${reserve.checkin gt todayStr}">
            <a href="updateForm?dno=${reserve.dno}" class="btn-primary">예약 수정</a>
                <input type="hidden" name="dno" value="${reserve.dno}">
                <input type="button" value="예약 취소" class="btn-cancel" onclick="delOk(${reserve.dno})">

        </c:if>
        <a href="list" class="btn-back">목록으로</a>
    </div>
</div>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
