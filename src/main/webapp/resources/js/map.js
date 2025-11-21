var map = new kakao.maps.Map(document.getElementById('map'), {
    center: new kakao.maps.LatLng(37.5665, 126.9780),
    level: 7
});

var startCoords = null;
var endCoords = null;
var startMarker = null;
var endMarker = null;
var infoWindow = new kakao.maps.InfoWindow({ zIndex: 1 });
var ps = new kakao.maps.services.Places();

// 도착지 input 자동 세팅 + 숫자 이후 제거
window.addEventListener('DOMContentLoaded', function() {
    var endInput = document.getElementById('endSearch');
    if (endInput && endInput.value) {
        // 숫자 포함 뒤쪽 삭제
       var processedAddress = endInput.value.replace(/\s\d+[-\d]*.*$/, '');
        endInput.value = processedAddress.trim();
    }
});

function searchStart() {
    var keyword = document.getElementById("startSearch").value;
    ps.keywordSearch(keyword, function(data, status) {
        if (status === kakao.maps.services.Status.OK) {
            var lat = data[0].y;
            var lng = data[0].x;
            startCoords = lng + "," + lat;
            document.getElementById("start").innerText = "출발지: " + data[0].place_name;

            if (startMarker) startMarker.setMap(null);
            startMarker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
            startMarker.setMap(map);
            map.setCenter(new kakao.maps.LatLng(lat, lng));
        }
    });
}

function searchEnd() {
    var keyword = document.getElementById("endSearch").value;
    
    ps.keywordSearch(keyword, function(data, status) {
        if (status === kakao.maps.services.Status.OK) {
            var lat = data[0].y;
            var lng = data[0].x;
            endCoords = lng + "," + lat;
            document.getElementById("end").innerText = "도착지: " + data[0].place_name;

            if (endMarker) endMarker.setMap(null);
            endMarker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(lat, lng),
                image: new kakao.maps.MarkerImage(
                    'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/red_dot.png',
                    new kakao.maps.Size(24, 35)
                )
            });
            endMarker.setMap(map);
            map.setCenter(new kakao.maps.LatLng(lat, lng));
        }
    });
}

function sendToServer() {
    if (!startCoords || !endCoords) {
        alert("출발지와 도착지를 모두 선택하세요!");
        return;
    }

    var [startLng, startLat] = startCoords.split(',');
    var [endLng, endLat] = endCoords.split(',');

    fetch(`/touring/map/duration/navi/time?origin=${startLng},${startLat}&destination=${endLng},${endLat}`)
    .then(res => res.json())
    .then(data => {
        if (data.duration != null) {
            var durationSec = data.duration;
            var hours = Math.floor(durationSec / 3600);
            var minutes = Math.round((durationSec % 3600) / 60);

            var msg = "예상 소요시간: ";
            if (hours > 0) msg += hours + "시간 ";
            msg += minutes + "분";

            alert(msg);
        } else {
            alert("소요시간 정보를 가져올 수 없습니다.");
        }
    })
    .catch(err => {
        console.error(err);
        alert("소요시간 계산 실패");
    });
}
