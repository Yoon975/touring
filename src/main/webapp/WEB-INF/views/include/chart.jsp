<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>추천지역 차트</title>
<link rel="stylesheet" href="<c:url value='/resources/css/header.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/nav.css' />">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    font-family: 'Pretendard', sans-serif;
    background-color: #f5f7fa;
    margin: 0;
}
.chart-container {
    width: 80%;
    max-width: 900px;
    margin: 100px auto;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    padding: 30px;
}
h2 {
    text-align: center;
    color: #333;
    margin-bottom: 30px;
}
#mainChart {
    width: 100%;
    height: 400px;
}
</style>
</head>
<body>
<jsp:include page="header.jsp"/>
<jsp:include page="nav.jsp"/>

<div class="chart-container">
    <h2>지역별 방문객 순위</h2>
    <canvas id="mainChart"></canvas>
</div>

<script>
window.onload = async function() {
    try {
        const response = await fetch('<c:url value="/top9api" />');
        const data = await response.json();

        const labels = data.map(item => item["시도명"]);
        const values = data.map((_, idx) => data.length - idx);

        const ctx = document.getElementById('mainChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '방문객 순위 (낮을수록 상위)',
                    data: values,
                    backgroundColor: 'rgba(54,162,235,0.6)',
                    borderColor: 'rgba(54,162,235,1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const rank = context.dataIndex + 1;
                                return rank + "위 " + context.label;
                            }
                        }
                    }
                },
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: '순위' } },
                    x: { title: { display: true, text: '지역명' } }
                }
            }
        });
    } catch (err) {
        console.error("차트 데이터 로드 실패:", err);
    }
};
</script>
<jsp:include page="footer.jsp"/>
</body>
</html>
