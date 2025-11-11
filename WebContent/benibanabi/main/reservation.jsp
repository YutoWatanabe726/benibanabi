<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>宿泊・レンタカー予約</title>
  <style>
    body {
      font-family: "Segoe UI", "Hiragino Sans", sans-serif;
      background-color: #f9fafb;
      margin: 0;
      padding: 0;
    }
    header {
      background-color: #010a13;
      color: white;
      text-align: center;
      padding: 20px;
      font-size: 22px;
    }
    main {
      max-width: 700px;
      margin: 40px auto;
      background-color: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .tab-buttons {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-bottom: 25px;
    }
    .tab-buttons button {
      padding: 10px 25px;
      border: none;
      border-radius: 6px;
      background-color: #e2e8f0;
      color: #2d3748;
      font-size: 16px;
      cursor: pointer;
      transition: 0.3s;
    }
    .tab-buttons button.active {
      background-color: #030d17;
      color: white;
    }
    .tab-content {
      display: none;
    }
    .tab-content.active {
      display: block;
      animation: fadeIn 0.4s ease;
    }
    @keyframes fadeIn {
      from {opacity: 0;}
      to {opacity: 1;}
    }
    h2 {
      color: #070f18;
      text-align: center;
    }
    .link-box {
      margin: 20px 0;
      padding: 15px;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      text-align: center;
    }
    .link-box a {
      display: inline-block;
      background-color: #01060a;
      color: white;
      padding: 10px 25px;
      border-radius: 6px;
      text-decoration: none;
      transition: 0.3s;
    }
    .link-box a:hover {
      background-color: #000913;
    }
  </style>
</head>
<body>
  <header>宿泊・レンタカー予約</header>
  <main>
    <!-- タブボタン -->
    <div class="tab-buttons">
      <button id="hotelBtn" class="active" onclick="showTab('hotel')">宿泊予約</button>
      <button id="carBtn" onclick="showTab('car')">レンタカー予約</button>
    </div>

    <!-- 宿泊予約 -->
    <div id="hotel" class="tab-content active">
      <h2>宿泊予約サイト一覧</h2>
      <p>以下の宿泊予約サイトから施設を検索・予約できます。</p>
      <div class="link-box">
        <h3>じゃらん</h3>
        <a href="https://www.jalan.net/" target="_blank">じゃらんで予約</a>
      </div>
      <div class="link-box">
        <h3>楽天トラベル</h3>
        <a href="https://travel.rakuten.co.jp/" target="_blank">楽天トラベルで予約</a>
      </div>
    </div>

    <!-- レンタカー予約 -->
    <div id="car" class="tab-content">
      <h2>レンタカー・カーシェア予約サイト一覧</h2>
      <p>以下のサイトから車両を予約できます。</p>
      <div class="link-box">
        <h3>トヨタレンタカー</h3>
        <a href="https://rent.toyota.co.jp/" target="_blank">トヨタレンタカーで予約</a>
      </div>
      <div class="link-box">
        <h3>タイムズカー</h3>
        <a href="https://share.timescar.jp/" target="_blank">タイムズカーで予約</a>
      </div>
    </div>
  </main>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script>
    function showTab(tabName) {
      $('.tab-content').removeClass('active');
      $('#' + tabName).addClass('active');

      $('.tab-buttons button').removeClass('active');
      $('#' + tabName + 'Btn').addClass('active');
    }
  </script>
</body>
</html>
