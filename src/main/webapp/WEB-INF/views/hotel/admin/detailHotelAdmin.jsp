<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>detailHotel</title>
<link rel="stylesheet" href="<c:url value='/resources/css/detailHotelAdmin'/>">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Swiper -->
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

<!-- 외부 CSS 연결 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detailHotelAdmin.css">

<script>
// 줄바꿈 처리
$(document).ready(function(){
    $(".td-description").each(function(){
        var text = $(this).text();
        var html = text.replace(/\r?\n/g, "<br/>");
        $(this).html(html);
    });
});
</script>

</head>
<body>

<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<table border="1">
    <tr>
        <th>번호</th>
        <td>${hotelVo.hno}</td>
    </tr>
    <tr>
        <th>이름</th>
        <td>${hotelVo.hname}
            <input type="hidden" name="hname" value="${hotelVo.hname}">
        </td>
    </tr>
	<tr>
	  <th>사진</th>
	  <td style="text-align:center; vertical-align: middle; padding: 0; width: 500px;">
	    <div style="width: 500px; height: 300px; margin: auto;">
	      <div class="swiper-container tour-swiper">
	        <div class="swiper-wrapper">
	          <c:forEach var="item" items="${hotelVo.fileDataList}">
	            <div class="swiper-slide">
	              <img src="<c:url value='/fileDataHotel/${item.hfilename}'/>" alt="호텔 이미지" />
	            </div>
	          </c:forEach>
	        </div>

	        <!-- 버튼 / 페이지네이션 -->
	        <div class="swiper-button-next"></div>
	        <div class="swiper-button-prev"></div>
	        <div class="swiper-pagination"></div>
	      </div>
	    </div>
	  </td>
	</tr>
    <tr>
        <th>지역</th>
        <td>${hotelVo.hregion}</td>
    </tr>
    <tr>
        <th>주소</th>
        <td>${hotelVo.haddress}</td>
    </tr>
    <tr>
        <th>설명</th>
        <td class="td-description">${hotelVo.hdescription}</td>
    </tr>
    <tr>
        <th>가격</th>
        <td>${hotelVo.hprice}원</td>
    </tr>
    <tr>
        <th>총 객실 수</th>
        <td>${hotelVo.hmax}실</td>
    </tr>
    <tr>
        <th>찜</th>
        <td>${hotelVo.hlike}개</td>
    </tr>
    <tr>
        <th>등록일</th>
        <td>${hotelVo.hregdate}</td>
    </tr>
    <tr>
        <th>카테고리</th>
        <td>
            <c:choose>
			    <c:when test="${hotelVo.hcno == 1}">모텔</c:when>
			    <c:when test="${hotelVo.hcno == 2}">호텔/리조트</c:when>
			    <c:when test="${hotelVo.hcno == 3}">펜션</c:when>
			    <c:when test="${hotelVo.hcno == 4}">풀빌라</c:when>
			    <c:when test="${hotelVo.hcno == 5}">독채펜션</c:when>
			    <c:when test="${hotelVo.hcno == 6}">글램핑</c:when>
			    <c:when test="${hotelVo.hcno == 7}">카라반</c:when>
			    <c:when test="${hotelVo.hcno == 8}">캠핑</c:when>
			    <c:when test="${hotelVo.hcno == 9}">무인텔</c:when>
			    <c:when test="${hotelVo.hcno == 10}">게스트하우스</c:when>
			    <c:otherwise>기타</c:otherwise>
			</c:choose>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align:center;">
			<a href="/touring/hotelAdmin/selectListAdmin"><input type="button" value="목록으로"></a>
            <a href="updateHotel?hno=${hotelVo.hno}"><input type="button" value="수정"></a>
            <input type="button" value="삭제" onclick="deleteHotel(${hotelVo.hno})">
        </td>
    </tr>
</table>

<!-- 리뷰 영역 -->
<c:choose>
    <c:when test="${empty reviewList}">
        <p>등록된 리뷰가 없습니다.</p>
    </c:when>
    <c:otherwise>
    	<h3>총 ${reviewList.size()}개의 리뷰</h3>
	    <c:forEach var="review" items="${reviewList}">
	    	<table class="review-table">
		        <tr>
		            <th>작성자</th>
		            <td>${review.name}</td>
		        </tr>
		        <tr>
		            <th>평점</th>
		            <td>${review.rating}점</td>
		        </tr>
		        <tr>
		            <th>내용</th>
		            <td>${review.content}</td>
		        </tr>
		        <tr>
		            <th>작성일</th>
		            <td>${review.createdAt}</td>
		        </tr>
	        </table>
	    </c:forEach>
    </c:otherwise>
</c:choose>

<jsp:include page="../../include/footer.jsp"/>

<!-- JS: Swiper 초기화 & 삭제 처리 -->
<script>
function deleteHotel(hno) {
    fetch('${pageContext.request.contextPath}/hotelAdmin/checkReservations?hno=' + hno)
        .then(response => response.json())
        .then(data => {
            if(data.hasFutureReservations) {
                alert("체크아웃되지 않은 예약이 있어 삭제할 수 없습니다.");
            } else {
                if(confirm("숙소를 정말 삭제하시겠습니까?")) {
                    window.location.href = '${pageContext.request.contextPath}/hotelAdmin/deleteHotel?hno=' + hno;
                }
            }
        })
        .catch(err => console.error(err));
}

var swiper = new Swiper('.tour-swiper', {
  loop: true,
  slidesPerView: 1,
  pagination: {
    el: '.swiper-pagination',
    clickable: true
  },
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev'
  }
});
</script>

</body>
</html>
