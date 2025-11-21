<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 내역</title>
<link rel="stylesheet" href="<c:url value='/resources/css/myReviewList.css' />">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>

<h2 class="page-title">
  ${sessionScope.loginSession.name}님이 작성한 리뷰 ${reviewList.size()}개
</h2>

<div class="review-container">
  <table class="review-table">
    <tr>
        <th>리뷰번호</th>
        <th>호텔명</th>
        <th>내용</th>
        <th>평점</th>
        <th>작성일</th>
        <th>수정 / 삭제</th>
    </tr>

    <c:if test="${empty reviewList}">
      <tr>
          <td colspan="6">작성된 리뷰가 없습니다.</td>
      </tr>
    </c:if>

    <c:forEach var="review" items="${reviewList}">
      <tr>
          <td><a href="${pageContext.request.contextPath}/reserve/detail?dno=${review.dno}">${review.rno}</a></td>
          <td><a href="${pageContext.request.contextPath}/hotelUser/detailHotelUser?hno=${review.hno}">${review.hname}</a></td>
          <td>${review.content}</td>
          <td>${review.rating}</td>
          <td>${review.createdAt}</td>
          <td>
            <c:choose>
               <c:when test="${review.canUpdateReview}">
                    <a href="<c:url value='/review/update?rno=${review.rno}' />">리뷰 수정</a>
               </c:when>
               <c:otherwise>수정 불가</c:otherwise>
            </c:choose>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="<c:url value='/review/delete?rno=${review.rno}' />"
               onclick="return confirm('정말 삭제하시겠습니까?');">리뷰 삭제</a>
          </td>
      </tr>
    </c:forEach>
  </table>

  <a href="javascript:history.back();">
    <input type="button" value="뒤로가기">
  </a>
</div>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
