<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>宿泊・レンタカー予約</title>
  <style>
    body {
      font-family: "Hiragino Sans", "Meiryo", sans-serif;
      background-color: #ffffff;
      margin: 0;
      padding: 0;
      color: #1e3a8a; /* 濃い青文字 */
    }

    header {
      background-color: #1d4ed8; /* 青系 */
      color: white;
      text-align: center;
      padding: 25px 10px;
      font-size: 26px;
      font-weight: bold;
      letter-spacing: 2px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    }

    main {
      max-width: 800px;
      margin: 50px auto;
      background-color: #ffffff;
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
      transition: box-shadow 0.3s ease;
    }

    main:hover {
      box-shadow: 0 6px 18px rgba(0, 0, 0, 0.12);
    }

    .tab-buttons {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-bottom: 30px;
    }

    .tab-buttons button {
      padding: 12px 30px;
      border: 2px solid #1d4ed8;
      border-radius: 30px;
      background-color: white;
      color: #1d4ed8;
      font-size: 16px;
      cursor: pointer;
      font-weight: 600;
      transition: all 0.3s;
    }

    .tab-buttons button:hover {
      background-color: #e0e7ff;
    }

    .tab-buttons button.active {
      background-color: #1d4ed8;
      color: white;
    }

    .tab-content {
      display: none;
      animation: fadeIn 0.5s ease;
    }

    .tab-content.active {
      display: block;
    }

    @keyframes fadeIn {
      from {opacity: 0;}
      to {opacity: 1;}
    }

    h2 {
      text-align: center;
      color: #1e3a8a;
      font-size: 22px;
      border-bottom: 2px solid #3b82f6;
      display: inline-block;
      padding-bottom: 5px;
      margin-bottom: 25px;
    }

    p {
      text-align: center;
      color: #475569;
      font-size: 15px;
    }

    .link-box {
      margin: 25px auto;
      padding: 20px;
      border: 1px solid #bfdbfe;
      border-radius: 10px;
      text-align: center;
      background-color: #f8fafc;
      transition: transform 0.3s, box-shadow 0.3s;
      max-width: 500px;
    }

    .link-box:hover {
      transform: translateY(-5px);
      box-shadow: 0 6px 15px rgba(59, 130, 246, 0.2);
    }

    .link-box h3 {
      margin-bottom: 15px;
      color: #1d4ed8;
      font-size: 18px;
    }

    .link-box a {
      display: inline-block;
      background-color: #1d4ed8;
      color: white;
      padding: 10px 30px;
      border-radius: 25px;
      text-decoration: none;
      transition: background-color 0.3s, transform 0.2s;
      font-weight: 500;
    }

    .link-box a:hover {
      background-color: #2563eb;
      transform: scale(1.05);
    }

    footer {
      text-align: center;
      margin-top: 50px;
      padding: 15px;
      color: #64748b;
      font-size: 14px;
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
