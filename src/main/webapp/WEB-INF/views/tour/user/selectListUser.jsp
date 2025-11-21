<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectListTour</title>
<link rel="stylesheet" href="<c:url value='/resources/css/selectListTour.css' />">
</head>
<body>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>


<div class="content-wrapper">
	<div class="search-container">
	    <form action="${pageContext.request.contextPath}/tourUser/selectListUser" method="get" class="search-form">
	        <input type="text" name="keyword" value="${keyword}" placeholder="관광지명 검색" class="search-input"/>
	        <select name="tregion" class="region-select">
	            <option value="">전체 지역</option>
	            <option value="서울특별시" ${param.tregion eq '서울특별시' ? 'selected' : ''}>서울특별시</option>
	            <option value="인천광역시" ${param.tregion eq '인천광역시' ? 'selected' : ''}>인천광역시</option>
	            <option value="대전광역시" ${param.tregion eq '대전광역시' ? 'selected' : ''}>대전광역시</option>
	            <option value="대구광역시" ${param.tregion eq '대구광역시' ? 'selected' : ''}>대구광역시</option>
	            <option value="울산광역시" ${param.tregion eq '울산광역시' ? 'selected' : ''}>울산광역시</option>
	            <option value="부산광역시" ${param.tregion eq '부산광역시' ? 'selected' : ''}>부산광역시</option>
	            <option value="광주광역시" ${param.tregion eq '광주광역시' ? 'selected' : ''}>광주광역시</option>
	            <option value="경기도" ${param.tregion eq '경기도' ? 'selected' : ''}>경기도</option>
	            <option value="경상도" ${param.tregion eq '경상도' ? 'selected' : ''}>경상도</option>
	            <option value="전라도" ${param.tregion eq '전라도' ? 'selected' : ''}>전라도</option>
	            <option value="충청도" ${param.tregion eq '충청도' ? 'selected' : ''}>충청도</option>
	            <option value="강원도" ${param.tregion eq '강원도' ? 'selected' : ''}>강원도</option>
	            <option value="제주특별자치도" ${param.tregion eq '제주특별자치도' ? 'selected' : ''}>제주특별자치도</option>
	        </select>
	        <input type="hidden" name="tcno" value="${selectedTcno}" />
	        <button type="submit" class="btn-search">검색</button>
	        <input type="button" value="초기화" class="btn-reset" onclick="location.href='<c:url value='/tourUser/selectListUser' />'">
	    </form>
	</div>
	
	<div class="category-buttons">
	    <a href="selectListUser?keyword=${keyword}&tregion=${selectedTregion}"><button ${empty selectedTcno ? 'disabled' : ''}>전체</button></a>
	    <a href="selectListUser?tcno=1&keyword=${keyword}&tregion=${selectedTregion}"><button ${selectedTcno == 1 ? 'disabled' : ''}>투어</button></a>
	    <a href="selectListUser?tcno=2&keyword=${keyword}&tregion=${selectedTregion}"><button ${selectedTcno == 2 ? 'disabled' : ''}>박물관, 예술, 문화</button></a>
	    <a href="selectListUser?tcno=3&keyword=${keyword}&tregion=${selectedTregion}"><button ${selectedTcno == 3 ? 'disabled' : ''}>엔터테인먼트 & 티켓</button></a>
	    <a href="selectListUser?tcno=4&keyword=${keyword}&tregion=${selectedTregion}"><button ${selectedTcno == 4 ? 'disabled' : ''}>자연 & 아웃도어</button></a>
	    <a href="selectListUser?tcno=5&keyword=${keyword}&tregion=${selectedTregion}"><button ${selectedTcno == 5 ? 'disabled' : ''}>푸드 & 드링크</button></a>
	    <a href="selectListUser?tcno=6&keyword=${keyword}&tregion=${selectedTregion}"><button ${selectedTcno == 6 ? 'disabled' : ''}>서비스 & 대여</button></a>
	    <a href="selectListUser?tcno=7&keyword=${keyword}&tregion=${selectedTregion}"><button ${selectedTcno == 7 ? 'disabled' : ''}>워크샵 & 클래스</button></a>
	</div>
	
	<c:if test="${empty tourList}">
	    <p class="no-result">검색 결과가 없습니다.</p>
	</c:if>
	
	<c:if test="${not empty tourList}">
	<div class="tour-list">
	    <c:forEach var="tour" items="${tourList}">
	        <div class="tour-card">
	            <a href="detailTourUser?tno=${tour.tno}">
	                <div class="tour-image">
	                    <c:if test="${not empty tour.mainFile}">
	                        <img src="<c:url value='/fileDataTour/${tour.mainFile}'/>" alt="${tour.tname}" />
	                    </c:if>
	                    <c:if test="${empty tour.mainFile}">
	                        <div class="no-image">이미지 없음</div>
	                    </c:if>
	                </div>
	                <div class="tour-info">
	                    <h3>${tour.tname}</h3>
	                    <p class="region">${tour.tregion}</p>
	                    <p class="hit">조회수 ${tour.thit}</p>
	                </div>
	            </a>
	        </div>
	    </c:forEach>
	</div>
	</c:if>
</div>

<jsp:include page="../../include/footer.jsp"/>
</body>
</html>
