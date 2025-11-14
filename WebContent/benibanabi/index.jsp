<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="../common/base.jsp">
  <c:param name="title" value="にばナビ TOP" />
  <c:param name="content">

<style>
/* ------------------------------
   全体
------------------------------ */
body {
  font-family: "Noto Sans JP", sans-serif;
  margin: 0;
  padding: 0;
}

/* ------------------------------
   HERO（トップの大画像）
------------------------------ */
.hero {
  position: relative;
  width: 100%;
  height: 55vh;
  overflow: hidden;
}
.hero-slide {
  width: 100%;
  height: 55vh;
  position: absolute;
  object-fit: cover;
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
  text-shadow: 0 0 8px rgba(0,0,0,.6);
}

/* ------------------------------
   直近のイベント
------------------------------ */
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
  transition: transform 0.35s, box-shadow 0.35s;
}
.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.18);
}
.card img {
  width: 100%;
  aspect-ratio: 16/10;
  object-fit: cover;
}
.card h3 {
  padding: 15px 18px 5px;
  font-size: 1.3rem;
}
.card p {
  padding: 0 18px 15px;
}

/* ------------------------------
   2カラム スライダー
------------------------------ */
.top-visual-area {
  margin: 50px auto;
  max-width: 1200px;
}
.slider-2col {
  display: flex;
  gap: 20px;
}
.slider-column {
  width: 50%;
  position: relative;
  overflow: hidden;
  border-radius: 15px;
  border: 3px solid #f0f0f0;
  box-shadow: 0 4px 16px rgba(0,0,0,.1);
  background: #fff;
}
.slide-item {
  position: absolute;
  width: 100%;
  opacity: 0;
  transition: opacity 1s ease-in-out;
}
.slide-item.active {
  opacity: 1;
}
.slide-item img {
  width: 100%;
  height: 300px;
  object-fit: cover;
}
.slide-caption {
  position: absolute;
  bottom: 10px;
  left: 15px;
  padding: 6px 12px;
  background: rgba(0,0,0,.55);
  color: #fff;
  border-radius: 6px;
  font-size: 0.95rem;
}

/* ------------------------------
   トピックス
------------------------------ */
.topics-area {
  padding: 50px 25px;
  background: #fafafa;
}
.topics-title {
  font-size: 1.8rem;
  border-left: 7px solid #ff9659;
  padding-left: 15px;
  margin-bottom: 20px;
}
.topics-list {
  list-style: none;
  padding: 0;
  margin: 0;
}
.topic-item {
  display: flex;
  gap: 20px;
  padding: 18px 0;
  border-bottom: 1px solid #e2e2e2;
}
.topic-date {
  font-weight: bold;
  min-width: 90px;
  color: #666;
}
.topic-more {
  color: #007bff;
  font-size: 0.9rem;
  margin-left: 10px;
}
</style>



<!-- ====================== HERO ====================== -->
<section class="hero" id="hero">
  <img src="../images/sample1.jpg" alt="山形の風景1" class="hero-slide active">
  <img src="../images/sample2.jpg" alt="山形の風景2" class="hero-slide">
  <img src="../images/sample3.jpg" alt="山形の風景3" class="hero-slide">

  <div class="hero-text">ようこそ、べにばナビへ</div>
</section>



<!-- ====================== イベント ====================== -->
<section class="main-content">
  <h2>直近のイベント</h2>

  <div class="card-container">
    <div class="card">
      <img src="../images/event1.jpg" alt="">
      <h3>世界はとなりやまがたフェス</h3>
      <p>10/25（土） やまぎん県民ホール広場</p>
    </div>

    <div class="card">
      <img src="../images/event2.jpg" alt="">
      <h3>全国ぐっと！！餃子まつり</h3>
      <p>10/24〜27 道の駅やまがた蔵王</p>
    </div>

    <div class="card">
      <img src="../images/event3.jpg" alt="">
      <h3>やまがた秋の芸術祭</h3>
      <p>9/1〜11/30 @山形市ほか</p>
    </div>
  </div>
</section>



<!-- ====================== 2カラムスライダー ====================== -->
<section class="top-visual-area">
  <div class="slider-2col">

    <!-- 左 -->
    <div class="slider-column" id="leftSlider">
      <c:forEach var="s" items="${leftSlides}" varStatus="st">
        <div class="slide-item ${st.first ? 'active' : ''}">
          <img src="${s.img}" alt="${s.alt}">
          <div class="slide-caption">${s.cap}</div>
        </div>
      </c:forEach>
    </div>

    <!-- 右 -->
    <div class="slider-column" id="rightSlider">
      <c:forEach var="s" items="${rightSlides}" varStatus="st">
        <div class="slide-item ${st.first ? 'active' : ''}">
          <img src="${s.img}" alt="${s.alt}">
          <div class="slide-caption">${s.cap}</div>
        </div>
      </c:forEach>
    </div>

  </div>
</section>



<!-- ====================== トピックス ====================== -->
<section class="topics-area">
  <h2 class="topics-title">直近のイベントトピック</h2>

  <ul class="topics-list">
    <c:forEach var="t" items="${topics}">
      <li class="topic-item">
        <div class="topic-date">${t.date}</div>
        <div class="topic-body">
          ${t.title}
          <span class="topic-more">${t.more}</span>
        </div>
      </li>
    </c:forEach>
  </ul>
</section>



</c:param>
</c:import>
