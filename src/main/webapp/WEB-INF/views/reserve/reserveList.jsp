<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 내역</title>
<link rel="stylesheet" href="<c:url value='/resources/css/reserveList.css'/>">

</head>
<body>

<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<h2 style="text-align:center;">${sessionScope.loginSession.name}님의 예약 내역</h2>

<!-- 지난 예약 토글 버튼 -->
<button id="toggleBtn" class="toggle-btn" onclick="togglePast()">지난 예약 보기 (${pastList.size()})</button>
<div class="container">
	<table>
	    <tr>
	        <th>예약번호</th>
	        <th>숙소명</th>
	        <th>체크인</th>
	        <th>체크아웃</th>
	        <th>가격</th>
	        <th>리뷰 상태</th>
	    </tr>
	   
	    <!-- 다가올 예약 (체크아웃 안 지난 예약) -->
	    <tbody id="upcomingSection">
	       <c:if test="${empty upcomingList}">
	          <tr class="no-upcoming-message">
	              <td id="hide" colspan="6" style="text-align:center;">현재 예약이 없습니다.</td>
	          </tr>
	       </c:if>
	       <c:forEach var="reserve" items="${upcomingList}">
	           <tr>
	               <td><a href="<c:url value='/reserve/detail?dno=${reserve.dno}' />">${reserve.dno}</a></td>
	               <td>${reserve.hotelName}</td>
	               <td>${reserve.checkin}</td>
	               <td>${reserve.checkout}</td>
	               <td>${reserve.dprice}</td>
	               <td>
	                   <c:choose>
	                       <c:when test="${reserve.canUse}">이용 예정</c:when>
	                       <c:when test="${reserve.hasReview}">작성 완료</c:when>
	                       <c:when test="${reserve.canWriteReview}">
	                           <a href="<c:url value='/review/insert?dno=${reserve.dno}' />">리뷰 작성</a>
	                       </c:when>
	                       <c:otherwise>작성 불가</c:otherwise>
	                   </c:choose>
	               </td>
	           </tr>
	       </c:forEach>
	    </tbody>
	   
	    <!-- 지난 예약 (체크아웃 지난 예약) -->
	   <tbody id="pastSection" class="hidden">
	    <c:forEach var="reserve" items="${pastList}">
	        <tr class="past-row hidden">
	            <td><a href="<c:url value='/reserve/detail?dno=${reserve.dno}' />">${reserve.dno}</a></td>
	            <td>${reserve.hotelName}</td>
	            <td>${reserve.checkin}</td>
	            <td>${reserve.checkout}</td>
	            <td>${reserve.dprice}</td>
	            <td>
	                <c:choose>
	                    <c:when test="${reserve.hasReview}">작성 완료</c:when>
	                    <c:when test="${reserve.canWriteReview}">
	                        <a href="<c:url value='/review/insert?dno=${reserve.dno}' />">리뷰 작성</a>
	                    </c:when>
	                    <c:otherwise>작성 불가</c:otherwise>
	                </c:choose>
	            </td>
	        </tr>
	    </c:forEach>
	    </tbody>
	</table>
	
</div>

<div class="back-btn-container">
  <a href="javascript:history.back();">
    <button class="back-btn">뒤로가기</button>
  </a>
</div>


<script>
function togglePast() {
    const pastRows = document.querySelectorAll(".past-row");
    const hide = document.getElementById('hide');
    const btn = document.getElementById("toggleBtn");

    if (pastRows.length > 0) {
        // 지난 예약 토글
        let isHidden = pastRows[0].classList.contains("hidden"); // 현재 숨겨져 있는 상태
        pastRows.forEach(r => {
            if (isHidden) r.classList.remove("hidden"); // 보여주기
            else r.classList.add("hidden"); // 숨기기
        });

        // 현재 예약 없으면 메시지 토글
        if (hide) hide.style.display = isHidden ? "none" : "table-row";

        // 버튼 텍스트
        btn.textContent = isHidden ? "지난 예약 닫기" : "지난 예약 보기 (" + pastRows.length + ")";
    }
}
</script>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
