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
body {
  font-family: Arial, sans-serif;
  margin:0;
  padding:0;
  background:#f5f7fa;
  position:relative;
  min-height:100vh;
}
#pdf-preview-container {
  max-width:1200px;
  margin:20px auto;
  padding:16px;
  background:rgba(255,255,255,0.95);
  border-radius:12px;
  box-shadow:0 2px 10px rgba(0,0,0,0.12);
}
.route-header {
  border-bottom:1px solid #ddd;
  padding-bottom:10px;
  margin-bottom:12px;
}
#routeList {
  max-height:650px;
  overflow-y:auto;
  padding-right:8px;
}
.day-block {
  margin-bottom:16px;
  padding:10px;
  border-radius:10px;
  background:#fff7f0;
  border:1px solid #ffd2a3;
}
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
.badge-start { background:#2563eb; color:#fff; }
.badge-goal  { background:#e11d48; color:#fff; }
.badge-meal  { background:#f97316; color:#fff; }
.badge-normal{ background:#6b7280; color:#fff; }

.spot-thumb {
  width:100%;
  max-height:120px;
  object-fit:cover;
  border-radius:6px;
  margin-top:4px;
}
.spot-meta {
  font-size:0.8rem;
  color:#555;
}
#previewMap {
  width:100%;
  height:650px;
  border-radius:12px;
  overflow:hidden;
  border:1px solid #ddd;
}
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
  .button-area { justify-content:center; }
}
.page-title {
  font-size:1.3rem;
  font-weight:bold;
  margin-bottom:4px;
}
.page-subtitle {
  font-size:0.9rem;
  color:#555;
}
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
.day-tab-btn:hover { background:#ffd5bd; }
.day-tab-btn.active {
  background:#ff7043;
  border-color:#ff7043;
  color:#ffffff;
  box-shadow:0 0 0 2px rgba(255,112,67,0.2);
}
.small-muted {
  font-size: 0.82rem;
  color: #666;
}
.time-chip {
  display:inline-block;
  padding:2px 8px;
  border-radius:999px;
  background:#eef2ff;
  color:#1e40af;
  font-size:0.78rem;
  margin-right:6px;
}

/* ▼PDFステータス（ボタン上） */
.pdf-status{
  margin: 0 0 10px 0;
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid #dbeafe;
  background: #eff6ff;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
  text-align: left;
}
.pdf-status--success{
  border-color:#bbf7d0;
  background:#ecfdf5;
}
.pdf-status--danger{
  border-color:#fecaca;
  background:#fef2f2;
}
.pdf-status__row{
  display:flex;
  gap:10px;
  align-items:flex-start;
}
.pdf-status__icon{
  width:32px;
  height:32px;
  border-radius:10px;
  display:flex;
  align-items:center;
  justify-content:center;
  background:#dbeafe;
  font-size:18px;
  flex:0 0 32px;
}
.pdf-status--success .pdf-status__icon{ background:#bbf7d0; }
.pdf-status--danger  .pdf-status__icon{ background:#fecaca; }
.pdf-status__title{
  font-weight:800;
  font-size:0.95rem;
  line-height:1.2;
  color:#0f172a;
}
.pdf-status__desc{
  margin-top:2px;
  font-size:0.85rem;
  color:#475569;
  line-height:1.35;
}
.pdf-status__bar{
  margin-top:10px;
  height:8px;
  border-radius:999px;
  background: rgba(15,23,42,0.08);
  overflow:hidden;
}
.pdf-status__barFill{
  height:100%;
  width:0%;
  border-radius:999px;
  background: rgba(37,99,235,0.9);
  transition: width 0.25s ease;
}
.pdf-status--success .pdf-status__barFill{ background: rgba(16,185,129,0.9); }
.pdf-status--danger  .pdf-status__barFill{ background: rgba(225,29,72,0.9); }

/* ▼スマホ時 */
@media (max-width: 768px){
  .route-header .col-md-4{
    text-align:left !important;
    margin-top:10px;
  }
  .button-area{
    justify-content:flex-start;
  }
}
</style>
</head>

<body>
<div id="pdf-preview-container">
  <div class="mb-3">
    <div class="page-title">PDF出力前のルート確認</div>
    <div class="page-subtitle">
      左側で「ルート一覧」を確認し、右側のマップで各日のルートを確認できます。<br>
      Day タブで日付を切り替え、内容に問題なければ「PDFを生成」ボタンからしおりを作成してください。
    </div>
  </div>

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
      <div id="pdfStatus" class="pdf-status" style="display:none;">
        <div class="pdf-status__row">
          <div class="pdf-status__icon" aria-hidden="true">⏳</div>
          <div>
            <div class="pdf-status__title" id="pdfStatusTitle">処理中…</div>
            <div class="pdf-status__desc" id="pdfStatusDesc">しばらくお待ちください</div>
          </div>
        </div>
        <div class="pdf-status__bar">
          <div class="pdf-status__barFill" id="pdfStatusBar"></div>
        </div>
      </div>

      <div class="button-area">
        <button id="generatePdfBtn" type="button" class="btn btn-danger">PDFを生成</button>
        <a href="CourseSpot.jsp" id="backToEditBtn" class="btn btn-outline-secondary">ルート編集画面に戻る</a>
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-4">
      <div class="d-flex align-items-center justify-content-between mb-1">
        <h5 class="mb-0">ルート一覧</h5>
      </div>
      <div id="dayTabs" class="day-tabs"></div>
      <div id="routeList"></div>
    </div>

    <div class="col-md-8">
      <h5 class="mb-2">ルートマップ</h5>
      <div id="previewMap"></div>
    </div>
  </div>
</div>

<textarea id="routeDataJson" style="display:none;"><c:out value="${param.routeData}" escapeXml="false" /></textarea>

<form id="pdfForm" method="post" action="<%= request.getContextPath() %>/PDFOutput">
  <input type="hidden" name="json" id="pdfJsonInput">
</form>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>

<script>
/** ★PDFOutputのエンドポイント */
const PDF_ENDPOINT = "<c:url value='/PDFOutput'/>";

let routeData = {};
let activeDayIndex = 0;
let previewMap = null;
let routeFeatureGroup = null;
let tileLayerRef = null;

const SS_KEY_ROUTE = "pdfPreview.routeData";

/** ★生成済みPDFを開くためのURL（Blob） */
let generatedPdfObjectUrl = null;

function isValidHHMM(str) {
  if (!str) return false;
  return /^([01]\d|2[0-3]):[0-5]\d$/.test(String(str).trim());
}
function parseHHMM(str) {
  if (!isValidHHMM(str)) return null;
  const s = String(str).trim();
  const h = parseInt(s.slice(0,2), 10);
  const m = parseInt(s.slice(3,5), 10);
  if (isNaN(h) || isNaN(m)) return null;
  return h * 60 + m;
}
function formatHHMM(totalMin) {
  if (totalMin == null || isNaN(totalMin)) return "";
  let t = totalMin % (24 * 60);
  if (t < 0) t += 24 * 60;
  const h = Math.floor(t / 60);
  const m = t % 60;
  return (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m;
}
function isFiniteNumber(v){ return v != null && isFinite(v) && !isNaN(v); }

function getFirstExistingTime(rp, keys) {
  if (!rp) return "";
  for (let i = 0; i < keys.length; i++) {
    const v = rp[keys[i]];
    if (isValidHHMM(v)) return String(v).trim();
  }
  return "";
}
function getMoveMinutes(rp) {
  if (!rp) return null;
  const candidates = ["moveMinutes", "travelMinutes", "moveTime", "travelTime"];
  for (let i = 0; i < candidates.length; i++) {
    const v = rp[candidates[i]];
    if (v == null || v === "") continue;
    const n = Number(v);
    if (isFiniteNumber(n) && n >= 0) return Math.floor(n);
  }
  return null;
}
function computeArrivalDepartureForDay(dayRoute) {
  if (!dayRoute || !Array.isArray(dayRoute) || dayRoute.length === 0) return;

  const startT = parseHHMM(routeData.startTime);
  let cursor = (startT != null ? startT : null);

  for (let i = 0; i < dayRoute.length; i++) {
    const rp = dayRoute[i];
    if (!rp) continue;

    const existingArr = getFirstExistingTime(rp, ["arrivalTime", "arriveTime", "arrival", "arrivedAt"]);
    const existingDep = getFirstExistingTime(rp, ["departTime", "departureTime", "depart", "departedAt"]);

    rp._calcArrival = "";
    rp._calcDeparture = "";

    if (existingArr || existingDep) {
      if (existingArr) rp._calcArrival = existingArr;
      if (existingDep) rp._calcDeparture = existingDep;
      if (existingDep && isValidHHMM(existingDep)) cursor = parseHHMM(existingDep);
      continue;
    }

    if (cursor == null) continue;

    if (i === 0) {
      const arr = cursor;
      rp._calcArrival = formatHHMM(arr);

      const stay = (rp.stayTime != null && rp.stayTime !== "") ? Number(rp.stayTime) : null;
      if (isFiniteNumber(stay) && stay >= 0) {
        const dep = arr + Math.floor(stay);
        rp._calcDeparture = formatHHMM(dep);
        cursor = dep;
      }
      continue;
    }

    const mv = getMoveMinutes(rp);
    if (mv == null) continue;

    const arr = cursor + mv;
    rp._calcArrival = formatHHMM(arr);

    const stay = (rp.stayTime != null && rp.stayTime !== "") ? Number(rp.stayTime) : null;
    if (isFiniteNumber(stay) && stay >= 0) {
      const dep = arr + Math.floor(stay);
      rp._calcDeparture = formatHHMM(dep);
      cursor = dep;
    }
  }
}
function pickArrivalTimeText(rp) {
  const v = getFirstExistingTime(rp, ["arrivalTime", "arriveTime", "arrival", "arrivedAt"]);
  if (v) return v;
  if (rp && isValidHHMM(rp._calcArrival)) return rp._calcArrival;
  return "-";
}
function pickDepartureTimeText(rp) {
  const v = getFirstExistingTime(rp, ["departTime", "departureTime", "depart", "departedAt"]);
  if (v) return v;
  if (rp && isValidHHMM(rp._calcDeparture)) return rp._calcDeparture;
  return "-";
}

// ---------- sessionStorage ----------
function saveRouteDataToSessionStorage() {
  try {
    if (!routeData) return;
    sessionStorage.setItem(SS_KEY_ROUTE, JSON.stringify(routeData));
  } catch (e) {
    console.warn("sessionStorage save failed:", e);
  }
}
function loadRouteDataFromSessionStorage() {
  try {
    const s = sessionStorage.getItem(SS_KEY_ROUTE);
    if (!s) return null;
    return JSON.parse(s);
  } catch (e) {
    console.warn("sessionStorage load failed:", e);
    return null;
  }
}
function loadRouteData() {
  const textarea = document.getElementById("routeDataJson");
  if (!textarea) return;

  const raw = (textarea.value || textarea.textContent || "").trim();

  if (raw) {
    try {
      routeData = JSON.parse(raw);
      activeDayIndex = 0;
      saveRouteDataToSessionStorage();
      return;
    } catch (e) {
      console.error("JSON 解析エラー(param):", e, raw);
    }
  }

  const fromSS = loadRouteDataFromSessionStorage();
  if (fromSS) {
    routeData = fromSS;
    activeDayIndex = 0;
    return;
  }

  alert("ルート情報が見つかりませんでした。もう一度ルートを作成してください。");
}

function renderCourseHeader() {
  if (!routeData) return;
  document.getElementById("courseTitleText").textContent = routeData.courseTitle || "未設定";
  document.getElementById("tripDaysText").textContent =
    routeData.tripDays || (routeData.routes ? routeData.routes.length : 1);
  document.getElementById("startPointText").textContent = routeData.startPoint || "";
  document.getElementById("startAddressText").textContent = routeData.startAddress ? "（" + routeData.startAddress + "）" : "";
  document.getElementById("startTimeText").textContent = routeData.startTime || "";
}

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
    if (idx === activeDayIndex) btn.classList.add("active");

    btn.addEventListener("click", async function() {
      const newIndex = parseInt(this.dataset.dayIndex, 10);
      if (isNaN(newIndex)) return;
      if (newIndex === activeDayIndex) return;

      activeDayIndex = newIndex;
      Array.prototype.forEach.call(
        tabsContainer.querySelectorAll(".day-tab-btn"),
        function(b) {
          b.classList.toggle("active", parseInt(b.dataset.dayIndex, 10) === activeDayIndex);
        }
      );

      await renderMapForDay(activeDayIndex);
      renderRouteListForDay(activeDayIndex);
    });

    tabsContainer.appendChild(btn);
  });
}

function createBadge(type) {
  let label = "";
  let cls = "badge-normal";
  if (type === "start") { label = "スタート"; cls = "badge-start"; }
  else if (type === "goal") { label = "ゴール"; cls = "badge-goal"; }
  else if (type === "meal") { label = "食事"; cls = "badge-meal"; }
  else { label = "スポット"; cls = "badge-normal"; }
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

  computeArrivalDepartureForDay(dayRoute);

  const dayDiv = document.createElement("div");
  dayDiv.className = "day-block";

  const first = dayRoute[0];
  const last = dayRoute[dayRoute.length - 1];
  const dayStart = (first ? pickDepartureTimeText(first) : "-");
  const dayArrive = (last ? pickArrivalTimeText(last) : "-");

  const dayHeader = document.createElement("div");
  dayHeader.innerHTML =
    "<div><strong>Day " + (dayIndex + 1) + "</strong></div>" +
    "<div class='small-muted mt-1'>" +
      "<span class='time-chip'>出発: " + escapeHtml(dayStart) + "</span>" +
      "<span class='time-chip'>到着: " + escapeHtml(dayArrive) + "</span>" +
    "</div>";
  dayDiv.appendChild(dayHeader);

  dayRoute.forEach(function(rp, idx) {
    const name = escapeHtml(rp.name || ("地点" + (idx + 1)));
    const stay = rp.stayTime != null ? rp.stayTime : 0;
    const memo = escapeHtml(rp.memo || "");
    const type = rp.type || "normal";
    const transport = rp.transport || "徒歩";

    const arrivalText = pickArrivalTimeText(rp);
    const departText  = pickDepartureTimeText(rp);

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
      "到着時間: " + escapeHtml(arrivalText) + "<br>" +
      "出発時間: " + escapeHtml(departText) + "<br>" +
      "滞在時間: " + stay + " 分<br>" +
      "移動手段: " + escapeHtml(transport) + "<br>" +
      "緯度: " + rp.lat + " / 経度: " + rp.lng +
      (memo ? ("<br>メモ: " + memo) : "");
    card.appendChild(metaDiv);

    dayDiv.appendChild(card);
  });

  container.appendChild(dayDiv);
}

function getIconByType(type) {
  let iconUrl;
  if (type === "start") iconUrl = "https://cdn-icons-png.flaticon.com/512/25/25694.png";
  else if (type === "goal") iconUrl = "https://illust8.com/wp-content/uploads/2018/06/checker-flag_illust_79.png";
  else if (type === "meal") iconUrl = "https://cdn-icons-png.flaticon.com/512/3075/3075977.png";
  else iconUrl = "https://cdn-icons-png.flaticon.com/512/252/252025.png";

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
    previewMap = L.map("previewMap", {
      zoomAnimation: false,
      fadeAnimation: false,
      markerZoomAnimation: false,
      inertia: false,
      preferCanvas: true
    }).setView([38.2485, 140.3276], 8);

    tileLayerRef = L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:"&copy; OpenStreetMap contributors",
      crossOrigin: true
    }).addTo(previewMap);
  }
}

function sleep(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }
function raf() { return new Promise(resolve => requestAnimationFrame(() => resolve())); }

function waitTileLoaded(timeoutMs) {
  timeoutMs = timeoutMs || 1500;
  return new Promise(function(resolve){
    if (!tileLayerRef) return resolve();

    let done = false;
    const timer = setTimeout(function(){
      if (done) return;
      done = true;
      resolve();
    }, timeoutMs);

    tileLayerRef.once("load", function(){
      if (done) return;
      done = true;
      clearTimeout(timer);
      resolve();
    });
  });
}

function waitMapMoveEnd(timeoutMs) {
  timeoutMs = timeoutMs || 1200;
  return new Promise(function(resolve){
    if (!previewMap) return resolve();

    let done = false;
    const timer = setTimeout(function(){
      if (done) return;
      done = true;
      resolve();
    }, timeoutMs);

    const onDone = function() {
      if (done) return;
      done = true;
      clearTimeout(timer);
      resolve();
    };

    previewMap.once("moveend", onDone);
    previewMap.once("zoomend", onDone);
  });
}

async function stabilizeBeforeCapture() {
  if (!previewMap) return;
  previewMap.invalidateSize(true);
  await sleep(120);
  await waitMapMoveEnd(1200);
  await waitTileLoaded(1800);
  await raf();
  await raf();
}

async function drawOsrmSegment(from, to, group) {
  if (!from || !to) return null;
  if (from.lat == null || from.lng == null || to.lat == null || to.lng == null) return null;

  const url =
    "https://router.project-osrm.org/route/v1/driving/" +
    from.lng + "," + from.lat + ";" +
    to.lng + "," + to.lat +
    "?overview=full&geometries=geojson";

  try {
    const res = await fetch(url);
    const data = await res.json();

    if (!data.routes || !data.routes[0]) {
      const fallback = L.polyline([[from.lat, from.lng],[to.lat,to.lng]], { weight: 4, color: "#2563eb" });
      fallback.addTo(group);
      return null;
    }

    const line = L.geoJSON(data.routes[0].geometry, { style: { weight: 4, color: "#2563eb" } });
    line.addTo(group);

    const durSec = data.routes[0].duration;
    const durMin = (durSec != null && isFinite(durSec)) ? Math.max(0, Math.round(Number(durSec) / 60)) : null;

    if (durMin != null && to && (to.moveMinutes == null || to.moveMinutes === "")) {
      to.moveMinutes = durMin;
    }

    return durMin;
  } catch (e) {
    console.error("OSRM error:", e);
    const fallback = L.polyline([[from.lat, from.lng],[to.lat,to.lng]], { weight: 4, color: "#2563eb" });
    fallback.addTo(group);
    return null;
  }
}

async function renderMapForDay(dayIndex) {
  initMapIfNeeded();
  if (!previewMap) return;

  if (routeFeatureGroup) previewMap.removeLayer(routeFeatureGroup);
  routeFeatureGroup = L.featureGroup().addTo(previewMap);

  if (!routeData || !Array.isArray(routeData.routes)) return;

  const dayRoute = routeData.routes[dayIndex];
  if (!dayRoute || dayRoute.length === 0) {
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

    const marker = L.marker([lat, lng], { icon: getIconByType(rp.type || "normal") })
      .addTo(routeFeatureGroup);

    marker.bindPopup(
      "<strong>" + escapeHtml(rp.name || "") + "</strong><br>" +
      "種別: " + escapeHtml(rp.type || "スポット") + "<br>" +
      "緯度: " + lat + " / 経度: " + lng
    );
  });

  if (dayRoute.length >= 2) {
    for (let i = 0; i < dayRoute.length - 1; i++) {
      await drawOsrmSegment(dayRoute[i], dayRoute[i+1], routeFeatureGroup);
    }
    previewMap.invalidateSize(true);
    await sleep(80);
    try {
      previewMap.fitBounds(routeFeatureGroup.getBounds(), { padding:[30,30] });
    } catch(e) {
      previewMap.setView(latlngs[0], 12);
    }
  } else if (latlngs.length === 1) {
    previewMap.setView(latlngs[0], 14);
  } else {
    previewMap.setView([38.2485, 140.3276], 8);
  }

  await stabilizeBeforeCapture();
}

async function captureMapBase64() {
  const mapEl = document.getElementById("previewMap");
  if (!mapEl) return "";

  await stabilizeBeforeCapture();

  try {
    const canvas = await html2canvas(mapEl, {
      useCORS: true,
      allowTaint: false,
      backgroundColor: "#ffffff",
      scale: 1
    });
    return canvas.toDataURL("image/jpeg", 0.80);
  } catch (e) {
    console.error("captureMapBase64 失敗:", e);
    return "";
  }
}

async function captureSegmentMap(dayIndex, segIndex) {
  initMapIfNeeded();
  if (!previewMap) return "";
  if (!routeData || !Array.isArray(routeData.routes)) return "";

  const dayRoute = routeData.routes[dayIndex];
  if (!dayRoute || dayRoute.length === 0) return "";

  if (routeFeatureGroup) {
    try { previewMap.removeLayer(routeFeatureGroup); } catch(e) {}
  }
  routeFeatureGroup = L.featureGroup().addTo(previewMap);

  if (segIndex === 0) {
    const rp0 = dayRoute[0];
    if (rp0 && rp0.lat != null && rp0.lng != null) {
      const lat0 = parseFloat(rp0.lat);
      const lng0 = parseFloat(rp0.lng);

      L.marker([lat0, lng0], { icon: getIconByType(rp0.type || "start") }).addTo(routeFeatureGroup);
      previewMap.invalidateSize(true);
      previewMap.setView([lat0, lng0], 14);
      return await captureMapBase64();
    }
    previewMap.setView([38.2485, 140.3276], 8);
    return await captureMapBase64();
  }

  const from = dayRoute[segIndex - 1];
  const to   = dayRoute[segIndex];
  if (!from || !to || from.lat == null || from.lng == null || to.lat == null || to.lng == null) return "";

  const fromLat = parseFloat(from.lat), fromLng = parseFloat(from.lng);
  const toLat   = parseFloat(to.lat),   toLng   = parseFloat(to.lng);

  L.marker([fromLat, fromLng], { icon: getIconByType(from.type || "start") }).addTo(routeFeatureGroup);
  L.marker([toLat, toLng],     { icon: getIconByType(to.type || "normal") }).addTo(routeFeatureGroup);

  await drawOsrmSegment(from, to, routeFeatureGroup);

  previewMap.invalidateSize(true);
  await sleep(80);

  try {
    previewMap.fitBounds(routeFeatureGroup.getBounds(), { padding:[40,40] });
  } catch(e) {
    previewMap.setView([toLat, toLng], 13);
  }

  return await captureMapBase64();
}

function buildSendPayloadBase(original, segmentMapImages) {
  const cloned = JSON.parse(JSON.stringify(original || {}));

  if (!cloned.tripDays) {
    cloned.tripDays = (cloned.routes && Array.isArray(cloned.routes)) ? cloned.routes.length : 1;
  }

  if (cloned.routes && Array.isArray(cloned.routes)) {
    cloned.routes.forEach(function(dayRoute) {
      if (!dayRoute || !Array.isArray(dayRoute)) return;
      dayRoute.forEach(function(rp) {
        if (!rp) return;
        delete rp.mapImage;
        delete rp._calcArrival;
        delete rp._calcDeparture;
      });
    });
  }

  cloned.segmentMapImages = segmentMapImages || [];
  return cloned;
}

function setPdfStatus(type, title, desc, progressPercent) {
  const box = document.getElementById("pdfStatus");
  const t = document.getElementById("pdfStatusTitle");
  const d = document.getElementById("pdfStatusDesc");
  const barFill = document.getElementById("pdfStatusBar");
  const icon = box ? box.querySelector(".pdf-status__icon") : null;

  if (!box || !t || !d || !barFill) return;

  box.style.display = "block";
  box.classList.remove("pdf-status--success", "pdf-status--danger");

  if (type === "success") box.classList.add("pdf-status--success");
  if (type === "danger")  box.classList.add("pdf-status--danger");

  t.textContent = title || "";
  d.textContent = desc || "";

  const p = Math.max(0, Math.min(100, Number(progressPercent || 0)));
  barFill.style.width = p + "%";

  if (icon) {
    icon.textContent = (type === "success") ? "✅" : (type === "danger") ? "⚠️" : "⏳";
  }
}

/** ★生成済みPDFを別タブで開く（ここだけユーザー操作なのでブロックされにくい） */
function openGeneratedPdfInNewTab() {
  if (!generatedPdfObjectUrl) {
    alert("PDFがまだ生成されていません。先にPDFを生成してください。");
    return;
  }
  const w = window.open(generatedPdfObjectUrl, "_blank", "noopener");
  if (!w) {
  }
}

/** ★ボタンを「開く」状態に切り替える */
function switchButtonToOpenMode(btn) {
  if (!btn) return;
  btn.dataset.mode = "open";
  btn.textContent = "生成されたPDFを開く";
  btn.classList.remove("btn-danger");
  btn.classList.add("btn-success");
}
/** ★ボタンを「生成」状態に戻す */
function switchButtonToGenerateMode(btn) {
  if (!btn) return;
  btn.dataset.mode = "generate";
  btn.textContent = "PDFを生成";
  btn.classList.remove("btn-success");
  btn.classList.add("btn-danger");
}

function setupPdfButton() {
  const btn = document.getElementById("generatePdfBtn");
  if (!btn) return;

  btn.dataset.mode = "generate";

  btn.addEventListener("click", async function() {
    // 生成済みなら「別タブで開く」
    if (btn.dataset.mode === "open") {
      openGeneratedPdfInNewTab();
      return;
    }

    if (!routeData || !Array.isArray(routeData.routes) || routeData.routes.length === 0) {
      alert("ルート情報がありません。先にルートを作成してください。");
      return;
    }

    saveRouteDataToSessionStorage();

    // 以前のPDFがあれば破棄
    if (generatedPdfObjectUrl) {
      try { URL.revokeObjectURL(generatedPdfObjectUrl); } catch(e) {}
      generatedPdfObjectUrl = null;
    }

    btn.disabled = true;
    setPdfStatus("info", "地図画像を作成中…", "地点ごとの地図画像を作っています。しばらくお待ちください。", 5);

    try {
      const segmentMapImages = [];
      const totalSteps = routeData.routes.reduce((sum, r) => sum + ((r && r.length) ? r.length : 0), 0);
      let doneSteps = 0;

      for (let day = 0; day < routeData.routes.length; day++) {
        const dayRoute = routeData.routes[day] || [];
        const segArr = [];

        activeDayIndex = day;

        await renderMapForDay(activeDayIndex);
        renderRouteListForDay(activeDayIndex);

        for (let i = 0; i < dayRoute.length; i++) {
          doneSteps++;
          const pct = totalSteps > 0 ? Math.round((doneSteps / totalSteps) * 85) : 10;
          setPdfStatus("info", "地図画像を作成中…", "Day " + (day + 1) + " / 地点 " + (i + 1) + " を作成しています。", pct);

          const b64 = await captureSegmentMap(day, i);
          segArr.push(b64 || "");
        }

        segmentMapImages.push(segArr);
      }

      setPdfStatus("info", "PDFを生成中…", "PDFを作成しています。完了後に「開く」ボタンに変わります。", 92);

      const sendData = buildSendPayloadBase(
        JSON.parse(JSON.stringify(routeData)),
        segmentMapImages
      );

      // ★fetchでPDFを取得（この時点では開かない）
      const body = new URLSearchParams();
      body.append("json", JSON.stringify(sendData));

      const res = await fetch(PDF_ENDPOINT + "?_ts=" + Date.now(), {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
          "Accept": "application/pdf"
        },
        body: body.toString(),
        cache: "no-store",
        credentials: "same-origin"
      });

      if (!res.ok) {
        const text = await res.text().catch(() => "");
        throw new Error("PDFOutput HTTP " + res.status + (text ? (" / " + text) : ""));
      }

      const blob = await res.blob();

      if (blob.type && !String(blob.type).toLowerCase().includes("pdf")) {
        const maybeText = await blob.text().catch(() => "");
        throw new Error("PDF以外の応答が返りました: " + blob.type + (maybeText ? (" / " + maybeText) : ""));
      }

      generatedPdfObjectUrl = URL.createObjectURL(blob);

      setPdfStatus("success", "PDF生成が完了しました", "「生成されたPDFを開く」ボタンから別タブで開けます。", 100);

      // ★ここでボタンを切替（自動で開かない）
      switchButtonToOpenMode(btn);

      btn.disabled = false;

    } catch (e) {
        console.error("PDF生成処理エラー:", e);

        let title = "PDF生成に失敗しました";
        let desc = "原因不明のエラーが発生しました。";
        let showAlert = true;

        // 通信エラー（一番多いパターン）
        if (e.name === "TypeError" && (e.message.includes("Failed to fetch") || e.message.includes("NetworkError"))) {
          title = "通信エラー";
          desc = "サーバーとの接続が切れました。\n\n【よくある原因】\n・スポットが多すぎる（画像が重い）\n・サーバーが一時的に混雑している\n\n【対処法】\n・スポットを減らして再度試す\n・少し待ってからもう一度押す";
        }
        // サーバーからエラーJSONが返ってきた場合
        else if (e.message && e.message.includes("HTTPエラー")) {
          title = "サーバーエラー";
          desc = e.message;
        }
        // その他のエラー
        else {
          desc = "予期しないエラーが発生しました。\n\nエラー内容： " + (e.message || "不明") + "\n\n管理者に連絡する場合はこのメッセージを伝えてください。";
        }

        setPdfStatus("danger", title, desc, 100);

        if (showAlert) {
          alert(title + "\n\n" + desc);
        }

        // ボタンを元に戻す
        switchButtonToGenerateMode(btn);
        btn.disabled = false;

        // 生成済みのPDFがあれば破棄
        if (generatedPdfObjectUrl) {
          URL.revokeObjectURL(generatedPdfObjectUrl);
          generatedPdfObjectUrl = null;
        }
      }
  });
}

function setupBackToEditButton() {
  const a = document.getElementById("backToEditBtn");
  if (!a) return;

  a.addEventListener("click", function() {
    saveRouteDataToSessionStorage();
  });
}

window.addEventListener("beforeunload", function() {
  if (generatedPdfObjectUrl) {
    try { URL.revokeObjectURL(generatedPdfObjectUrl); } catch(e) {}
    generatedPdfObjectUrl = null;
  }
});

document.addEventListener("DOMContentLoaded", async function() {
  loadRouteData();
  renderCourseHeader();
  renderDayTabs();

  await renderMapForDay(activeDayIndex);
  renderRouteListForDay(activeDayIndex);

  setupPdfButton();
  setupBackToEditButton();
});
</script>

</body>
</html>
  </c:param>
</c:import>
