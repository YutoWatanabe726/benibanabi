<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="../common/base.jsp">
  <c:param name="title" value="べにばナビ TOP" />
  <c:param name="content">

<style>

/* ===== HERO（スライドショー）===== */
.hero {
  position: relative;
  width: 100%;
  height: 85vh;
  overflow: hidden;
  border-radius: 0 0 40px 40px;
}

.hero-slide {
  width: 100%;
  height: 100%;
  object-fit: cover;
  position: absolute;
  opacity: 0;
  transition: opacity 1.2s ease-in-out;
  filter: brightness(0.75);
}
.hero-slide.active { opacity: 1; }

/* 薄い紅花グラデ */
.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, rgba(217,41,41,0.28), rgba(255,255,255,0));
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
  text-shadow: 0 0 22px rgba(0,0,0,0.55);
}
.hero-content p {
  font-size: 1.25rem;
  margin-top: 10px;
}
.hero-btn {
  display: inline-block;
  margin-top: 24px;
  padding: 14px 34px;
  background: linear-gradient(90deg, #FFB35E, #D92929);
  color: white;
  border-radius: 50px;
  font-weight: 700;
  font-size: 1.15rem;
  text-decoration: none;
  box-shadow: 0 10px 22px rgba(217,41,41,0.35);
  transition: 0.3s;
}
.hero-btn:hover {
  transform: translateY(-4px);
  box-shadow: 0 14px 32px rgba(217,41,41,0.48);
}

/* 花びら */
.petal {
  position: absolute;
  top: -50px;
  width: 28px;
  opacity: 0.9;
  pointer-events: none;
  z-index: 12;
}

@keyframes petalFall {
  0% { transform: translateY(-20px) rotate(0deg); opacity: 0; }
  15% { opacity: 1; }
  50% { transform: translateY(400px) rotate(200deg); opacity: 0.9; }
  100% { transform: translateY(850px) rotate(360deg); opacity: 0; }
}

/* ===== スクロールアニメ ===== */
.fade-up {
  opacity: 0;
  transform: translateY(24px);
  transition: all .9s cubic-bezier(.17,.67,.2,1);
}
.fade-left {
  opacity: 0;
  transform: translateX(-40px);
  transition: all .9s cubic-bezier(.17,.67,.2,1);
}
.fade-right {
  opacity: 0;
  transform: translateX(40px);
  transition: all .9s cubic-bezier(.17,.67,.2,1);
}
.show {
  opacity: 1;
  transform: translate(0,0);
}

</style>


<!-- ================= HERO ================= -->
<section class="hero">
  <img src="../images/9_倉津川の桜2.jpg"  class="hero-slide active">
  <img src="../images/1674_飛島の海岸.jpg" class="hero-slide">
  <img src="../images/199_月山遠景.jpg"   class="hero-slide">
  <img src="../images/110_銀山温泉4.jpg" class="hero-slide">

  <div class="hero-overlay"></div>

  <div class="hero-content fade-left">
    <h1>紅花が彩る、山形の旅。</h1>
    <p>伝統 × 自然 × 食 × 温泉 —— もう一歩ふかく。</p>
    <a href="<c:url value='/benibanabi/start.jsp'/>" class="hero-btn">コースを作成する</a>
  </div>

  <!-- 花びら -->
  <img class="petal" style="left:10%; animation:petalFall 9s linear infinite;">
  <img class="petal" style="left:25%; animation:petalFall 10s linear infinite 1s;">
  <img class="petal" style="left:40%; animation:petalFall 11s linear infinite 0.5s;">
  <img class="petal" style="left:55%; animation:petalFall 9.5s linear infinite 2s;">
  <img class="petal" style="left:70%; animation:petalFall 12s linear infinite 1s;">
  <img class="petal" style="left:85%; animation:petalFall 8s linear infinite 0.3s;">
</section>


<script>
const slides = document.querySelectorAll(".hero-slide");
let current = 0;
const seasons = ["spring","summer","autumn","winter"];
const petalImg = {
  spring: "../images/petal_sakura.png",
  summer: "../images/benibana.png",
  autumn: "../images/petal_maple.png",
  winter: "../images/petal_snow.png"
};
function showSlide(){
  slides[current].classList.remove("active");
  current = (current + 1) % slides.length;
  slides[current].classList.add("active");
  changeSeason(seasons[current]);
}
function changeSeason(season){
  document.querySelectorAll(".petal").forEach(p=>p.src = petalImg[season]);
}
changeSeason(seasons[0]);
setInterval(showSlide, 4500);
</script>


<!-- ================= イベント ================= -->
<h2 class="section-title fade-left">直近のイベント</h2>

<div class="event-list">
  <div class="event-item fade-up" style="transition-delay:0s">
    <h3>世界はとなりやまがたフェス</h3>
    <p>10/25（土）＠やまぎん県民ホール広場</p>
  </div>

  <div class="event-item fade-up" style="transition-delay:0.1s">
    <h3>全国ぐっと！！餃子まつり</h3>
    <p>10/24〜27＠道の駅やまがた蔵王</p>
  </div>

  <div class="event-item fade-up" style="transition-delay:0.2s">
    <h3>やまがた秋の芸術祭</h3>
    <p>9/1〜11/30＠山形市ほか</p>
  </div>
</div>


<!-- ================= トピックス ================= -->
<h2 class="section-title fade-left">最新トピックス</h2>

<div class="topic-item fade-right" style="transition-delay:0s">
  <div class="topic-meta">2025.11.12 — 大蔵村</div>
  <div class="topic-title">【イベント】高円寺で「やまがた村祭り」を開催</div>
</div>

<div class="topic-item fade-right" style="transition-delay:0.12s">
  <div class="topic-meta">2025.05.19 — 山形県観光文化協会</div>
  <div class="topic-title">【動画公開】山形旅番組を YouTube にて配信中</div>
</div>


  </c:param>
</c:import>
