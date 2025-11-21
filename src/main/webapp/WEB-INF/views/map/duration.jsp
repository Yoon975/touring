<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>소요시간 계산</title>
    <script type="text/javascript"
            src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=6f7d9225de59ebcac2931cb5af4b08a9&libraries=services,clusterer,drawing"></script>
    <link rel="stylesheet" href="<c:url value='/resources/css/duration.css'/>">
</head>
<body>
<h2>출발지 / 도착지 선택</h2>

<!-- 🔹 출발지 입력 -->
<div class="search-container">
    <div class="search-box">
        <input type="text" id="startSearch" placeholder="출발지 검색">
        <button onclick="searchStart()">검색</button>
    </div>
    <p id="start"></p>
</div>

<!-- 🔹 도착지 입력 (호텔 주소 자동 입력 가능) -->
<div class="search-container">
    <div class="search-box">
        <input type="text" id="endSearch" placeholder="도착지 검색" value="${hotelVo.haddress}">
        <button onclick="searchEnd()">검색</button>
    </div>
    <p id="end"></p>
</div>

<!-- 🔹 지도 표시 -->
<div id="map"></div>

<!-- 🔹 서버로 소요시간 요청 -->
<div class="center-btn">
    <button onclick="sendToServer()">소요시간 계산</button>
</div>

<script src="<c:url value='/resources/js/map.js'/>"></script>
</body>
</html>
