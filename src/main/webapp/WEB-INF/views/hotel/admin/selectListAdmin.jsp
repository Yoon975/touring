<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>selectListHotel</title>

<!-- Flatpickr CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

<!-- 호텔 리스트 전용 CSS -->
<link rel="stylesheet" href="<c:url value='/resources/css/selectListAdmin.css'/>">

</head>
<body>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<!-- 숙소 등록 + 검색 폼 -->
<div class="hotel-search-container">
    <div class="register-btn-container">
	    <input type="button" 
	           onclick="location.href='${pageContext.request.contextPath}/hotelAdmin/insertHotel'" 
	           value="숙소 등록" 
	           class="btn-register">
	</div>
    <form class="hotel-search-form" action="${pageContext.request.contextPath}/hotelAdmin/selectListAdmin" method="get" id="searchForm">
        <input type="text" name="hname" placeholder="숙소명 검색" value="${hname}" class="search-input">
        <select name="hregion" class="search-select">
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
        <input type="number" name="minPrice" placeholder="최소 가격" value="${minPrice}" class="search-input price"> ~
        <input type="number" name="maxPrice" placeholder="최대 가격" value="${maxPrice}" class="search-input price">

        <input type="text" name="checkin" id="checkin" placeholder="체크인" value="${checkin}" autocomplete="off" class="search-input date">
        <input type="text" name="checkout" id="checkout" placeholder="체크아웃" value="${checkout}" autocomplete="off" class="search-input date">

        <input type="hidden" name="hcno" id="hcno" value="${selectedTcno}">
        <input type="submit" value="검색" class="btn-search">
        <input type="button" value="초기화" onclick="location.href='<c:url value='/hotelAdmin/selectListAdmin' />'" class="btn-reset">
    </form>
</div>

<!-- 카테고리 버튼 -->
<div class="hotel-category-buttons">
    <a href="selectListAdmin?hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${empty selectedTcno ? 'disabled' : ''}>전체</button>
    </a>
    <a href="selectListAdmin?hcno=1&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 1 ? 'disabled' : ''}>모텔</button>
    </a>
    <a href="selectListAdmin?hcno=2&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 2 ? 'disabled' : ''}>호텔/리조트</button>
    </a>
    <a href="selectListAdmin?hcno=3&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 3 ? 'disabled' : ''}>펜션</button>
    </a>
    <a href="selectListAdmin?hcno=4&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 4 ? 'disabled' : ''}>풀빌라</button>
    </a>
    <a href="selectListAdmin?hcno=5&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 5 ? 'disabled' : ''}>독채펜션</button>
    </a>
    <a href="selectListAdmin?hcno=6&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 6 ? 'disabled' : ''}>글램핑</button>
    </a>
    <a href="selectListAdmin?hcno=7&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 7 ? 'disabled' : ''}>카라반</button>
    </a>
    <a href="selectListAdmin?hcno=8&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 8 ? 'disabled' : ''}>캠핑</button>
    </a>
    <a href="selectListAdmin?hcno=9&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 9 ? 'disabled' : ''}>무인텔</button>
    </a>
    <a href="selectListAdmin?hcno=10&hname=${hname}&hregion=${hregion}&minPrice=${minPrice}&maxPrice=${maxPrice}&checkin=${checkin}&checkout=${checkout}">
        <button ${selectedTcno == 10 ? 'disabled' : ''}>게스트하우스</button>
    </a>
</div>


<!-- 호텔 리스트 테이블 -->
<c:choose>
    <c:when test="${empty hotelList}">
        <p style="text-align:center; margin-top:30px;">검색 결과가 없습니다.</p>
    </c:when>
    <c:otherwise>
        <table class="hotel-list-table">
            <tr>
                <th>숙소명</th>
                <th>지역</th>
                <th>가격</th>
                <th>찜</th>
                <th>대표 이미지</th>
            </tr>
            <c:forEach var="hotel" items="${hotelList}">
                <tr>
                    <td><a href="detailHotelAdmin?hno=${hotel.hno}">${hotel.hname}</a></td>
                    <td>${hotel.hregion}</td>
                    <td>${hotel.hprice}</td>
                    <td>${hotel.hlike}</td>
                    <td>
                        <c:if test="${not empty hotel.mainFile}">
                            <img src="${pageContext.request.contextPath}/fileDataHotel/${hotel.mainFile}" alt="대표 이미지" width="100"/>
                        </c:if>
                        <c:if test="${empty hotel.mainFile}">
                            <span>이미지 없음</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>

<jsp:include page="../../include/footer.jsp"/>

<!-- Flatpickr JS -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
var checkinInput = document.getElementById('checkin');
var checkoutInput = document.getElementById('checkout');
var checkoutPicker = flatpickr(checkoutInput, { dateFormat: "Y-m-d" });

flatpickr(checkinInput, {
    dateFormat: "Y-m-d",
    onChange: function(selectedDates) {
        if (!selectedDates.length) return;
        var minCheckout = new Date(selectedDates[0]);
        minCheckout.setDate(minCheckout.getDate() + 1);
        checkoutPicker.set('minDate', minCheckout);
    }
});
</script>

</body>
</html>
