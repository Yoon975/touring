<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>detailTour</title>
<link rel="stylesheet" href="<c:url value='/resources/css/detailTourAdmin.css'/>">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
// 줄바꿈
$(document).ready(function(){
    $(".td-description").each(function(){
        // HTML로 변환: 줄바꿈(\n) → <br>
        var text = $(this).text();
        var html = text.replace(/\r?\n/g, "<br/>");
        $(this).html(html);
    });
});
</script>
<!-- 슬라이더 용 -->
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

</head>
<body>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>
<table border="1">
    <tr><td>번호</td><td>${tourVo.tno}</td></tr>
    <tr><td>이름</td><td>${tourVo.tname}</td></tr>
    <tr>
	  <td>사진</td>
	  <td style="text-align:center; vertical-align: middle; padding: 0; width: 500px;">
	    <div style="width: 500px; height: 300px; margin: auto;">
	      <div class="swiper-container tour-swiper">
	        <div class="swiper-wrapper">
	          <c:forEach var="item" items="${tourVo.fileDataList}">
	            <div class="swiper-slide">
	              <img src="<c:url value='/fileDataTour/${item.tfilename}'/>" />
	            </div>
	          </c:forEach>
	        </div>
	        <div class="swiper-button-next"></div>
	        <div class="swiper-button-prev"></div>
	        <div class="swiper-pagination"></div>
	      </div>
	    </div>
	  </td>
	</tr>
	<tr><td>지역</td><td>${tourVo.tregion}</td></tr>
	<tr><td>주소</td><td>${tourVo.taddress}</td></tr>
	<tr><td>설명</td><td class="td-description">${tourVo.tdescription}</td></tr>
	<tr><td>조회수</td><td>${tourVo.thit}</td></tr>
	<tr><td>등록일</td><td>${tourVo.tregdate}</td></tr>
    <tr>
        <td>카테고리</td>
        <td>
            <c:choose>
                <c:when test="${tourVo.tcno == 1}">투어</c:when>
                <c:when test="${tourVo.tcno == 2}">박물관, 예술, 문화</c:when>
                <c:when test="${tourVo.tcno == 3}">엔터테인먼트 & 티켓</c:when>
                <c:when test="${tourVo.tcno == 4}">자연 & 아웃도어</c:when>
                <c:when test="${tourVo.tcno == 5}">푸드 & 드링크</c:when>
                <c:when test="${tourVo.tcno == 6}">서비스 & 대여</c:when>
                <c:otherwise>기타</c:otherwise>
            </c:choose>
        </td>
    </tr>
    <tr>
    	<td colspan="2">
			<a href="/touring/tourAdmin/selectListAdmin"><input type="button" value="목록으로"></a>
    		<a href="updateTour?tno=${tourVo.tno }"><input type="button" value="수정"></a>
    		<a href="deleteTour?tno=${tourVo.tno }"
    			onclick="if (!confirm('관광지를 삭제하시겠습니까?')) return false; alert('삭제되었습니다!');">
    		<input type="button" value="삭제"></a>
    	</td>
    </tr>
</table>


<!-- 지도 -->
<div style="margin-top:50px; text-align:center;">
    <h3>주변 호텔 검색</h3>
    <div id="map" style="width:100%; height:400px; margin-top:20px;"></div>
</div>

<jsp:include page="../../include/footer.jsp"/>

<script type="text/javascript" 
    src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=6f7d9225de59ebcac2931cb5af4b08a9&libraries=services,clusterer">
</script>

<script type="text/javascript">
window.onload = function(){
    var map = new kakao.maps.Map(document.getElementById('map'), {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 7
    });
    var ps = new kakao.maps.services.Places();
    var hotelMarkers = [];
    var infoWindow = new kakao.maps.InfoWindow({zIndex:1});
    var endMarker = null;

    var endMarkerImage = new kakao.maps.MarkerImage(
        'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
        new kakao.maps.Size(24, 35)
    );

    // 숫자 제거 + , 기준 왼쪽만
    var rawAddress = '<c:out value="${tourVo.taddress}"/>';
    if(rawAddress && rawAddress.trim() !== ''){
        var noNumbers = rawAddress.replace(/[0-9]/g,''); // 숫자 제거
        var parts = noNumbers.split(',');
        var finalAddress = parts[0].trim(); // , 기준 왼쪽만
    } else {
        var finalAddress = rawAddress;
    }

    function searchEnd(keyword){
        ps.keywordSearch(keyword, function(data, status){
            if(status === kakao.maps.services.Status.OK){
                var lat = data[0].y;
                var lng = data[0].x;

                if(endMarker) endMarker.setMap(null);
                endMarker = new kakao.maps.Marker({
                    map: map,
                    position: new kakao.maps.LatLng(lat, lng),
                    title: "도착지",
                    image: endMarkerImage
                });

                map.setCenter(new kakao.maps.LatLng(lat, lng));
                searchNearbyHotels(lat, lng);
            }
        });
    }

    function searchNearbyHotels(lat, lng){
        hotelMarkers.forEach(m => m.setMap(null));
        hotelMarkers = [];
        ps.keywordSearch('호텔', function(data, status){
            if(status === kakao.maps.services.Status.OK){
                data.forEach(h => {
                    var marker = new kakao.maps.Marker({
                        map: map,
                        position: new kakao.maps.LatLng(h.y, h.x),
                        title: h.place_name
                    });
                    kakao.maps.event.addListener(marker, 'click', function() {
                        infoWindow.setContent('<div style="padding:5px;"><b>'+h.place_name+'</b><br>'+(h.road_address_name || h.address_name)+'</div>');
                        infoWindow.open(map, marker);
                    });
                    hotelMarkers.push(marker);
                });
            }
        }, {location: new kakao.maps.LatLng(lat, lng), radius:2000});
    }

    if(finalAddress && finalAddress.trim() !== '') searchEnd(finalAddress);
};
</script>

<script>
var swiper = new Swiper('.tour-swiper', {
    loop: true,
    slidesPerView: 1,
    pagination: { el: '.swiper-pagination', clickable: true },
    navigation: { nextEl: '.swiper-button-next', prevEl: '.swiper-button-prev' }
});
</script>

</body>
</html>
