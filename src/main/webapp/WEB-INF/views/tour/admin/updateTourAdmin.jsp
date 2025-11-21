<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateTour</title>
<link rel="stylesheet" href="<c:url value='/resources/css/updateTour.css'/>">

<script>
// 줄바꿈
$(document).ready(function(){
    $(".td-description").each(function(){
        // HTML로 변환: 줄바꿈(\n) → <br>
        var text = $(this).text();
        var html = text.replace(/\r?\n/g, "<br/>");
        $(this).html(html);
    });
});
</script>
</head>
<jsp:include page="../../include/header.jsp"/>
<jsp:include page="../../include/nav.jsp"/>

<h2>관광지 수정</h2>

<form action="/touring/tourAdmin/updateTourOk" method="post" enctype="multipart/form-data"
	 onsubmit="if (!confirm('수정하시겠습니까?')) return false; alert('수정되었습니다!');">
    <table border="1">
        <tr>
            <td>이름</td>
            <td>
		    	<input type="hidden" name="tno" value="${tourVo.tno }">
		    	<input type="text" name="tname" value="${tourVo.tname }" required/>
	    	</td>
        </tr>
        <tr>
            <td>지역</td>
            <td>
		        <select name="tregion" required>
		            <option value="">선택</option>
		            <option value="서울특별시" ${tourVo.tregion == '서울특별시' ? 'selected' : ''}>서울특별시</option>
		            <option value="인천광역시" ${tourVo.tregion == '인천광역시' ? 'selected' : ''}>인천광역시</option>
		            <option value="대전광역시" ${tourVo.tregion == '대전광역시' ? 'selected' : ''}>대전광역시</option>
		            <option value="대구광역시" ${tourVo.tregion == '대구광역시' ? 'selected' : ''}>대구광역시</option>
		            <option value="울산광역시" ${tourVo.tregion == '울산광역시' ? 'selected' : ''}>울산광역시</option>
		            <option value="부산광역시" ${tourVo.tregion == '부산광역시' ? 'selected' : ''}>부산광역시</option>
		            <option value="광주광역시" ${tourVo.tregion == '광주광역시' ? 'selected' : ''}>광주광역시</option>
		            <option value="경상도" ${tourVo.tregion == '경상도' ? 'selected' : ''}>경상도</option>
		            <option value="전라도" ${tourVo.tregion == '전라도' ? 'selected' : ''}>전라도</option>
		            <option value="충청도" ${tourVo.tregion == '충청도' ? 'selected' : ''}>충청도</option>
		            <option value="강원도" ${tourVo.tregion == '강원도' ? 'selected' : ''}>강원도</option>
		        </select>
		    </td>
        </tr> 
        
        <tr>
            <td>주소</td>
            <td><input type="text" name="taddress"  value="${tourVo.taddress }" required/></td>
        </tr>
        
        <tr>
            <td>설명</td>
            <td class="td-description">
				<textarea name="tdescription" rows="5" cols="50"><c:out value='${tourVo.tdescription}' /></textarea>
    		</td>
        </tr>
        <tr>
            <td>카테고리</td>
            <td>
				<select name="tcno" required>
				    <option value="1" ${tourVo.tcno == 1 ? 'selected' : ''}>투어</option>
				    <option value="2" ${tourVo.tcno == 2 ? 'selected' : ''}>박물관, 예술, 문화</option>
				    <option value="3" ${tourVo.tcno == 3 ? 'selected' : ''}>엔터테인먼트 & 티켓</option>
				    <option value="4" ${tourVo.tcno == 4 ? 'selected' : ''}>자연 & 아웃도어</option>
				    <option value="5" ${tourVo.tcno == 5 ? 'selected' : ''}>푸드 & 드링크</option>
				    <option value="6" ${tourVo.tcno == 6 ? 'selected' : ''}>서비스 & 대여</option>
				</select>
            </td>
        </tr>
		<tr>
		    <td>기존 업로드 파일</td>
		    <td>
			    <c:forEach var="file" items="${tourVo.fileDataList}">
			        <div>
			            <a href="${pageContext.request.contextPath}/tourlAdmin/fileData/${file.tfilename}" target="_blank">
			                ${file.toriginal}</a>
			            <label>
			                <input type="checkbox" name="deleteFiles" value="${file.tfno}"/> 삭제
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
		        <input type="submit" value="수정 완료" />
            	<a href="javascript:history.back();"><input type="button" value="뒤로가기"></a>
		    </td>
		</tr>
    </table>
</form>
<jsp:include page="../../include/footer.jsp"/>
</body>
</html>