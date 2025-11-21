<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>투어링</title>

<!-- CSS -->
<link rel="stylesheet" href="<c:url value='/resources/css/header.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/nav.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/home.css'/>">

<!-- Flatpickr -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body>
<jsp:include page="./include/header.jsp"/>
<jsp:include page="./include/nav.jsp"/>

<h1>국내 여행자의 길잡이, “투어링”!</h1>

<!-- 숙소 / 관광지 버튼 -->
<div class="category-buttons">
  <c:choose>
    <c:when test="${sessionScope.loginSession != null and sessionScope.loginSession.admin eq '1'}">
      <a href="<c:url value='/hotelAdmin' />"><button>숙소</button></a>
      <a href="<c:url value='/tourAdmin' />"><button>관광지</button></a>
    </c:when>
    <c:otherwise>
      <a href="<c:url value='/hotelUser' />"><button>숙소</button></a>
      <a href="<c:url value='/tourUser' />"><button>관광지</button></a>
    </c:otherwise>
  </c:choose>
</div>

<!-- 숙소 검색 -->
<c:choose>
  <c:when test="${sessionScope.loginSession != null and sessionScope.loginSession.admin eq '1'}">
    <form action="<c:url value='/hotelAdmin/selectListAdmin' />" method="get">
  </c:when>
  <c:otherwise>
    <form action="<c:url value='/hotelUser/selectListUser' />" method="get">
  </c:otherwise>
</c:choose>
    <input type="text" name="hname" placeholder="숙소명 검색" value="${hname}">
    <input type="text" name="checkin" id="checkin" placeholder="체크인" value="${checkin}" autocomplete="off">
    <input type="text" name="checkout" id="checkout" placeholder="체크아웃" value="${checkout}" autocomplete="off">
    <button type="submit">검색</button>
</form>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
var checkinInput = document.getElementById('checkin');
var checkoutInput = document.getElementById('checkout');
var checkoutPicker = flatpickr(checkoutInput, { dateFormat: "Y-m-d" });

flatpickr(checkinInput, {
    dateFormat: "Y-m-d",minDate: "today",
    onChange: function(selectedDates) {
        if (!selectedDates.length) return;
        var minCheckout = new Date(selectedDates[0]);
        minCheckout.setDate(minCheckout.getDate() + 1);
        checkoutPicker.set('minDate', minCheckout);
    }
});
</script>
<jsp:include page="./include/footer.jsp"/>
</body>
</html>
