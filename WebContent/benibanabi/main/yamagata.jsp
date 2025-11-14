<%@ page contentType="text/html; charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>山形への行き方｜べにばナビ</title>
<link rel="stylesheet" href="../../common/style.css">

<style>
/* ========== 全体 ========== */
body {
  font-family: "Noto Sans JP", sans-serif;
  background: #fafafa;
  margin: 0;
  padding: 0;
}

/* ↓↓↓ ここからはあなたが既に作ったデザイン ↓↓↓ */

.tab-container {
  display: flex;
  justify-content: center;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  margin-bottom: 25px;
}

.tab {
  padding: 14px 30px;
  border: none;
  background: none;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: 0.3s;
  color: #555;
}

.tab:hover {
  color: #d94c4c;
}

.tab.active {
  border-bottom: 3px solid #d94c4c;
  color: #d94c4c;
}

/* コンテンツ部分 */
main {
  max-width: 1000px;
  margin: 0 auto;
  padding: 10px 20px 40px;
}

main h2 {
  font-size: 1.8rem;
  border-left: 8px solid #ff7a45;
  padding-left: 15px;
  margin-bottom: 15px;
  font-weight: 700;
}

main p {
  font-size: 1rem;
  margin-bottom: 25px;
  line-height: 1.8;
  color: #444;
}

.souvenir-list {
  display: grid;
  gap: 25px;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
}

.souvenir-item {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 4px 14px rgba(0,0,0,0.1);
  overflow: hidden;
  transition: 0.35s;
}

.souvenir-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 22px rgba(0,0,0,0.15);
}

.souvenir-item img {
  width: 100%;
  height: 180px;
  object-fit: cover;
}

.souvenir-item h3 {
  font-size: 1.3rem;
  padding: 15px;
  margin: 0;
  color: #d94c4c;
}

.souvenir-item p {
  padding: 0 15px 20px;
  margin: 0;
  color: #555;
  line-height: 1.7;
}

/* スマホ */
@media (max-width: 600px) {
  .tab { padding: 12px 20px; font-size: 0.9rem; }
  .souvenir-item img { height: 150px; }
}
</style>
</head>

<body>

<!-- ★ 共通ヘッダーをここに読み込む！ -->
<jsp:include page="../../common/header.jsp" />

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
      <p>羽田空港 ⇔ 山形空港（約1時間）<br>空港から市街地まで車で約30分。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/shinkansen.jpg" alt="山形新幹線">
      <h3>🚄 新幹線</h3>
      <p>東京 ⇔ 山形駅（つばさ号 約2時間30分）<br>乗り換えなしで快適なアクセス。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/bus.jpg" alt="高速バス">
      <h3>🚌 高速バス</h3>
      <p>新宿 ⇔ 山形駅前（約6時間30分）<br>お得な料金で利用可能。夜行便もあり。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/car.jpg" alt="自家用車">
      <h3>🚗 自家用車</h3>
      <p>東北自動車道 → 山形自動車道で約5時間。<br>ドライブにも最適。</p>
    </div>

  </div>
</main>

</body>
</html>
