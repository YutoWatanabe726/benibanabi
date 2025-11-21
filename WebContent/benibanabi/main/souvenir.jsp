<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>四季の名産品｜べにばナビ</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <style>
  /* ============================================
        四季ラッパ（動画＋エフェクト）
  ============================================ */
  .season-wrapper {
    position: relative;
    margin: 40px auto;
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

  /* 花びら */
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
    0%   { transform: translateY(-30px) rotate(0deg);   opacity: 0; }
    20%  { opacity: 1; }
    100% { transform: translateY(900px) rotate(360deg); opacity: 0; }
  }

  /* ============================================
        トップのタブ（山形への行き方など）
  ============================================ */
  .tab-container {
    display: flex;
    gap: 10px;
    padding: 20px 40px;
    margin-top: 90px;
  }

  .tab {
    flex: 1;
    padding: 14px 0;
    border: none;
    font-size: 1.05rem;
    font-weight: 700;
    border-radius: 12px;
    background: #f2f2f2;
    color: #555;
    cursor: pointer;
    transition: 0.25s ease;
  }

  .tab:hover { background: #ffe1d2; }

  .tab.active {
    background: linear-gradient(90deg, #FFB35E, #D92929);
    color: #fff;
    box-shadow: 0 6px 16px rgba(217,41,41,0.25);
  }

  /* ============================================
        季節タブ
  ============================================ */
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
    background: rgba(255,255,255,0.12);
    color: #fff;
    font-weight: 700;
    cursor: pointer;
    backdrop-filter: blur(4px);
    transition: 0.3s;
    font-size: 0.98rem;
    white-space: nowrap;
  }

  .season-tab:hover {
    background: rgba(255,255,255,0.25);
  }

  .season-tab.active {
    background: linear-gradient(90deg, #FFB35E, #D92929);
    box-shadow: 0 6px 18px rgba(0,0,0,0.35);
  }

  .season-tab-row {
    overflow-x: auto;
    padding-bottom: 6px;
  }

  .season-tab-row::-webkit-scrollbar {
    height: 6px;
  }
  .season-tab-row::-webkit-scrollbar-thumb {
    background: rgba(255,255,255,0.4);
    border-radius: 999px;
  }

  /* ============================================
        季節コンテンツ
  ============================================ */
  .season-content { display: none; }
  .season-content.active { display: block; }

  .season-content h2 {
    color: #fff;
    font-size: 1.9rem;
    margin: 10px 4px 8px;
  }
  .season-content p.lead {
    color: #f0f0f0;
    margin: 0 4px 20px;
    font-size: 0.98rem;
  }

  /* ============================================
        名産品カード（増量版）
  ============================================ */
  .souvenir-list {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
    gap: 20px;
  }

  .souvenir-item {
    background: #fff;
    border-radius: 18px;
    overflow: hidden;
    box-shadow: 0 6px 18px rgba(0,0,0,0.22);
    border-top: 6px solid #D92929;
    transition: 0.35s ease;
    position: relative;
  }

  .souvenir-item img {
    width: 100%;
    height: 150px;
    object-fit: cover;
  }

  .souvenir-item h3 {
    margin: 14px 16px 6px;
    color: #D92929;
    font-size: 1.08rem;
    font-weight: 800;
  }

  .souvenir-item p {
    margin: 0 16px 12px;
    font-size: 0.9rem;
    color: #333;
  }

  .souvenir-item:hover {
    transform: translateY(-6px);
    box-shadow: 0 14px 30px rgba(0,0,0,0.35);
  }

  .souvenir-item::after {
    content: "";
    position: absolute;
    inset: 0;
    border-radius: 18px;
    box-shadow: 0 0 0 rgba(255,150,100,0);
    transition: box-shadow 0.35s;
  }
  .souvenir-item:hover::after {
    box-shadow: 0 0 30px rgba(255,150,100,0.7);
  }

  /* ============================================
        スクロールアニメーション
  ============================================ */
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

  /* ============================================
        サウンドトグル
  ============================================ */
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
  .sound-toggle span.icon {
    font-size: 1.1rem;
  }

  @media (max-width: 768px) {
    .season-wrapper {
      margin: 20px 10px 40px;
      border-radius: 18px;
    }
    .season-inner {
      padding: 24px 16px 30px;
    }
    .season-content h2 {
      font-size: 1.5rem;
    }
  }
  </style>
</head>

<body>

  <!-- 共通ヘッダー -->
  <jsp:include page="../../common/header.jsp" />

  <!-- 上の3タブ（アクセス系） -->
  <div class="tab-container">
    <button class="tab" onclick="location.href='yamagata.jsp'">山形への行き方</button>
    <button class="tab" onclick="location.href='local.jsp'">現地移動手段</button>
    <button class="tab active">お土産・名産品</button>
  </div>

  <!-- 四季のエリア -->
  <div id="seasonWrapper" class="season-wrapper">
    <!-- 背景動画 -->
    <video id="bgVideo" class="season-bg-video" autoplay muted loop playsinline></video>

    <!-- 花びら -->
    <img class="petal" id="petal1" style="left:12%; animation-duration:11s;">
    <img class="petal" id="petal2" style="left:32%; animation-delay:1s; animation-duration:9s;">
    <img class="petal" id="petal3" style="left:55%; animation-delay:2s; animation-duration:10s;">
    <img class="petal" id="petal4" style="left:78%; animation-delay:0.5s; animation-duration:12s;">
    <img class="petal" id="petal5" style="left:90%; animation-delay:1.8s; animation-duration:9.5s;">

    <!-- サウンドトグル -->
    <div class="sound-toggle" onclick="toggleSound()">
      <span class="icon" id="soundIcon">🔇</span>
      <span id="soundLabel">サウンドOFF</span>
    </div>
    <audio id="bgAudio" loop></audio>

    <div class="season-inner">
      <!-- 季節タブ（横スクロール） -->
      <div class="season-tab-row fade-up">
        <div class="season-tabs">
          <button class="season-tab active" onclick="changeSeason('spring', event)">🌸 春</button>
          <button class="season-tab" onclick="changeSeason('summer', event)">🌻 夏</button>
          <button class="season-tab" onclick="changeSeason('autumn', event)">🍁 秋</button>
          <button class="season-tab" onclick="changeSeason('winter', event)">❄ 冬</button>
        </div>
      </div>

      <main>
        <!-- 春 -->
        <section id="spring" class="season-content active fade-up">

  <h2 class="fade-left">🌸 春の名産品</h2>
  <p class="lead fade-left">桜と共に楽しみたい、山形の春の味覚。</p>

  <div class="souvenir-list">

    <a href="https://www.yamagata-bussan.co.jp/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/sakuranbo.jpg" alt="さくらんぼ">
        <h3>🍒 さくらんぼ（佐藤錦）</h3>
        <p>山形を代表する果物。甘みと酸味のバランスが絶妙。</p>
      </div>
    </a>

    <a href="https://www.dewaya.com/season/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/山菜.jpg" alt="山菜">
        <h3>🌱 春の山菜セット</h3>
        <p>こごみ・わらび・たらの芽など、春山の恵みがぎゅっと。</p>
      </div>
    </a>

    <a href="https://www.yamagatabussan.com/oishii-yamagata/products/detail/104" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/山形のだし.jpg" alt="だし">
        <h3>🥢 山形のだし</h3>
        <p>刻んだ野菜を醤油で和えた郷土料理。ご飯にも冷奴にも合う。</p>
      </div>
    </a>

    <a href="https://www.yonezawa-kankou-navi.com/souvenir/dentoyasai.html" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/ウコギ.jpg" alt="うこぎご飯">
        <h3>🍚 うこぎご飯の素</h3>
        <p>米沢藩ゆかりの食材。独特の風味がクセになる。</p>
      </div>
    </a>

    <a href="https://tabelog.com/yamagata/A0601/A060101/6000821/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/山寺饅頭.jpg" alt="山寺まんじゅう">
        <h3>🍡 山寺まんじゅう</h3>
        <p>山寺参拝のお土産として人気の素朴な甘さの和菓子。</p>
      </div>
    </a>

    <a href="https://mokkedano.net/feature/atsumikabu/top" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/あつみかぶずけ.jpg" alt="あつみかぶ漬け">
        <h3>🥬 あつみかぶ漬け</h3>
        <p>鮮やかな赤色とシャキッとした食感が楽しい漬物。</p>
      </div>
    </a>

  </div>
</section>


        <!-- 夏 -->
        <section id="summer" class="season-content fade-up">

  <h2 class="fade-left">🌻 夏の名産品</h2>
  <p class="lead fade-left">暑い夏を乗り切る、瑞々しくて力強い味わい。</p>

  <div class="souvenir-list">

    <a href="https://www.kiyokawaya.com/p/search?keyword=%E3%81%99%E3%81%84%E3%81%8B" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/すいか.jpg" alt="尾花沢スイカ">
        <h3>🍉 尾花沢スイカ</h3>
        <p>糖度の高さで有名な夏の王様。シャリっと爽快。</p>
      </div>
    </a>

    <a href="https://www.kiyokawaya.com/c/gr7/gr2" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/だだちゃ豆.jpg" alt="だだちゃ豆">
        <h3>🫘 だだちゃ豆</h3>
        <p>庄内地方のブランド枝豆。香りと甘みが段違い。</p>
      </div>
    </a>

    <a href="https://www.kiyokawaya.com/c/gr7/gr372" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/桃.jpg" alt="桃">
        <h3>🍑 山形の桃</h3>
        <p>ジューシーでとろける甘さ。夏の贈り物にも人気。</p>
      </div>
    </a>

    <a href="https://yamagata.chokuso-keikaku.jp/s0078/0078-001/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/トマトジュース.jpg" alt="完熟トマト">
        <h3>🍅 完熟トマトジュース</h3>
        <p>山形産トマトを搾った濃厚な1本。</p>
      </div>
    </a>

    <a href="https://www.yakitoriyuuki.com/ramen.php" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/冷やしラーメン.jpg" alt="冷やしラーメン">
        <h3>🍜 冷やしラーメン（お土産用）</h3>
        <p>山形発祥の冷たいラーメンを自宅でも。</p>
      </div>
    </a>

    <a href="https://www.kiyokawaya.com/c/gr7/gr341" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/メロン.jpg" alt="メロン">
        <h3>🍈 庄内メロン</h3>
        <p>香り高く上品な甘さの夏のフルーツ。</p>
      </div>
    </a>

  </div>
</section>


        <!-- 秋 -->
       <section id="autumn" class="season-content fade-up">

  <h2 class="fade-left">🍁 秋の名産品</h2>
  <p class="lead fade-left">実りの秋をそのまま味わえる山形の恵み。</p>

  <div class="souvenir-list">

    <a href="https://www.kiyokawaya.com/c/gr7/gr195/gr3" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/ラ・フランス.jpg" alt="ラ・フランス">
        <h3>🍐 ラ・フランス</h3>
        <p>とろける食感と芳醇な香り。秋の女王。</p>
      </div>
    </a>

    <a href="https://www.tabechoku.com/products/categories/200003?srsltid=AfmBOopGhv18Y-vUrQiyR7Y-hJjJuT5WZ-TkyGC8RKerxwmv7U490IBc" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/リンゴ.jpg" alt="りんご">
        <h3>🍎 りんご</h3>
        <p>甘み・酸味のバランスが良い山形りんご。</p>
      </div>
    </a>

    <a href="https://www.tuyahime.jp/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/つや姫.jpg" alt="新米">
        <h3>🍚 新米（つや姫／はえぬき）</h3>
        <p>炊き立ての香りとツヤが格別のブランド米。</p>
      </div>
    </a>

    <a href="https://www.dewaya.com/season/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/きのこ.jpg" alt="きのこ">
        <h3>🍄 きのこセット</h3>
        <p>秋の山の恵みを詰め合わせた人気セット。</p>
      </div>
    </a>

    <a href="https://imoni-fes.jp/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/芋煮会.jpg" alt="芋煮セット">
        <h3>🍲 芋煮セット</h3>
        <p>山形の秋の風物詩をそのまま持ち帰れる。</p>
      </div>
    </a>

    <a href="https://www.ja-town.com/shop/f/f1060_ssp/?filtercode2=S02-006" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/ぶどう.jpg" alt="ぶどう">
        <h3>🍇 デラウェア・ぶどう</h3>
        <p>濃厚な甘さが魅力。</p>
      </div>
    </a>

  </div>
</section>


        <!-- 冬 -->
       <section id="winter" class="season-content fade-up">

  <h2 class="fade-left">❄ 冬の名産品</h2>
  <p class="lead fade-left">雪国ならではの温かい味覚。</p>

  <div class="souvenir-list">

    <a href="https://yamagata-sake.or.jp/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/sake.jpg" alt="地酒">
        <h3>🍶 冬造りの地酒</h3>
        <p>キレとコクが際立つ寒造りの日本酒。</p>
      </div>
    </a>

    <a href="https://shop.yamagata-nokyo.or.jp/products/list?category_id=9" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/imo.png" alt="いも煮">
        <h3>🍲 いも煮</h3>
        <p>山形の定番。冬にも嬉しい味。</p>
      </div>
    </a>

    <a href="https://www.benibanasoba.co.jp/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/soba.jpg" alt="そば">
        <h3>🥢 板そば・田舎そば</h3>
        <p>太くコシの強い山形そば。</p>
      </div>
    </a>

    <a href="https://www.yamagata-bussan.co.jp/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/oshinko.jpg" alt="おしんこ">
        <h3>🥬 冬の漬物</h3>
        <p>雪の下で熟成された深い味。</p>
      </div>
    </a>

    <a href="https://yamagata-nokyo.jp/special/hoshigaki/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/hoshigaki.jpg" alt="干し柿">
        <h3>🍊 干し柿</h3>
        <p>濃縮された甘さが魅力。</p>
      </div>
    </a>

    <a href="https://www.ginzanonsen.jp/" target="_blank" class="link-card">
      <div class="souvenir-item fade-up">
        <img src="../../images/ginzan_pudding.jpg" alt="銀山温泉プリン">
        <h3>🍮 銀山温泉プリン</h3>
        <p>名物スイーツとして人気。</p>
      </div>
    </a>

  </div>
</section>

      </main>
    </div>
  </div>

  <!-- 共通フッター（必要なら） -->
  <jsp:include page="../../common/footer.jsp" />

  <script>
  // 季節ごとの動画と自然音のパス（★ここを実際のファイル名に合わせて変更）
  const seasonVideos = {
    spring: "../../video/spring.mp4",
    summer: "../../video/summer.mp4",
    autumn: "../../video/autumn.mp4",
    winter: "../../video/winter.mp4"
  };
  const seasonAudios = {
    spring: "../../audio/spring_nature.mp3", // 川+鳥など
    summer: "../../audio/summer_sea.mp3",    // 波+風鈴など
    autumn: "../../audio/autumn_forest.mp3",// 風+落ち葉
    winter: "../../audio/winter_snow.mp3"   // 風+雪
  };

  const bgVideo = document.getElementById("bgVideo");
  const bgAudio = document.getElementById("bgAudio");
  const soundIcon = document.getElementById("soundIcon");
  const soundLabel = document.getElementById("soundLabel");

  let currentSeason = "spring";
  let soundOn = false;

  function setSeasonMedia(season) {
    // 動画切替
    if (seasonVideos[season]) {
      bgVideo.src = seasonVideos[season];
      bgVideo.load();
      bgVideo.play().catch(()=>{});
    }
    // 音声切替
    if (seasonAudios[season]) {
      bgAudio.src = seasonAudios[season];
      bgAudio.load();
      if (soundOn) {
        bgAudio.play().catch(()=>{});
      }
    }
  }

  function changeSeason(season, ev) {
    currentSeason = season;

    // タブ状態切替
    document.querySelectorAll('.season-tab').forEach(btn => btn.classList.remove('active'));
    if (ev && ev.target) {
      ev.target.classList.add('active');
    }

    // コンテンツ切替
    document.querySelectorAll('.season-content').forEach(sec => sec.classList.remove('active'));
    const target = document.getElementById(season);
    if (target) target.classList.add('active');

    // メディア切替
    setSeasonMedia(season);

    // 花びら画像切替
    const petalSrc = {
      spring: "../../images/petal_sakura.png",
      summer: "../../images/benibana.png",
      autumn: "../../images/petal_maple.png",
      winter: "../../images/petal_snow.png"
    }[season];

    document.querySelectorAll('.petal').forEach(p => {
      p.src = petalSrc;
    });
  }

  function toggleSound() {
    soundOn = !soundOn;
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

  // スクロールアニメーション
  document.addEventListener("DOMContentLoaded", () => {
    // 初期季節セット
    setSeasonMedia("spring");
    changeSeason("spring", {target: document.querySelector(".season-tab[data-default]") || document.querySelector(".season-tab")});

    const targets = document.querySelectorAll('.fade-up, .fade-left, .fade-right');
    const io = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          e.target.classList.add('show');
          io.unobserve(e.target);
        }
      });
    }, { threshold: 0.2 });

    targets.forEach(el => io.observe(el));
  });
  </script>
</body>
</html>
