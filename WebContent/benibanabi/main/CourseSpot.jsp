<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/base.jsp">
	<c:param name="title">
	コース作成
	</c:param>

	<c:param name="content">
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>旅のルート作成</title>

<!-- Leaflet -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.Default.css" />

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>

/* ================================
   全体レイアウト
================================ */
body {
  font-family: Arial, sans-serif;
  background: #f8f8f8;
  margin: 0;
  padding: 0;
  color: #333;
}

h3 {
  margin-bottom: 0;
}

/* ================================
   サイドバー
================================ */
.sidebar button {
  margin-bottom: 6px;
  padding: 6px 12px;
  border-radius: 8px;
  border: none;
  background: #ffb35e;
  color: #fff;
  font-weight: 600;
  cursor: pointer;
  transition: 0.3s;
}

.sidebar button:hover {
  background: #d92929;
}

/* ================================
   履歴表示エリア
================================ */
.route-history {
  max-height: 450px;
  overflow-y: auto;
  border-top: 1px solid #ccc;
  padding-top: 10px;
}

/* ================================
   カード（スポット / ルート）
================================ */
.route-card, .route-item {
  background: #fff;
  border-radius: 10px;
  padding: 10px 12px;
  margin-bottom: 12px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  transition: 0.2s;
}

.route-card:hover, .route-item:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

/* カードヘッダー */
.route-card .card-header,
.route-item .card-header {
  font-weight: bold;
  font-size: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* 削除ボタン */
.removeBtn {
  background: #ff5a5a;
  border: none;
  color: #fff;
  padding: 2px 8px;
  border-radius: 5px;
  cursor: pointer;
  transition: 0.2s;
}

.removeBtn:hover {
  background: #ff2e2e;
}

/* 滞在時間・メモ */
.route-card .card-body {
  margin-top: 6px;
  font-size: 0.9rem;
  color: #444;
}

.stayTimeInput, .stayTime {
  width: 60px;
}

.memoInput {
  width: 100%;
  margin-top: 4px;
}

.small-muted {
  color: #666;
  font-size: 0.85rem;
  margin-bottom: 4px;
}

/* ================================
   矢印カード（移動情報）
================================ */
.arrow-card {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: #f0f4ff;
  border-left: 4px solid #4f7cff;
  padding: 0 12px;
  margin: -4px 0 12px 0;
  border-radius: 8px;
  font-size: 0.9rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
  white-space: nowrap;
  overflow: hidden;
}

.arrow-card::before {
  content: "↓";
  font-weight: bold;
  font-size: 1.2rem;
  color: #4f7cff;
  margin-right: 5px;
}

.arrow-card select,
.arrow-card input {
  font-size: 0.9rem;
  margin-left: 4px;
}

/* ================================
   モーダル内カード
================================ */
.modal-card {
  border: 1px solid #ddd;
  padding: 8px;
  margin: 6px;
  cursor: pointer;
  position: relative;
  border-radius: 8px;
  background: #fff;
  transition: box-shadow 0.2s;
}

.modal-card:hover {
  box-shadow: 0 3px 8px rgba(0,0,0,0.15);
}

/* お気に入り星 */
.favorite {
  position: absolute;
  top: 6px;
  right: 6px;
  cursor: pointer;
  color: #ccc;
  user-select: none;
  transition: 0.2s;
}

.favorite.active {
  color: gold;
}

/* ================================
   Day セクション
================================ */
#routesContainer .day-section {
  margin-bottom: 30px;
  background: #fff;
  padding: 14px;
  border-radius: 12px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.08);
}

/* ================================
   マップ
================================ */
.map-container {
  flex: 1;
  height: 600px;
  min-height: 300px;
  border-radius: 10px;
  overflow: hidden;
}

/* ================================
   インラインフォーム
================================ */
.form-inline {
  display: flex;
  gap: 8px;
  align-items: center;
}

/* ================================
   汎用ボタン
================================ */
.btn {
  display: inline-block;
  padding: 10px 24px;
  font-size: 1rem;
  font-weight: 700;
  text-decoration: none;
  color: #fff;
  border-radius: 50px;
  background: linear-gradient(90deg, #FFB35E, #D92929);
  box-shadow: 0 10px 22px rgba(217,41,41,0.35);
  transition: 0.3s;
  cursor: pointer;
  text-align: center;
  border: none;
}

.btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 14px 28px rgba(217,41,41,0.48);
}
/* コンテナ全体 */
.container.mb-3 {
  background-color: #f9f9f9;
  padding: 16px;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  font-family: Arial, sans-serif;
}

/* 行全体 */
.container.mb-3 .row > .col-md-8 > div {
  margin-bottom: 8px;
  display: flex;
  align-items: center;
}

/* ラベル部分 */
.container.mb-3 strong {
  width: 80px; /* ラベル幅を揃える */
  display: inline-block;
  color: #333;
}

/* 値部分 */
.container.mb-3 span {
  color: #555;
}

/* 小さめ文字の補足 */
.container.mb-3 .small-muted {
  font-size: 0.85em;
  color: #888;
  margin-left: 4px;
}

/* 日数表示を目立たせる */
#tripDaysDisplay {
  font-weight: bold;
  color: #2a7ae2;
}

/* コースタイトルを強調 */
#courseTitle {
  font-size: 1.1em;
  font-weight: bold;
  color: #1a4b7a;
}

</style>
</head>

<body>

<h3 class="text-center">日別ルート作成</h3>

<!-- コース情報表示（start.jspから渡された属性） -->
<div class="container mb-3">
  <div class="row">
    <div class="col-md-8">
      <div><strong>コース：</strong>
        <span id="courseTitle">
          <%= request.getAttribute("courseTitle") != null ? request.getAttribute("courseTitle") : "未設定" %>
        </span>
      </div>
      <div><strong>日数：</strong>
        <span id="tripDaysDisplay">
          <%= request.getAttribute("tripDays") != null ? request.getAttribute("tripDays") : 1 %>
        </span> 日
      </div>
      <div>
        <strong>開始地点：</strong>
        <span id="startPointDisplay">
          <%= request.getAttribute("startPoint") != null ? request.getAttribute("startPoint") : "山形駅" %>
        </span>
        <span id="startAddress" class="small-muted"></span>
      </div>
      <div><strong>開始時間：</strong>
        <span id="startTimeDisplay">
          <%= request.getAttribute("startTime") != null ? request.getAttribute("startTime") : "09:00" %>
        </span>
      </div>
    </div>
    <div class="col-md-4 text-end">
      <!-- PDF出力までつなげるボタン -->
      <button id="confirmRouteBtn" class="btn btn-danger">全ルート確定</button>
    </div>
  </div>
</div>

<!-- ルートセクション -->
<div id="routesContainer" class="container" style="margin-left:unset; margin-right:unset; padding-left:unset; padding-right:unset;"></div>

<!-- スポット選択モーダル -->
<div id="spotModal" class="modal fade" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">スポット選択</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
      </div>

      <div class="modal-body">
        <!-- キーワード -->
        <div class="mb-2">
          <input type="text" id="keyword" placeholder="キーワード検索" class="form-control"/>
        </div>

        <!-- エリア & タグ：ドロップダウン複数選択（DB連動） -->
        <div class="mb-3 d-flex gap-2">
          <!-- エリア -->
          <div class="dropdown w-50">
            <button class="btn btn-outline-primary dropdown-toggle w-100" type="button" data-bs-toggle="dropdown">
              エリアを選択
            </button>
            <ul class="dropdown-menu p-2" id="areaDropdown" style="max-height:250px; overflow-y:auto;">
              <!-- JSで自動生成 -->
            </ul>
          </div>
          <!-- タグ -->
          <div class="dropdown w-50">
            <button class="btn btn-outline-success dropdown-toggle w-100" type="button" data-bs-toggle="dropdown">
              タグを選択
            </button>
            <ul class="dropdown-menu p-2" id="tagDropdown" style="max-height:250px; overflow-y:auto;">
              <!-- JSで自動生成 -->
            </ul>
          </div>
        </div>

        <!-- お気に入り -->
        <div class="mb-2">
          <label><input type="checkbox" id="favOnlyCheck"/> お気に入りのみ</label>
        </div>

        <!-- カード一覧 -->
        <div class="row" id="spotCards"></div>
      </div>

      <div class="modal-footer">
        <button id="searchSpotBtn" class="btn btn-primary">検索</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">閉じる</button>
      </div>
    </div>
  </div>
</div>

<!-- ゴール住所入力モーダル -->
<div class="modal fade" id="goalModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">ゴール地点の住所を入力</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="text" id="goalAddressInput" class="form-control"
               placeholder="例：山形県山形市香澄町1-1-1">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary"
                data-bs-dismiss="modal">キャンセル</button>
        <button type="button" id="goalAddressSubmitBtn"
                class="btn btn-primary">決定</button>
      </div>
    </div>
  </div>
</div>

<!-- PDF 出力用 hidden form -->
<form id="pdfForm" method="post" action="<%= request.getContextPath() %>/PDFOutput" target="_blank">
  <input type="hidden" name="json" id="pdfJsonInput">
</form>

<!-- ライブラリ -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster/dist/leaflet.markercluster.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

<script>
/*
  統合版スクリプト（省略なし）
  - start.jsp からの値受け取り
  - 山形駅／山形空港 固定座標
  - 任意住所は Nominatim ジオコーディング
  - Dayごとのマップ＋ルート履歴管理
  - お気に入り Cookie
  - CourseSpotSearch.action(listOnly / spots 検索)
  - PDFOutput へ JSON 送信（写真URL付き）
*/

/* ------------------------
   JSP -> JS への受け渡し
   ------------------------ */
let tripDays = <%= request.getAttribute("tripDays") != null ? request.getAttribute("tripDays") : 1 %>;
let courseTitle = '<%= request.getAttribute("courseTitle") != null ? request.getAttribute("courseTitle").toString().replace("'", "\\'") : "" %>';
let startPointRaw = '<%= request.getAttribute("startPoint") != null ? request.getAttribute("startPoint").toString().replace("'", "\\'") : "山形駅" %>';
let startAddressRaw = '<%= request.getAttribute("address") != null ? request.getAttribute("address").toString().replace("'", "\\'") : "" %>';
let startTime = '<%= request.getAttribute("startTime") != null ? request.getAttribute("startTime").toString().replace("'", "\\'") : "09:00" %>';
let allSpots = []; // モーダルで表示する全スポットを保持

document.getElementById("courseTitle").textContent = courseTitle || "未設定";
document.getElementById("tripDaysDisplay").textContent = tripDays;
document.getElementById("startPointDisplay").textContent = startPointRaw;
document.getElementById("startTimeDisplay").textContent = startTime;
if (startAddressRaw && startPointRaw === "任意の地点") {
  document.getElementById("startAddress").textContent = "（" + startAddressRaw + "）";
}

/* ------------------------
   固定の座標
   ------------------------ */
const FIXED_STARTS = {
  "山形駅":   { lat: 38.2485, lng: 140.3276 },
  "山形空港": { lat: 38.4116, lng: 140.3713 }
};

/* ------------------------
   グローバル状態
   ------------------------ */
let dayCount = 0;
let routesByDay = [];   // 日ごと: [{name,lat,lng,type,circle,stayTime,memo,transport,photoUrl}, ...]
let mapsByDay = [];     // 日ごと: { map, markers, routeLine }
let osrmLinesByDay = [];
/* 移動手段速度（km/h） */
const speedMap = { "徒歩":5, "車":40, "電車":60 };

/* ------------------------
   Cookie ユーティリティ
   ------------------------ */
function setCookieJSON(name, obj, days) {
  if (days === undefined) days = 365;
  const v = encodeURIComponent(JSON.stringify(obj));
  const d = new Date();
  d.setTime(d.getTime() + (days*24*60*60*1000));
  document.cookie = name + "=" + v + ";expires=" + d.toUTCString() + ";path=/";
}
function getCookieJSON(name) {
  const cookies = document.cookie.split(";");
  for (let i = 0; i < cookies.length; i++) {
    let c = cookies[i].trim();
    if (c.indexOf(name + "=") === 0) {
      try {
        return JSON.parse(decodeURIComponent(c.substring(name.length+1)));
      } catch(e) {
        return null;
      }
    }
  }
  return null;
}
const FAV_COOKIE = "benibanabi_favs_v1";

/* ------------------------
お気に入り（Cookie）
------------------------ */
function loadFavsFromCookie() {
    const match = document.cookie.match(/favoriteIds=([^;]+)/);
    if(!match) return [];
    return decodeURIComponent(match[1]).split(",").map(v => v.trim()).filter(v=>v);
}

// Cookieに保存
function saveFavsToCookie(list) {
    const unique = Array.from(new Set(list.map(String)));
    document.cookie = "favoriteIds=" + encodeURIComponent(unique.join(",")) + "; path=/; max-age=" + (60*60*24*365);
}

/* ------------------------
   Nominatim ジオコーディング
   ------------------------ */
function geocodeAddressNominatim(address) {
  return new Promise(function(resolve, reject) {
    if (!address || address.trim() === "") {
      reject("住所が空です");
      return;
    }
    const url = "https://nominatim.openstreetmap.org/search?format=json&q=" +
                encodeURIComponent(address);
    fetch(url, { method:"GET", headers:{ "Accept-Language":"ja" } })
      .then(res => res.json())
      .then(json => {
        if (Array.isArray(json) && json.length > 0) {
          const best = json[0];
          resolve({
            lat: parseFloat(best.lat),
            lng: parseFloat(best.lon),
            display_name: best.display_name
          });
        } else {
          reject("ジオコーディングで結果が見つかりませんでした");
        }
      })
      .catch(err => reject(err));
  });
}

/* ------------------------
   Day セクション生成 & Leaflet 初期化
   ------------------------ */
function createDaySection(day, startLat, startLng, startName) {
  if (startLat === undefined) startLat = 38.2404;
  if (startLng === undefined) startLng = 140.3633;
  if (!startName) startName = "スタート";

  dayCount = Math.max(dayCount, day);
  const sectionId = "daySection" + day;
  const mapId = "mapDay" + day;
  const sidebarId = "sidebarDay" + day;

  const html = `
    <div class="day-section" id="${sectionId}" style="width:100%">
      <h5>Day ${day}</h5>
      <div style="display:flex; width:100%;">
        <div id="${sidebarId}" class="sidebar card p-2" style="width:30%;">
          <div class="route-history mt-3" id="routeHistoryDay${day}"></div>
          <button class="btn btn-primary w-100 mb-2 nextSpotBtn">次の地点へ</button>
          <button class="btn btn-warning w-100 mb-2 addMealBtn">食事スポット追加</button>
          <button class="btn btn-success w-100 mb-2 setGoalBtn">ゴール設定</button>
        </div>
        <div id="${mapId}" class="map-container card"></div>
      </div>
    </div>
  `;
  $("#routesContainer").append(html);

  const map = L.map(mapId).setView([startLat, startLng], 13);
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:"&copy; OpenStreetMap contributors"
  }).addTo(map);

  const markers = L.markerClusterGroup();
  markers.addTo(map);

  mapsByDay[day - 1] = { map, markers, routeLine: null };
  routesByDay[day - 1] = [];
  osrmLinesByDay[day - 1] = null;

  setTimeout(() => {
    try { map.invalidateSize(); } catch(e) { console.error(e); }
  }, 200);

  // スタート地点を履歴に追加
  // （復元時はこの後に上書きされる想定なので、ここは従来通りでOK）
  addRouteHistory(day - 1, startName, startLat, startLng, "start", null, null);
}

/* ------------------------
   マップ関連
   ------------------------ */
function addMarker(dayIndex, name, lat, lng, type) {
  if (type === undefined) type = "normal";
  if (!mapsByDay[dayIndex]) return;

  let iconUrl;
  if (type === "start") iconUrl = "https://cdn-icons-png.flaticon.com/512/25/25694.png";
  else if (type === "goal") iconUrl = "https://cdn-icons-png.flaticon.com/512/60/60993.png";
  else if (type === "meal") iconUrl = "https://cdn-icons-png.flaticon.com/512/3075/3075977.png";
  else iconUrl = "https://cdn-icons-png.flaticon.com/512/252/252025.png";

  const icon = L.icon({
    iconUrl,
    iconSize:[32,32],
    iconAnchor:[16,32]
  });
  const marker = L.marker([lat, lng], { icon })
    .bindPopup("<strong>" + escapeHtml(name) + "</strong>");
  mapsByDay[dayIndex].markers.addLayer(marker);
  updateEstimatedTime(dayIndex);
}

async function redrawRouteLine(dayIndex) {
  const mapObj = mapsByDay[dayIndex];
  if (!mapObj || !mapObj.map) return;

  const route = routesByDay[dayIndex];
  if (!Array.isArray(route) || route.length < 2) return;

  if (osrmLinesByDay[dayIndex]) {
    mapObj.map.removeLayer(osrmLinesByDay[dayIndex]);
    osrmLinesByDay[dayIndex] = null;
  }

  const coords = route.map(r => r.lng + "," + r.lat).join(";");

  const url =
    "https://router.project-osrm.org/route/v1/driving/" +
    coords +
    "?overview=full&geometries=geojson";

  const res = await fetch(url);
  const data = await res.json();
  if (!data.routes || !data.routes.length) return;

  osrmLinesByDay[dayIndex] = L.geoJSON(
    data.routes[0].geometry,
    { style: { weight: 4 } }
  ).addTo(mapObj.map);
}

function calcDistance(lat1, lng1, lat2, lng2) {
  const R = 6371;
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLng = (lng2 - lng1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) *
    Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLng / 2) * Math.sin(dLng / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

function updateEstimatedTime(dayIndex) {
  const route = routesByDay[dayIndex] || [];
  const sectionSelector = "#daySection" + (dayIndex + 1);

  if (route.length < 2) {
    $(sectionSelector + " .estimatedTime").text(0);
    return;
  }

  let totalMin = 0;
  for (let i = 1; i < route.length; i++) {
    const prev = route[i - 1];
    const curr = route[i];
    const dist = calcDistance(prev.lat, prev.lng, curr.lat, curr.lng);

    const arrowCard = $(sectionSelector).find(`.arrow-card[data-index="${i}"]`);
    let transport = "徒歩";
    if (arrowCard.length > 0) {
      transport = arrowCard.find(".transportSelect").val() || "徒歩";
    } else {
      transport = "徒歩";
    }

    const speed = speedMap[transport] || 5;
    totalMin += dist / speed * 60;

    const stayVal = parseInt(
      $(sectionSelector).find(`.route-item[data-index="${i}"] .stayTime`).val() ||
      $(sectionSelector).find(`.route-item[data-index="${i}"] .stayTimeInput`).val(),
      10
    );
    totalMin += isNaN(stayVal) ? 0 : stayVal;
  }

  $(sectionSelector).find(".totalEstimatedTimeDisplay").text(Math.round(totalMin));
}

/* ------------------------
   履歴（ルート）管理
   ------------------------ */
/**
 * ★修正ポイント：
 * 復元時に photoUrl / stayTime / memo / transport を渡せるように引数追加
 */
function addRouteHistory(dayIndex, name, lat, lng, type, existingCircle, photoUrl, stayTimeOpt, memoOpt, transportOpt) {
  if (type === undefined) type = "normal";
  routesByDay[dayIndex] = routesByDay[dayIndex] || [];

  let circle = existingCircle;
  if (type === "meal" && !circle) {
    circle = L.circle([lat, lng], {
      color:"orange",
      fillColor:"#ffa500",
      fillOpacity:0.2,
      radius:1000
    }).addTo(mapsByDay[dayIndex].map);
  }

  const defaultStay = (type === "start" || type === "goal") ? 0 : 30;

  routesByDay[dayIndex].push({
    name,
    lat,
    lng,
    type,
    circle,
    stayTime: (stayTimeOpt != null && stayTimeOpt !== "") ? Number(stayTimeOpt) : defaultStay,
    memo: (memoOpt != null) ? String(memoOpt) : "",
    transport: (transportOpt != null && transportOpt !== "") ? String(transportOpt) : "徒歩",
    photoUrl: photoUrl || null
  });

  renderRouteHistory(dayIndex);
  addMarker(dayIndex, name, lat, lng, type);
  saveRoutesToLocal();
}

function renderRouteHistory(dayIndex) {
  const list = routesByDay[dayIndex] || [];
  const container = $(`#routeHistoryDay${dayIndex+1}`);
  container.empty();

  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    const prev = i > 0 ? list[i-1] : null;

    if (prev) {
      const dist = calcDistance(prev.lat, prev.lng, item.lat, item.lng).toFixed(1);
      const transport = item.transport || "徒歩";
      const speed = speedMap[transport] || 5;
      const timeMin = Math.round(dist / speed * 60);

      const arrowHtml = $(`
        <div class="arrow-card small-muted" data-index="${i}">
          移動手段:
          <select class="form-select form-select-sm transportSelect" data-index="${i}" style="width:100px; display:inline-block;">
            <option ${transport === "徒歩" ? "selected" : ""}>徒歩</option>
            <option ${transport === "車" ? "selected" : ""}>車</option>
            <option ${transport === "電車" ? "selected" : ""}>電車</option>
          </select>
          予測時間: <span class="estimatedTime">${timeMin}</span>分 / 概算距離: ${dist}km
        </div>
      `);
      container.append(arrowHtml);
    }

    const stayTime = item.stayTime != null ? item.stayTime : 30;
    const memo = item.memo || "";

    const cardHtml = $(`
      <div class="route-card route-item" data-index="${i}">
        <div class="card-header">
          [${escapeHtml(item.name)}]
          ${item.type === "start" ? "(スタート地点)" :
            item.type === "goal" ? "(ゴール地点)" : ""}
          <button class="btn btn-sm btn-danger removeBtn">×</button>
        </div>
        <div class="card-body">
          <div>滞在時間:
            <input type="number" class="stayTime" value="${stayTime}" data-index="${i}" style="width:60px"/> 分
          </div>
          <div>メモ:
            <input type="text" class="memoInput form-control form-control-sm"
                   value="${escapeHtml(memo)}" data-index="${i}" />
          </div>
        </div>
      </div>
    `);
    container.append(cardHtml);
  }

  container.find(".removeBtn").off("click").on("click", function(){
    const $item = $(this).closest(".route-item");
    const index = $item.data("index");
    const target = routesByDay[dayIndex][index];

    if (dayIndex === 0 && target.type === "start") {
        if (confirm("スタート地点を変更しますか？\n「OK」でスタート地点選択画面に戻ります。")) {
            window.location.href = "start.jsp";
        }
        return;
    }

    if (target.type === "start") {
        if (confirm("この日のスタート地点を削除すると、前日のゴールとこの日以降のルートも削除されます。よろしいですか？")) {
            const prevDayIndex = dayIndex - 1;
            const prevRoutes = routesByDay[prevDayIndex] || [];
            const goalIndex = prevRoutes.findIndex(r => r.type === "goal");
            if (goalIndex >= 0) removeRoute(prevDayIndex, goalIndex);

            for (let d = dayCount - 1; d >= dayIndex; d--) {
                const sectionId = "#daySection" + (d + 1);
                $(sectionId).remove();
                routesByDay[d] = [];
                mapsByDay[d] = null;
            }
            dayCount = dayIndex;
        }
        return;
    }

    removeRoute(dayIndex, index);
  });

  container.find(".transportSelect").off("change").on("change", function () {
    const idx = $(this).data("index");
    const val = $(this).val();
    const list = routesByDay[dayIndex] || [];

    if (list[idx]) {
      list[idx].transport = val;
    }

    const prev = idx > 0 ? list[idx - 1] : null;
    if (prev && list[idx]) {
      const dist = calcDistance(prev.lat, prev.lng, list[idx].lat, list[idx].lng);
      const speed = speedMap[val] || 5;
      const timeMin = Math.round(dist / speed * 60);

      container
        .find('.arrow-card[data-index="' + idx + '"] .estimatedTime')
        .text(timeMin);
    }

    updateEstimatedTime(dayIndex);
    redrawRouteLine(dayIndex);
    saveRoutesToLocal();
  });

  container.find(".stayTime").off("change").on("change", function(){
    const idx = $(this).data("index");
    const val = parseInt($(this).val(), 10);
    const list = routesByDay[dayIndex] || [];
    if (!isNaN(val) && list[idx]) {
      list[idx].stayTime = val;
      updateEstimatedTime(dayIndex);
    }
  });

  container.find(".memoInput").off("input").on("input", function(){
    const idx = $(this).data("index");
    const list = routesByDay[dayIndex] || [];
    if (list[idx]) {
      list[idx].memo = $(this).val();
    }
  });

  const arrowCards = container.find(".arrow-card");
  arrowCards.each(function(){
    const parentWidth = $(this).parent().width();
    const contentWidth = this.scrollWidth;
    let scale = 1;
    if (contentWidth > parentWidth) {
      scale = parentWidth / contentWidth;
    }
    $(this).css({
      transform:`scale(${scale})`,
      "transform-origin":"left center"
    });
  });
}

function removeRoute(dayIndex, index) {
  const mapObj = mapsByDay[dayIndex];
  if (!mapObj || !routesByDay[dayIndex]) return;

  const target = routesByDay[dayIndex][index];

  if (target && target.circle) {
    mapObj.map.removeLayer(target.circle);
  }

  routesByDay[dayIndex].splice(index, 1);

  if (osrmLinesByDay[dayIndex]) {
    mapObj.map.removeLayer(osrmLinesByDay[dayIndex]);
    osrmLinesByDay[dayIndex] = null;
  }

  mapObj.markers.clearLayers();

  const snapshot = [...routesByDay[dayIndex]];
  routesByDay[dayIndex] = [];

  snapshot.forEach(r => {
    addRouteHistory(
      dayIndex,
      r.name,
      r.lat,
      r.lng,
      r.type,
      r.circle || null,
      r.photoUrl || null,
      r.stayTime,
      r.memo,
      r.transport
    );
  });

  renderRouteHistory(dayIndex);

  if (routesByDay[dayIndex].length >= 2) {
    redrawRouteLine(dayIndex);
  }

  saveRoutesToLocal();
}

/* ------------------------
   エリア・タグ（DB連動）＋スポット検索
   ------------------------ */
function populateAreaAndTagSelects(areaContainerId, tagContainerId) {
  $.ajax({
    url:"CourseSpotSearch.action",
    type:"POST",
    data:{ listOnly:"true" },
    dataType:"json",
    success:function(data) {
      const areas = data.areas || [];
      const tags  = data.tags  || [];

      const $areaContainer = $("#" + areaContainerId);
      $areaContainer.empty();
      areas.forEach(function(a, index){
        const areaName = (typeof a === "string") ? a : (a.areaName || a.name);
        const safeName = (areaName || "").replace(/"/g, '\\"');
        const id = "areaChk_" + areaContainerId + "_" + index;
        $areaContainer.append(`
          <li>
            <label class="dropdown-item" for="${id}">
              <input type="checkbox" id="${id}" class="form-check-input me-2 area-check" value="${safeName}">
              ${safeName}
            </label>
          </li>
        `);
      });

      const $tagContainer = $("#" + tagContainerId);
      $tagContainer.empty();
      tags.forEach(function(t, index){
        const tagName = t.name || t.tagName || "";
        const safeName = tagName.replace(/"/g, '\\"');
        const id = "tagChk_" + tagContainerId + "_" + index;
        $tagContainer.append(`
          <li>
            <label class="dropdown-item" for="${id}">
              <input type="checkbox" id="${id}" class="form-check-input me-2 tag-check" value="${safeName}">
              ${safeName}
            </label>
          </li>
        `);
      });
    },
    error:function(xhr, status, err) {
      console.error("エリア・タグ一覧取得エラー", status, err);
      alert("エリア・タグの取得に失敗しました。");
    }
  });
}

function searchSpots(keyword, areas, tags, favOnly, targetSelector) {
  $.ajax({
    url: "CourseSpotSearch.action",
    type: "POST",
    data: {
      keyword: keyword,
      areaIds: areas,
      tagIds: tags,
    },
    traditional: true,
    dataType: "json",
    success: function(data) {
      if (favOnly && (!data.spots || data.spots.length === 0)) {
        const favIds = loadFavsFromCookie().map(Number);
        console.log("[INFO] favOnly でサーバー返却0件、Cookieに従って描画可能なスポットは:", favIds);
        allSpots = [];
      } else {
        allSpots = data.spots || [];
      }
      updateSpotCards(favOnly);
    },
    error: function(xhr, status, err) {
      console.error("検索エラー", status, err);
      alert("スポット検索中にエラーが発生しました。");
    }
  });
}

$(document).on("click", "#searchSpotBtn", function() {
  const keyword = $("#keyword").val() || "";
  const areas = $("#areaDropdown input:checked").map(function(){ return $(this).val(); }).get();
  const tags  = $("#tagDropdown input:checked").map(function(){ return $(this).val(); }).get();
  const favOnly = $("#favOnlyCheck").prop("checked");
  searchSpots(keyword, areas, tags, favOnly, "#spotCards");
});

function renderSpotCards(spots) {
  $("#spotCards").empty();
  const favs = loadFavsFromCookie().map(String);
  const contextPath = "<%= request.getContextPath() %>";

  spots.forEach(function(s){
    const spotIdStr = String(s.spotId);
    const isFav = favs.includes(spotIdStr) || s.fav === true;

    const favClass = isFav ? "active" : "";
    const imgUrl = s.spotPhoto ? contextPath + s.spotPhoto
                               : contextPath + "/images/placeholder.jpg";
    s.fullPhotoUrl = imgUrl;

    const card = $(`
      <div class="col-md-4">
        <div class="modal-card" data-id="${spotIdStr}">
          <span class="favorite ${favClass}" data-id="${spotIdStr}">★</span>
          <img src="${imgUrl}" class="img-fluid mb-2" alt="${escapeHtml(s.spotName)}"/>
          <h6 class="mb-0">${escapeHtml(s.spotName)}</h6>
          <div class="small-muted">${escapeHtml(s.area || "")}</div>
        </div>
      </div>
    `);

    card.find(".modal-card").on("click", function(e){
      if ($(e.target).hasClass("favorite")) return;
      selectSpot(s.spotId, s.spotName, parseFloat(s.lat), parseFloat(s.lng), s.fullPhotoUrl || null);
    });

    card.find(".favorite").on("click", function(e){
      e.stopPropagation();
      toggleFavCookie($(this).data("id"), this);
    });

    $("#spotCards").append(card);
  });
}

/* スポット選択 */
function selectSpot(id, name, lat, lng, photoUrl) {
  const dayIndex = dayCount - 1;
  addRouteHistory(dayIndex, name, lat, lng, "normal", null, photoUrl);
  redrawRouteLine(dayIndex);
  const modalEl = document.getElementById("spotModal");
  const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
  modal.hide();
}

/* お気に入り切替 */
function toggleFavCookie(spotId, elem) {
  let favs = loadFavsFromCookie().map(String);
  const idStr = String(spotId);

  if (favs.includes(idStr)) {
    favs = favs.filter(x => x !== idStr);
    elem.classList.remove("active");
  } else {
    favs.push(idStr);
    elem.classList.add("active");
  }

  saveFavsToCookie(favs);

  if ($("#favOnlyCheck").prop("checked")) {
    updateSpotCards(true);
  }
}

function updateSpotCards(favOnly) {
  if (!allSpots || !Array.isArray(allSpots)) return;
  const favs = loadFavsFromCookie().map(String);

  const filtered = allSpots.filter(s => {
    const idStr = String(s.spotId);
    const isFav = favs.includes(idStr) || s.fav === true;
    return !favOnly || isFav;
  });

  renderSpotCards(filtered);
}

function updateFavStars() {
  const favs = loadFavsFromCookie().map(String);

  $(".card[data-id]").each(function () {
    const id = String($(this).data("id"));

    const star = $(this).find(".favorite-star");
    if (star.length === 0) return;

    const isActive = favs.includes(id);

    star
      .text(isActive ? "★" : "☆")
      .toggleClass("active", isActive);

    star.off("click").on("click", function (e) {
      e.stopPropagation();

      let updatedFavs = loadFavsFromCookie().map(String);
      if (updatedFavs.includes(id)) {
        updatedFavs = updatedFavs.filter(x => x !== id);
      } else {
        updatedFavs.push(id);
      }

      saveFavsToCookie(updatedFavs);
      updateFavStars();
    });
  });
}

/* ------------------------
   イベントハンドラ（その他）
   ------------------------ */
$(document).on("click", ".nextSpotBtn", function(){
  const modalEl = document.getElementById("spotModal");
  const modal = new bootstrap.Modal(modalEl);
  modal.show();
});

$(document).on("click", ".addMealBtn", function(){
  const daySection = $(this).closest(".day-section");
  const dayIndex = $(".day-section").index(daySection);
  if (!mapsByDay[dayIndex]) return;

  alert("マップ上をクリックして食事スポットを追加してください");

  const map = mapsByDay[dayIndex].map;

  function onMapClick(e) {
    const lat = e.latlng.lat;
    const lng = e.latlng.lng;

    const circle = L.circle([lat, lng], {
      color:"orange",
      fillColor:"#ffa500",
      fillOpacity:0.2,
      radius:1000
    }).addTo(map);

    addRouteHistory(dayIndex, "食事スポット", lat, lng, "meal", circle, null);
    if (routesByDay[dayIndex].length >= 2) {
      redrawRouteLine(dayIndex);
    }

    map.off("click", onMapClick);
  }

  map.on("click", onMapClick);
});

/* ゴール設定ボタン */
$(document).on("click", ".setGoalBtn", function(){
  const daySection = $(this).closest(".day-section");
  const dayIndex = $(".day-section").index(daySection);
  window.currentGoalDayIndex = dayIndex;

  const modalEl = document.getElementById("goalModal");
  const modal = new bootstrap.Modal(modalEl);
  modal.show();
});

/* 日本住所 → Nominatim向けに整形 */
function normalizeAddress(addr) {
  if (!addr) return addr;
  let a = addr.trim();

  a = a.replace(/[０-９]/g, function(s){
    return String.fromCharCode(s.charCodeAt(0) - 65248);
  });
  a = a.replace(/[ー－―]/g, "-");
  a = a.replace(/(\d+)丁目/g, "$1 Chome ");
  a = a.replace(/([^\d])(\d+-\d+-?\d*)/, "$1 $2");

  return a;
}

/* ゴール住所決定 */
$("#goalAddressSubmitBtn").on("click", async function(){
  const address = $("#goalAddressInput").val().trim();

  if (!address) {
    alert("住所を入力してください");
    return;
  }

  const dayIndex = window.currentGoalDayIndex;
  if (dayIndex == null) return;

  const modalEl = document.getElementById("goalModal");
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) {
    modal.hide();
  }

  try {
    const normalized = normalizeAddress(address);
    console.log("Nominatim 検索用住所:", normalized);

    const url =
      "https://nominatim.openstreetmap.org/search?format=json&q=" +
      encodeURIComponent(normalized) +
      "&addressdetails=1";

    const res = await fetch(url);
    const data = await res.json();

    if (!Array.isArray(data) || data.length === 0) {
      alert("住所が見つかりませんでした。入力を確認してください。");
      return;
    }

    const result = data[0];
    const lat = parseFloat(result.lat);
    const lng = parseFloat(result.lon);

    const formattedAddress = formatAddress(result.address) || address;

    addRouteHistory(dayIndex, formattedAddress, lat, lng, "goal", null, null);

    if (routesByDay[dayIndex].length >= 2) {
      redrawRouteLine(dayIndex);
    }

    if (mapsByDay[dayIndex] && mapsByDay[dayIndex].map) {
      mapsByDay[dayIndex].map.setView([lat, lng], 14);
    }

    if (dayCount < tripDays) {
      createDaySection(dayCount + 1, lat, lng, formattedAddress);

      const nextDaySection = document.getElementById("daySection" + (dayCount));
      if (nextDaySection) {
        nextDaySection.scrollIntoView({ behavior:"smooth", block:"start" });
      }

      alert("ゴールを設定しました。次の日のスタート地点として登録されました。");
    } else {
      alert("ゴールを設定しました。これ以上の日程はありません。");
    }

  } catch(err) {
    console.error("ゴール検索エラー:", err);
    alert("住所の検索中にエラーが発生しました。");
  }
});

/* ------------------------
   PDF 出力：routesByDay → JSON
   ------------------------ */
function syncRoutesFromDOM() {
  $(".day-section").each(function(dayIdx){
    const $section = $(this);
    const list = routesByDay[dayIdx] || [];

    $section.find(".route-item").each(function(){
      const idx = $(this).data("index");
      if (list[idx]) {
        const stayVal = parseInt($(this).find(".stayTime").val() ||
                                 $(this).find(".stayTimeInput").val(), 10);
        const memoVal = $(this).find(".memoInput").val() || "";

        const arrowCard = $section.find(`.arrow-card[data-index="${idx}"]`);
        let transportVal = list[idx].transport || "徒歩";
        if (arrowCard.length > 0) {
          transportVal = arrowCard.find(".transportSelect").val() || transportVal;
        }

        list[idx].stayTime = isNaN(stayVal) ? 0 : stayVal;
        list[idx].memo = memoVal;
        list[idx].transport = transportVal;
      }
    });
  });
}

function buildPdfPayload() {
  const payload = {
    courseTitle: courseTitle || "未設定",
    tripDays: tripDays,
    startPoint: startPointRaw,
    startAddress: startAddressRaw,
    startTime: startTime,
    routes: []
  };

  for (let d = 0; d < dayCount; d++) {
    const dayRoute = routesByDay[d] || [];
    const simpleDay = dayRoute.map(function(r){
      return {
        name: r.name,
        lat: r.lat,
        lng: r.lng,
        type: r.type,
        stayTime: r.stayTime || 0,
        memo: r.memo || "",
        transport: r.transport || "徒歩",
        photoUrl: r.photoUrl || ""
      };
    });
    payload.routes.push(simpleDay);
  }
  return payload;
}

$("#confirmRouteBtn").on("click", function(){
  if (!routesByDay[0] || routesByDay[0].length === 0) {
    alert("ルートが未設定です。スポットやゴールを追加してください。");
    return;
  }

  syncRoutesFromDOM();

  const payload = buildPdfPayload();
  const jsonStr = JSON.stringify(payload);

  const form = document.createElement("form");
  form.method = "POST";
  form.action = "pdf_output.jsp";
  form.style.display = "none";

  const input = document.createElement("input");
  input.type = "hidden";
  input.name = "routeData";
  input.value = jsonStr;
  form.appendChild(input);

  document.body.appendChild(form);
  form.submit();
});

/* ------------------------
   住所整形（表示用）
   ------------------------ */
function formatAddress(addr) {
  if (!addr) return "";
  const parts = [];
  if (addr.state) parts.push(addr.state);
  if (addr.city || addr.town || addr.municipality)
    parts.push(addr.city || addr.town || addr.municipality);
  if (addr.suburb || addr.neighbourhood)
    parts.push(addr.suburb || addr.neighbourhood);
  if (addr.road) parts.push(addr.road);
  if (addr.house_number) parts.push(addr.house_number);
  return parts.join("");
}

/* ------------------------
   ユーティリティ
   ------------------------ */
function escapeHtml(str) {
  if (!str && str !== 0) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

//------------------------
//LocalStorage 保存・復元
//------------------------
function saveRoutesToLocal() {
  const payload = buildPdfPayload();
  localStorage.setItem("routesData", JSON.stringify(payload));
}

function loadRoutesFromLocal() {
  const dataStr = localStorage.getItem("routesData");
  if (!dataStr) return null;
  try {
    return JSON.parse(dataStr);
  } catch(e) {
    console.error("LocalStorage 読み込みエラー", e);
    return null;
  }
}

$(document).ready(function(){
  populateAreaAndTagSelects("areaDropdown", "tagDropdown");

  function initStartSection(lat, lng, name, day=1) {
    createDaySection(day, lat, lng, name);
    mapsByDay.forEach(m => { try { m.map.invalidateSize(); } catch(e){} });
  }

  // --------------------------
  // LocalStorage から復元（★ここが写真が消える原因だったので修正）
  // --------------------------
  const savedData = loadRoutesFromLocal();
  if (savedData && savedData.routes) {
    routesByDay = savedData.routes.map(day => day.map(r => ({ ...r })));
    dayCount = routesByDay.length;

    routesByDay.forEach((dayRoute, d) => {
      dayRoute.forEach((r, i) => {
        if (i === 0) {
          initStartSection(r.lat, r.lng, r.name, d+1);
        } else {
          // ★photoUrl / stayTime / memo / transport を復元して追加
          addRouteHistory(
            d,
            r.name,
            r.lat,
            r.lng,
            r.type || "normal",
            null,
            r.photoUrl || null,
            r.stayTime,
            r.memo,
            r.transport
          );
        }
      });
    });

    routesByDay.forEach((dayRoute, d) => {
      if (dayRoute.length >= 2) {
        redrawRouteLine(d);
      }
    });

  } else {
    if (startPointRaw === "任意の地点") {
      if (startAddressRaw && startAddressRaw.trim().length > 0) {
        geocodeAddressNominatim(startAddressRaw)
          .then(res => {
            $("#startAddress").text("（" + res.display_name + "）");
            initStartSection(res.lat, res.lng, startAddressRaw);
          })
          .catch(err => {
            console.warn("ジオコーディング失敗:", err);
            initStartSection(FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, "山形駅（ジオコ失敗）");
          });
      } else {
        initStartSection(FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, "山形駅");
      }
    } else if (FIXED_STARTS[startPointRaw]) {
      const s = FIXED_STARTS[startPointRaw];
      initStartSection(s.lat, s.lng, startPointRaw);
    } else {
      initStartSection(FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, startPointRaw || "山形駅");
    }
  }

  // 初期スポットロード
  const spotModalEl = document.getElementById("spotModal");
  spotModalEl.addEventListener("show.bs.modal", function () {
    if(allSpots && allSpots.length > 0) {
      updateSpotCards($("#favOnlyCheck").prop("checked"));
      updateFavStars();
    } else {
      $.ajax({
        url: "CourseSpotSearch.action",
        type: "POST",
        dataType: "json",
        success: function(data){
          allSpots = data.spots || [];
          updateSpotCards($("#favOnlyCheck").prop("checked"));
          updateFavStars();
        },
        error: function(xhr, status, err){
          console.error("初期スポット取得エラー", status, err);
        }
      });
    }
  });

  $(document).on("change", "#favOnlyCheck", function(){
    updateSpotCards($(this).prop("checked"));
    setTimeout(updateFavStars, 50);
  });

  $(".day-section").on("change", ".stayTime, .transportSelect", function(){
    syncRoutesFromDOM();
    saveRoutesToLocal();
  });
  $(".day-section").on("input", ".memoInput", function(){
    syncRoutesFromDOM();
    saveRoutesToLocal();
  });
});
</script>

<!-- Bootstrap JS（Bundle：Popper 同梱） -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
	</c:param>
</c:import>
