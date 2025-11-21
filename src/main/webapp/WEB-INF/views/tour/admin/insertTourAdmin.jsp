<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertTour</title>
<link rel="stylesheet" href="<c:url value='/resources/css/insertTour.css'/>">

</head>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<h2>관광지 등록</h2>

<form action="${pageContext.request.contextPath}/tourAdmin/insertTourOk" method="post" enctype="multipart/form-data"
	onsubmit="if (!confirm('관광지를 등록하시겠습니까?')) return false; alert('등록되었습니다!');">
    <table border="1">
        <tr>
            <td>이름</td>
            <td><input type="text" name="tname" required/></td>
        </tr>
        <tr>
            <td>지역</td>
            <td>
               <select name="tregion" required>
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
            <td><input type="text" name="taddress" required/></td>
        </tr>
              
        <tr>
            <td>설명</td>
            <td>
        		<textarea name="tdescription" rows="5" cols="50"
        				placeholder="설명을 입력하세요"></textarea>
    		</td>
        </tr>
        <tr>
            <td>카테고리</td>
            <td>
                <select name="tcno" required>
                    <option value="1">투어</option>
                    <option value="2">박물관, 예술, 문화</option>
                    <option value="3">엔터테인먼트 & 티켓</option>
                    <option value="4">자연 & 아웃도어</option>
                    <option value="5">푸드 & 드링크</option>
                    <option value="6">서비스 & 대여</option>
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
            <td colspan="2">
                <input type="submit" value="등록"/>
                <input type="button" value="목록으로"
		        	onclick="location.href='${pageContext.request.contextPath}/tourAdmin/selectListAdmin'" />
            </td>
        </tr>
    </table>
</form>

<jsp:include page="../../include/footer.jsp"/>
</body>
</html>