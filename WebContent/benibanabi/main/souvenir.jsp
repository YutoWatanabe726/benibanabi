<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageContent">
  <style>
  /* ===== 動く背景 ===== */
  .season-wrapper {
    position: relative;
    margin: 24px auto;
    max-width: 1200px;
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 12px 30px rgba(0,0,0,0.18);
    background: #000;
  }

  .season-bg-video {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    filter: brightness(0.7);
    z-index: 1;
  }

  .season-inner {
    position: relative;
    z-index: 3;
    padding: 30px 24px 40px;
    background: linear-gradient(
      to bottom,
      rgba(0,0,0,0.35),
      rgba(0,0,0,0.4),
      rgba(0,0,0,0.3)
    );
  }

  /* ===== 花びら ===== */
  .petal {
    position: absolute;
    top: -50px;
    width: 30px;
    pointer-events: none;
    opacity: 0.9;
    z-index: 2;
    animation: petalFall 10s linear infinite;
  }

  @keyframes petalFall {
    0%   { transform: translateY(-30px) rotate(0deg); opacity: 0; }
    20%  { opacity: 1; }
    100% { transform: translateY(900px) rotate(360deg); opacity: 0; }
  }

  /* ===== サウンド ===== */
  .sound-toggle {
    position: absolute;
    right: 18px;
    top: 18px;
    z-index: 4;
    padding: 6px 14px;
    border-radius: 999px;
    background: rgba(0,0,0,0.45);
    color: #fff;
    font-size: 0.85rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
    backdrop-filter: blur(6px);
  }

  /* ===== 四季タブ ===== */
  .season-tabs {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-bottom: 20px;
  }

  .season-tab {
    padding: 10px 22px;
    border-radius: 999px;
    border: none;
    font-weight: 700;
    cursor: pointer;
    transition: 0.3s;
    font-size: 0.98rem;
    white-space: nowrap;
    color: #555;
    background: #f2f2f2;
    text-decoration: none;
  }

  .season-tab:hover { background: #ffe1d2; }

  .season-tab.active {
    background: linear-gradient(90deg, #FFB35E, #D92929);
    box-shadow: 0 6px 18px rgba(0,0,0,0.35);
    color: #fff;
  }

  main h2 {
    color: #fff;
    margin-bottom: 8px;
  }

  .season-message {
    color: #fff;
    font-size: 1.05rem;
    margin-bottom: 26px;
  }

  /* ===== 名産品 ===== */
  .souvenir-list {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
  }

  .souvenir-item p {
    text-align: left;
  }

  @media (max-width: 1000px) {
    .souvenir-list {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  @media (max-width: 600px) {
    .souvenir-list {
      grid-template-columns: 1fr;
    }
  }
  @media (max-width: 600px) {
  .sound-toggle {
    top: auto;
    bottom: 16px;
    right: 16px;
    font-size: 0.8rem;
    padding: 6px 12px;
  }
}

  </style>

  <!-- 上部タブ -->
  <div class="tab-container">
    <button class="tab" onclick="location.href='yamagata.jsp'">山形への行き方</button>
    <button class="tab" onclick="location.href='local.jsp'">現地移動手段</button>
    <button class="tab active">お土産・名産品</button>
  </div>

  <div class="season-wrapper">

    <video id="bgVideo" class="season-bg-video" autoplay muted loop playsinline></video>

    <img class="petal" style="left:12%;">
    <img class="petal" style="left:32%; animation-delay:1s;">
    <img class="petal" style="left:55%; animation-delay:2s;">
    <img class="petal" style="left:78%; animation-delay:.5s;">
    <img class="petal" style="left:90%; animation-delay:1.8s;">

    <div class="sound-toggle" onclick="toggleSound()">
      <span id="soundIcon">🔊</span>
      <span id="soundLabel">サウンドON</span>
    </div>
    <audio id="bgAudio" loop></audio>

    <div class="season-inner">

      <div class="season-tab-row fade-up">
        <div class="season-tabs">
          <a class="season-tab ${season=='春' ? 'active' : ''}" href="Souvenir.action?season=春">春</a>
          <a class="season-tab ${season=='夏' ? 'active' : ''}" href="Souvenir.action?season=夏">夏</a>
          <a class="season-tab ${season=='秋' ? 'active' : ''}" href="Souvenir.action?season=秋">秋</a>
          <a class="season-tab ${season=='冬' ? 'active' : ''}" href="Souvenir.action?season=冬">冬</a>
        </div>
      </div>

      <main class="fade-up">
        <h2 class="fade-left">${season}の名産品</h2>

        <p class="season-message fade-left">
          <c:choose>
            <c:when test="${season=='春'}">芽吹きの季節に広がる、山形らしい春の美味しさ。</c:when>
            <c:when test="${season=='夏'}">最上川の風と夏空が育てた、山形ならではの美味しさ。</c:when>
            <c:when test="${season=='秋'}">実りの季節がもたらす、山形の豊かな味覚</c:when>
            <c:when test="${season=='冬'}">雪国の寒さが引き出す、山形の奥深い美味しさ。</c:when>
          </c:choose>
        </p>

        <div class="souvenir-list">
          <c:forEach var="s" items="${souvenirList}">
            <div class="souvenir-item fade-up">
              <img src="${pageContext.request.contextPath}${s.souvenirPhoto}">
              <h3>${s.souvenirName}</h3>
              <p>${s.souvenirContent}</p>
            </div>
          </c:forEach>
        </div>

        <c:if test="${empty souvenirList}">
          <p class="no-data">表示する名産品がありません。</p>
        </c:if>
      </main>

    </div>
  </div>

<script>
  const seasonMedia = {
    "春": { video: "../../souvenvideo/spring.mp4", audio: "../../souvenaudio/spring_nature.mp3", petal: "../../souvenirdropimages/petal_sakura.png" },
    "夏": { video: "../../souvenvideo/summer.mp4", audio: "../../souvenaudio/summer_sea.mp3", petal: "../../souvenirdropimages/benibana.png" },
    "秋": { video: "../../souvenvideo/autumn.mp4", audio: "../../souvenaudio/autumn_forest.mp3", petal: "../../souvenirdropimages/petal_maple.png" },
    "冬": { video: "../../souvenvideo/winter.mp4", audio: "../../souvenaudio/winter_snow.mp3", petal: "../../souvenirdropimages/petal_snow.png" }
  };

  const current = "${season}";
  const bgVideo = document.getElementById("bgVideo");
  const bgAudio = document.getElementById("bgAudio");
  const petals = document.querySelectorAll(".petal");
  const soundIcon = document.getElementById("soundIcon");
  const soundLabel = document.getElementById("soundLabel");

  if (seasonMedia[current]) {
    bgVideo.src = seasonMedia[current].video;
    bgAudio.src = seasonMedia[current].audio;
    petals.forEach(p => p.src = seasonMedia[current].petal);
  }

  // ▼ サウンド状態を復元（デフォルトON）
  let soundOn = sessionStorage.getItem("soundOn");
  soundOn = soundOn === null ? true : soundOn === "true";

  function applySoundState() {
    if (soundOn) {
      bgAudio.play().catch(()=>{});
      soundIcon.textContent = "🔊";
      soundLabel.textContent = "サウンドON";
    } else {
      bgAudio.pause();
      soundIcon.textContent = "🔇";
      soundLabel.textContent = "サウンドOFF";
    }
  }

  window.addEventListener("DOMContentLoaded", () => {
    applySoundState();

    const savedY = sessionStorage.getItem("scrollY");
    if (savedY !== null) {
      window.scrollTo(0, parseInt(savedY, 10));
    }
  });

  window.addEventListener("beforeunload", () => {
    sessionStorage.setItem("scrollY", window.scrollY);
  });

  function toggleSound() {
    soundOn = !soundOn;
    sessionStorage.setItem("soundOn", soundOn);
    applySoundState();
  }
</script>


</c:set>

<c:import url="/common/base.jsp">
  <c:param name="title" value="四季の名産品｜べにばナビ" />
  <c:param name="content" value="${pageContent}" />
</c:import>
