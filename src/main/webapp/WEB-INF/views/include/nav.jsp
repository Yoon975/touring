<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관광지 실시간 검색</title>
<link href='<c:url value="/resources/css/nav.css" />' rel="stylesheet" type="text/css">
</head>
<body>

<ul class="menu-bar">
    <div class="menu-left">
        <c:if test="${loginSession.admin eq '0' || loginSession.admin eq '2' || loginSession.admin eq null}">
            <li><a href="<c:url value='/hotelUser' />">숙소</a></li>
            <li><a href="<c:url value='/tourUser' />">관광지</a></li>
        </c:if>
    </div>

    <div class="menu-right">
        <c:choose>
            <c:when test="${empty loginSession}">
                <li><a href="<c:url value='/user/login' />">로그인</a></li>
                <li><a href="<c:url value='/user/insert' />">회원가입</a></li>
            </c:when>
            <c:otherwise>
                <li>${loginSession.name}님</li>
                <li><a href="<c:url value='/user/myPage' />">마이페이지</a></li>
                <c:if test="${loginSession.admin eq '1'}">
                    <li class="admin-menu">
                        관리자 메뉴
                        <ul class="submenu">
                            <li><a href="<c:url value='/user/list'/>">회원관리</a></li>
                            <li><a href="<c:url value='/hotelAdmin' />">숙소관리</a></li>
                            <li><a href="<c:url value='/tourAdmin' />">관광지관리</a></li>
                            <li><a href="<c:url value='/reserveAdmin/list' />">예약관리</a></li>
                            <li><a href="<c:url value='/reviewAdmin/list' />">리뷰관리</a></li>
                        </ul>
                    </li>
                </c:if>
                <li><a href="<c:url value='/user/logout' />">로그아웃</a></li>
            </c:otherwise>
        </c:choose>

        <!-- 추천지역 메뉴 -->
        <li class="realtime-menu">
            <a href="<c:url value='/chart' />">추천지역</a>
            <ul class="submenu" id="top9-list"></ul>
        </li>
    </div>
</ul>

<script>
window.onload = async function() {
    try {
        const response = await fetch('<c:url value="/top9api" />');
        const data = await response.json();

        const list = document.getElementById("top9-list");
        list.innerHTML = "";
        data.forEach((item, idx) => {
            const li = document.createElement("li");
            li.textContent = (idx + 1) + "위 " + item["시도명"];
            list.appendChild(li);
        });

    } catch (err) {
        console.error("실시간 검색 로드 실패:", err);
    }
};

document.addEventListener('DOMContentLoaded', function() {
    const top9List = document.getElementById('top9-list');

    top9List.addEventListener('click', function(e) {
        if (e.target && e.target.tagName === 'LI') {
            let selectedRegion = e.target.textContent.trim();
            selectedRegion = selectedRegion.replace(/^\d+위\s*/, '');

            if (selectedRegion.includes('경상')) selectedRegion = '경상도';
            else if (selectedRegion.includes('전라')) selectedRegion = '전라도';
            else if (selectedRegion.includes('충청')) selectedRegion = '충청도';
            else if (selectedRegion.includes('강원')) selectedRegion = '강원도';

            location.href = '${pageContext.request.contextPath}/tourUser/selectListUser?tregion=' 
                            + encodeURIComponent(selectedRegion);
        }
    });
});
</script>
</body>
</html>
