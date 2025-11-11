<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>にばナビ｜山形観光ポータルサイト</title>
<style>
/* ========== ベース設定 ========== */
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: "メイリオ", "Hiragino Kaku Gothic ProN", sans-serif;
  background-color: #f2f5fa;
  color: #333;
  line-height: 1.6;
}

/* ========== ヘッダー ========== */
header {
  background: linear-gradient(90deg, #003d99, #0059b3);
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 40px;
  box-shadow: 0 3px 6px rgba(0,0,0,0.2);
  position: sticky;
  top: 0;
  z-index: 100;
}

.logo { display: flex; align-items: center; gap: 10px; }
.logo img { height: 45px; filter: drop-shadow(1px 1px 3px rgba(0,0,0,0.3)); }
.logo span { font-size: 1.5em; font-weight: bold; letter-spacing: 1px; }

/* ========== ナビゲーション ========== */
nav { display: flex; align-items: center; gap: 25px; }
nav a {
  color: #fff;
  text-decoration: none;
  font-weight: bold;
  position: relative;
  transition: 0.3s;
}
nav a::after {
  content: "";
  position: absolute;
  width: 0;
  height: 3px;
  bottom: -4px;
  left: 0;
  background-color: #ffcc33;
  transition: width 0.3s;
}
nav a:hover::after { width: 100%; }
nav a:hover { color: #ffcc33; }

.right-menu { display: flex; gap: 10px; }
.btn {
  background-color: #ffcc33;
  border: none;
  color: #003366;
  padding: 8px 14px;
  border-radius: 6px;
  font-weight: bold;
  cursor: pointer;
  transition: 0.3s;
}
.btn:hover { background-color: #ffdb4d; transform: translateY(-2px); }

/* ========== ヒーロースライダー ========== */
.hero {
  position: relative;
  width: 100%;
  height: 70vh;
  overflow: hidden;
}
.hero img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  position: absolute;
  top: 0; left: 0;
  opacity: 0;
  transition: opacity 1.5s ease-in-out;
}
.hero img.active { opacity: 1; }

.hero-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 2.8em;
  letter-spacing: 3px;
  text-shadow: 0 3px 8px rgba(0,0,0,0.6);
  animation: fadeIn 2s ease-in-out;
  z-index: 10;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translate(-50%, -40%); }
  to { opacity: 1; transform: translate(-50%, -50%); }
}

/* ========== イベントカード ========== */
.main-content {
  max-width: 1100px;
  margin: 50px auto;
  text-align: center;
  padding: 0 20px;
}
.main-content h2 {
  color: #004080;
  font-size: 2em;
  margin-bottom: 25px;
}
.card-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 30px;
}
.card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  width: 300px;
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.3s;
}
.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.2);
}
.card img {
  width: 100%;
  height: 180px;
  object-fit: cover;
}
.card h3 {
  margin: 15px 0 8px;
  color: #003366;
}
.card p {
  padding: 0 15px 15px;
  font-size: 0.95em;
  color: #444;
}
.card a {
  display: inline-block;
  background-color: #004080;
  color: white;
  text-decoration: none;
  padding: 8px 14px;
  border-radius: 6px;
  margin-bottom: 18px;
  transition: 0.3s;
}
.card a:hover { background-color: #0073e6; }

/* ========== フッター ========== */
footer {
  background-color: #004080;
  color: white;
  text-align: center;
  padding: 15px;
  margin-top: 60px;
  font-size: 0.9em;
}
</style>
</head>
<body>

<header>
  <div class="logo">
    <img src="../images/logo_nibanavi.png" alt="にばナビ ロゴ">
    <span>にばナビ</span>
  </div>

  <nav>
    <a href="index.jsp">トップ</a>
    <a href="start.jsp">コース</a>
    <a href="#">スポット</a>
    <a href="#">イベント</a>
    <a href="main/souvenir.jsp">お土産紹介</a>
    <a href="main/yamagata.jsp">アクセス情報</a>
    <a href="main/reservation.jsp">宿泊、レンタカー・カーシェア予約</a>
  </nav>

  <div class="right-menu">
    <button class="btn">ログイン</button>
    <button class="btn">メニュー</button>
  </div>
</header>

<!-- ===== ヒーロースライドショー ===== -->
<section class="hero" id="hero">
  <img src="../images/sample1.jpg" alt="山形の風景1" class="active">
  <img src="../images/sample2.jpg" alt="山形の風景2">
  <img src="../images/sample3.jpg" alt="山形の風景3">
  <div class="hero-text">ようこそ、にばナビへ</div>
</section>

<!-- ===== 直近のイベント ===== -->
<section class="main-content">
  <h2>直近のイベント</h2>

  <div class="card-container">
    <div class="card">
      <img src="../images/event1.jpg" alt="世界はとなりやまがたフェス">
      <h3>世界はとなりやまがたフェス</h3>
      <p>10/25（土）＠やまぎん県民ホール広場。多文化ステージ＆多国籍料理で世界とつながる。</p>
      <a href="#">詳しく見る</a>
    </div>

    <div class="card">
      <img src="../images/event2.jpg" alt="全国ぐっと！！餃子まつり">
      <h3>全国ぐっと！！餃子まつり</h3>
      <p>10/24（金）〜27（月）＠道の駅やまがた蔵王。全国の餃子が山形に集結！</p>
      <a href="#">詳しく見る</a>
    </div>

    <div class="card">
      <img src="../images/event3.jpg" alt="やまがた秋の芸術祭">
      <h3>やまがた秋の芸術祭</h3>
      <p>9/1〜11/30＠山形市ほか。音楽やアートで街全体が彩られる文化の秋。</p>
      <a href="#">詳しく見る</a>
    </div>
  </div>
</section>

<footer>
  &copy; 2025 にばナビ All Rights Reserved.
</footer>

<script>
// ===== スライドショー制御 =====
let current = 0;
const slides = document.querySelectorAll('#hero img');
let interval;

function showNext() {
  slides[current].classList.remove('active');
  current = (current + 1) % slides.length;
  slides[current].classList.add('active');
}

function startSlide() { interval = setInterval(showNext, 4000); }
function stopSlide() { clearInterval(interval); }

startSlide();

const hero = document.getElementById('hero');
hero.addEventListener('mouseenter', stopSlide);
hero.addEventListener('mouseleave', startSlide);
</script>

</body>
</html>
