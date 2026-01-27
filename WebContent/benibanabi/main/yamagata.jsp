<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageContent">
<!DOCTYPE html>
<html lang="ja">



<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>山形への行き方｜べにばナビ</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
<jsp:include page="../../common/header.jsp" />
<div class="tab-container">
  <button class="tab active">山形への行き方</button>
  <button class="tab" onclick="location.href='local.jsp'">現地移動手段</button>
  <button class="tab" onclick="location.href='Souvenir.action'">お土産・名産品</button>
</div>

<main>
  <h2>山形への行き方</h2>
  <p>山形へは、飛行機・新幹線・高速バス・自家用車などの手段でアクセスできます。</p>

  <div class="souvenir-list">

    <!-- 飛行機 -->
    <a href="https://www.yamagata-airport.co.jp/" target="_blank" class="souvenir-item link-card">
      <img src="../../images/airport.jpg" alt="山形空港">
      <h3>✈️ 飛行機</h3>
      <p>羽田空港 ⇔ 山形空港（約1時間）<br>空港から市街地まで車で約30分。</p>
    </a>

    <!-- 新幹線 -->
    <a href="https://www.eki-net.com/" target="_blank" class="souvenir-item link-card">
      <img src="../../images/shinkansen.jpg" alt="山形新幹線">
      <h3>🚄 新幹線</h3>
      <p>東京 ⇔ 山形駅（つばさ号 約2時間30分）<br>乗り換えなしで快適なアクセス。</p>
    </a>

    <!-- 高速バス -->
    <a href="https://www.kousokubus.net/" target="_blank" class="souvenir-item link-card">
      <img src="../../images/bus.jpg" alt="高速バス">
      <h3>🚌 高速バス</h3>
      <p>新宿 ⇔ 山形駅前（約6時間30分）<br>お得な料金で利用可能。夜行便もあり。</p>
    </a>

    <!-- 自家用車 -->
    <a href="https://www.driveplaza.com/" target="_blank" class="souvenir-item link-card">
      <img src="../../images/car.jpg" alt="自家用車">
      <h3>🚗 自家用車</h3>
      <p>東北自動車道 → 山形自動車道で約5時間。<br>ドライブにも最適。</p>
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