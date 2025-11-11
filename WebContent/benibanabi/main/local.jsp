<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>現地移動手段</title>
<link rel="stylesheet" href="../../common/style.css">
</head>
<body>
<header>アクセス情報</header>

<div class="tab-container">
  <button class="tab" onclick="location.href='yamagata.jsp'">山形への行き方</button>
  <button class="tab active">現地移動手段</button>
  <button class="tab" onclick="location.href='souvenir.jsp'">お土産・名産品</button>
</div>

<main>
  <h2>現地移動手段</h2>
  <p>山形県内の主要な交通手段を紹介します。</p>

  <div class="souvenir-list">
    <div class="souvenir-item">
      <img src="../../images/rentalcar.jpg" alt="レンタカー">
      <h3>🚗 レンタカー</h3>
      <p>山形駅や空港で利用可能。主要観光地を巡るのに便利。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/train.jpg" alt="電車">
      <h3>🚃 電車</h3>
      <p>奥羽本線・仙山線などを利用し、主要都市を移動可能。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/bus.jpg" alt="バス">
      <h3>🚌 バス</h3>
      <p>市街地や観光地を結ぶバス網が発達。山交バス・庄内交通が主要。</p>
    </div>
  </div>
</main>
</body>
</html>
