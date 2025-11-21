<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>detailHotel</title>

<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<link rel="stylesheet" href="<c:url value='/resources/css/detailHotelUser.css' />">
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

</head>
<body>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<main class="hotel-detail-page">

  <div class="hotel-top-wrap unified-wrap">

    <!-- left: gallery + hotel description -->
    <section class="gallery-area">
      <div class="gallery-main">

        <!-- Swiper 영역 -->
        <div class="swiper-container gallery-main-swiper">
          <div class="swiper-wrapper">
            <c:choose>
              <c:when test="${not empty hotelVo.fileDataList}">
                <c:forEach var="item" items="${hotelVo.fileDataList}">
                  <div class="swiper-slide">
                    <img src="<c:url value='/fileDataHotel/${item.hfilename}'/>" alt="${hotelVo.hname}" />
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <!-- 이미지 없는 경우 기본 플레이스홀더 -->
                <div class="swiper-slide">
                  <div class="no-image-placeholder">이미지가 없습니다.</div>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="swiper-button-prev"></div>
          <div class="swiper-button-next"></div>
          <div class="swiper-pagination"></div>
        </div>

        <!-- 썸네일 영역 -->
        <div class="gallery-thumbs">
          <div class="swiper-container gallery-thumb-swiper">
            <div class="swiper-wrapper">
              <c:choose>
                <c:when test="${not empty hotelVo.fileDataList}">
                  <c:forEach var="item" items="${hotelVo.fileDataList}">
                    <div class="swiper-slide">
                      <img src="<c:url value='/fileDataHotel/${item.hfilename}'/>" alt="thumb" />
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <div class="swiper-slide">
                    <div class="no-image-placeholder">이미지 없음</div>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

      </div>

      <!-- 호텔 설명만 스와이퍼 아래로 이동 -->
      <div class="hotel-body">
        <div class="hotel-description">
          <h2>숙소 설명</h2>
          <p>${hotelVo.hdescription}</p>
        </div>
      </div>
    </section>

    <!-- right: info -->
    <aside class="info-area">
      <div class="hotel-header">
        <div class="hotel-meta">
          <div class="rating-badges">
            <span class="stars">★★★★★</span>
            <span class="badge">특가</span>
          </div>
          <h1 class="hotel-name">${hotelVo.hname}</h1>
          <p class="hotel-location">${hotelVo.haddress}</p>
        </div>

        <div class="action-group">
          <form action="${pageContext.request.contextPath}/hotelUser/toggleLike" method="post" class="like-form">
            <input type="hidden" name="hno" value="${hotelVo.hno}" />
            <button type="submit" class="btn-like" aria-label="찜하기">
            	<c:choose>
		            <c:when test="${like}">❤️</c:when>
		            <c:otherwise>♡</c:otherwise>
		        </c:choose>${hotelVo.hlike}</button>
          </form>

          <div class="top-buttons">
            <a href="<c:url value='/reserve/insertForm?hno=${hotelVo.hno}'/>"><button class="btn-reserve">지금 예약</button></a>
            <a href="/touring/hotelUser/selectListUser"><button class="btn-list">목록으로</button></a>
          </div>
        </div>
      </div>

		<c:set var="sumRating" value="0" />
		<c:set var="reviewCount" value="${empty reviewList ? 0 : reviewList.size()}" />
		<c:forEach var="review" items="${reviewList}">
		    <c:if test="${review.rating != null}">
		        <c:set var="sumRating" value="${sumRating + review.rating}" />
		    </c:if>
		</c:forEach>
				
		<c:set var="avgRating" value="${reviewCount == 0 ? 0 : (sumRating / reviewCount)}" />
		
		<div class="score-box">
		<div class="score">
		        <c:choose>
		            <c:when test="${reviewCount == 0}">
		                –
		            </c:when>
		            <c:otherwise>
		                <fmt:formatNumber value="${avgRating}" pattern="0.0"/>
		            </c:otherwise>
		        </c:choose>
		</div>
	    <div class="score-text">
	        <p class="score-sub">평균 점수</p>
	        <p class="score-note">${reviewCount}개의 이용 후기</p>
	    </div>
		</div>

      <div class="short-review">
        <p><strong>최신 후기</strong></p>
        <p class="quote">
			<c:choose>
            <c:when test="${not empty reviewList}">
                <c:set var="latestReview" value="${reviewList[0].content}" />
                <c:choose>
                    <c:when test="${fn:length(latestReview) > 20}">
                        "${fn:substring(latestReview, 0, 20)}..."
                    </c:when>
                    <c:otherwise>
                        "${latestReview}"
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                등록된 리뷰가 없습니다.
            </c:otherwise>
        </c:choose>
        </p>
      </div>

      <div class="price-info">
        <p class="price-label">기준 요금</p>
        <p class="price-value">${hotelVo.hprice}원</p>
      </div>

      <!-- 총 객실 수 원래 위치 -->
      <div class="hotel-stats">
        <p><strong>총 객실 수:</strong> ${hotelVo.hmax}실</p>
      </div>

    </aside>
  </div>

  <!-- map section -->
  <section class="hotel-map">	
    <jsp:include page="../../map/duration.jsp"/>
  </section>

  <!-- reviews -->
  <section class="hotel-reviews">
    <c:choose>
      <c:when test="${empty reviewList}">
        <div class="no-review-message">등록된 리뷰가 없습니다.</div>
      </c:when>
      <c:otherwise>
        <h3>총 ${reviewList.size()}개의 리뷰</h3>
        <c:forEach var="review" items="${reviewList}">
          <article class="review-item">
            <div class="review-head">
              <span class="review-author">${review.name}님</span>
              <span class="review-rating">${review.rating}점</span>
              <span class="review-date">${review.createdAt}</span>
            </div>
            <div class="review-body">${review.content}</div>
          </article>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </section>

</main>

<script>
  // Swiper 초기화
  var galleryThumbs = new Swiper('.gallery-thumb-swiper', {
    spaceBetween: 8,
    slidesPerView: 5,
    watchSlidesProgress: true,
    slideToClickedSlide: true
  });

  var galleryTop = new Swiper('.gallery-main-swiper', {
    spaceBetween: 10,
    loop: true,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    pagination: { el: '.swiper-pagination', clickable: true },
    thumbs: { swiper: galleryThumbs }
  });
</script>

<jsp:include page="../../include/footer.jsp"/>
</body>
</html>
