<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="../common/base.jsp">
  <c:param name="title" value="べにばナビ TOP" />
  <c:param name="content">

<style>

/* =====================================================
      HERO（紅花 × スライドショー）
===================================================== */
.hero {
  position: relative;
  width: 100%;
  height: 85vh;
  overflow: hidden;
  border-radius: 0 0 40px 40px;
}

/* スライド画像 */
.hero-slide {
  width: 100%;
  height: 100%;
  object-fit: cover;
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
  transition: opacity 1.2s ease-in-out;
  filter: brightness(0.75);
}
.hero-slide.active {
  opacity: 1;
}

/* 紅花オーバーレイ */
.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, rgba(217,41,41,0.35), rgba(255,255,255,0));
  z-index: 3;
}

/* HERO テキスト */
.hero-content {
  position: absolute;
  bottom: 18%;
  left: 8%;
  color: #fff;
  z-index: 10;
}
.hero-content h1 {
  font-size: 3.2rem;
  font-weight: 900;
  text-shadow: 0 0 20px rgba(0,0,0,0.5);
}
.hero-content p {
  font-size: 1.25rem;
  margin-top: 12px;
}
.hero-btn {
  display: inline-block;
  margin-top: 25px;
  padding: 14px 34px;
  background: linear-gradient(90deg, #FFB35E, #D92929);
  color: #fff;
  border-radius: 50px;
  font-size: 1.2rem;
  font-weight: 700;
  text-decoration: none;
  box-shadow: 0 10px 22px rgba(217,41,41,0.35);
  transition: 0.3s;
}
.hero-btn:hover {
  transform: translateY(-4px);
  box-shadow: 0 14px 28px rgba(217,41,41,0.48);
}

/* =====================================================
      花びらゆらゆら アニメーション
===================================================== */
@keyframes petalFall {
  0% {
    transform: translateY(-20px) translateX(0px) rotate(0deg);
    opacity: 0;
  }
  15% { opacity: 1; }
  30% {
    transform: translateY(200px) translateX(-30px) rotate(60deg);
  }
  50% {
    transform: translateY(400px) translateX(20px) rotate(160deg);
  }
  80% {
    transform: translateY(600px) translateX(-15px) rotate(260deg);
    opacity: 0.8;
  }
  100% {
    transform: translateY(850px) translateX(0px) rotate(360deg);
    opacity: 0;
  }
}

.petal {
  position: absolute;
  top: -50px;
  width: 28px;
  opacity: 0.9;
  z-index: 12;
  pointer-events: none;
}

/* =====================================================
      セクションタイトル
===================================================== */
.section-title {
  font-size: 2rem;
  margin: 60px 0 25px;
  padding-left: 18px;
  border-left: 8px solid #FF7A45;
  font-weight: 800;
  color: #333;
}

/* =====================================================
      イベントカード
===================================================== */
.event-list {
  display: grid;
  gap: 25px;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
}
.event-item {
  background: #fff;
  border-radius: 16px;
  border-top: 6px solid #D92929;
  padding: 22px;
  box-shadow: 0 4px 14px rgba(0,0,0,0.1);
  transition: 0.3s;
}
.event-item:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 26px rgba(217,41,41,0.22);
}
.event-item h3 {
  color: #D92929;
}

/* =====================================================
      トピックス
===================================================== */
.topic-item {
  background: #fff;
  padding: 18px 16px;
  border-left: 5px solid #FF7A45;
  margin-bottom: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.05);
  transition: 0.2s;
}
.topic-item:hover {
  background: #fff5f1;
  transform: translateX(6px);
}
.topic-meta {
  font-size: 0.9rem;
  color: #777;
}
.topic-title {
  font-size: 1.1rem;
  font-weight: 700;
}

</style>



<!-- =====================================================
      HERO（スライドショー）
===================================================== -->
<section class="hero">

  <!-- スライド画像 -->
  <img src="../images/9_倉津川の桜2.jpg"  class="hero-slide active">
  <img src="../images/1674_飛島の海岸.jpg" class="hero-slide">
  <img src="../images/199_月山遠景.jpg"   class="hero-slide">
  <img src="../images/110_銀山温泉4.jpg" class="hero-slide">

  <div class="hero-overlay"></div>

  <div class="hero-content">
    <h1>紅花が彩る、山形の旅。</h1>
    <p>伝統 × 自然 × 食 × 温泉　もう一歩ふかく。</p>
    <a href="<c:url value='/benibanabi/start.jsp' />" class="hero-btn">コースを作成する</a>
  </div>

  <!-- 花びら（位置＆遅延はランダム） -->
  <img class="petal" style="left:10%; animation:petalFall 9s linear infinite 0s;">
  <img class="petal" style="left:25%; animation:petalFall 10s linear infinite 1s;">
  <img class="petal" style="left:40%; animation:petalFall 11s linear infinite 0.5s;">
  <img class="petal" style="left:55%; animation:petalFall 9.5s linear infinite 2s;">
  <img class="petal" style="left:70%; animation:petalFall 12s linear infinite 1s;">
  <img class="petal" style="left:85%; animation:petalFall 8s linear infinite 0.3s;">

</section>



<!-- =====================================================
      スライド × 季節別エフェクト 自動切替 JS
===================================================== -->
<script>
  const slides = document.querySelectorAll(".hero-slide");
  let current = 0;

  // スライド → 季節 対応（あなたの画像に合わせてある）
  const slideSeasons = [
    "spring", // 桜
    "summer", // 飛島の海
    "autumn", // 月山
    "winter"  // 銀山温泉
  ];

  // 季節別 花びら画像
  const petalImgs = {
    spring: "../images/petal_sakura.png",
    summer: "../images/benibana.png",
    autumn: "../images/petal_maple.png",
    winter: "../images/petal_snow.png"
  };

  // スライド切り替え
  function showSlide() {
    slides[current].classList.remove("active");
    current = (current + 1) % slides.length;
    slides[current].classList.add("active");

    changeSeasonEffect(slideSeasons[current]);
  }

  // 季節に合わせて花びら画像を全て変更
  function changeSeasonEffect(season) {
    const petals = document.querySelectorAll(".petal");
    petals.forEach(p => {
      p.src = petalImgs[season];
    });
  }

  // 初期状態：春
  changeSeasonEffect(slideSeasons[0]);

  // 4.5秒ごとにスライド切り替え
  setInterval(showSlide, 4500);
</script>



<!-- =====================================================
      イベント
===================================================== -->
<h2 class="section-title">直近のイベント</h2>

<div class="event-list">
  <div class="event-item">
    <h3>世界はとなりやまがたフェス</h3>
    <p>10/25（土）＠やまぎん県民ホール広場</p>
  </div>

  <div class="event-item">
    <h3>全国ぐっと！！餃子まつり</h3>
    <p>10/24〜27＠道の駅やまがた蔵王</p>
  </div>

  <div class="event-item">
    <h3>やまがた秋の芸術祭</h3>
    <p>9/1〜11/30＠山形市ほか</p>
  </div>
</div>


<!-- =====================================================
      トピックス
===================================================== -->
<h2 class="section-title">最新トピックス</h2>

<div class="topic-item">
  <div class="topic-meta">2025.11.12 — 大蔵村</div>
  <div class="topic-title">【イベント】高円寺で「やまがた村祭り」を開催</div>
</div>

<div class="topic-item">
  <div class="topic-meta">2025.05.19 — 山形県観光文化協会</div>
  <div class="topic-title">【動画公開】山形旅番組を YouTube にて配信中</div>
</div>


</c:param>
</c:import>
