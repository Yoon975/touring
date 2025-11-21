<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로딩중</title>
</head>
<body>
<script>
    alert('${msg}');
    location.href='${pageContext.request.contextPath}${url}';
</script>

</body>
</html>