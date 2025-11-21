<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>detailTour</title>

<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<link rel="stylesheet" href="<c:url value='/resources/css/detailTourUser.css' />">
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

</head>
<body>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<main class="tour-detail-page">

  <div class="tour-top-wrap unified-wrap">

    <!-- left : swiper gallery + description -->
    <section class="gallery-area">
      <div class="gallery-main">
        <!-- 메인 스와이퍼 -->
        <div class="swiper-container tour-main-swiper">
          <div class="swiper-wrapper">
            <c:forEach var="item" items="${tourVo.fileDataList}">
              <div class="swiper-slide">
                <img src="<c:url value='/fileDataTour/${item.tfilename}'/>" alt="${tourVo.tname}" />
              </div>
            </c:forEach>
          </div>
          <div class="swiper-button-prev"></div>
          <div class="swiper-button-next"></div>
          <div class="swiper-pagination"></div>
        </div>
      </div>

      <!-- 하단 썸네일 스와이퍼 -->
      <div class="gallery-thumbs">
        <div class="swiper-container tour-thumb-swiper">
          <div class="swiper-wrapper">
            <c:forEach var="item" items="${tourVo.fileDataList}">
              <div class="swiper-slide">
                <img src="<c:url value='/fileDataTour/${item.tfilename}'/>" alt="thumb" />
              </div>
            </c:forEach>
          </div>
        </div>
      </div>

      <!-- 🔹 설명 부분을 스와이퍼 아래로 이동 -->
      <div class="tour-description">
        <h2>설명</h2>
        <p>${tourVo.tdescription}</p>
      </div>
    </section>

    <!-- right : info -->
    <aside class="info-area">
      <div class="tour-header">
        <h1 class="tour-name">${tourVo.tname}</h1>
        <p class="tour-region">${tourVo.tregion}</p>
      </div>

      <div class="tour-info">
        <p><strong>주소:</strong> ${tourVo.taddress}</p>
        <p><strong>카테고리:</strong>
          <c:choose>
            <c:when test="${tourVo.tcno == 1}">투어</c:when>
            <c:when test="${tourVo.tcno == 2}">박물관, 예술, 문화</c:when>
            <c:when test="${tourVo.tcno == 3}">엔터테인먼트 & 티켓</c:when>
            <c:when test="${tourVo.tcno == 4}">자연 & 아웃도어</c:when>
            <c:when test="${tourVo.tcno == 5}">푸드 & 드링크</c:when>
            <c:when test="${tourVo.tcno == 6}">서비스 & 대여</c:when>
            <c:otherwise>기타</c:otherwise>
          </c:choose>
        </p>
        <p><strong>조회수:</strong> ${tourVo.thit}</p>
        <p><strong>등록일:</strong> ${tourVo.tregdate}</p>
      </div>

      <div class="tour-buttons">
        <a href="/touring/tourUser/selectListUser"><button class="btn-list">목록으로</button></a>
        <a href="https://search.naver.com/search.naver?query=${tourVo.tname}"><button class="btn-detail">자세히</button></a>
      </div>
    </aside>
  </div>

  <!-- map section -->
  <section class="tour-map">
    <h3>주변 호텔 검색</h3>
    <div id="map" style="width:100%; height:600px; margin-top:20px;"></div>
  </section>

</main>

<script type="text/javascript" 
    src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=6f7d9225de59ebcac2931cb5af4b08a9&libraries=services">
</script>

<script>
// Swiper 초기화
var galleryThumbs = new Swiper('.tour-thumb-swiper', {
  spaceBetween: 8,
  slidesPerView: 5,
  watchSlidesProgress: true,
  slideToClickedSlide: true
});

var galleryTop = new Swiper('.tour-main-swiper', {
  spaceBetween: 10,
  loop: true,
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  pagination: { el: '.swiper-pagination', clickable: true },
  thumbs: { swiper: galleryThumbs }
});

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

  function searchEnd(keyword){
      ps.keywordSearch(keyword, function(data, status){
          if(status === kakao.maps.services.Status.OK){
              var lat = data[0].y, lng = data[0].x;
              if(endMarker) endMarker.setMap(null);
              endMarker = new kakao.maps.Marker({
                  map: map,
                  position: new kakao.maps.LatLng(lat, lng),
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
                      position: new kakao.maps.LatLng(h.y, h.x)
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

  var rawAddress = '<c:out value="${tourVo.taddress}"/>';
  if(rawAddress && rawAddress.trim() !== ''){
      var cleanAddress = rawAddress.replace(/[0-9]/g, '').split(',')[0].trim();
      searchEnd(cleanAddress);
  }
};
</script>

<jsp:include page="../../include/footer.jsp"/>
</body>
</html>
