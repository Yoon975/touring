<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 수정</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/reserveUpdate.css'/>">
    
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<h2>예약 수정</h2>

<c:if test="${not empty errorMessage}">
    <p style="color:red;">${errorMessage}</p>
</c:if>

<form action="update" method="post"
	onsubmit="if (!confirm('수정하시겠습니까?')) return false; alert('수정되었습니다!');">
    <input type="hidden" name="dno" value="${reserve.dno}">
    <p>숙소명: ${reserve.hotelName}</p>
    <p>체크인: <input type="text" id="checkin" name="checkin" value="${reserve.checkin}" required></p>
    <p>체크아웃: <input type="text" id="checkout" name="checkout" value="${reserve.checkout}" required></p>
    <p>가격: <span class="price-wrap"><input type="text" name="dprice" value="${reserve.dprice}" readonly><span>원</span></span></p>
    <input type="submit" value="수정하기">
    <a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
</form>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
var bookedDates = <c:out value='${bookedDatesJson}'/> || [];

var checkinInput = document.getElementById('checkin');
var checkoutInput = document.getElementById('checkout');

var checkoutPicker = flatpickr(checkoutInput, { dateFormat: "Y-m-d", defaultDate: checkoutInput.value });

flatpickr(checkinInput, {
    dateFormat: "Y-m-d",
    disable: bookedDates,
    defaultDate: checkinInput.value,
    onChange: function(selectedDates) {
        if (!selectedDates.length) return;

        var minCheckout = new Date(selectedDates[0]);
        minCheckout.setDate(minCheckout.getDate() + 1);
        checkoutPicker.set('minDate', minCheckout);

        var disableAfterCheckin = bookedDates.filter(d => new Date(d) > selectedDates[0]);
        checkoutPicker.set('disable', disableAfterCheckin);
    }
});
</script>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
