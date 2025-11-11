<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>お土産・名産品｜にばナビ</title>
<link rel="stylesheet" href="../../common/style.css">
<style>
  body {
    font-family: "メイリオ", sans-serif;
    background-color: #f5f7fa;
    margin: 0;
    padding: 0;
    color: #222;
  }

  header {
    background-color: #004080;
    color: #fff;
    text-align: center;
    padding: 15px;
    font-size: 1.8em;
    letter-spacing: 1px;
  }

  .tab-container {
    display: flex;
    justify-content: center;
    background: linear-gradient(#e9eef9, #dfe9f6);
    gap: 5px;
    padding: 10px;
  }

  .tab {
    padding: 10px 20px;
    background-color: #d8e0ef;
    border: none;
    font-weight: bold;
    font-size: 1.1em;
    border-radius: 10px 10px 0 0;
    cursor: pointer;
  }

  .tab.active {
    background-color: #ffffff;
    border-bottom: 3px solid #004080;
  }

  main {
    background-color: #fff;
    max-width: 1100px;
    margin: 0 auto;
    padding: 30px;
    border-radius: 10px;
  }

  h2 {
    color: #004080;
    border-left: 6px solid #004080;
    padding-left: 10px;
  }

  .souvenir-list {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
    gap: 20px;
    margin-top: 20px;
  }

  .souvenir-item {
    background: #fafafa;
    border-radius: 8px;
    padding: 15px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.1);
  }

  .souvenir-item img {
    width: 100%;
    height: auto;
    border-radius: 8px;
    margin-bottom: 10px;
  }

  .souvenir-item h3 {
    color: #004080;
    font-size: 1.4em;
    margin-bottom: 8px;
  }

  .souvenir-item p {
    line-height: 1.7;
    font-size: 1.1em;
  }

  @media (max-width: 600px) {
    main { padding: 15px; }
    .souvenir-list { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>

<header>お土産・名産品</header>

<div class="tab-container">
  <button class="tab" onclick="location.href='yamagata.jsp'">山形への行き方</button>
  <button class="tab" onclick="location.href='local.jsp'">現地移動手段</button>
  <button class="tab active">お土産・名産品</button>
</div>

<main>
  <h2>山形の名産品を紹介します</h2>
  <p>山形の自然と気候が生んだ、魅力あふれるお土産をお楽しみください。</p>

  <div class="souvenir-list">
    <div class="souvenir-item">
      <img src="../../images/sakuranbo.jpg" alt="さくらんぼ">
      <h3>🍒 さくらんぼ</h3>
      <p>山形県の初夏を彩る果実。甘みと酸味のバランスが絶妙で「佐藤錦」が人気です。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/yonezawagyu.jpg" alt="米沢牛">
      <h3>🥩 米沢牛</h3>
      <p>きめ細かな霜降りと柔らかい肉質を誇るブランド牛。すき焼き・ステーキに最適。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/tamakon.jpg" alt="玉こんにゃく">
      <h3>🥢 玉こんにゃく</h3>
      <p>山形の定番グルメ。丸いこんにゃくを串に刺し、醤油で煮込んだ素朴な味わい。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/sake.jpg" alt="山形の地酒">
      <h3>🍶 山形の地酒</h3>
      <p>寒暖差のある気候と清らかな水が生む、香り高く繊細な味わいの日本酒。</p>
    </div>
  </div>
</main>

</body>
</html>
