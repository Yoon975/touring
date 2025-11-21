<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateHotel</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/updateHotelAdmin.css">

</head>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<h2>숙소 수정</h2>

<form id="updateHotelForm" action="/touring/hotelAdmin/updateHotelOk" method="post" enctype="multipart/form-data"
	onsubmit="if (!confirm('수정하시겠습니까?')) return false; alert('수정되었습니다!');">
    <table border="1">
        <tr>
            <td>이름</td>
            <td>
		    	<input type="hidden" name="hno" value="${hotelVo.hno }">
		    	<input type="text" name="hname" value="${hotelVo.hname }" required/>
	    	</td>
        </tr>
        <tr>
            <td>지역</td>
		    <td>
		        <select name="hregion" required>
		            <option value="">선택</option>
		            <option value="서울특별시" ${hotelVo.hregion == '서울특별시' ? 'selected' : ''}>서울특별시</option>
		            <option value="인천광역시" ${hotelVo.hregion == '인천광역시' ? 'selected' : ''}>인천광역시</option>
		            <option value="대전광역시" ${hotelVo.hregion == '대전광역시' ? 'selected' : ''}>대전광역시</option>
		            <option value="대구광역시" ${hotelVo.hregion == '대구광역시' ? 'selected' : ''}>대구광역시</option>
		            <option value="울산광역시" ${hotelVo.hregion == '울산광역시' ? 'selected' : ''}>울산광역시</option>
		            <option value="부산광역시" ${hotelVo.hregion == '부산광역시' ? 'selected' : ''}>부산광역시</option>
		            <option value="광주광역시" ${hotelVo.hregion == '광주광역시' ? 'selected' : ''}>광주광역시</option>
		            <option value="경상도" ${hotelVo.hregion == '경상도' ? 'selected' : ''}>경상도</option>
		            <option value="전라도" ${hotelVo.hregion == '전라도' ? 'selected' : ''}>전라도</option>
		            <option value="충청도" ${hotelVo.hregion == '충청도' ? 'selected' : ''}>충청도</option>
		            <option value="강원도" ${hotelVo.hregion == '강원도' ? 'selected' : ''}>강원도</option>
		        </select>
		    </td>
        </tr>
        <tr>
            <td>주소</td>
            <td><input type="text" name="haddress" value="${hotelVo.haddress }" required/></td>
        </tr>
        <tr>
            <td>설명</td>
            <td>
				<textarea name="hdescription" rows="5" cols="50"><c:out value='${hotelVo.hdescription}' /></textarea>
    		</td>
        </tr>
        <tr>
            <td>가격</td>
            <td><input type="number" name="hprice" value="${hotelVo.hprice }" required/>원</td>
        </tr>
        <tr>
            <td>예약가능여부</td>
            <td>
            	<select name="hreserveOk">
				  <option value="가능" ${hotelVo.hreserveOk eq '가능' ? 'selected' : ''}>가능</option>
				  <option value="불가능" ${hotelVo.hreserveOk eq '불가능' ? 'selected' : ''}>불가능</option>
				</select>
            </td>
        </tr>
        <tr>
            <td>총 객실 수</td>
            <td><input type="number" name="hmax" value="${hotelVo.hmax }" required/>실</td>
        </tr>
        <tr>
            <td>카테고리</td>
			<td>
			    <select name="hcno" required>
			        <option value="1" ${hotelVo.hcno == 1 ? 'selected' : ''}>모텔</option>
			        <option value="2" ${hotelVo.hcno == 2 ? 'selected' : ''}>호텔/리조트</option>
			        <option value="3" ${hotelVo.hcno == 3 ? 'selected' : ''}>펜션</option>
			        <option value="4" ${hotelVo.hcno == 4 ? 'selected' : ''}>풀빌라</option>
			        <option value="5" ${hotelVo.hcno == 5 ? 'selected' : ''}>독채펜션</option>
			        <option value="6" ${hotelVo.hcno == 6 ? 'selected' : ''}>글램핑</option>
			        <option value="7" ${hotelVo.hcno == 7 ? 'selected' : ''}>카라반</option>
			        <option value="8" ${hotelVo.hcno == 8 ? 'selected' : ''}>캠핑</option>
			        <option value="9" ${hotelVo.hcno == 9 ? 'selected' : ''}>무인텔</option>
			        <option value="10" ${hotelVo.hcno == 10 ? 'selected' : ''}>게스트하우스</option>
			    </select>
			</td>
        </tr>
		<tr>
			<td>기존 업로드 파일</td>
			<td>
			    <c:forEach var="file" items="${hotelVo.fileDataList}">
			        <div>
			            <a href="${pageContext.request.contextPath}/hotelAdmin/fileData/${file.hfilename}" target="_blank">
			                ${file.horiginal}</a>
			            <label>
			                <input type="checkbox" name="deleteFiles" value="${file.hfno}"/> 삭제
			            </label>
			        </div>
			    </c:forEach>
			</td>
		</tr>
		<tr>
		    <td>사진 업로드</td>
		    <td>
		        <input type="file" name="multi" multiple />
		        <small>여러 파일 선택 가능</small>
		    </td>
		</tr>
		<tr>
		    <td colspan="2">
		        <input type="button" value="수정 완료"  onclick="submitUpdateForm()">
                <a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
		    </td>
		</tr>
    </table>
</form>
<script>
function submitUpdateForm() {
    if (confirm('수정하시겠습니까?')) {
        document.getElementById('updateHotelForm').submit();
    }
}
</script>
<jsp:include page="../../include/footer.jsp"/>
</body>
</html>