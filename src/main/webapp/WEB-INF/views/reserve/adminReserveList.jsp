<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 예약 리스트</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/adminReserveList.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<h2>관리자 예약 리스트</h2>

<!-- 검색 -->
<form action="list" method="get" class="search-form">
    <label for="category">검색 범주:</label>
    <select name="category" id="category">
        <option value="dno" <c:if test="${category == 'dno'}">selected</c:if>>예약번호</option>
        <option value="uno" <c:if test="${category == 'uno'}">selected</c:if>>유저번호</option>
        <option value="hno" <c:if test="${category == 'hno'}">selected</c:if>>호텔번호</option>
        <option value="uname" <c:if test="${category == 'uname'}">selected</c:if>>회원이름</option>
    </select>

    <label for="value">검색어:</label>
    <input type="text" id="value" name="value" value="${value}" placeholder="번호 입력">

    <input type="submit" value="검색">
</form>

<!-- 예약 리스트 테이블 -->
<c:choose>
    <c:when test="${empty reserveList}">
        <p class="no-result">검색 결과가 없습니다.</p>
    </c:when>
    <c:otherwise>
        <table class="reserve-table">
            <tr>
                <th>예약번호</th>
                <th>유저번호</th>
                <th>회원이름</th>
                <th>호텔번호</th>
                <th>숙소명</th>
                <th>체크인</th>
                <th>체크아웃</th>
                <th>가격</th>
            </tr>
            <c:forEach var="reserve" items="${reserveList}">
                <tr>
                    <td><a href="detail?dno=${reserve.dno}">${reserve.dno}</a></td>
                    <td>${reserve.uno}</td>
                    <td>${reserve.name}</td>
                    <td>${reserve.hno}</td>
                    <td>${reserve.hotelName}</td>
                    <td>${reserve.checkin}</td>
                    <td>${reserve.checkout}</td>
                    <td>${reserve.dprice}</td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>

<jsp:include page="../include/footer.jsp"/>
</body>
<script>
    // 입력 필드 요소 가져오기
    const categorySelect = document.getElementById("category");
    const valueInput = document.getElementById("value");

    // 입력 제한 함수
    function setInputRestriction() {
        const selected = categorySelect.value;

        if (selected === "uname") {
            // 이름 검색일 때 - 문자만 입력 가능
            valueInput.value = "";
            valueInput.placeholder = "회원 이름 입력";
            valueInput.removeAttribute("inputmode");
            valueInput.removeEventListener("input", restrictToNumbers);
        } else {
            // 번호 검색일 때 - 숫자만 입력 가능
            valueInput.value = "";
            valueInput.placeholder = "숫자만 입력";
            valueInput.setAttribute("inputmode", "numeric");
            valueInput.addEventListener("input", restrictToNumbers);
        }
    }

    // 숫자만 허용하는 함수
    function restrictToNumbers(event) {
        event.target.value = event.target.value.replace(/[^0-9]/g, "");
    }

    // 드롭다운 변경 시 입력 제한 적용
    categorySelect.addEventListener("change", setInputRestriction);

    // 초기 상태 설정
    window.addEventListener("DOMContentLoaded", setInputRestriction);
</script>
</html>
