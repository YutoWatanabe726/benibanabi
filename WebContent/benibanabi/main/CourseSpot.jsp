<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<style> /* 基本レイアウト */ body { font-family: Arial, sans-serif; background:#f8f8f8; margin:0; padding:0px; } h3 { margin-bottom:16px; }
.sidebar button { margin-bottom:6px; } .route-history { max-height:200px; overflow-y:auto; border-top:1px solid #ccc; padding-top:8px; } .modal-card { border:1px solid #ddd; padding:8px; margin:6px; cursor:pointer; position:relative; border-radius:6px; background:#fff; } .favorite { position:absolute; top:6px; right:6px; cursor:pointer; color:#ccc; user-select:none; } .favorite.active { color:gold; }
#routesContainer .day-section { margin-bottom:20px; }
.map-container { flex:1; height:400px; min-height:300px; }
.route-item { display:flex; justify-content:space-between; align-items:center; padding:4px 0; border-bottom:1px dashed #eee; } .form-inline { display:flex; gap:8px; align-items:center; }
.small-muted { color:#666; font-size:0.9rem; }
</style>


</head>

<body>

<h3 class="text-center">旅のルート作成</h3>

<!-- コース情報表示（start.jspから渡された属性） -->
<div class="container mb-3">
  <div class="row">
    <div class="col-md-8">

      <div><strong>コース：</strong><span id="courseTitle"><%= request.getAttribute("courseTitle") != null ? request.getAttribute("courseTitle") : "未設定" %></span></div>
      <div><strong>日数：</strong><span id="tripDaysDisplay"><%= request.getAttribute("tripDays") != null ? request.getAttribute("tripDays") : 1 %></span> 日</div>
      <div><strong>開始地点：</strong><span id="startPointDisplay"><%= request.getAttribute("startPoint") != null ? request.getAttribute("startPoint") : "山形駅" %></span>
        <span id="startAddress" class="small-muted"></span>
      </div>
      <div><strong>開始時間：</strong><span id="startTimeDisplay"><%= request.getAttribute("startTime") != null ? request.getAttribute("startTime") : "09:00" %></span></div>
    </div>
    <div class="col-md-4 text-end">
      <button id="confirmRouteBtn" class="btn btn-danger">全ルート確定</button>
    </div>
  </div>
</div>

<!-- ルートセクションをここに追加 -->
<div id="routesContainer" class="container" style="margin-left: unset; margin-right: unset; padding-left: unset; padding-right: unset;"></div>

<!-- スポット選択モーダル -->
<div id="spotModal" class="modal fade" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">スポット選択</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
      </div>
      <div class="modal-body">
        <div class="mb-2">
          <input type="text" id="keyword" placeholder="キーワード検索" class="form-control"/>
        </div>
        <div class="mb-2 d-flex gap-2">
          <select id="areaSelect" multiple class="form-select"></select>
          <select id="tagSelect" multiple class="form-select"></select>
        </div>
        <div class="mb-2">
          <label><input type="checkbox" id="favOnlyCheck"/> お気に入りのみ</label>
        </div>
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

<!-- ライブラリ -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster/dist/leaflet.markercluster.js"></script>

<script>
/*
  全コード（省略無し）
  - start.jsp から渡された値を受け取る
  - 山形駅／山形空港は固定座標
  - 任意住所は Nominatim でジオコーディング（無料）
  - Day1 マップは DOM 構築後に初期化（Map container not found エラー対策）
  - Cookie によるお気に入り保存
  - CourseSpotSearchAction.action に Ajax で問い合わせ（JSON）
  - 全ての関数を省略せずにこのファイルに記載
*/

/* ------------------------
   JSP -> JS への安全な受け渡し
   ------------------------ */
let tripDays = <%= request.getAttribute("tripDays") != null ? request.getAttribute("tripDays") : 1 %>;
let courseTitle = '<%= request.getAttribute("courseTitle") != null ? request.getAttribute("courseTitle").toString().replace("'", "\\'") : "" %>';
let startPointRaw = '<%= request.getAttribute("startPoint") != null ? request.getAttribute("startPoint").toString().replace("'", "\\'") : "山形駅" %>';
let startAddressRaw = '<%= request.getAttribute("address") != null ? request.getAttribute("address").toString().replace("'", "\\'") : "" %>';
let startTime = '<%= request.getAttribute("startTime") != null ? request.getAttribute("startTime").toString().replace("'", "\\'") : "09:00" %>';

document.getElementById("courseTitle").textContent = courseTitle || "未設定";
document.getElementById("tripDaysDisplay").textContent = tripDays;
document.getElementById("startPointDisplay").textContent = startPointRaw;
document.getElementById("startTimeDisplay").textContent = startTime;
if (startAddressRaw && startPointRaw === '任意の地点') {
  document.getElementById("startAddress").textContent = "（" + startAddressRaw + "）";
}

/* ------------------------
   固定の座標（山形駅 / 山形空港）
   ------------------------ */
const FIXED_STARTS = {
  "山形駅": { lat: 38.2405, lng: 140.3633 },
  "山形空港": { lat: 38.4116, lng: 140.3713 }
};

/* ------------------------
   グローバル状態
   ------------------------ */
let dayCount = 0; // 実際に作られた日の数
let routesByDay = []; // 日ごとの配列 [ {name,lat,lng,type}, ... ]
let mapsByDay = [];   // 日ごとの map オブジェクト： {map, markers, routeLine}

/* 移動手段速度（km/h） */
const speedMap = { "徒歩":5, "車":40, "電車":60 };

/* ------------------------
   Cookie ユーティリティ（お気に入りを Cookie に保存）
   - cookieName: string
   - value: JSON-serializable
   ------------------------ */
function setCookieJSON(name, obj, days = 365) {
  const v = encodeURIComponent(JSON.stringify(obj));
  const d = new Date();
  d.setTime(d.getTime() + (days*24*60*60*1000));
  document.cookie = `${name}=${v};expires=${d.toUTCString()};path=/`;
}
function getCookieJSON(name) {
  const cookies = document.cookie.split(';').map(c => c.trim());
  for (let c of cookies) {
    if (c.startsWith(name + '=')) {
      try {
        return JSON.parse(decodeURIComponent(c.substring(name.length+1)));
      } catch(e) { return null; }
    }
  }
  return null;
}

/* お気に入り ID 配列を Cookie で保持 */
const FAV_COOKIE = "benibanabi_favs_v1";
function loadFavsFromCookie() {
  return getCookieJSON(FAV_COOKIE) || [];
}
function saveFavsToCookie(favs) {
  setCookieJSON(FAV_COOKIE, favs, 3650);
}

/* ------------------------
   Nominatim ジオコーディング（任意住所向け）
   - 完全無料、キー不要
   - rate limiting に注意（ここでは単発使用を想定）
   ------------------------ */
 function geocodeAddressNominatim(address) {
  return new Promise((resolve, reject) => {
    if (!address || address.trim() === "") {
      reject("住所が空です");
      return;
    }
    const url = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(address);
    fetch(url, { method: "GET", headers: { 'Accept-Language':'ja' } })
      .then(res => res.json())
      .then(json => {
        if (Array.isArray(json) && json.length>0) {
          const best = json[0];
          resolve({ lat: parseFloat(best.lat), lng: parseFloat(best.lon), display_name: best.display_name });
        } else {
          reject("ジオコーディングで結果が見つかりませんでした");
        }
      })
      .catch(err => reject(err));
  });
}

/* ------------------------
   Day セクション生成 & Leaflet 初期化
   - DOM を append -> その直後に Leaflet を作る（Map container not found 対策）
   ------------------------ */
function createDaySection(day, startLat = 38.2404, startLng = 140.3633, startName = "スタート") {
  dayCount = Math.max(dayCount, day);
  const sectionId = "daySection" + day;
  const mapId = "mapDay" + day;
  const sidebarId = "sidebarDay" + day;

  // HTML を構築して DOM に挿入（必ず先に DOM を追加）
  const html = `
    <div class="day-section" id="\${sectionId}">
      <h5>Day \${day}</h5>
      <div style="display:flex; width:100vw;">
        <div id="\${sidebarId}" class="sidebar card p-2" style="width:30%;">
          <div class="route-history mt-3" id="routeHistoryDay\${day}"></div>
          <button class="btn btn-primary w-100 mb-2 nextSpotBtn">次の地点へ</button>
          <button class="btn btn-warning w-100 mb-2 addMealBtn">食事スポット追加</button>
          <button class="btn btn-success w-100 mb-2 setGoalBtn">ゴール設定</button>
          </div>
        <div id="\${mapId}" class="map-container card"></div>
      </div>
    </div>
  `;
  $("#routesContainer").append(html);

  // 必ず DOM に要素が入った後で Leaflet を初期化する
  const map = L.map(mapId).setView([startLat, startLng], 13);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap contributors'
  }).addTo(map);

  const markers = L.markerClusterGroup();
  const routeLine = L.polyline([], { color: 'blue', weight: 4 });

  routeLine.addTo(map);
  markers.addTo(map);

  mapsByDay[day-1] = { map, markers, routeLine };
  routesByDay[day-1] = []; // 空の履歴配列を用意

  // Leaflet はコンテナのサイズ計算をしないことがあるため invalidateSize
  setTimeout(() => {
    try { map.invalidateSize(); } catch(e) { console.error(e); }
  }, 200);

  // 初期スタート地点を履歴 & マーカーに追加（視覚的に）
  addRouteHistory(day-1, startName, startLat, startLng, "start");
}

/* ------------------------
   マップ関連の関数（省略なし）
   ------------------------ */
function addMarker(dayIndex, name, lat, lng, type = "normal") {
  if (!mapsByDay[dayIndex]) return;
  let iconUrl;
  if (type === "start") iconUrl = "https://cdn-icons-png.flaticon.com/512/25/25694.png";
  else if (type === "goal") iconUrl = "https://cdn-icons-png.flaticon.com/512/60/60993.png";
  else if (type === "meal") iconUrl = "https://cdn-icons-png.flaticon.com/512/3075/3075977.png";
  else iconUrl = "https://cdn-icons-png.flaticon.com/512/252/252025.png";

  const icon = L.icon({ iconUrl: iconUrl, iconSize: [32, 32], iconAnchor: [16, 32] });
  const marker = L.marker([lat, lng], { icon }).bindPopup(`<strong>\${escapeHtml(name)}</strong>`);
  mapsByDay[dayIndex].markers.addLayer(marker);
  updateRouteLine(dayIndex);
  updateEstimatedTime(dayIndex);
}

function updateRouteLine(dayIndex) {
  if (!mapsByDay[dayIndex]) return;
  const latlngs = (routesByDay[dayIndex] || []).map(r => [r.lat, r.lng]);
  mapsByDay[dayIndex].routeLine.setLatLngs(latlngs);
  if (latlngs.length > 0) {
    mapsByDay[dayIndex].map.fitBounds(latlngs, { padding: [50, 50] });
  }
}

function calcDistance(lat1, lng1, lat2, lng2) {
  const R = 6371; // km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLng = (lng2 - lng1) * Math.PI / 180;
  const a = Math.sin(dLat / 2) ** 2 + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLng / 2) ** 2;
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

function updateEstimatedTime(dayIndex) {
  const route = routesByDay[dayIndex] || [];
  if (route.length < 2) {
    $(`#daySection\${dayIndex+1} .estimatedTime`).text(0);
    return;
  }
  let totalMin = 0;
  for (let i = 1; i < route.length; i++) {
    const prev = route[i-1], curr = route[i];
    const dist = calcDistance(prev.lat, prev.lng, curr.lat, curr.lng);
    const transport = $(`#daySection\${dayIndex+1}`).find(".transportSelect").val();
    const speed = speedMap[transport] || 5;
    totalMin += dist / speed * 60;
    totalMin += parseInt($(`#daySection\${dayIndex+1}`).find(".stayTime").val()) || 0;
  }
  $(`#daySection\${dayIndex+1}`).find(".estimatedTime").text(Math.round(totalMin));
}

/* ------------------------
   履歴（ルート）管理
   ------------------------ */
function addRouteHistory(dayIndex, name, lat, lng, type = "normal", existingCircle = null) {
	   routesByDay[dayIndex] = routesByDay[dayIndex] || [];

	   let circle = existingCircle;
	   if(type === "meal" && !circle){
	     // 半径1kmの円を作成して map に追加
	     circle = L.circle([lat, lng], {
	       color: 'orange',
	       fillColor: '#ffa500',
	       fillOpacity: 0.2,
	       radius: 1000
	     }).addTo(mapsByDay[dayIndex].map);
	   }

	   routesByDay[dayIndex].push({ name, lat, lng, type, circle });

	   renderRouteHistory(dayIndex);
	   addMarker(dayIndex, name, lat, lng, type);
	 }


function renderRouteHistory(dayIndex) {
	  const list = routesByDay[dayIndex] || [];
	  let html = "";

	  for (let i = 0; i < list.length; i++) {
	    const item = list[i];
	    const prev = i > 0 ? list[i-1] : null;

	    // 移動手段・距離・所要時間
	    let transportInfo = "";
	    if (prev) {
	      const dist = calcDistance(prev.lat, prev.lng, item.lat, item.lng).toFixed(1);
	      const transport = item.transport || "徒歩";
	      const speed = speedMap[transport] || 5;
	      const timeMin = Math.round(dist / speed * 60);

	      transportInfo = `
	        <div class="small-muted">
	          ↓ 移動手段:
	          <select class="form-select form-select-sm transportSelect" data-index="\${i}" style="width:100px; display:inline-block;">
	            <option \${transport==="徒歩"?"selected":""}>徒歩</option>
	            <option \${transport==="車"?"selected":""}>車</option>
	            <option \${transport==="電車"?"selected":""}>電車</option>
	          </select>
	          予測時間: <span class="estimatedTime">\${timeMin}</span>分 / 概算距離: \${dist}km
	        </div>
	      `;
	    }

	    // 滞在時間・メモ
	    const stayTime = item.stayTime != null ? item.stayTime : 30;
	    const memo = item.memo || "";

	    html += `
	    	<div class="route-item" data-index="\${i}"> <div> <strong>\${escapeHtml(item.name)}</strong> \${item.type === "start" ? "(スタート地点)" : item.type === "goal" ? "(ゴール地点)" : ""} <button class="btn btn-sm btn-danger removeBtn">×</button> </div> \${transportInfo} <div class="small-muted"> 滞在時間: <input type="number" class="stayTimeInput" value="\${stayTime}" data-index="\${i}" style="width:60px"/> 分 </div> <div> メモ: <input type="text" class="memoInput form-control form-control-sm" value="\${escapeHtml(memo)}" data-index="\${i}" /> </div> </div>
	    	</div>
	    `;
	  }

	  $(`#routeHistoryDay\${dayIndex+1}`).html(html);

	  // 削除ボタンのイベント
	  $(`#routeHistoryDay\${dayIndex+1} .removeBtn`).off("click").on("click", function() {
	    const index = $(this).closest(".route-item").data("index");
	    removeRoute(dayIndex, index);
	  });

	  // 移動手段変更時の反映
	  $(`#routeHistoryDay\${dayIndex+1} .transportSelect`).off("change").on("change", function() {
	    const idx = $(this).data("index");
	    const val = $(this).val();
	    if (list[idx]) {
	      list[idx].transport = val;
	      updateEstimatedTime(dayIndex);
	    }
	  });
	}


function removeRoute(dayIndex, index) {
	  if (!routesByDay[dayIndex]) return;

	  // 削除対象
	  const target = routesByDay[dayIndex][index];

	  // 円があれば削除
	  if (target.circle) {
	    mapsByDay[dayIndex].map.removeLayer(target.circle);
	  }

	  // 配列から削除
	  routesByDay[dayIndex].splice(index, 1);

	  // マーカーをクリアして再描画
	  mapsByDay[dayIndex].markers.clearLayers();
	  const snapshot = [...routesByDay[dayIndex]];
	  routesByDay[dayIndex] = [];
	  snapshot.forEach(r => {
	    addRouteHistory(dayIndex, r.name, r.lat, r.lng, r.type, r.circle || null);
	  });
	  renderRouteHistory(dayIndex);
	}


/* ------------------------
   モーダル操作・Ajax 検索（SpotSearchAction を想定）
   ------------------------ */
function populateAreaAndTagSelects() {
  // 実際のアプリでは DAO から取得するが、ここでは簡易サンプルを入れておく
  const areas = ["山形市", "蔵王", "天童", "米沢"];
  const tags = ["観光", "食事", "温泉", "自然"];
  $("#areaSelect").empty();
  areas.forEach(a => $("#areaSelect").append(`<option value="${a}">${a}</option>`));
  $("#tagSelect").empty();
  tags.forEach(t => $("#tagSelect").append(`<option value="${t}">${t}</option>`));
}

$("#searchSpotBtn").on("click", function () {
  const keyword = $("#keyword").val() || "";
  const areas = $("#areaSelect").val() || [];
  const tags = $("#tagSelect").val() || [];
  const favOnly = $("#favOnlyCheck").prop("checked");

  // Ajax で SpotSearchAction.action に問い合わせ（ユーザーが既に実装）
  $.ajax({
    url: "CourseSpotSearch.action",
    type: "POST",
    data: {
      keyword: keyword,
      areas: areas.join(","),
      tags: tags.join(","),
      favOnly: favOnly
    },
    dataType: "json",
    success: function (data) {
      renderSpotCards(data);
    },
    error: function (xhr, status, err) {
      console.error("スポット検索エラー", status, err);
      alert("スポット検索でエラーが発生しました。コンソールを確認してください。");
    }
  });
});

function renderSpotCards(spots) {
	  $("#spotCards").empty();
	  const favs = loadFavsFromCookie();
	  spots.forEach(s => {
	    const isFav = favs.includes(String(s.spotId)) || s.fav === true;
	    const favClass = isFav ? "active" : "";

	    const contextPath = '<%= request.getContextPath() %>'; // JSP 内で取得
	    const imgUrl = contextPath + s.spotPhoto || contextPath + '/images/placeholder.jpg';

	    const card = $(`
	      <div class="col-md-4">
	        <div class="modal-card" data-id="\${s.spotId}">
	          <span class="favorite \${favClass}" data-id="\${s.spotId}">★</span>
	          <img src="\${imgUrl}" class="img-fluid mb-2" alt="\${escapeHtml(s.spotName)}"/>
	          <h6 class="mb-0">\${escapeHtml(s.spotName)}</h6>
	          <div class="small-muted">\${escapeHtml(s.area || "")}</div>
	        </div>
	      </div>
	    `);

	    // クリックでスポット選択
	    card.find(".modal-card").on("click", function(e){
	      if ($(e.target).hasClass("favorite")) return;
	      const id = $(this).data("id");
	      const sObj = spots.find(x => String(x.spotId) === String(id));
	      if (sObj) selectSpot(sObj.spotId, sObj.spotName, parseFloat(sObj.lat), parseFloat(sObj.lng));
	    });

	    // favorite のクリック
	    card.find(".favorite").on("click", function(e){
	      e.stopPropagation();
	      toggleFavCookie($(this).data("id"), this);
	    });

	    $("#spotCards").append(card);
	  });
	}


/* モーダルで選択（カードクリック） */
function selectSpot(id, name, lat, lng) {
  // 現在は dayCount の最後の作成日（つまり表示されている最新の日）に追加
  const dayIndex = dayCount - 1;
  addRouteHistory(dayIndex, name, lat, lng, "normal");
  // モーダルを閉じる（Bootstrap 5）
  const modalEl = document.getElementById('spotModal');
  const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
  modal.hide();
}

/* お気に入りの切替（Cookie 保存） */
function toggleFavCookie(id, elem) {
  const favs = loadFavsFromCookie().map(String);
  const idx = favs.indexOf(String(id));
  if (idx === -1) {
    favs.push(String(id));
    $(elem).addClass("active");
  } else {
    favs.splice(idx, 1);
    $(elem).removeClass("active");
  }
  saveFavsToCookie(favs);
}

/* ------------------------
   イベントハンドラ（その他）
   ------------------------ */
$(document).on("click", ".nextSpotBtn", function () {
  // モーダルを表示してスポット選択
  const modalEl = document.getElementById('spotModal');
  const modal = new bootstrap.Modal(modalEl);
  modal.show();
});
$(document).on("click", ".addMealBtn", function () {
	  const daySection = $(this).closest(".day-section");
	  const dayIndex = $(".day-section").index(daySection);
	  if (!mapsByDay[dayIndex]) return;

	  alert("マップ上をクリックして食事スポットを追加してください");

	  const map = mapsByDay[dayIndex].map;

	  function onMapClick(e) {
	    const lat = e.latlng.lat;
	    const lng = e.latlng.lng;

	    // 先に円を作る
	    const circle = L.circle([lat, lng], {
	      color: 'orange',
	      fillColor: '#ffa500',
	      fillOpacity: 0.2,
	      radius: 1000
	    }).addTo(map);

	    // circle を addRouteHistory に渡す！
	    addRouteHistory(dayIndex, "食事スポット", lat, lng, "meal", circle);

	    map.off('click', onMapClick);
	  }

	  map.on('click', onMapClick);
	});

$(document).on("click", ".setGoalBtn", function () {

	  const daySection = $(this).closest(".day-section");

	  const dayIndex = $(".day-section").index(daySection);

	  window.currentGoalDayIndex = dayIndex;

	  const modalEl = document.getElementById('goalModal');

	  const modal = new bootstrap.Modal(modalEl);

	  modal.show();

	});

	/* ゴール住所決定（検索機能統合版・シンプル表示） */

	$("#goalAddressSubmitBtn").on("click", async function () {

	  const address = $("#goalAddressInput").val().trim();

	  if (!address) {

	    alert("住所を入力してください");

	    return;

	  }

	  const dayIndex = window.currentGoalDayIndex;

	  if (dayIndex == null) return;

	  // モーダルを閉じる

	  const modalEl = document.getElementById('goalModal');

	  const modal = bootstrap.Modal.getInstance(modalEl);

	  if (modal) {

	    modal.hide();

	  }

	  try {

	    const url = `https://nominatim.openstreetmap.org/search?format=json&q=\${encodeURIComponent(address)}&addressdetails=1`;

	    const res = await fetch(url);

	    const data = await res.json();

	    if (!Array.isArray(data) || data.length === 0) {

	      alert("住所が見つかりませんでした。入力を確認してください。");

	      return;

	    }

	    const result = data[0];

	    const lat = parseFloat(result.lat);

	    const lng = parseFloat(result.lon);

	    // 住所オブジェクトをきれいに整形（日本語のまま）

	    const formattedAddress = formatAddress(result.address) || address;

	    // ゴールを履歴に追加

	    addRouteHistory(dayIndex, formattedAddress, lat, lng, "goal");

	    // ゴール地点へマップ移動

	    if (mapsByDay[dayIndex] && mapsByDay[dayIndex].map) {

	      mapsByDay[dayIndex].map.setView([lat, lng], 14);

	    }

	    // 残り日数があれば次の日を作成

	    if (dayCount < tripDays) {

	      createDaySection(dayCount + 1, lat, lng, formattedAddress);

	      alert("ゴールを設定しました。次の日のスタート地点として登録されました。");

	    } else {

	      alert("ゴールを設定しました。これ以上の日程はありません。");

	    }

	  } catch (err) {

	    console.error("ゴール検索エラー:", err);

	    alert("住所の検索中にエラーが発生しました。");

	  }

	});



$("#confirmRouteBtn").on("click", function () {
  // サーバーにルートデータを送って PDF 生成等を行うことができる（実装はサーバー側）
  // ここでは簡易的にダイアログ表示
  alert("全ルート確定！サーバー側で旅のしおりPDF作成可能（未実装）。");
});

function loadAllSpots() {
	  $.ajax({
	    url: "CourseSpotSearch.action",
	    type: "POST",
	    data: { keyword: "", areas: "", tags: "", favOnly: false },
	    dataType: "json",
	    success: renderSpotCards,
	    error: function(xhr, status, err) {
	      console.error("初期スポット取得エラー", status, err);
	      alert("スポット一覧取得でエラーが発生しました。");
	    }
	  });
	}

	// モーダルが開いたときに初期スポットを表示
	const spotModalEl = document.getElementById('spotModal');
	spotModalEl.addEventListener('show.bs.modal', function () {
	  loadAllSpots();
	});

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
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}


/* ------------------------
   初期化シーケンス（ページロード）
   - startPointRaw の値に応じて座標を決定
   - 任意の地点なら Nominatim を呼び出して座標を取得
   - 取得完了後に createDaySection(1) を呼ぶ（Map container not found を防ぐ）
   ------------------------ */
$(document).ready(function () {
  // モーダルのセレクトを埋める
  populateAreaAndTagSelects();

  // 初期お気に入りを Cookie から読み込んで UI に反映（もしモーダルが開くとき）
  const initialFavs = loadFavsFromCookie().map(String);

  // 決定ロジック：固定スタート or 任意住所ジオコーディング
  if (startPointRaw === "任意の地点") {
    if (startAddressRaw && startAddressRaw.trim().length > 0) {
      // ジオコーディングしてから Day1 を作る
      geocodeAddressNominatim(startAddressRaw)
        .then(res => {
          // 表示更新
          $("#startAddress").text("（" + res.display_name + "）");
          createDaySection(1, res.lat, res.lng, startAddressRaw);
          // invalidate サイズを確実に実行
          mapsByDay.forEach(m => { try { m.map.invalidateSize(); } catch(e){ } });
        })
        .catch(err => {
          console.warn("ジオコーディング失敗:", err);
          // ジオコーディング失敗時はデフォルト座標で Day1 作成
          createDaySection(1, FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, "山形駅（ジオコ失敗）");
          mapsByDay.forEach(m => { try { m.map.invalidateSize(); } catch(e){ } });
        });
    } else {
      // address が無ければデフォルトで山形駅
      createDaySection(1, FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, "山形駅");
    }
  } else if (FIXED_STARTS[startPointRaw]) {
    const s = FIXED_STARTS[startPointRaw];
    createDaySection(1, s.lat, s.lng, startPointRaw);
  } else {
    // 想定外の文字列ならデフォルト座標
    createDaySection(1, FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, startPointRaw || "山形駅");
  }
});

/* ------------------------
   最後の注釈
   - SpotSearchAction.action 側は JSON を返す必要があります（あなたが提供した SpotSearchAction.java の形に合致）
   - Cookie によるお気に入り管理を行っています（FAV_COOKIE）
   - Map container not found エラー対策：
     -> createDaySection は DOM 追加後に直接 Leaflet を初期化する（append -> L.map）
     -> $(document).ready 内ではジオコーディングが完了してから createDaySection を呼び出す
   ------------------------ */
</script>

<!-- Bootstrap JS（Bundle：Popper 同梱） -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
