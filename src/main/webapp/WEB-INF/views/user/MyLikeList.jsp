<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>찜 내역</title>
  	<link rel="stylesheet" href="<c:url value='/resources/css/myLikeList.css'/>">
    
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<div class="container">
	<h2>${sessionScope.loginSession.name}님의 찜목록</h2>
	
	<table border="1">
	    <tr>
	        <th>숙소번호</th>
	        <th>숙소명</th>
	        <th>지역</th>
	        <th>가격</th>
	        <th>상세보기</th>
	    </tr>
	
	    <c:forEach var="hotel" items="${likeList}">
	        <tr>
	            <td>${hotel.hno}</td>
	            <td>${hotel.hname}</td>
	            <td>${hotel.hregion}</td>
	            <td>${hotel.hprice}</td>
	            <td>
	                <a href="<c:url value='/hotelUser/detailHotelUser?hno=${hotel.hno}' />">자세히 보기</a>
	            </td>
	        </tr>
	    </c:forEach>
	</table>
</div>
<a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
<jsp:include page="../include/footer.jsp"/>
</body>
</html>
