<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageContent">
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>現地移動手段｜べにばナビ</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<div class="tab-container">
  <button class="tab" onclick="location.href='yamagata.jsp'">山形への行き方</button>
  <button class="tab active">現地移動手段</button>
  <button class="tab" onclick="location.href='Souvenir.action'">お土産・名産品</button>
</div>

<main>
  <h2>現地移動手段</h2>
  <p>山形県内の主要な交通手段を紹介します。</p>

  <div class="souvenir-list">

    <!-- レンタカー -->
    <a href="http://localhost:8080/benibanabi/benibanabi/main/reservation.jsp"
       target="_blank" class="link-card">
      <div class="souvenir-item">
        <img src="../../images/NSX.jpg" alt="レンタカー">
        <h3>🚗 レンタカー</h3>
        <p>山形駅や空港で利用可能。主要観光地を巡るのに便利。</p>
      </div>
    </a>

    <!-- 電車 -->
    <a href="https://www.navitime.co.jp/diagram/area/06/"
       target="_blank" class="link-card">
      <div class="souvenir-item">
        <img src="../../images/train.png" alt="電車">
        <h3>🚃 電車</h3>
        <p>奥羽本線・仙山線などを利用し、主要都市を移動可能。</p>
      </div>
    </a>

    <!-- バス -->
    <a href="https://www.yamakobus.jp/"
       target="_blank" class="link-card">
      <div class="souvenir-item">
        <img src="../../images/bus.jpg" alt="バス">
        <h3>🚌 バス</h3>
        <p>市街地や観光地を結ぶバス網が発達。山交バス・庄内交通が主要。</p>
      </div>
    </a>

  </div>
</main>

</body>
</html>
</c:set>
<c:import url="/common/base.jsp">
  <c:param name="title" value="四季の名産品｜べにばナビ" />
  <c:param name="content" value="${pageContent}" />
</c:import>
