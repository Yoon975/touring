<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertHotel</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/insertHotelAdmin.css">
</head>
<body>

<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<h2>숙소 등록</h2>

<form action="${pageContext.request.contextPath}/hotelAdmin/insertHotelOk"
      method="post" enctype="multipart/form-data"
      onsubmit="if (!confirm('숙소를 등록하시겠습니까?')) return false; alert('등록되었습니다!');">
    <table>
        <tr>
            <td>이름</td>
            <td><input type="text" name="hname" required/></td>
        </tr>
        <tr>
            <td>지역</td>
            <td>
                <select name="hregion" required>
                    <option value="">선택</option>
                    <option value="서울특별시">서울특별시</option>
                    <option value="인천광역시">인천광역시</option>
                    <option value="대전광역시">대전광역시</option>
                    <option value="대구광역시">대구광역시</option>
                    <option value="울산광역시">울산광역시</option>
                    <option value="부산광역시">부산광역시</option>
                    <option value="광주광역시">광주광역시</option>
                    <option value="경상도">경상도</option>
                    <option value="전라도">전라도</option>
                    <option value="충청도">충청도</option>
                    <option value="강원도">강원도</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>주소</td>
            <td><input type="text" name="haddress" required/></td>
        </tr>
        <tr>
            <td>설명</td>
            <td>
                <textarea name="hdescription" rows="5" cols="50"
                          placeholder="설명을 입력하세요"></textarea>
            </td>
        </tr>
        <tr>
            <td>가격</td>
            <td><input type="number" name="hprice" required/></td>
        </tr>
        <tr>
            <td>예약가능여부</td>
            <td>
                <select name="hreserveOk">
                    <option value="가능">가능</option>
                    <option value="불가능">불가능</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>총 객실 수</td>
            <td><input type="number" name="hmax" required/></td>
        </tr>
        <tr>
            <td>카테고리</td>
            <td>
                <select name="hcno" required>
                    <option value="">전체</option>
                    <option value="1">모텔</option>
                    <option value="2">호텔/리조트</option>
                    <option value="3">펜션</option>
                    <option value="4">풀빌라</option>
                    <option value="5">독채펜션</option>
                    <option value="6">글램핑</option>
                    <option value="7">카라반</option>
                    <option value="8">캠핑</option>
                    <option value="9">무인텔</option>
                    <option value="10">게스트하우스</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>사진 업로드</td>
            <td>
                <input type="file" name="multi" multiple/>
                <small>여러 파일 선택 가능</small>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
            	<input type="submit" value="등록"/>
		        <input type="button" value="목록으로"
		        	onclick="location.href='${pageContext.request.contextPath}/hotelAdmin/selectListAdmin'" />
            </td>
        </tr>
    </table>
</form>

<jsp:include page="../../include/footer.jsp"/>

</body>
</html>
