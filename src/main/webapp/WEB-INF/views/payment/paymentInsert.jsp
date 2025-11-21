<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 페이지</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/reserveInsert.css'/>">
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/nav.jsp"/>
<div class="reserve-insert">
<h2>결제하기</h2>
</div>

<form action="${pageContext.request.contextPath}/payment/insertOk" method="post" onsubmit="return confirm('결제하시겠습니까?');">
    <input type="hidden" name="hno" value="${hno}">
    <input type="hidden" name="hname" value="${hname}">
    <input type="hidden" name="hprice" value="${hprice}">
    <input type="hidden" name="checkin" value="${checkin}">
    <input type="hidden" name="checkout" value="${checkout}">
    <input type="hidden" name="status" value="결제완료">

    <p>
        <label>호텔명</label><br>
        <input type="text" class="form-control" value="${hname}" readonly>
    </p>

    <p>
        <label>체크인 / 체크아웃</label><br>
        <input type="text" class="form-control" value="${checkin} ~ ${checkout}" readonly>
    </p>

    <p>
        <label>결제 금액</label><br>
        <input type="text" class="form-control" value="${hprice} 원" readonly>
    </p>

    <p>
        <label>결제 수단</label><br>
        <select name="method" class="form-select" required>
            <option value="">-- 결제 수단 선택 --</option>
            <option value="카드">카드결제</option>
            <option value="현금">계좌이체</option>
            <option value="간편결제">간편결제 (카카오페이 등)</option>
        </select>
    </p>

    <p style="text-align: center;">
        <button type="submit" class="btn btn-primary">결제하기</button>
        <button type="button" class="btn btn-secondary" onclick="history.back()">뒤로가기</button>
    </p>
</form>

<jsp:include page="../include/footer.jsp"/>
</body>
</html>
