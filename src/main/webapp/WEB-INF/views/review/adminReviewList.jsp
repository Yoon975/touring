<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 리뷰 리스트</title>
<link rel="stylesheet" href="<c:url value='/resources/css/adminReviewList.css' />">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<h2>관리자 리뷰 리스트</h2>

<c:if test="${not empty errorMsg}">
    <script>
        alert("${errorMsg}");
    </script>
</c:if>

<!-- 검색 -->
<form action="list" method="get" class="search-form">
    <label for="category">검색 범주:</label>
    <select name="category" id="category">
        <option value="rno" <c:if test="${category == 'rno'}">selected</c:if>>리뷰번호</option>
        <option value="name" <c:if test="${category == 'name'}">selected</c:if>>회원명</option>
        <option value="hname" <c:if test="${category == 'hname'}">selected</c:if>>호텔명</option>
    </select>

    <label for="value">번호:</label>
    <input type="text" id="value" name="value" value="${value}" placeholder="번호 입력">

    <input type="submit" value="검색">
</form>

<!-- 리뷰 리스트 테이블 -->
<c:choose>
    <c:when test="${empty reviewList}">
        <p>검색 결과가 없습니다.</p>
    </c:when>
    <c:otherwise>
		<table class="reserve-table">
		    <tr>
		        <th>리뷰번호</th>
		        <th>작성자</th>
		        <th>호텔명</th>
		        <th>내용</th>
		        <th>평점</th>
		        <th>작성일</th>
		        <th>관리</th>
		    </tr>
		    <c:forEach var="review" items="${reviewList}">
		        <tr>
		            <td>${review.rno}</td>
		            <td><a href="${pageContext.request.contextPath}/user/detail?uno=${review.uno}">${review.name}</a></td>
		            <td><a href="${pageContext.request.contextPath}/hotelAdmin/detailHotelAdmin?hno=${review.hno}">${review.hname}</a></td>
		            <td>${review.content}</td>
		            <td>${review.rating}</td>
		            <td>${review.createdAt}</td>
		            <td><a href="${pageContext.request.contextPath}/reserveAdmin/detail?dno=${review.dno}">예약 내역</a>
		            	&nbsp;&nbsp;|&nbsp;&nbsp;
		            	<a href="<c:url value='/reviewAdmin/delete?rno=${review.rno}' />"
							onclick="return confirm('정말 삭제하시겠습니까?');">리뷰 삭제</a>
					</td>
		        </tr>
		    </c:forEach>
		</table>
	</c:otherwise>
</c:choose>
<jsp:include page="../include/footer.jsp"/>
</body>
<script>
    // 입력 필드 가져오기
    const categorySelect = document.getElementById("category");
    const valueInput = document.getElementById("value");

    // 입력 제한 함수
    function setInputRestriction() {
        const selected = categorySelect.value;

        // 이벤트 리스너 제거 (중복 방지)
        valueInput.removeEventListener("input", restrictToNumbers);
        valueInput.removeEventListener("keyup", restrictToLetters);

        if (selected === "rno") {
            valueInput.value = "";
            valueInput.placeholder = "리뷰번호 입력";
            valueInput.setAttribute("inputmode", "numeric");
            valueInput.addEventListener("input", restrictToNumbers);

        } else if (selected === "name") {
            valueInput.value = "";
            valueInput.placeholder = "회원 이름 입력";
            valueInput.removeAttribute("inputmode");
            valueInput.addEventListener("keyup", restrictToLetters);

        } else if (selected === "hname") {
            valueInput.value = "";
            valueInput.placeholder = "호텔 이름 입력";
            valueInput.removeAttribute("inputmode");
        }
    }

    function restrictToNumbers(e) {
        e.target.value = e.target.value.replace(/[^0-9]/g, "");
    }

    function restrictToLetters(e) {
        e.target.value = e.target.value.replace(/[^a-zA-Z가-힣^0-9]/g, "");
    }

    categorySelect.addEventListener("change", setInputRestriction);
    window.addEventListener("DOMContentLoaded", setInputRestriction);
</script>
</html>
