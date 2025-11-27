<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/base.jsp">
  <c:param name="title">
    PDF出力確認
  </c:param>

  <c:param name="content">
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>PDF出力確認</title>

<!-- Leaflet -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
/* 全体レイアウト */
body {
  font-family: Arial, sans-serif;
  margin:0;
  padding:0;
  background:#f5f7fa;
  position:relative;
  min-height:100vh;
}

/* 背景の山画像（薄く） */
body::before {
  content:"";
  position:fixed;
  inset:0;
  background:url('<%= request.getContextPath() %>/images/mountain_bg.jpg') center/cover no-repeat;
  opacity:0.15;
  z-index:-1;
}

/* メインコンテナ */
#pdf-preview-container {
  max-width:1200px;
  margin:20px auto;
  padding:16px;
  background:rgba(255,255,255,0.95);
  border-radius:12px;
  box-shadow:0 2px 10px rgba(0,0,0,0.12);
}

/* ルート情報ヘッダ */
.route-header {
  border-bottom:1px solid #ddd;
  padding-bottom:10px;
  margin-bottom:12px;
}

/* 左側ルート一覧 */
#routeList {
  max-height:650px;
  overflow-y:auto;
  padding-right:8px;
}

/* Dayごとの箱 */
.day-block {
  margin-bottom:16px;
  padding:10px;
  border-radius:10px;
  background:#fff7f0;
  border:1px solid #ffd2a3;
}

/* 地点カード */
.spot-card {
  border-radius:8px;
  border:1px solid #eee;
  padding:8px;
  margin-bottom:8px;
  background:#ffffff;
}

.spot-title {
  font-weight:bold;
  font-size:0.95rem;
}

.spot-badge {
  display:inline-block;
  padding:2px 8px;
  border-radius:999px;
  font-size:0.75rem;
  margin-left:4px;
}

.badge-start {
  background:#2563eb;
  color:#fff;
}
.badge-goal {
  background:#e11d48;
  color:#fff;
}
.badge-meal {
  background:#f97316;
  color:#fff;
}
.badge-normal {
  background:#6b7280;
  color:#fff;
}

/* サムネイル画像 */
.spot-thumb {
  width:100%;
  max-height:120px;
  object-fit:cover;
  border-radius:6px;
  margin-top:4px;
}

/* 小さなテキスト */
.spot-meta {
  font-size:0.8rem;
  color:#555;
}

/* マップ側 */
#previewMap {
  width:100%;
  height:650px;
  border-radius:12px;
  overflow:hidden;
  border:1px solid #ddd;
}

/* ボタン周り */
.button-area {
  margin-top:10px;
  display:flex;
  flex-wrap:wrap;
  gap:10px;
  justify-content:flex-end;
}
.button-area .btn {
  min-width:190px;
  padding:10px 18px;
  font-size:1rem;
  font-weight:bold;
}
@media (max-width: 768px) {
  .button-area {
    justify-content:center;
  }
}

/* PDFステータス */
#pdfStatus {
  margin-top:10px;
}

/* タイトル */
.page-title {
  font-size:1.3rem;
  font-weight:bold;
  margin-bottom:4px;
}
.page-subtitle {
  font-size:0.9rem;
  color:#555;
}

/* Day タブ（ボタン型） */
.day-tabs {
  display:flex;
  flex-wrap:wrap;
  gap:8px;
  margin-bottom:8px;
}

.day-tab-btn {
  border-radius:999px;
  padding:6px 18px;
  border:1px solid #ffb38a;
  background:#ffe8d9;
  color:#d35400;
  font-size:0.9rem;
  font-weight:bold;
  cursor:pointer;
  transition:background-color 0.15s, color 0.15s, box-shadow 0.15s, border-color 0.15s;
}

.day-tab-btn:hover {
  background:#ffd5bd;
}

.day-tab-btn.active {
  background:#ff7043;
  border-color:#ff7043;
  color:#ffffff;
  box-shadow:0 0 0 2px rgba(255,112,67,0.2);
}
</style>
</head>

<body>
<div id="pdf-preview-container">
  <!-- 画面タイトル -->
  <div class="mb-3">
    <div class="page-title">PDF出力前のルート確認</div>
    <div class="page-subtitle">
      左側で「ルート一覧」を確認し、右側のマップで各日のルートを確認できます。<br>
      Day タブで日付を切り替え、内容に問題なければ「PDFを生成」ボタンからしおりを作成してください。
    </div>
  </div>

  <!-- コース情報 -->
  <div class="route-header row">
    <div class="col-md-8">
      <div><strong>コースタイトル：</strong><span id="courseTitleText">-</span></div>
      <div><strong>旅行日数：</strong><span id="tripDaysText">-</span> 日</div>
      <div>
        <strong>開始地点：</strong><span id="startPointText">-</span>
        <span id="startAddressText" class="text-muted"></span>
      </div>
      <div><strong>開始時間：</strong><span id="startTimeText">-</span></div>
    </div>
    <div class="col-md-4 text-md-end">
      <div class="button-area">
        <!-- PDF生成ボタン -->
        <button id="generatePdfBtn" class="btn btn-danger">
          PDFを生成
        </button>
        <!-- CourseSpot.jsp に戻る -->
        <a href="CourseSpot.jsp" class="btn btn-outline-secondary">
          ルート編集画面に戻る
        </a>
      </div>
    </div>
  </div>

  <!-- 左右2カラム：左ルート一覧 / 右マップ -->
  <div class="row">
    <!-- 左：ルート一覧 -->
    <div class="col-md-4">
      <div class="d-flex align-items-center justify-content-between mb-1">
        <h5 class="mb-0">ルート一覧</h5>
      </div>
      <!-- Day タブ -->
      <div id="dayTabs" class="day-tabs"></div>

      <div id="routeList">
        <!-- JS で Day ごとの地点カードを描画（アクティブな Day のみ） -->
      </div>
    </div>

    <!-- 右：マップ -->
    <div class="col-md-8">
      <h5 class="mb-2">ルートマップ</h5>
      <div id="previewMap"></div>
    </div>
  </div>

  <!-- PDF生成ステータス表示 -->
  <div id="pdfStatus" class="alert alert-info" style="display:none;"></div>
</div>

<!-- routeData (JSON) をそのまま埋め込む -->
<textarea id="routeDataJson" style="display:none;"><c:out value="${param.routeData}" /></textarea>

<!-- PDFOutput 用のフォーム（PDFOutputServlet に POST） -->
<form id="pdfForm" method="post" action="<%= request.getContextPath() %>/PDFOutput" target="_blank">
  <input type="hidden" name="json" id="pdfJsonInput">
</form>

<!-- ライブラリ -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ============================
   routeData の読み込み
============================ */
let routeData = {};
let activeDayIndex = 0;      // 現在表示中の Day（0 始まり）
let previewMap = null;       // Leaflet マップ
let routeLayerGroup = null;  // Day ごとのレイヤー（マーカー＋ポリライン）

function loadRouteData() {
  const textarea = document.getElementById("routeDataJson");
  if (!textarea) return;

  const raw = (textarea.value || textarea.textContent || "").trim();
  if (!raw) {
    alert("ルート情報が見つかりませんでした。もう一度ルートを作成してください。");
    return;
  }
  try {
    routeData = JSON.parse(raw);
    console.log("routeData:", routeData);

    // Day が存在しない / 空配列だけの場合のケア
    if (!routeData.routes || !Array.isArray(routeData.routes) || routeData.routes.length === 0) {
      activeDayIndex = 0;
    } else {
      activeDayIndex = 0;
    }
  } catch (e) {
    console.error("JSON 解析エラー:", e);
    alert("ルート情報の読み込みに失敗しました。もう一度ルートを作成してください。");
  }
}

/* ============================
   コース情報の表示
============================ */
function renderCourseHeader() {
  if (!routeData) return;
  document.getElementById("courseTitleText").textContent =
    routeData.courseTitle || "未設定";
  document.getElementById("tripDaysText").textContent =
    routeData.tripDays || (routeData.routes ? routeData.routes.length : 1);
  document.getElementById("startPointText").textContent =
    routeData.startPoint || "";
  if (routeData.startAddress) {
    document.getElementById("startAddressText").textContent =
      "（" + routeData.startAddress + "）";
  }
  document.getElementById("startTimeText").textContent =
    routeData.startTime || "";
}

/* ============================
   Day タブの描画
============================ */
function renderDayTabs() {
  const tabsContainer = document.getElementById("dayTabs");
  tabsContainer.innerHTML = "";

  if (!routeData || !Array.isArray(routeData.routes) || routeData.routes.length === 0) {
    tabsContainer.innerHTML = "<span class='text-muted'>Day 情報がありません。</span>";
    return;
  }

  routeData.routes.forEach(function(dayRoute, idx) {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "day-tab-btn";
    btn.dataset.dayIndex = idx;
    btn.textContent = "Day " + (idx + 1);

    if (idx === activeDayIndex) {
      btn.classList.add("active");
    }

    btn.addEventListener("click", function() {
      const newIndex = parseInt(this.dataset.dayIndex, 10);
      if (isNaN(newIndex)) return;
      if (newIndex === activeDayIndex) return;

      activeDayIndex = newIndex;
      // タブの見た目更新
      Array.prototype.forEach.call(
        tabsContainer.querySelectorAll(".day-tab-btn"),
        function(b) {
          b.classList.toggle("active", parseInt(b.dataset.dayIndex, 10) === activeDayIndex);
        }
      );
      // ルート一覧・マップを切り替え
      renderRouteListForDay(activeDayIndex);
      renderMapForDay(activeDayIndex);
    });

    tabsContainer.appendChild(btn);
  });
}

/* ============================
   ルート一覧の描画（左） - Day ごと
============================ */
function createBadge(type) {
  let label = "";
  let cls = "badge-normal";
  if (type === "start") {
    label = "スタート";
    cls = "badge-start";
  } else if (type === "goal") {
    label = "ゴール";
    cls = "badge-goal";
  } else if (type === "meal") {
    label = "食事";
    cls = "badge-meal";
  } else {
    label = "スポット";
    cls = "badge-normal";
  }
  return '<span class="spot-badge ' + cls + '">' + label + '</span>';
}

function escapeHtml(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function renderRouteListForDay(dayIndex) {
  const container = document.getElementById("routeList");
  container.innerHTML = "";

  if (!routeData || !Array.isArray(routeData.routes)) {
    container.innerHTML = "<div class='text-muted'>ルート情報がありません。</div>";
    return;
  }

  const dayRoute = routeData.routes[dayIndex];
  if (!dayRoute || dayRoute.length === 0) {
    container.innerHTML =
      "<div class='day-block'><strong>Day " + (dayIndex + 1) +
      "</strong><div class='text-muted mt-1'>この日のルート情報はありません。</div></div>";
    return;
  }

  const dayDiv = document.createElement("div");
  dayDiv.className = "day-block";

  const dayHeader = document.createElement("div");
  dayHeader.innerHTML = "<strong>Day " + (dayIndex + 1) + "</strong>";
  dayDiv.appendChild(dayHeader);

  dayRoute.forEach(function(rp, idx) {
    const name = escapeHtml(rp.name || ("地点" + (idx + 1)));
    const stay = rp.stayTime != null ? rp.stayTime : 0;
    const memo = escapeHtml(rp.memo || "");
    const type = rp.type || "normal";
    const transport = rp.transport || "徒歩";
    const lat = rp.lat;
    const lng = rp.lng;

    const card = document.createElement("div");
    card.className = "spot-card";

    const headerDiv = document.createElement("div");
    headerDiv.className = "spot-title";
    headerDiv.innerHTML = name + " " + createBadge(type);
    card.appendChild(headerDiv);

    if (rp.photoUrl) {
      const img = document.createElement("img");
      img.className = "spot-thumb";
      img.src = rp.photoUrl;
      img.alt = name;
      card.appendChild(img);
    }

    const metaDiv = document.createElement("div");
    metaDiv.className = "spot-meta";
    metaDiv.innerHTML =
      "滞在時間: " + stay + " 分<br>" +
      "移動手段: " + escapeHtml(transport) + "<br>" +
      "緯度: " + lat + " / 経度: " + lng +
      (memo ? ("<br>メモ: " + memo) : "");
    card.appendChild(metaDiv);

    dayDiv.appendChild(card);
  });

  container.appendChild(dayDiv);
}

/* ============================
   マップ描画（右） - Day ごと
============================ */
function getIconByType(type) {
  let iconUrl;
  if (type === "start") {
    iconUrl = "https://cdn-icons-png.flaticon.com/512/25/25694.png";
  } else if (type === "goal") {
    iconUrl = "https://cdn-icons-png.flaticon.com/512/60/60993.png";
  } else if (type === "meal") {
    iconUrl = "https://cdn-icons-png.flaticon.com/512/3075/3075977.png";
  } else {
    iconUrl = "https://cdn-icons-png.flaticon.com/512/252/252025.png";
  }
  return L.icon({
    iconUrl: iconUrl,
    iconSize: [32, 32],
    iconAnchor: [16, 32]
  });
}

function initMapIfNeeded() {
  const mapDiv = document.getElementById("previewMap");
  if (!mapDiv) return;

  if (!previewMap) {
    previewMap = L.map("previewMap").setView([38.2485, 140.3276], 8);
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:"&copy; OpenStreetMap contributors"
    }).addTo(previewMap);
  }
}

function renderMapForDay(dayIndex) {
  initMapIfNeeded();
  if (!previewMap) return;

  // 以前の Day のマーカー＋ポリラインを削除
  if (routeLayerGroup) {
    previewMap.removeLayer(routeLayerGroup);
  }
  routeLayerGroup = L.layerGroup().addTo(previewMap);

  if (!routeData || !Array.isArray(routeData.routes)) return;

  const dayRoute = routeData.routes[dayIndex];
  if (!dayRoute || dayRoute.length === 0) {
    // Day にルートが無い場合は、山形駅あたりを表示
    previewMap.setView([38.2485, 140.3276], 8);
    return;
  }

  const latlngs = [];

  dayRoute.forEach(function(rp) {
    if (rp.lat == null || rp.lng == null) return;
    const lat = parseFloat(rp.lat);
    const lng = parseFloat(rp.lng);
    if (isNaN(lat) || isNaN(lng)) return;

    latlngs.push([lat, lng]);

    const marker = L.marker([lat, lng], {
      icon: getIconByType(rp.type || "normal")
    }).addTo(routeLayerGroup);

    const popupHtml =
      "<strong>" + escapeHtml(rp.name || "") + "</strong><br>" +
      "種別: " + escapeHtml(rp.type || "スポット") + "<br>" +
      "緯度: " + lat + " / 経度: " + lng;
    marker.bindPopup(popupHtml);
  });

  if (latlngs.length > 0) {
    const line = L.polyline(latlngs, { color:"blue", weight:4 }).addTo(routeLayerGroup);
    previewMap.fitBounds(line.getBounds(), { padding:[30,30] });
  } else {
    // 座標が 1 つもない場合も念のためリセット
    previewMap.setView([38.2485, 140.3276], 8);
  }
}

/* ============================
   PDF生成ボタン処理
============================ */
function setupPdfButton() {
  const btn = document.getElementById("generatePdfBtn");
  const status = document.getElementById("pdfStatus");
  if (!btn) return;

  btn.addEventListener("click", function() {
    if (!routeData || !Array.isArray(routeData.routes) || routeData.routes.length === 0) {
      alert("ルート情報がありません。先にルートを作成してください。");
      return;
    }

    const ok = confirm("現在のルート情報で PDF を生成しますか？");
    if (!ok) return;

    const form = document.getElementById("pdfForm");
    const jsonInput = document.getElementById("pdfJsonInput");
    jsonInput.value = JSON.stringify(routeData);

    // PDFOutputServlet に POST → 新しいタブで PDF 表示
    form.submit();

    // 完了メッセージ表示
    status.style.display = "block";
    status.className = "alert alert-success";
    status.textContent =
      "PDF生成を開始しました。ブラウザの新しいタブ（またはウィンドウ）に PDF が表示されます。表示されない場合は、ポップアップブロックを確認してください。";
  });
}

/* ============================
   初期化
============================ */
document.addEventListener("DOMContentLoaded", function() {
  loadRouteData();
  renderCourseHeader();
  renderDayTabs();
  renderRouteListForDay(activeDayIndex);
  renderMapForDay(activeDayIndex);
  setupPdfButton();
});
</script>

</body>
</html>
  </c:param>
</c:import>
