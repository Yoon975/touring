<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약하기</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/reserveInsert.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<div class="reserve-insert">
<h2>예약하기</h2>
</div>

<c:if test="${not empty errorMessage}">
    <p style="color:red;">${errorMessage}</p>
</c:if>

<form action="<c:url value='/payment/insert'/>" method="get">
    <input type="hidden" name="hno" value="${hotel.hno}">
    <input type="hidden" name="hprice" value="${hotel.hprice}">
    <p>숙소명: ${hotel.hname}</p>

    <p>체크인: <input type="text" id="checkin" name="checkin" required></p>
    <p>체크아웃: <input type="text" id="checkout" name="checkout" required></p>
    <p>가격: <input type="hidden" id="dprice" name="dprice" value="${hotel.hprice}">${hotel.hprice}</p>

    <input type="submit" value="결제하러 가기">
    <a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
    
</form>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
var bookedDates = <c:out value='${bookedDatesJson}'/> || [];

var checkinInput = document.getElementById('checkin');
var checkoutInput = document.getElementById('checkout');
var checkoutPicker = flatpickr(checkoutInput, { dateFormat: "Y-m-d" });

flatpickr(checkinInput, {
    dateFormat: "Y-m-d",minDate: "today",
    disable: bookedDates,
    onChange: function(selectedDates) {
        if (!selectedDates.length) return;
        var minCheckout = new Date(selectedDates[0]);
        minCheckout.setDate(minCheckout.getDate() + 1);
        checkoutPicker.set('minDate', minCheckout);

        var disableAfterCheckin = bookedDates.filter(d => new Date(d) > selectedDates[0]);
        checkoutPicker.set('disable', disableAfterCheckin);
    }
});
document.querySelector("form").addEventListener("submit", function(e) {
    const checkin = checkinInput.value.trim();
    const checkout = checkoutInput.value.trim();

    if (!checkin || !checkout) {
        alert("체크인 및 체크아웃 날짜를 모두 선택해주세요!");
        e.preventDefault(); // 제출 막기
        return false;
    }

    if (new Date(checkout) <= new Date(checkin)) {
        alert("체크아웃 날짜는 체크인 날짜 이후여야 합니다.");
        e.preventDefault();
        return false;
    }
});
</script>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
