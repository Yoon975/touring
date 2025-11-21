<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>투어링 숙소</title>
<link rel="stylesheet" href="<c:url value='/resources/css/selectListUser.css'/>">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<div id="myLikeBtnContainer">
    <input id="myLikeBtn" type="button" onclick="location.href='${pageContext.request.contextPath}/user/mylike'" value="나의 찜">
</div>

<form id="searchForm" action="${pageContext.request.contextPath}/hotelUser/selectListUser" method="get">


  <div class="search-row-top">
    <input type="text" name="hname" placeholder="숙소명 검색" value="${hname}">
    <select name="hregion">
        <option value="">전체 지역</option>
        <option value="서울특별시" ${param.hregion eq '서울특별시' ? 'selected' : ''}>서울특별시</option>
        <option value="인천광역시" ${param.hregion eq '인천광역시' ? 'selected' : ''}>인천광역시</option>
        <option value="대전광역시" ${param.hregion eq '대전광역시' ? 'selected' : ''}>대전광역시</option>
        <option value="대구광역시" ${param.hregion eq '대구광역시' ? 'selected' : ''}>대구광역시</option>
        <option value="울산광역시" ${param.hregion eq '울산광역시' ? 'selected' : ''}>울산광역시</option>
        <option value="부산광역시" ${param.hregion eq '부산광역시' ? 'selected' : ''}>부산광역시</option>
        <option value="광주광역시" ${param.hregion eq '광주광역시' ? 'selected' : ''}>광주광역시</option>
        <option value="경기도" ${param.hregion eq '경기도' ? 'selected' : ''}>경기도</option>
        <option value="경상도" ${param.hregion eq '경상도' ? 'selected' : ''}>경상도</option>
        <option value="전라도" ${param.hregion eq '전라도' ? 'selected' : ''}>전라도</option>
        <option value="충청도" ${param.hregion eq '충청도' ? 'selected' : ''}>충청도</option>
        <option value="강원도" ${param.hregion eq '강원도' ? 'selected' : ''}>강원도</option>
    </select>

    <input type="number" name="minPrice" placeholder="최소 가격" value="${minPrice}" min="0" max="10000000" style="width: 100px;"> ~
    <input type="number" name="maxPrice" placeholder="최대 가격" value="${maxPrice}" min="0" max="10000000" style="width: 100px;">
  </div>

  <div class="search-row-bottom">
    <input type="text" name="checkin" id="checkin" placeholder="체크인" value="${checkin}" autocomplete="off">
    <input type="text" name="checkout" id="checkout" placeholder="체크아웃" value="${checkout}" autocomplete="off">
    <input type="hidden" name="hcno" id="hcno" value="${selectedTcno}">
    <input type="submit" value="검색">
    <input type="button" value="초기화" onclick="location.href='<c:url value="/hotelUser/selectListUser"/>'">
  </div>
</form>


<!-- 카테고리 버튼 -->
<div class="category-buttons">
    <c:forEach var="i" begin="0" end="10">
        <c:choose>
            <c:when test="${i == 0}">
                <!-- 전체 버튼: hcno 파라미터 제거 -->
                <a href="selectListUser?hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
                    <button ${selectedTcno == i ? 'disabled' : ''}>전체</button>
                </a>
            </c:when>
            <c:otherwise>
                <!-- 나머지 카테고리 버튼 -->
                <a href="selectListUser?hcno=${i}&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
                    <button ${selectedTcno == i ? 'disabled' : ''}>
                        <c:choose>
                            <c:when test="${i==1}">모텔</c:when>
                            <c:when test="${i==2}">호텔/리조트</c:when>
                            <c:when test="${i==3}">펜션</c:when>
                            <c:when test="${i==4}">풀빌라</c:when>
                            <c:when test="${i==5}">독채펜션</c:when>
                            <c:when test="${i==6}">글램핑</c:when>
                            <c:when test="${i==7}">카라반</c:when>
                            <c:when test="${i==8}">캠핑</c:when>
                            <c:when test="${i==9}">무인텔</c:when>
                            <c:when test="${i==10}">게스트하우스</c:when>
                        </c:choose>
                    </button>
                </a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>

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

<!-- 호텔 카드 리스트 -->
<c:if test="${empty hotelList}">
    <p style="text-align:center; margin-top:30px;">검색 결과가 없습니다.</p>
</c:if>

<c:if test="${not empty hotelList}">
    <div class="hotel-list">
        <c:forEach var="hotel" items="${hotelList}">
            <div class="hotel-card">
                <a href="detailHotelUser?hno=${hotel.hno}">
                    <c:if test="${not empty hotel.mainFile}">
                        <img src="${pageContext.request.contextPath}/fileDataHotel/${hotel.mainFile}" alt="대표 이미지"/>
                    </c:if>
                    <c:if test="${empty hotel.mainFile}">
                        <img src="<c:url value='/resources/images/no-image.png' />" alt="이미지 없음"/>
                    </c:if>
                </a>
                <div class="hotel-info">
                    <h4>${hotel.hname}</h4>
                    <p>${hotel.hregion}</p>
                    <p class="price">${hotel.hprice}원</p>
                    <form action="${pageContext.request.contextPath}/hotelUser/toggleLike" method="post">
                        <input type="hidden" name="hno" value="${hotel.hno}" />
                        <button type="submit">찜하기 (${hotel.hlike})</button>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>
</c:if>

<jsp:include page="../../include/footer.jsp"/>
</body>
</html>
