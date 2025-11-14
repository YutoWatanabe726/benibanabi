<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<c:import url="../common/base.jsp">
  <c:param name="title" value="べにばナビ TOP" />
  <c:param name="content">

<style>

/* ======================
   HERO（スライドショー）
====================== */
.hero {
  position: relative;
  width: 100%;
  height: 55vh;
  overflow: hidden;
}

.hero-slide {
  width: 100%;
  height: 55vh;
  object-fit: cover;
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
  transition: opacity 1.2s ease-in-out;
}

.hero-slide.active {
  opacity: 1;
}

.hero-text {
  position: absolute;
  bottom: 10%;
  left: 5%;
  font-size: 2.8rem;
  color: #fff;
  font-weight: 700;
  text-shadow: 0 0 8px rgba(0,0,0,.7);
}

/* ======================
   イベントカード
====================== */
.main-content {
  padding: 40px 30px;
}

.main-content h2 {
  font-size: 2.2rem;
  border-left: 8px solid #ff6f61;
  padding-left: 15px;
  margin-bottom: 25px;
}

.card-container {
  display: grid;
  gap: 25px;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
}

.card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 14px rgba(0,0,0,0.12);
  transition: 0.35s;
  padding: 20px;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.18);
}

/* ======================
   トピックス（Topics）
====================== */

.topics-wrapper {
  max-width: 1100px;
  margin: 40px auto 80px;
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.topic-item {
  display: grid;
  grid-template-columns: 70px 1fr 40px;
  align-items: center;
  padding: 18px 10px;
  border-bottom: 1px solid #ddd;
  cursor: pointer;
  transition: background 0.2s;
}

.topic-item:hover {
  background: #fafafa;
}

/* 左の丸アイコン */
.topic-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #f2f2f2;
}

.topic-icon img {
  width: 70%;
  opacity: 0.9;
}

/* メタ情報 */
.topic-meta {
  font-size: 0.9rem;
  color: #666;
  margin-bottom: 3px;
}

.topic-meta .date {
  color: #666;
}

.topic-meta .label {
  display: inline-block;
  font-size: 0.75rem;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 700;
  margin-left: 6px;
}

.label.new {
  background: #ff4f6e;
  color: #fff;
}

.label.check {
  background: #ffb3b3;
  color: #fff;
}

.topic-meta .category {
  margin-left: 6px;
  color: #999;
}

/* タイトル */
.topic-title {
  font-size: 1.1rem;
  font-weight: 600;
  line-height: 1.4;
  color: #333;
}

/* 矢印 */
.topic-arrow {
  font-size: 1.4rem;
  color: #20a0ff;
  font-weight: bold;
  text-align: center;
  transition: transform 0.2s;
}

.topic-item:hover .topic-arrow {
  transform: translateX(4px);
}

@media (max-width: 650px) {
  .topic-item {
    grid-template-columns: 50px 1fr 30px;
    padding: 15px 5px;
  }

  .topic-icon {
    width: 50px;
    height: 50px;
  }

  .topic-title {
    font-size: 1rem;
  }
}

</style>


<!-- ======================
      HERO（スライドショー）
====================== -->
<section class="hero" id="hero">
  <img src="../images/9_倉津川の桜2.jpg" alt="山形の風景1" class="hero-slide active">
  <img src="../images/1674_飛島の海岸.jpg" alt="山形の風景2" class="hero-slide">
  <img src="../images/199_月山遠景.jpg" alt="山形の風景3" class="hero-slide">
  <img src="../images/110_銀山温泉4.jpg" alt="山形の風景4" class="hero-slide">

  <div class="hero-text">ようこそ、べにばナビへ</div>
</section>


<!-- ======================
      イベント
====================== -->
<section class="main-content">
  <h2>直近のイベント</h2>

  <div class="card-container">
    <div class="card">
      <h3>世界はとなりやまがたフェス</h3>
      <p>10/25（土）＠やまぎん県民ホール広場</p>
    </div>

    <div class="card">
      <h3>全国ぐっと！！餃子まつり</h3>
      <p>10/24〜27＠道の駅やまがた蔵王</p>
    </div>

    <div class="card">
      <h3>やまがた秋の芸術祭</h3>
      <p>9/1〜11/30＠山形市ほか</p>
    </div>
  </div>
</section>


<!-- ======================
      トピックス（Topics）
====================== -->
<section class="topics-wrapper">

  <!-- 1 -->
  <div class="topic-item">
    <div class="topic-icon">
      <img src="../images/icon_info.png">
    </div>

    <div class="topic-text">
      <div class="topic-meta">
        <span class="date">2025.11.12</span>
        <span class="label new">NEW</span>
        <span class="category">— 大蔵村 —</span>
      </div>
      <div class="topic-title">
        【イベント情報】東京の高円寺で「やまがた村祭り」を開催します
      </div>
    </div>

    <div class="topic-arrow">→</div>
  </div>

  <!-- 2 -->
  <div class="topic-item">
    <div class="topic-icon">
      <img src="../images/icon_youtube.png">
    </div>

    <div class="topic-text">
      <div class="topic-meta">
        <span class="date">2022.05.19</span>
        <span class="label check">CHECK</span>
        <span class="category">— 山形県観光文化協会 —</span>
      </div>
      <div class="topic-title">
        【動画配信】ワクワク！やまがた旅番組をYouTubeで配信中！
      </div>
    </div>

    <div class="topic-arrow">→</div>
  </div>

</section>


<!-- ======================
      スライドショー JavaScript
====================== -->
<script>
  let current = 0;
  const slides = document.querySelectorAll(".hero-slide");

  function showSlide() {
    slides[current].classList.remove("active");
    current = (current + 1) % slides.length;
    slides[current].classList.add("active");
  }

  setInterval(showSlide, 4000);
</script>

</c:param>
</c:import>
