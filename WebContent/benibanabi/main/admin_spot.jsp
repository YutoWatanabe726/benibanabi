<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>観光スポット管理</title>
<style>
  body {
    font-family: "Hiragino Sans", "Segoe UI", sans-serif;
    background: #f5f5f5;
    color: #333;
    margin: 0;
    padding: 0;
  }

  header {
    background-color: #00796b;
    color: white;
    text-align: center;
    padding: 1rem;
    font-size: 1.6rem;
    letter-spacing: 1px;
  }

  main {
    max-width: 900px;
    margin: 2rem auto;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 1.5rem;
  }

  h2 {
    border-left: 6px solid #00796b;
    padding-left: 10px;
    margin-top: 0;
  }

  button {
    background: #00796b;
    color: white;
    border: none;
    padding: 8px 14px;
    border-radius: 6px;
    cursor: pointer;
    transition: 0.2s;
    margin-right: 10px;
  }

  button:hover { background: #005b4f; }

  .menu, .register, .list { display: none; }
  .visible { display: block; }

  .form-group { margin-bottom: 1rem; }

  input, textarea, select {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 6px;
  }

  textarea { resize: vertical; }

  .spot-item {
    background: #f9f9f9;
    border-radius: 8px;
    padding: 10px;
    margin-bottom: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .message { color: #d32f2f; font-weight: bold; margin-top: 10px; }
  .success { color: #2e7d32; font-weight: bold; }
  .actions button { margin-left: 5px; }
</style>
</head>
<body>

<header>🗾 観光スポット管理システム（管理者用）</header>

<main>
  <!-- 管理メニュー -->
  <section id="menu" class="menu visible">
    <h2>観光スポット管理メニュー</h2>
    <p>以下の操作を選択してください。</p>
    <button id="newSpotBtn">新規登録</button>
    <button id="listSpotBtn">一覧・編集</button>
  </section>

  <!-- 登録フォーム -->
  <section id="register" class="register">
    <h2>観光スポット登録</h2>
    <div class="form-group">
      <label>スポット名：</label>
      <input type="text" id="spotName">
    </div>

    <div class="form-group">
      <label>説明：</label>
      <textarea id="spotDesc" rows="3"></textarea>
    </div>

	<div class="form-group">
	  <label>タグ（複数選択可）：</label>
	  <select id="spotTag" multiple size="5">
	    <c:forEach var="tag" items="${tagList}">
	      <option value="${tag.tagId}">${tag.tagName}</option>
	    </c:forEach>
	  </select>
	  <small>※ Ctrl（Windows）または Command（Mac）キーで複数選択できます</small>
	</div>


    <div class="form-group">
      <label>所在地：</label>
      <input type="text" id="spotLocation">
    </div>

    <div class="form-group">
	  <label>写真アップロード：</label>
	  <input type="file" id="spotImg" accept="image/*">
	  <small>※ JPEG、PNGなどの画像ファイルを選択してください</small>
	</div>


    <button id="registerBtn">登録する</button>
    <button id="cancelRegister">キャンセル</button>
    <p id="registerMsg" class="message"></p>
  </section>

  <!-- 一覧画面 -->
  <section id="list" class="list">
    <h2>観光スポット一覧・編集</h2>
    <div id="spotList"></div>
    <p id="noSpotMsg" class="message hidden">登録されているスポットはありません。</p>
    <button id="backMenu">メニューへ戻る</button>
  </section>
</main>

<script>
  const menu = document.getElementById('menu');
  const register = document.getElementById('register');
  const list = document.getElementById('list');
  const newSpotBtn = document.getElementById('newSpotBtn');
  const listSpotBtn = document.getElementById('listSpotBtn');
  const cancelRegister = document.getElementById('cancelRegister');
  const backMenu = document.getElementById('backMenu');
  const registerBtn = document.getElementById('registerBtn');
  const registerMsg = document.getElementById('registerMsg');
  const spotList = document.getElementById('spotList');

  let spots = [];

  const show = (section) => {
    [menu, register, list].forEach(s => s.classList.remove('visible'));
    section.classList.add('visible');
  };

  newSpotBtn.onclick = () => show(register);
  listSpotBtn.onclick = () => {
    if (spots.length === 0) {
      alert("登録されているスポットはありません。");
    }
    show(list);
    renderList();
  };
  cancelRegister.onclick = () => show(menu);
  backMenu.onclick = () => show(menu);

  registerBtn.onclick = () => {
    const name = document.getElementById('spotName').value.trim();
    const loc = document.getElementById('spotLocation').value.trim();
    const desc = document.getElementById('spotDesc').value.trim();
    const img = document.getElementById('spotImg').value.trim();
    const selectedTags = Array.from(document.getElementById('spotTag').selectedOptions).map(opt => opt.text);
    registerMsg.textContent = "";

    if (!name || !loc || !desc) {
      registerMsg.textContent = "入力内容に不備があります。";
      return;
    }

    if (spots.some(s => s.name === name)) {
      registerMsg.textContent = "同一のスポットが既に登録されています。";
      return;
    }

    spots.push({ name, loc, tag: selectedTags.join(", "), desc, img });
    registerMsg.textContent = "登録が完了しました。";
    registerMsg.className = "success";

    document.getElementById('spotName').value = "";
    document.getElementById('spotLocation').value = "";
    document.getElementById('spotDesc').value = "";
    document.getElementById('spotImg').value = "";
    document.getElementById('spotTag').selectedIndex = -1;

    setTimeout(() => show(menu), 1000);
  };

  function renderList() {
    spotList.innerHTML = "";
    if (spots.length === 0) {
      spotList.innerHTML = "<p class='message'>登録されているスポットはありません。</p>";
      return;
    }
    spots.forEach((s, index) => {
      const div = document.createElement('div');
      div.classList.add('spot-item');
      div.innerHTML = `
        <div>
          <strong>${s.name}</strong><br>
          ${s.loc}<br>
          ${s.tag}<br>
        </div>
        <div class="actions">
          <button onclick="editSpot(${index})">編集</button>
          <button onclick="deleteSpot(${index})">削除</button>
        </div>
      `;
      spotList.appendChild(div);
    });
  }

  window.deleteSpot = function(index) {
    if (confirm("このスポットを削除しますか？")) {
      spots.splice(index, 1);
      alert("削除が完了しました。");
      renderList();
    }
  };
</script>

</body>
</html>
