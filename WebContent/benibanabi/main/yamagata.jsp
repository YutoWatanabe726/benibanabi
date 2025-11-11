<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>山形への行き方</title>
<link rel="stylesheet" href="../../common/style.css">
</head>
<body>
<header>アクセス情報</header>

<div class="tab-container">
  <button class="tab active">山形への行き方</button>
  <button class="tab" onclick="location.href='local.jsp'">現地移動手段</button>
  <button class="tab" onclick="location.href='souvenir.jsp'">お土産・名産品</button>
</div>

<main>
  <h2>山形への行き方</h2>
  <p>山形へは、飛行機・新幹線・高速バス・自家用車などの手段でアクセスできます。</p>

  <div class="souvenir-list">
    <div class="souvenir-item">
      <img src="../../images/airport.jpg" alt="山形空港">
      <h3>✈️ 飛行機</h3>
      <p>羽田空港 ⇔ 山形空港（約1時間）<br>JAL便が運航。空港から市街地までは車で約30分。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/shinkansen.jpg" alt="山形新幹線">
      <h3>🚄 新幹線</h3>
      <p>東京 ⇔ 山形駅（つばさ号 約2時間30分）<br>乗り換えなしで快適なアクセスが可能。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/bus.jpg" alt="高速バス">
      <h3>🚌 高速バス</h3>
      <p>新宿 ⇔ 山形駅前（約6時間30分）<br>お得な料金で利用可能。夜行便もあり。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/car.jpg" alt="自家用車">
      <h3>🚗 自家用車</h3>
      <p>東北自動車道 → 山形自動車道経由で約5時間。<br>ドライブに最適なルートです。</p>
    </div>
  </div>
</main>
</body>
</html>
