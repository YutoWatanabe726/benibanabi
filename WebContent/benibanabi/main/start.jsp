<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>スタート地点設定</title>

<style>
body {
  font-family: Arial, sans-serif;
  background:#f5f7fa;
  margin:0;
  padding:0;
}
header {
  background:#ff7043;
  color:#fff;
  text-align:center;
  padding:16px;
  font-size:1.4rem;
}
main {
  max-width:500px;
  margin:2rem auto;
  background:#fff;
  padding:20px;
  border-radius:12px;
  box-shadow:0 2px 8px rgba(0,0,0,0.1);
}
label { display:block; margin-top:1rem; font-weight:bold; }

/* 入力欄（コースタイトル等と同じデザイン） */
.input-like {
  width:100%;
  padding:10px;
  border:1px solid #ccc;
  border-radius:8px;
  background:#fff;
  cursor:pointer;
}

/* ▼ 日数選択モーダル（折りたたみ） */
#daySelectArea {
  margin-top:8px;
  display:none;
  padding:10px;
  background:#fff7f0;
  border:1px solid #ffb38a;
  border-radius:8px;
}

.day-grid {
  display:grid;
  grid-template-columns: repeat(3, 1fr);
  gap:10px;
}

.day-option {
  padding:10px 0;
  text-align:center;
  background:#ffe8d9;
  border:1px solid #ffb38a;
  border-radius:8px;
  cursor:pointer;
  font-weight:bold;
  color:#d35400;
}
.day-option:hover {
  background:#ffd5bd;
}
.day-option.active {
  background:#ff7043;
  border-color:#ff7043;
  color:#fff;
}

/* その他の入力 */
#otherDayInput {
  margin-top:12px;
  display:none;
}
#address-field { display:none; }

/* ボタン */
button {
  margin-top:20px;
  width:100%;
  padding:10px;
  font-size:1.1rem;
  font-weight:bold;
  background:#ff7043;
  color:#fff;
  border:none;
  border-radius:8px;
  cursor:pointer;
}
button:hover { background:#e85d2c; }

</style>
</head>
<body>

<header>スタート地点設定</header>

<main>
<form id="startForm" action="Course.action" method="post">

  <!-- コースタイトル -->
  <label for="courseTitle">コースタイトル</label>
  <input type="text" id="courseTitle" name="courseTitle"
         class="input-like" placeholder="例：山形名所巡りコース" required />

  <!-- 旅行期間（日数） -->
  <label>旅行期間（日数）</label>

  <!-- ▼ 折りたたみ風の入力欄 -->
  <div id="daySelectBox" class="input-like">
    日数を選択してください
  </div>

  <!-- ▼ タブ（最大化時のみ表示） -->
  <div id="daySelectArea">
    <div class="day-grid">
      <% for(int i=1; i<=9; i++){ %>
        <div class="day-option" data-value="<%=i%>"><%=i%>日</div>
      <% } %>
      <div class="day-option" data-value="other">その他</div>
    </div>

    <!-- その他日数入力 -->
    <div id="otherDayInput">
      <input type="number" id="otherDayValue" min="10" max="30"
             class="input-like" placeholder="10〜30 を入力">
    </div>
  </div>

  <!-- 実際にサーバへ送る値 -->
  <input type="hidden" id="tripDays" name="tripDays" value="">

  <!-- スタート地点 -->
  <label>スタート地点</label>
  <div class="radio-group">
    <label><input type="radio" name="startPoint" value="山形駅" checked> 山形駅</label>
    <label><input type="radio" name="startPoint" value="山形空港"> 山形空港</label>
    <label><input type="radio" name="startPoint" value="任意の地点"> 任意の地点</label>
  </div>

  <!-- 任意の住所 -->
  <div id="address-field">
    <label for="address">任意の住所を入力</label>
    <input type="text" id="address" name="address"
           class="input-like"
           placeholder="例：山形県山形市七日町1-2-3">
  </div>

  <!-- 観光開始時間 -->
  <label for="startTime">観光開始時間</label>
  <input type="time" id="startTime" name="startTime"
         value="09:00" class="input-like" required />

  <button type="submit">スタート地点を設定</button>

</form>
</main>

<script>
// ▼ 任意住所の開閉
document.querySelectorAll('input[name="startPoint"]').forEach(radio => {
  radio.addEventListener('change', () => {
    document.getElementById('address-field').style.display =
      (radio.value === '任意の地点') ? 'block' : 'none';
  });
});

/* ===============================
   日数 選択欄（最大化・最小化）
=============================== */
const box = document.getElementById("daySelectBox");
const area = document.getElementById("daySelectArea");
const days = document.querySelectorAll(".day-option");
const tripInput = document.getElementById("tripDays");
const otherBox = document.getElementById("otherDayInput");
const otherValue = document.getElementById("otherDayValue");

// ▼ 初期は閉じてる
area.style.display = "none";

// ▼ クリックで展開・閉じる
box.addEventListener("click", () => {
  area.style.display = (area.style.display === "none") ? "block" : "none";
});

/* ▼ 日数クリック処理 */
days.forEach(d => {
  d.addEventListener("click", () => {

    // 一旦全部解除
    days.forEach(x => x.classList.remove("active"));

    d.classList.add("active");
    const val = d.dataset.value;

    if (val === "other") {
      otherBox.style.display = "block";
      tripInput.value = "";
      box.textContent = "日数：その他";
    } else {
      otherBox.style.display = "none";
      tripInput.value = val;
      box.textContent = "日数：" + val + "日";
    }
  });
});

// その他 → 入力反映
otherValue.addEventListener("input", () => {
  tripInput.value = otherValue.value;
  box.textContent = "日数：" + otherValue.value + "日";
});
</script>

</body>
</html>
