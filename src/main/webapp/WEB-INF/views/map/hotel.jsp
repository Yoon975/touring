<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도착지 주변 호텔</title>
<script type="text/javascript"
    src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=6f7d9225de59ebcac2931cb5af4b08a9&libraries=services,clusterer"></script>
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<h2>도착지 주변 호텔 검색</h2>

<div>
    <input type="text" id="endSearch" placeholder="도착지 검색">
    <button onclick="searchEnd()">도착지 검색</button>
</div>

<div id="map" style="width:100%;height:400px;"></div>

<script>
var map = new kakao.maps.Map(document.getElementById('map'), {
    center: new kakao.maps.LatLng(37.5665, 126.9780),
    level: 7
});
var ps = new kakao.maps.services.Places();
var hotelMarkers = [];
var infoWindow = new kakao.maps.InfoWindow({zIndex:1});
var endCoords;
var endMarker = null;

// 빨간 마커 이미지 (도착지)
var endMarkerImageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png';
var endMarkerImageSize = new kakao.maps.Size(24, 35);
var endMarkerImage = new kakao.maps.MarkerImage(endMarkerImageSrc, endMarkerImageSize);

function searchEnd(){
    var keyword = document.getElementById("endSearch").value.trim();
    if(!keyword) return;
    ps.keywordSearch(keyword, function(data, status){
        if(status === kakao.maps.services.Status.OK){
            endCoords = {lat:data[0].y, lng:data[0].x};
            map.setCenter(new kakao.maps.LatLng(endCoords.lat, endCoords.lng));

            // 기존 도착지 마커 제거
            if(endMarker) endMarker.setMap(null);

            // 도착지 마커 추가
            endMarker = new kakao.maps.Marker({
                map: map,
                position: new kakao.maps.LatLng(endCoords.lat, endCoords.lng),
                title: "검색한 도착지",
                image: endMarkerImage
            });

            searchNearbyHotels(endCoords.lat, endCoords.lng);
        }
    });
}

function searchNearbyHotels(lat, lng){
    // 기존 호텔 마커 제거
    hotelMarkers.forEach(m => m.setMap(null));
    hotelMarkers = [];

    // 주변 호텔 검색
    ps.keywordSearch('호텔', function(data, status){
        if(status === kakao.maps.services.Status.OK){
            data.forEach(h => {
                var marker = new kakao.maps.Marker({
                    map: map,
                    position: new kakao.maps.LatLng(h.y, h.x),
                    title: h.place_name
                    // 기본 파란 마커
                });

                kakao.maps.event.addListener(marker, 'click', function() {
                    infoWindow.setContent('<div style="padding:5px;"><b>'+h.place_name+'</b><br>'+(h.road_address_name || h.address_name)+'</div>');
                    infoWindow.open(map, marker);
                });

                hotelMarkers.push(marker);
            });
        }
    }, {location: new kakao.maps.LatLng(lat, lng)});
}

// 페이지 로드 시 기본 위치 주변 호텔 표시
searchNearbyHotels(37.5665, 126.9780);
</script>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
