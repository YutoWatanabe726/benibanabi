<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/common/base.jsp">
  <c:param name="title" value="宿泊・レンタカー予約｜べにばナビ" />
  <c:param name="content">

<style>

/* ======================
      レイアウト
====================== */
main {
  max-width: 900px;
  margin: 40px auto;
  background: #ffffff;
  padding: 40px;
  border-radius: 18px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.08);
}

/* ======================
      タブ（グラデーション版）
====================== */
.tab-buttons {
  display: flex;
  justify-content: center;
  gap: 18px;
  margin-bottom: 35px;
}

.tab-buttons button {
  padding: 12px 32px;
  border: none;
  background: #fff;
  color: #d92929;
  border-radius: 30px;
  cursor: pointer;
  font-size: 16px;
  font-weight: 700;
  border: 2px solid #d92929;
  transition: .3s;
}

.tab-buttons button.active {
  background: linear-gradient(90deg, #FFB35E, #D92929);
  border-color: transparent;
  color: white;
  box-shadow: 0 6px 16px rgba(217,41,41,.25);
}

.tab-buttons button:hover {
  background: linear-gradient(90deg, #FFD9A8, #FF7A7A);
  color: white;
  border-color: transparent;
}

/* ======================
      タブ中身
====================== */
.tab-content { display: none; animation: fadeIn .5s ease; }
.tab-content.active { display: block; }

@keyframes fadeIn { from{opacity:0;} to{opacity:1;} }

/* ======================
      見出し（グラデーション）
====================== */
.section-title {
  text-align: center;
  font-size: 26px;
  font-weight: 900;
  background: linear-gradient(90deg, #FFB35E, #D92929);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  padding-bottom: 10px;
  margin-bottom: 25px;
  border-bottom: 3px solid #D92929;
  display: inline-block;
  margin-left: 50%;
  transform: translateX(-50%);
}

/* ======================
      説明文
====================== */
p {
  text-align: center;
  font-size: 15px;
  color: #555;
}

/* ======================
      リンクボックス（グラデーション枠）
====================== */
.link-box {
  margin: 25px auto;
  padding: 22px;
  border-radius: 14px;
  background: #fff;
  max-width: 520px;
  text-align: center;
  transition: .3s ease;
  border: 2px solid transparent;
  background-image:
    linear-gradient(#fff, #fff),
    linear-gradient(90deg, #FFB35E, #D92929);
  background-origin: border-box;
  background-clip: padding-box, border-box;
}

.link-box:hover {
  transform: translateY(-6px);
  box-shadow: 0 10px 24px rgba(217,41,41,.24);
}

.link-box h3 {
  background: linear-gradient(90deg, #FFB35E, #D92929);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  font-size: 20px;
  margin-bottom: 14px;
}

/* ======================
      ボタン（グラデーション版）
====================== */
.link-box a {
  display: inline-block;
  background: linear-gradient(90deg, #FFB35E, #D92929);
  color: white;
  padding: 10px 35px;
  border-radius: 25px;
  text-decoration: none;
  font-weight: 700;
  transition: .3s ease;
  box-shadow: 0 6px 18px rgba(217,41,41,.25);
}

.link-box a:hover {
  transform: scale(1.08);
  box-shadow: 0 10px 26px rgba(217,41,41,.35);
}

</style>


<!-- ======================
      本文
====================== -->

<div class="tab-buttons">
  <button id="hotelBtn" class="active" onclick="showTab('hotel')">宿泊予約</button>
  <button id="carBtn" onclick="showTab('car')">レンタカー予約</button>
</div>

<!-- 宿泊予約 -->
<div id="hotel" class="tab-content active">
  <h2 class="section-title">宿泊予約サイト一覧</h2>

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

<!-- レンタカー -->
<div id="car" class="tab-content">
  <h2 class="section-title">レンタカー・カーシェア予約サイト一覧</h2>

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


<script>
function showTab(name) {
  document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
  document.getElementById(name).classList.add('active');

  document.querySelectorAll('.tab-buttons button').forEach(btn => btn.classList.remove('active'));
  document.getElementById(name + 'Btn').classList.add('active');
}
</script>

  </c:param>
</c:import>
