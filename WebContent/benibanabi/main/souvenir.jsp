<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<jsp:include page="../../common/header.jsp" />

<head>
<meta charset="UTF-8">
<title>お土産・名産品｜べにばナビ</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

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
      <p>甘みと酸味のバランスが絶妙。「佐藤錦」が特に人気。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/usi.png" alt="米沢牛">
      <h3>🥩 米沢牛</h3>
      <p>きめ細かな霜降りと柔らかい肉質を誇る、世界的ブランド牛。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/tama.jpg" alt="玉こんにゃく">
      <h3>🥢 玉こんにゃく</h3>
      <p>山形名物。丸いこんにゃくを醤油ベースで煮込んだ素朴な逸品。</p>
    </div>

    <div class="souvenir-item">
      <img src="../../images/sake.jpg" alt="山形の地酒">
      <h3>🍶 山形の地酒</h3>
      <p>寒暖差のある気候と清らかな水が生む、香り豊かで繊細な味わい。</p>
    </div>
  </div>
</main>

</body>
</html>
